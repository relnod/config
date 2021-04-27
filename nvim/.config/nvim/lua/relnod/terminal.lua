local utils = require("relnod/utils")
local keymap = require("relnod/keymap")
local window = require("relnod/window")
local actions = require("relnod/actions")

local terminal = {}

_Terminals = _Terminals or {}

local default_mappings = {
  n = {
    ["<C-c>"] = "i<C-c>",
    ["q"] = "A",
    ["r"] = terminal.restart_command,
    ["gf"] = actions.open_file_under_cursor
  }
}

--- This will initialize all given terminals.
---
--- It is possible to call this function multiple times. If the terminal already
--- exists, the configuration gets updated.
---
--- @param opts table Initialization options
function terminal.setup(opts)
  for name, config in pairs(opts) do
    if not window.exists(config.window) then
      vim.api.error_message("invalid window name")
    end

    if _Terminals[name] == nil then
      _Terminals[name] = {
        buf = nil,
        open = false
      }
    end

    _Terminals[name].config = {
      window = config.window,
      startinsert = config.startinsert ~= nil and config.startinsert or true,
      command = config.command,
      mappings = vim.tbl_deep_extend(
        "keep",
        config.mappings or {},
        default_mappings
      ),
      before_open = config.before_open
    }
  end
end

function terminal.isopen(termname)
  local term = _Terminals[termname]
  if term == nil then
    return
  end

  return term.open
end

local function create_term(command)
  -- Create a new non listed, non scratch buffer
  local bufnr = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_set_current_buf(bufnr)

  vim.call("termopen", "bash", {detach = 0})
  local jobid = vim.api.nvim_buf_get_var(bufnr, "terminal_job_id")

  if command ~= nil then
    vim.fn.chansend(jobid, command .. "\n")
  end
  return bufnr, jobid
end

local function load_term(bufnr)
  vim.api.nvim_set_current_buf(bufnr)
end

--- Opens the terminal window with the given name.
--- If the terminal was not opened before, it creates a new one.
--- If the window is already open, it just loads the terminal
--- buffer.
---
--- @param name string The name of the terminal
function terminal.open(name)
  local term = _Terminals[name]
  if term == nil or term.open then
    return
  end

  if term.config.before_open then
    term.config.before_open()
  end

  local tempbuf = nil
  if window.isopen(term.config.window) then
    -- Make sure the window is focused.
    window.focus(term.config.window)
  else
    -- Open the window.
    window.open(term.config.window)

    tempbuf = vim.api.nvim_get_current_buf()
  end

  if term.buf == nil or not vim.api.nvim_buf_is_loaded(term.buf) then
    term.buf, term.jobid = create_term(term.config.command)
  else
    load_term(term.buf)
  end

  -- This is a hacky workaround, to delete the temporary buffer, that was
  -- created, when creating the split.
  if tempbuf then
    vim.api.nvim_buf_delete(tempbuf, {force = true})
  end

  -- Apply all terminal buffer key mapping.
  if term.config.mappings ~= nil then
    for mode, mappings in pairs(term.config.mappings) do
      for lhs, rhs in pairs(mappings) do
        local rhs2 = rhs
        -- If the rhs is a function, wrap it and pass the terminal name to the
        -- rhs.
        if type(rhs) == "function" then
          rhs2 = function()
            rhs(name)
          end
        end
        keymap.map_buf(term.buf, mode, lhs, rhs2, {noremap = true})
      end
    end
  end

  if term.config.startinsert then
    vim.cmd("startinsert")
  end

  term.open = true
end

--- Closes the terminal window with the given name.
---
--- @param termname string The name of the terminal
function terminal.close(termname)
  local term = _Terminals[termname]
  if term == nil then
    return
  end

  window.close(term.config.window)
  term.open = false
end

--- Toggles the terminal window with the given name.
---
--- @param name string The name of the terminal
function terminal.toggle(name)
  local term = _Terminals[name]
  if term == nil then
    return
  end

  if terminal.isopen(name) then
    terminal.close(name)
  else
    terminal.open(name)
  end
end

function terminal.restart_command(name)
  local term = _Terminals[name]
  if term == nil then
    return
  end

  if term.config.command == nil then
    return
  end

  vim.fn.chansend(term.jobid, "^C")
  vim.fn.chansend(term.jobid, "clear")
  vim.fn.chansend(term.jobid, term.config.command .. "\n")
end

function terminal.run_command(name, command)
  local term = _Terminals[name]
  if term == nil then
    return
  end

  vim.fn.chansend(term.jobid, command .. "\n")
end

--- Runs the current line in the given terminal.
---
--- @param name string The name of the terminal
function terminal.run_current_line(name)
  local term = _Terminals[name]
  if term == nil then
    return
  end

  local current_line = vim.api.nvim_get_current_line()
  if not terminal.isopen(name) then
    terminal.open(name)
  end

  terminal.run_command(name, vim.trim(current_line))

  if vim.api.nvim_get_current_buf() == term.buf then
    vim.cmd("startinsert")
  end
end

--- Runs the visual selection in the given terminal.
---
--- Note: This currently only supports single line selections.
---
--- @param name string The name of the terminal
function terminal.run_selection(name)
  local term = _Terminals[name]
  if term == nil then
    return
  end

  local selection = utils.get_selection()
  if not terminal.isopen(name) then
    terminal.open(name)
  end

  terminal.run_command(name, vim.trim(selection))
  vim.cmd("startinsert")
end

vim.cmd [[augroup terminal_buf_hidden]]
vim.cmd [[autocmd!]]
vim.cmd [[autocmd BufHidden * lua require'relnod/terminal'.handle_term_closed()]]
vim.cmd [[augroup END]]

function terminal.handle_term_closed()
  local bufname = vim.fn.expand("<afile>")
  local bufnr = vim.fn.bufnr(bufname)

  for _, term in pairs(_Terminals) do
    if term.buf == bufnr then
      term.open = false
      return
    end
  end
end

vim.cmd [[augroup terminal_buf_delete]]
vim.cmd [[autocmd!]]
vim.cmd [[autocmd BufDelete * lua require'relnod/terminal'.handle_term_delete()]]
vim.cmd [[augroup END]]

function terminal.handle_term_delete()
  local bufname = vim.fn.expand("<afile>")
  if bufname == "" then
    return
  end
  local bufnr = vim.fn.bufnr(bufname)

  for _, term in pairs(_Terminals) do
    if term.buf == bufnr then
      term.buf = nil
      term.open = false
      return
    end
  end
end

return terminal
