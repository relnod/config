local utils = require("relnod/utils")
local keymap = require("relnod/keymap")
local window = require("relnod/window")

local terminal = {}

_Terminals = _Terminals or {}

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
      mappings = config.mappings,
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

local function create_term(name, command)
  -- Create a new non listed, non scratch buffer
  local bufnr = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_set_current_buf(bufnr)

  vim.call("termopen", "bash", { detach = 0 })
  local jobid = vim.api.nvim_buf_get_var(bufnr, "terminal_job_id")

  if command ~= nil then
    terminal.run_command(name, command)
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

  if term.buf == nil then
    local bufnr, jobid = create_term(name, term.config.command)
    term.buf = bufnr
    term.jobid = jobid
  else
    load_term(term.buf)
  end

  -- This is a hacky workaround, to delete the temporary buffer, that was
  -- created, when creating the split.
  if tempbuf then
    vim.api.nvim_buf_delete(tempbuf, { force = true })
  end

  -- Apply all terminal buffer key mapping.
  if term.config.mappings ~= nil then
    for mode, mappings in pairs(term.config.mappings) do
      for lhs, rhs in pairs(mappings) do
        keymap.nvim_buf_set_keymap(term.buf, mode, lhs, rhs, { noremap = true })
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

function terminal.run_command(name, command)
  local term = _Terminals[name]
  if term == nil then
    return
  end

    vim.call("jobsend", term.jobid, command .. "\n")
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

  terminal.run_command(name, current_line)
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

  terminal.run_command(name, selection)
end

terminal.actions = {}

--- Opens the file under the cursor.
--- The file will be opened in the window where the terminal was created from.
function terminal.actions.open_file()
  local file = vim.call("expand", "<cWORD>")

  local previous_win = window.get_previous_win(vim.api.nvim_get_current_win())

  if previous_win ~= -1 and window.is_editing_win(previous_win) then
    vim.api.nvim_set_current_win(previous_win)
  else
    local win = window.get_editing_win()
    if win ~= -1 then
      vim.api.nvim_set_current_win(win)
    end
  end

  vim.cmd(string.format("e %s", file))
end

vim.cmd[[augroup terminal_buf_hidden]]
  vim.cmd[[autocmd!]]
  vim.cmd[[autocmd BufHidden * lua require'relnod/terminal'.handle_term_closed()]]
vim.cmd[[augroup END]]

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

vim.cmd[[augroup terminal_buf_delete]]
  vim.cmd[[autocmd!]]
  vim.cmd[[autocmd BufDelete * lua require'relnod/terminal'.handle_term_delete()]]
vim.cmd[[augroup END]]

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
