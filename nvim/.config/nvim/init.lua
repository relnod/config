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
-- PLUGIN MANAGER {{{
local install_path = fn.stdpath("data") .. "/site/pack/paqs/opt/paq-nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/savq/paq-nvim.git " .. install_path)
end

cmd "packadd paq-nvim"
local paq = require("paq-nvim").paq
paq {"savq/paq-nvim", opt = true}
-- }}}

-- WORKSPACE {{{
paq {"airblade/vim-rooter"}
-- }}}

-- EXPLORER {{{
paq {"scrooloose/nerdtree"}
g.NERDTreeShowHidden = 1
g.NerdTreeWinSize = 70

map("n", "<F3>", ":NERDTreeToggle<CR>")

cmd "au FileType nerdtree nmap <buffer> a o"
-- }}}

-- TREESITTER {{{
paq {"nvim-treesitter/nvim-treesitter"}
local ts = require "nvim-treesitter.configs"
ts.setup {
  ensure_installed = "maintained",
  highlight = {enable = true},
  indent = {enable = true}
}
-- }}}

-- COMPLETION {{{
opt("o", "completeopt", "menuone,noinsert,noselect") -- wildmenu, completion

paq {"hrsh7th/nvim-compe"}

require "compe".setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  allow_prefix_unmatch = false,
  source = {
    path = true,
    buffer = true,
    vsnip = true,
    nvim_lsp = true,
    nvim_lua = true
  }
}

-- use <c-space> to force completion
map("i", "<c-space>", '<C-r>=luaeval(\'require"compe"._complete()\')<CR>')

-- }}}

-- TELESCOPE {{{
paq {"nvim-telescope/telescope.nvim"}
paq {"nvim-lua/popup.nvim"}
paq {"nvim-lua/plenary.nvim"}
paq {
  "nvim-telescope/telescope-fzy-native.nvim",
  hook = "git submodule init && git submodule update"
}
local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden"
      -- '-g "!.git"',
      -- '-g "!vendor"'
    },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-w>"] = actions.send_selected_to_qflist,
        ["<C-q>"] = actions.send_to_qflist
      },
      n = {
        ["<C-w>"] = actions.send_selected_to_qflist,
        ["<C-q>"] = actions.send_to_qflist
      }
    }
  }
}
telescope.load_extension("fzy_native")

local find_command = {
  "fd",
  "--type",
  "f",
  "--hidden",
  "-E",
  ".git"
}
G_find_command = find_command

function G_edit_dotfiles()
  require("telescope.builtin").find_files {
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    cwd = "~/.config/dotm/profiles/relnod",
    find_command = find_command
  }
end

function G_edit_notes()
  require("telescope.builtin").find_files {
    prompt_title = "~ notes ~",
    shorten_path = false,
    cwd = "~/Notes",
    find_command = find_command
  }
end

map(
  "n",
  "<leader>ff",
  '<cmd>lua require("telescope.builtin").find_files({ find_command = G_find_command })<CR>'
)
map("n", "<leader>fg", '<cmd>lua require("telescope.builtin").git_files()<CR>')
map("n", "<leader>fa", '<cmd>lua require("telescope.builtin").live_grep()<CR>')
map(
  "n",
  "<leader>fw",
  '<cmd>lua require("telescope.builtin").grep_string()<CR>'
)
map(
  "n",
  "<leader>fb",
  '<cmd>lua require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true, sorter = require\'telescope.sorters\'.get_substr_matcher() })<CR>'
)
map("n", "<leader>fh", '<cmd>lua require("telescope.builtin").help_tags()<CR>')
map("n", "<leader>fd", "<cmd>lua G_edit_dotfiles()<CR>")
map("n", "<leader>fn", "<cmd>lua G_edit_notes()<CR>")
-- }}}

-- LSP {{{
paq {"neovim/nvim-lspconfig"}
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

local on_attach = function(_)
  -- Goto
  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")

  -- Find
  map(
    "n",
    "<leader>r",
    "<cmd>lua require('telescope.builtin').lsp_references()<CR>"
  )
  map(
    "n",
    "<leader>s",
    "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>"
  )

  -- Hover
  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")

  -- Code Action
  map(
    "n",
    "<leader>a",
    "<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>"
  )
  map(
    "v",
    "<leader>a",
    "<cmd>lua require('telescope.builtin').lsp_range_code_actions()<CR>"
  )

  -- Rename
  map("n", "<leader>m", "<cmd>lua vim.lsp.buf.rename()<CR>")

  -- Diagnostics
  map(
    "n",
    "<leader>d",
    "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>"
  )
  map("n", "<leader>;", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
  map("n", "<leader>,", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")

  -- Formating
  map("n", "F", "<cmd>lua vim.lsp.buf.formatting()<CR>")
  map("v", "F", "<cmd>lua vim.lsp.buf.range_formatting()<CR>")
end
local prettier = {
  formatCommand = "./node_modules/.bin/prettier --stdin-filepath ${INPUT}",
  formatStdin = true
}
local eslint = {
  lintCommand = "eslint -f unix --stdin",
  lintIgnoreExitCode = true,
  lintStdin = true
}
local luafmt = {
  formatCommand = "luafmt -i 2 -l 80 --stdin",
  formatStdin = true
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
  lua = {luafmt}
}

lspconfig.efm.setup {
  on_attach = on_attach,
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
    on_attach(client)
  end
}
lspconfig.jedi_language_server.setup {
  on_attach = on_attach
}
lspconfig.gopls.setup {
  on_attach = on_attach
}
-- cmd 'au BufWritePre *.go lua vim.lsp.buf.formatting()'
lspconfig.dockerls.setup {
  on_attach = on_attach
}
lspconfig.yamlls.setup {
  on_attach = on_attach
}
lspconfig.jsonls.setup {
  on_attach = on_attach
}
lspconfig.bashls.setup {
  on_attach = on_attach
}
lspconfig.cssls.setup {
  on_attach = on_attach
}
lspconfig.rnix.setup {
  on_attach = on_attach
}

paq {"kosayoda/nvim-lightbulb"}
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb { sign_priority = 5 } ]]
-- }}}

-- GIT {{{
paq {"rhysd/git-messenger.vim"}
map("n", "<leader>c", ":GitMessenger<CR>")

paq {"airblade/vim-gitgutter"}
g.gitgutter_map_keys = 0
-- }}}

-- TEXT SURROUND {{{
paq {"tpope/vim-surround"}
paq {"tpope/vim-repeat"}
-- }}}
-- TEXT COMMENTING {{{
paq {"tpope/vim-commentary"}
-- }}}
-- TEXT ALIGN {{{
paq {"godlygeek/tabular"}
map("v", "ga", ":Tabularize /")
-- }}}

-- UI COLORSCHEME {{{
paq {"rjoshdick/onedark.vim"}
cmd "colorscheme onedark"       -- colorscheme
opt("o", "termguicolors", true) -- enable termguicolors
-- }}}
-- UI LINE NUMBERS {{{
opt("w", "number", true)                  -- enable line numbers
opt("w", "relativenumber", true)          -- enable relative line numbers
paq {"jeffkreeftmeijer/vim-numbertoggle"} -- disabled relative line numbers for non current buffer
-- }}}
-- UI TAGS {{{
paq {"valloric/MatchTagAlways"}
-- }}}

-- SETTINGS {{{
opt("o", "mouse", "a")                               -- enable mouse

opt("o", "hidden", true)                             -- allow switching unsafed buffers

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
-- TODO {{{
cmd "au BufRead,BufNewFile *.todo set filetype=todo"
-- function RequireFtPlugin()
-- end
-- cmd string.format("au BufRead,BufNewFile *.todo :lua require('/.config/nvim/ftplugin/todo')")
-- cmd { "au BufRead,BufNewFile *.todo lua require('" .. home .. "/.config/nvim/ftplugin/todo')" }
-- }}}

-- vim:fdm=marker
