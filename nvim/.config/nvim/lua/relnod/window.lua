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

  vim.api.nvim_win_close(win.handle, true)

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

vim.cmd[[augroup window_close]]
  vim.cmd[[autocmd!]]
  vim.cmd[[autocmd WinClosed * lua require'relnod/window'.handle_win_closed()]]
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
