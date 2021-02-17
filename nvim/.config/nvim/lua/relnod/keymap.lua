local M = {}

_Mappings = _Mappings or {}
_MappingsBuffer = _MappingsBuffer or {}

--- @param mode string
--- @param lhs string
local function create_map_key(mode, lhs)
  local map_key = mode .. lhs
  map_key = string.gsub(map_key,"<", "-")
  map_key = string.gsub(map_key,">", "-")
  return map_key
end

--- @param map_key string
local function create_map_string(map_key)
  return string.format(
    "<cmd>lua require('relnod.keymap').execute_mapping('%s')<CR>",
    map_key
  )
end

--- @param map_key string
--- @param bufnr number
local function create_map_string_buf(map_key, bufnr)
  return string.format(
    "<cmd>lua require('relnod.keymap').execute_buffer_mapping(%d, '%s')<CR>",
    bufnr,
    map_key
  )
end

--- See |nvim_set_keymap|, but the rhs can either be a string or a lua function.
---
--- @param mode string
--- @param lhs string
--- @param rhs string or function
--- @param opts table
function M.nvim_set_keymap(mode, lhs, rhs, opts)
  if type(rhs) == "string" then
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  else
    local map_key = create_map_key(mode, lhs)
    local map_string = create_map_string(map_key)

    _Mappings[map_key] = rhs
    vim.api.nvim_set_keymap(mode, lhs, map_string, opts)
  end
end

--- See |nvim_buf_set_keymap|, but the rhs can either be a string or a lua
--- function.
---
--- @param bufnr number
--- @param mode string
--- @param lhs string
--- @param rhs string or function
--- @param opts table
function M.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  if type(rhs) == "string" then
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  else
    if _MappingsBuffer[bufnr] == nil then
      _MappingsBuffer[bufnr] = {}
    end
    local map_key = create_map_key(mode, lhs)
    local map_string = create_map_string_buf(map_key, bufnr)
    _MappingsBuffer[bufnr][map_key] = rhs

    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, map_string, opts)
  end
end

--- Executes a keymap.
---
--- @param map_key string
function M.execute_mapping(map_key)
  if _Mappings ~= nil and _Mappings[map_key] ~= nil then
    _Mappings[map_key]()
  end
end

--- Executes a keymap.
---
--- @param bufnr number
--- @param map_key string
function M.execute_buffer_mapping(bufnr, map_key)
  if
    _MappingsBuffer ~= nil and _MappingsBuffer[bufnr][map_key] and
      _MappingsBuffer[bufnr][map_key] ~= nil
   then
    _MappingsBuffer[bufnr][map_key]()
  end
end

vim.cmd[[augroup keymap_buf_delete]]
  vim.cmd[[autocmd!]]
  vim.cmd[[autocmd BufDelete * lua require'relnod/keymap'.handle_buf_delete()]]
vim.cmd[[augroup END]]

function M.handle_buf_delete()
  local bufname = vim.fn.expand("<afile>")
  if bufname == "" then
    return
  end

  local bufnr = vim.fn.bufnr(bufname)
  for _, b in pairs(_MappingsBuffer) do
    if b == bufnr then
      _MappingsBuffer[bufnr] = nil
      return
    end
  end
end

return M
