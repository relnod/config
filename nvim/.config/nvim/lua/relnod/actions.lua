local window = require("relnod/window")

local actions = {}

--- Window selection order
---   1. The current window if an editing window
---   2. The previous window if an editing window
---   3. Any editing window
---   4. The current window (do nothing)
function actions.select_editing_window()
  local curent_win = vim.api.nvim_get_current_win()
  -- 1. The current window
  if not window.is_editing_win(curent_win) then
    -- 2. The previous window
    local previous_win = window.get_previous_win(vim.api.nvim_get_current_win())
    if previous_win ~= -1 and window.is_editing_win(previous_win) then
      vim.api.nvim_set_current_win(previous_win)
    else
      -- 3. Any editing window
      local win = window.get_editing_win()
      if win ~= -1 then
        vim.api.nvim_set_current_win(win)
      end
    end
  end
end

--- Opens the buffer with the given command
---
---@param bufnr number The buffer number
---@param command string The command to open the file
---         Valid commands are:
---           - "edit"
---           - "new"
---           - "vnew"
---           - "tabedit"
function actions.open_buffer(bufnr, command)
  if command == nil then
    command = "edit"
  end

  local command_map = {
    edit = "buffer",
    new = "sbuffer",
    vnew = "vert sbuffer",
    tabedit = "tab sb"
  }

  actions.select_editing_window()
  vim.cmd(string.format("%s %d", command_map[command], bufnr))
end

--- Opens the file with the given command.
---
---@param filename string The file name
---@param command string The command to open the file
---         Valid commands are:
---           - "edit"
---           - "new"
---           - "vnew"
---           - "tabedit"
function actions.open_file(filename, command, row, col)
  if filename == nil or filename == "" then
    return
  end

  if command == nil then
    command = "edit"
  end

  actions.select_editing_window()

  -- Check if the current buffer is already loaded.
  local bufnr = vim.api.nvim_get_current_buf()
  if filename ~= vim.api.nvim_buf_get_name(bufnr) then
    -- Open the buffer and set the new buffer as listed
    vim.cmd(string.format(":%s %s", command, filename))
    bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(bufnr, "buflisted", true)
  end

  if row and col then
    local ok, err_msg = pcall(vim.api.nvim_win_set_cursor, 0, {row, col})
    if not ok then
      error(
        string.format(
          "Failed to move to cursor: %s, row: %d, col: %d",
          err_msg,
          row,
          col
        )
      )
    end
  end
end

--- Open the filename under the cursor.
---
---@see actions.open_file
function actions.open_file_under_cursor()
  local filename = vim.call("expand", "<cWORD>")
  actions.open_file(filename, "edit")
end

return actions
