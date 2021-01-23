-- HELPERS {{{
local cmd, fn, g = vim.cmd, vim.fn, vim.g
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
local execute = vim.api.nvim_command

local opt = function(scope, key, value)
  scopes[scope][key] = value
  if scope ~= "o" then
    scopes["o"][key] = value
  end
end

local map = function(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local home = os.getenv("HOME")
-- }}}
vim.g.mapleader = " "
-- PLUGINS {{{
local install_path = fn.stdpath("data") .. "/site/pack/paqs/opt/paq-nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/savq/paq-nvim.git " .. install_path)
end

cmd "packadd paq-nvim"
local paq = require("paq-nvim").paq
paq {"savq/paq-nvim", opt = true}
paq {"rjoshdick/onedark.vim"}
paq {"valloric/MatchTagAlways"}
paq {"jeffkreeftmeijer/vim-numbertoggle"}
paq {"airblade/vim-rooter"}

paq {"tpope/vim-surround"}
paq {"tpope/vim-commentary"}
paq {"tpope/vim-repeat"}

paq {"rhysd/git-messenger.vim"} -- {{{
map("n", "<leader>c", ":GitMessenger<CR>")
-- }}}
paq {"airblade/vim-gitgutter"} -- {{{
g.gitgutter_map_keys = 0
-- }}}

paq {"scrooloose/nerdtree"} -- {{{
g.NERDTreeShowHidden = 1
g.NerdTreeWinSize = 70

map("n", "<F3>", ":NERDTreeToggle<CR>")

cmd "au FileType nerdtree nmap <buffer> a o"
-- }}}

paq {"nvim-treesitter/nvim-treesitter"} -- {{{
local ts = require "nvim-treesitter.configs"
ts.setup {
  ensure_installed = "maintained",
  highlight = {enable = true},
  indent = {enable = true}
}
-- }}}

paq {"neovim/nvim-lspconfig"} -- {{{
local lspconfig = require "lspconfig"
lspconfig.sumneko_lua.setup {
  cmd = {"lua-language-server"},
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        globals = {"vim"}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
        }
      }
    }
  }
}

local prettier = {formatCommand = "prettier"}
local eslint = {
  lintCommand = "eslint -f unix --stdin",
  lintIgnoreExitCode = true,
  lintStdin = true
}
local languages = {
  javascript = {prettier, eslint},
  typescript = {prettier, eslint},
  javascriptreact = {prettier, eslint},
  typescriptreact = {prettier, eslint},
  yaml = {prettier},
  json = {prettier},
  html = {prettier},
  scss = {prettier},
  css = {prettier},
  markdown = {prettier},
  lua = {{formatCommand = "luafmt -i 2 -l 82 --stdin", formatStdin = true}}
}

lspconfig.efm.setup {
  -- Fallback to .bashrc as a project root to enable LSP on loose files
  root_dir = lspconfig.util.root_pattern(".git/", ".bashrc"),
  -- Enable document formatting (other capabilities are off by default).
  init_options = {documentFormatting = true},
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = {
      ".git/",
      ".bashrc"
    },
    languages = languages
  }
}
lspconfig.tsserver.setup {
  on_attach = function(client)
    -- Disable formatting. Using prettier via the efm server for this.
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end
}
lspconfig.jedi_language_server.setup {}
lspconfig.gopls.setup {}
-- cmd 'au BufWritePre *.go lua vim.lsp.buf.formatting()'
lspconfig.dockerls.setup {}
lspconfig.yamlls.setup {}
lspconfig.jsonls.setup {}
lspconfig.bashls.setup {}
lspconfig.cssls.setup {}
lspconfig.rnix.setup {}
map("n", "<leader>,", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
map("n", "<leader>;", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
map("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
map("n", "<leader>d", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "F", "<cmd>lua vim.lsp.buf.formatting()<CR>")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "<leader>m", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>r", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "<leader>s", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
-- }}}

paq {"nvim-lua/completion-nvim"} -- {{{
paq {"steelsojka/completion-buffers"}

g.completion_chain_complete_list = {
  {complete_items = {"lsp"}},
  {complete_items = {"buffers"}},
  {mode = {"<c-p>"}},
  {mode = {"<c-n>"}}
}

cmd 'autocmd BufEnter * lua require"completion".on_attach()'
-- }}}

paq {"nvim-telescope/telescope.nvim"} -- {{{
paq {"nvim-lua/popup.nvim"}
paq {"nvim-lua/plenary.nvim"}
local telescope = require("telescope")
telescope.setup(
  {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      '-g "!.git"',
      '-g "!vendor"'
    }
  }
)
function Edit_dotfiles()
  require("telescope.builtin").find_files {
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    cwd = "~/.config/dotm/profiles/relnod",
    find_command = {
      "fd",
      "--type",
      "f",
      "--hidden",
      "-E",
      ".git"
    }
  }
end

function Edit_notes()
  require("telescope.builtin").find_files {
    prompt_title = "~ notes ~",
    shorten_path = false,
    cwd = "~/Notes",
    find_command = {
      "fd",
      "--type",
      "f",
      "--hidden",
      "-E",
      ".git"
    }
  }
end

map("n", "<leader>ff", '<cmd>lua require("telescope.builtin").find_files()<CR>')
map("n", "<leader>fg", '<cmd>lua require("telescope.builtin").git_files()<CR>')
map("n", "<leader>fa", '<cmd>lua require("telescope.builtin").live_grep()<CR>')
map("n", "<leader>fw", '<cmd>lua require("telescope.builtin").grep_string()<CR>')
map(
  "n",
  "<leader>fb",
  '<cmd>lua require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true, sorter = require\'telescope.sorters\'.get_substr_matcher() })<CR>'
)
map("n", "<leader>fh", '<cmd>lua require("telescope.builtin").help_tags()<CR>')
map("n", "<leader>fd", "<cmd>lua Edit_dotfiles()<CR>")
map("n", "<leader>fn", "<cmd>lua Edit_notes()<CR>")
-- }}}

-- }}}
-- SETTINGS {{{
-- colors
cmd "colorscheme onedark"
opt("o", "termguicolors", true)

-- mouse
opt("o", "mouse", "a")

-- buffers
opt("o", "hidden", true)

-- wildmenu, completion
opt("o", "completeopt", "menuone,noinsert,noselect")
-- set shortmess+=c
opt("o", "wildignorecase", true)
-- set wildignore+=*/.git/**/*
-- set wildignore+=tags
-- set wildignorecase

-- inccommand
opt("o", "inccommand", "split")

-- tabs, spaces
opt("o", "expandtab", true)
opt("o", "tabstop", 4)
opt("o", "softtabstop", 4)
opt("o", "shiftwidth", 4)

-- folding
opt("o", "foldmethod", "expr")
opt("o", "foldexpr", "nvim_treesitter#foldexpr()")
opt("o", "foldenable", false)

-- search
opt("o", "ignorecase", true)

-- opt('o', 'listchars', 'tab:▸ ,extends:❯,precedes:❮,trail:')
opt("o", "fillchars", "eob:█")
opt("o", "showbreak", "↪")

-- swap, undo, backup
opt("o", "swapfile", false)
opt("o", "undodir", home .. "/.local/share/nvim/undo/")
opt("o", "undofile", true)
opt("o", "backupdir", home .. "/.local/share/nvim/backup/")

opt("w", "number", true)
opt("w", "relativenumber", true)
opt("w", "list", true)
cmd "au BufRead,BufNewFile *.nix set filetype=nix"
-- }}}
-- MAPPINGS {{{
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>sw", ":w !sudo -S tee %<CR>")
map("n", "<leader>ir", ":luafile ~/.config/nvim/init.lua<CR>")
map("n", "<leader>io", ":e ~/.config/nvim/init.lua<CR>")
map("n", "<ESC>", ":noh<CR>:ccl<CR>")

-- sort selected lines
map("v", "<leader>s", ":sort<CR>")

-- faster movement
map("n", "<M-h>", "^")
map("n", "<M-j>", "5j")
map("n", "<M-k>", "5k")
map("n", "<M-l>", "$")

map("v", "<M-h>", "^")
map("v", "<M-j>", "5j")
map("v", "<M-k>", "5k")
map("v", "<M-l>", "$")
-- }}}
-- vim:fdm=marker
