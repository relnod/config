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

-- Stores the window, from where the last terminal was opened. This enables
-- jumping back to that window.
local previous_win = nil

local function create_term(command)
  vim.call("termopen", "bash", { detach = 0 })
  local bufnr = vim.fn.bufnr("")
  local jobid = vim.api.nvim_buf_get_var("", "terminal_job_id")

  -- set buflisted = false
  vim.api.nvim_buf_set_option("", "buflisted", false)

  if command ~= nil then
    vim.call("jobsend", jobid, command .. "\n")
  end
  return bufnr, jobid
end

local function load_term(bufnr)
  vim.cmd(string.format("%dbuffer", bufnr))
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

  if window.isopen(term.config.window) then
    -- Make sure the window is focused.
    window.focus(term.config.window)

    if term.buf == nil then
      -- Create a new buffer
      vim.cmd[[enew]]
      local bufnr, jobid = create_term(term.config.command)
      term.buf = bufnr
      term.jobid = jobid
    else
      load_term(term.buf)
    end
  else
    -- Open the window.
    window.open(term.config.window)

    if term.buf == nil then
      local bufnr, jobid = create_term(term.config.command)
      term.buf = bufnr
      term.jobid = jobid
    else
      local buf = vim.api.nvim_get_current_buf()

      load_term(term.buf)

      -- This is a hacky workaround, to delete the temporary buffer, that was
      -- created, when creating the split.
      vim.api.nvim_buf_delete(buf, { force = true })
    end
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
--- @param termname string The name of the terminal
function terminal.toggle(termname)
  local term = _Terminals[termname]
  if term == nil then
    return
  end

  if terminal.isopen(termname) then
    terminal.close(termname)
  else
    terminal.open(termname)
  end
end

--- Runs the current line in the given terminal.
---
--- @param name string The name of the terminal
function terminal.run_current_line(name)
  local term = _Terminals[name]

  local current_line = vim.api.nvim_get_current_line()
  if not terminal.isopen(name) then
    terminal.open(name)
  end
  vim.call("jobsend", term.jobid, current_line)
end

--- Runs the visual selection in the given terminal.
---
--- Note: This currently only supports single line selections.
---
--- @param name string The name of the terminal
function terminal.run_selection(name)
  local term = _Terminals[name]

  local selection = utils.get_selection()
  if not terminal.isopen(name) then
    terminal.open(name)
  end
  vim.call("jobsend", term.jobid, selection)
end

terminal.actions = {}

--- Opens the file under the cursor.
--- The file will be opened in the window where the terminal was created from.
function terminal.actions.open_file()
  local file = vim.call("expand", "<cWORD>")

  vim.api.nvim_set_current_win(previous_win)

  vim.cmd(string.format("e %s", file))
end

vim.cmd[[augroup terminal_closed]]
  vim.cmd[[autocmd!]]
  vim.cmd[[autocmd BufHidden * lua require'relnod/terminal'.handle_term_closed()]]
vim.cmd[[augroup END]]

vim.cmd[[augroup terminal_deleted]]
  vim.cmd[[autocmd!]]
  vim.cmd[[autocmd BufDelete * lua require'relnod/terminal'.handle_term_deleted()]]
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

function terminal.handle_term_deleted()
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
