_Windows = _Windows or {}

local window = {}

--- This will initialize all given windows.
---
--- It is possible to call this function multiple times. If the window already
--- exists, the configuration gets updated.
---
--- @param opts table Initialization options
function window.setup(opts)
  for name, config in pairs(opts) do
    if _Windows[name] == nil then
      _Windows[name] = {
        handle = nil
      }
    end

    _Windows[name].config = {
      location = config.location ~= nil and config.location or "bottom",
      size = config.size ~= nil and config.size or 25,
      before_open = config.before_open,
      after_open = config.after_open
    }
  end
end

--- Checks if the window with the given name exists.
---
--- @param name string The name of the window
function window.exists(name)
  return _Windows[name] ~= nil
end

--- Checks if the window with the given name is open.
---
--- @param name string The name of the window
function window.isopen(name)
  local win = _Windows[name]
  if win == nil then
    return false
  end

  if win.handle == nil then
    return false
  end

  return true
end

--- Opens the window with the given name.
---
--- @param name string The name of the window
function window.open(name)
  local win = _Windows[name]
  if win == nil then
    return
  end
  if window.isopen(name) then
    return
  end

  if win.config.before_open then
    win.config.before_open()
  end

  local previous_win = vim.api.nvim_get_current_win()

  if win.config.location == "bottom" then
    vim.cmd(string.format("botright %dnew", win.config.size))
  elseif win.config.location == "top" then
    vim.cmd(string.format("topleft %dnew", win.config.size))
  elseif win.config.location == "right" then
    vim.cmd(string.format("botright %dvnew", win.config.size))
  elseif win.config.location == "left" then
    vim.cmd(string.format("topleft %dvnew", win.config.size))
  else
    return
  end

  if win.config.after_open then
    win.config.after_open()
  end

  win.handle = vim.api.nvim_get_current_win()

  vim.api.nvim_win_set_var(win.handle, "previous_win", previous_win)
end

--- Closes the window with the given name.
---
--- @param name string The name of the window
function window.close(name)
  local win = _Windows[name]
  if win == nil then
    return
  end
  if not window.isopen(name) then
    return
  end

  local previous_win = window.get_previous_win(win.handle)

  vim.api.nvim_win_close(win.handle, true)
  if previous_win ~= -1 then
    vim.api.nvim_set_current_win(previous_win)
  end

  win.handle = nil
  win.open = false
end

--- Toggles the window with the given name.
---
--- @param name string The name of the window
function window.toggle(name)
  local win = _Windows[name]
  if win == nil then
    return
  end

  if window.isopen(name) then
    window.close(name)
  else
    window.open(name)
  end
end

--- Sets the window with the given name as the current window.
---
--- @param name string The name of the window
function window.focus(name)
  local win = _Windows[name]
  if win == nil then
    return
  end
  if not window.isopen(name) then
    return
  end

  vim.api.nvim_set_current_win(win.handle)
end

--- Returns the previous window, for the window with the given window number.
---
--- @param winnr string The window handle.
--- @returns number The window handle or -1
function window.get_previous_win(winnr)
  local ok, previous_win = pcall(vim.api.nvim_win_get_var, winnr, "previous_win")
  if not ok then
    return -1
  end

  return previous_win
end

--- Returns an editing window.
---
--- @returns number The window handle or -1
function window.get_editing_win()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if window.is_editing_win(win) then
      return win
    end
  end
  return -1
end

--- Checks if the window with the given window number is an editing window.
---
--- @param winnr number The window handle.
--- @returns boolean
function window.is_editing_win(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
  return buftype == ""
end

vim.cmd[[augroup window_close]]
  vim.cmd[[autocmd!]]
  vim.cmd[[autocmd WinClosed * lua require'relnod.window'.handle_win_closed()]]
vim.cmd[[augroup END]]

function window.handle_win_closed()
  local handle = tonumber(vim.fn.expand("<afile>"))
  for _, win in pairs(_Windows) do
    if win.handle == handle then
      win.handle = nil
      return
    end
  end
end

return window
