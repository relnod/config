local utils = require("relnod/utils")
local keymap = require("relnod/keymap")
local window = require("relnod/window")

local quickfix = {}

_Quickfixes = _Quickfixes or {}

--- This will initialize all given quickfixes.
---
--- It is possible to call this function multiple times. If the quickfix already
--- exists, the configuration gets updated.
---
--- @param opts table Initialization options
function quickfix.setup(opts)
  for name, config in pairs(opts) do
    if not window.exists(config.window) then
        vim.api.error_message("invalid window name")
    end

    if _Quickfixes[name] == nil then
      _Quickfixes[name] = {
        buf = nil,
        open = false
      }
    end

    _Quickfixes[name].config = {
      window = config.window,
      mappings = config.mappings
    }
  end
end

function quickfix.isopen(name)
  local qf = _Quickfixes[name]
  if qf == nil then
    return
  end

  return qf.open
end

--- Opens the quickfix window with the given name.
---
--- @param name string The name of the quickfix
function quickfix.open(name)
  local qf = _Quickfixes[name]
  if qf == nil or qf.open then
    return
  end

  if qf.config.before_open then
    qf.config.before_open()
  end

  vim.cmd("copen")
  vim.cmd("cclose")

  if window.isopen(qf.config.window) then
    -- Make sure the window is focused.
    window.focus(qf.config.window)
  else
    -- Open the window.
    window.open(qf.config.window)
  end

  local bufnr = vim.cmd("echo getqflist({'qfbufnr':1})")
  vim.api.nvim_set_current_buf(bufnr)

  -- Apply all quickfix buffer key mapping.
  if qf.config.mappings ~= nil then
    for mode, mappings in pairs(qf.config.mappings) do
      for lhs, rhs in pairs(mappings) do
        keymap.nvim_buf_set_keymap(qf.buf, mode, lhs, rhs, { noremap = true })
      end
    end
  end

  qf.open = true
end

--- Closes the quickfix window with the given name.
---
--- @param qfname string The name of the quickfix
function quickfix.close(qfname)
  local qf = _Quickfixes[qfname]
  if qf == nil then
    return
  end

  window.close(qf.config.window)
  qf.open = false
end

--- Toggles the quickfix window with the given name.
---
--- @param name string The name of the quickfix
function quickfix.toggle(name)
  local qf = _Quickfixes[name]
  if qf == nil then
    return
  end

  if quickfix.isopen(name) then
    quickfix.close(name)
  else
    quickfix.open(name)
  end
end

-- somewhat broken...
-- vim.cmd[[augroup quickfix_buf_hidden]]
--   vim.cmd[[autocmd!]]
--   vim.cmd[[autocmd BufUnload * lua require'relnod/quickfix'.handle_qf_closed()]]
-- vim.cmd[[augroup END]]

-- function quickfix.handle_qf_closed()
--   local bufname = vim.fn.expand("<afile>")
--   local bufnr = vim.fn.bufnr(bufname)

--   for _, qf in pairs(_Quickfixes) do
--     if qf.buf == bufnr then
--       qf.open = false

--       return
--     end
--   end
-- end

return quickfix
