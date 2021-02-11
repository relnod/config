local utils = require("relnod/utils")
local keymap = require("relnod/keymap")

local terminal = {}

local terminals = {}

--- This will initialize all given terminals.
---
--- It is possible to call this function multiple times.
---
--- @param opts table Initialization options
function terminal.setup(opts)
  for name, config in pairs(opts.terminals) do
    terminals[name] = {
      buf = nil,
      open = false,
      config = {
        location = config.location ~= nil and config.location or "bottom",
        size = config.size ~= nil and config.size or 25,
        startinsert = config.startinsert ~= nil and config.startinsert or true,
        command = config.command,
        mappings = config.mappings,
        before_open = config.before_open
      }
    }
  end
end

-- Stores the window, from where the last terminal was opened. This enabled
-- jumping back to that window.
local previous_win = nil

--- Opens the terminal with the given name.
--- If the terminal was not opened before, it creates a new one.
---
--- @param termname string The name of the terminal
function terminal.open(termname)
  local term = terminals[termname]

  if term.open then
    return
  end

  if term.config.before_open then
    term.config.before_open()
  end

  previous_win = vim.api.nvim_get_current_win()

  if term.config.location == "bottom" then
    vim.cmd(string.format("botright %dnew", term.config.size))
  elseif term.config.location == "top" then
    vim.cmd(string.format("%dnew", term.config.size))
  elseif term.config.location == "right" then
    vim.cmd(string.format("botright %dvnew", term.config.size))
  elseif term.config.location == "left" then
    vim.cmd(string.format("%dvnew", term.config.size))
  else
    return
  end

  if term.buf ~= nil then
    local buf = vim.api.nvim_get_current_buf()
    vim.cmd("buffer" .. term.buf)

    -- This is a hacky workaround, to delete the temporary buffer, that was
    -- created, when creating the split.
    vim.api.nvim_buf_delete(buf, { force = true })
  else
    vim.call("termopen", "bash", { detach = 0 })
    term.buf = vim.fn.bufnr("")
    term.jobid = vim.api.nvim_buf_get_var("", "terminal_job_id")

    -- set buflisted = false
    vim.api.nvim_buf_set_option("", "buflisted", false)

    if term.config.command ~= nil then
      vim.call("jobsend", term.jobid, term.config.command .. "\n")
    end
  end

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

  term.win = vim.api.nvim_get_current_win()
  term.open = true
end

--- Closes the terminal with the given name.
---
--- @param termname string The name of the terminal
function terminal.close(termname)
  local term = terminals[termname]

  if not term.open then
    return
  end

  vim.api.nvim_win_close(term.win, true)

  term.open = false
end

--- Toggles the terminal with the given name.
---
--- @param termname string The name of the terminal
function terminal.toggle(termname)
  local term = terminals[termname]

  if term.open then
    terminal.close(termname)
  else
    terminal.open(termname)
  end
end

--- Runs the current line in the given terminal.
---
--- @param termname string The name of the terminal
function terminal.run_current_line(termname)
  local term = terminals[termname]

  local current_line = vim.api.nvim_get_current_line()
  if term.open == false then
    terminal.open(termname)
  end
  vim.call("jobsend", term.jobid, current_line)
end

--- Runs the visual selection in the given terminal.
---
--- Note: This currently only supports single line selections.
---
--- @param termname string The name of the terminal
function terminal.run_selection(termname)
  local term = terminals[termname]

  local selection = utils.get_selection()
  if term.open == false then
    terminal.open(termname)
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

return terminal
