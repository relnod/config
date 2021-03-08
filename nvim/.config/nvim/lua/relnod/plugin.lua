local uv = vim.loop

_Packages = {}

local M = {}

local PATH = vim.fn.stdpath("data") .. "/site/pack/plugins"
local LOGFILE = vim.fn.stdpath("data") .. "/plugin.log"
local REPO_RE = "^[%w-]+/([%w-_.]+)$"

local setup_package
--- This sets up a package, by converting args into a package table.
--- It also recursively sets up all required packages.
---@param args table
setup_package = function(args)
  args = args or {}
  local name = args.as or args[1]:match(REPO_RE)
  local dir = PATH .. "/opt/" .. name

  local requires
  if args.requires ~= nil then
    requires = {}
    for _, package in pairs(args.requires) do
      table.insert(requires, setup_package(package))
    end
  end

  return {
    name = name,
    url = args.url or string.format("https://github.com/%s.git", args[1]),
    dir = dir,
    lazy = args.lazy,
    hook = args.hook,
    requires = requires,
    config = args.config,
    exists = vim.fn.isdirectory(dir) ~= 0,
    loaded = false
  }
end

--- This is the entrypoint for each plugin.
--- It load the plugin and call args.config if it is set afterwards.
---
---@param args table
M.plugin = function(args)
  local package = setup_package(args)
  table.insert(_Packages, package)

  if package.lazy then
    vim.schedule(
      vim.schedule_wrap(
        function()
          M.init_package(package)
        end
      )
    )
  else
    M.init_package(package)
  end
end

local function for_required_packages(package, fn)
  if package.requires ~= nil then
    for _, required_package in pairs(package.requires) do
      fn(required_package)
    end
  end
end

local function for_hooks(package, fn)
  if package.hook ~= nil then
    for _, hook in pairs(package.hook) do
      fn(hook)
    end
  end
end

M.init_package = function(package)
  if package.loaded then
    return
  end

  for_required_packages(package, function(required_package)
    M.load_package(required_package)
  end)

  M.load_package(package)
  M.run_config(package)

  for_required_packages(package, function(required_package)
    M.run_config(required_package)
   end)

  package.loaded = true
end

M.load_package = function(package)
  if package.exists then
    vim.cmd(string.format("packadd %s", package.name))
  end
end

M.run_config = function(package)
  if package.exists and package.config ~= nil then
    package.config()
  end
end

local function call_proc(process, args, cwd)
  local log = uv.fs_open(LOGFILE, "a+", 0x1A4)
  local stderr = uv.new_pipe(false)
  stderr:open(log)

  local handle
  handle = uv.spawn(
    process,
    {args = args, cwd = cwd, stdio = {nil, nil, stderr}},
    vim.schedule_wrap(function()
        uv.fs_write(log, "\n", -1)
        uv.fs_close(log)
        stderr:close()
        handle:close()
    end)
  )
end

M.install = function()
  for _, package in pairs(_Packages) do
    M.install_package(package)
  end
end

M.install_package = function(package)
  if not package.exists then
    call_proc("git", {"clone", package.url, package.dir})
  end

  for_hooks(package, function(hook)
    local args = {}
    for word in hook:gmatch("%S+") do
      table.insert(args, word)
    end
    local process = table.remove(args, 1)
    call_proc(process, args, package.dir)
  end)

  for_required_packages(package, function(required_package)
    local exists = vim.fn.isdirectory(required_package.dir) ~= 0
    if not exists then
      M.install_package(required_package)
    end
  end)
end

M.update = function()
  for _, package in pairs(_Packages) do
    M.update_package(package)
  end
end

M.update_package = function(package)
  if package.exists then
    call_proc("git", {"pull"}, package.dir)

    for_hooks(package, function(hook)
      local args = {}
      for word in hook:gmatch("%S+") do
        table.insert(args, word)
      end
      local process = table.remove(args, 1)
      call_proc(process, args, package.dir)
    end)
  end

  for_required_packages(package, function(required_package)
    local exists = vim.fn.isdirectory(required_package.dir) ~= 0
    if exists then
      M.update_package(required_package)
    end
  end)
end

return M
