-- HELPERS {{{
local cmd, fn, g = vim.cmd, vim.fn, vim.g
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local opt = function(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local map = function(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
-- }}}
-- PLUGINS {{{
cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq
paq {'joshdick/onedark.vim'}
paq {'valloric/MatchTagAlways'}
paq {'jeffkreeftmeijer/vim-numbertoggle'}

paq {'tpope/vim-surround'}
paq {'tpope/vim-commentary'}
paq {'tpope/vim-repeat'}

paq {'airblade/vim-gitgutter'} -- {{{
g.gitgutter_map_keys = 0
-- }}}

paq {'scrooloose/nerdtree'} -- {{{
g.NERDTreeShowHidden = 1
g.NerdTreeWinSize = 70

map('n', '<F3>', ':NERDTreeToggle<CR>')

cmd 'au FileType nerdtree nmap <buffer> a o'
-- }}}

paq {'nvim-treesitter/nvim-treesitter'} -- {{{
local ts = require 'nvim-treesitter.configs'
ts.setup {
  ensure_installed = 'maintained',
  highlight = { enable = true },
  indent = { enable = true },
}
-- }}}

paq {'neovim/nvim-lspconfig'} -- {{{
local lspconfig = require 'lspconfig'
local cache_dir = os.getenv("HOME") .. '/.cache/nvim'
lspconfig.sumneko_lua.setup({
  cmd = {
    cache_dir .. '/lua-language-server/bin/Linux/lua-language-server',
    '-E',
    cache_dir .. '/lua-language-server/main.lua'
  },
  settings = {
    Lua = {
      diagnostics = {
	enable = true,
	globals = { "vim" },
      },
    },
  },
})
lspconfig.tsserver.setup{}
lspconfig.gopls.setup{}
cmd 'au BufWritePre *.go lua vim.lsp.buf.formatting()'
lspconfig.dockerls.setup{}
lspconfig.yamlls.setup{}
lspconfig.jsonls.setup{}
lspconfig.bashls.setup{}
lspconfig.cssls.setup{}
lspconfig.rnix.setup{}
map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', 'gd','<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', 'gD','<cmd>lua vim.lsp.buf.declaration()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', 'F', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
-- }}}

paq {'nvim-lua/completion-nvim'} -- {{{
cmd 'autocmd BufEnter * lua require"completion".on_attach()'
-- }}}

paq {'nvim-telescope/telescope.nvim'} -- {{{
paq {'nvim-lua/popup.nvim'}
paq {'nvim-lua/plenary.nvim'}
local telescope = require('telescope')
telescope.setup({
  vimgrep_arguments = {
    'rg',
    '--color=never',
    '--no-heading',
    '--with-filename',
    '--line-number',
    '--column',
    '--smart-case',
    '--hidden',
    '-g "!.git"',
    '-g "!vendor"',
  }
})
map('n', '<space>ff', '<cmd>lua require("telescope.builtin").find_files()<CR>')
map('n', '<space>fg', '<cmd>lua require("telescope.builtin").git_files()<CR>')
map('n', '<space>fa', '<cmd>lua require("telescope.builtin").live_grep()<CR>')
map('n', '<space>fb', '<cmd>lua require("telescope.builtin").buffers()<CR>') -- TODO: buffers should be sorted by recently used
map('n', '<space>fh', '<cmd>lua require("telescope.builtin").help_tags()<CR>')
-- }}}

-- }}}
-- SETTINGS {{{
-- colors
cmd 'colorscheme onedark'
opt('o', 'termguicolors', true)

-- mouse
opt('o', 'mouse', 'a')

-- buffers
opt('o', 'hidden', true)

-- wildmenu, completion
opt('o', 'completeopt', 'menuone,noinsert,noselect')
opt('o', 'wildignorecase', true)
-- set wildignore+=*/.git/**/*
-- set wildignore+=tags
-- set wildignorecase

-- inccommand
opt('o', 'inccommand', 'split')

-- tabs, spaces
opt('o', 'expandtab', true)
opt('o', 'tabstop', 4)
opt('o', 'softtabstop', 4)
opt('o', 'shiftwidth', 4)

-- folding
opt('o', 'foldmethod', 'expr')
opt('o', 'foldexpr', 'nvim_treesitter#foldexpr()')

-- search
opt('o', 'ignorecase', true)

-- opt('o', 'listchars', 'tab:▸ ,extends:❯,precedes:❮,trail:')
opt('o', 'fillchars', 'eob:█')
opt('o', 'showbreak', '↪')

-- swap, undo, backup
opt('o', 'noswapfile', true)
opt('o', 'undodir', '~/.local/share/nvim/undo//')
opt('o', 'undofile', true)
opt('o', 'backupdir', '~/.local/share/nvim/backup//')
opt('o', 'backupfile', true)

opt('w', 'number', true)
-- }}}
-- MAPPINGS {{{
map('n', '<space>w', ':w<CR>')
map('n', '<space>sw', ':w !sudo -S tee %<CR>')
map('n', '<space>ir', ':luafile ~/.config/nvim/init.lua<CR>')
map('n', '<space>io', ':e ~/.config/nvim/init.lua<CR>')
map('n', '<ESC>', ':noh<CR>')

-- faster movement
map('n', '<M-h>', '^')
map('n', '<M-j>', '5j')
map('n', '<M-k>', '5k')
map('n', '<M-l>', '$')

map('v', '<M-h>', '^')
map('v', '<M-j>', '5j')
map('v', '<M-k>', '5k')
map('v', '<M-l>', '$')
-- }}}
-- vim:fdm=marker
