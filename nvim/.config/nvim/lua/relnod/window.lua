_Windows = _Windows or {}

local window = {}

function window.setup(opts)
  for name, config in pairs(opts) do
    _Windows[name] = {
      win = false,
      open = false,
      config = {
        location = config.location ~= nil and config.location or "bottom",
        size = config.size ~= nil and config.size or 25,
        before_open = config.before_open,
        after_open = config.after_open
      }
    }
  end
end


--- Checks if the window with the fiven name exists.
---
--- @param name string The name of the window
function window.exists(name)
  return _Windows[name] ~= nil
end

--- Opens the window with the given name.
---
--- @param name string The name of the window
function window.open(name)
  local win = _Windows[name]
  if win == nil or win.open then
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

  win.win = vim.api.nvim_get_current_win()
  win.open = true
end

--- Closes the window with the given name.
---
--- @param name string The name of the window
function window.close(name)
  local win = _Windows[name]

  if win == nil or not win.open then
    return
  end

  vim.api.nvim_win_close(win.win, true)

  win.win = nil
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

  if win.open then
    window.close(name)
  else
    window.open(name)
  end
end

return window
