-- OVERVIEW {{{
-- Mappings:
--   n <A-v> Toggle left window
--   n <A-b> Toggle bottom window
--   n <A-n> Toggle top window
--   n <A-m> Toggle right window
--   n <A-e> Toggle explorer window
--   n <A-q> Toggle quickfix window
--   n <A-t> Toggle terminal window
--   n <A-1> Toggle terminal 1 window
--       ...
--   n <A-10> Toggle terminal 10 window
-- }}}

-- PLUGIN MANAGER {{{
local plugin = require("relnod/plugin").plugin
vim.cmd [[ command! -nargs=* PluginInstall lua require("relnod/plugin").install() ]]
vim.cmd [[ command! -nargs=* PluginUpdate lua require("relnod/plugin").update() ]]
vim.cmd [[ command! -nargs=* PluginStatus lua require("relnod/plugin").status() ]]
-- }}}
-- HELPERS {{{
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
local opt = function(scope, key, value)
  scopes[scope][key] = value
  if scope ~= "o" then
    scopes["o"][key] = value
  end
end

local home = os.getenv("HOME")

plugin {"nvim-lua/plenary.nvim"}
RELOAD = require("plenary.reload").reload_module

P = function(v)
  print(vim.inspect(v))
  return v
end

local actions = require("relnod/actions")
local map = require("relnod/keymap").map
-- }}}

-- GENERAL SETTINGS {{{
opt("o", "mouse", "a") -- enable mouse

opt("o", "hidden", true) -- allow switching unsafed buffers

-- set shortmess+=c
opt("o", "wildignorecase", true)
-- set wildignore+=*/.git/**/*
-- set wildignore+=tags
-- set wildignorecase

-- inccommand
opt("o", "inccommand", "split")

-- scroll
opt("o", "scrolloff", 10)

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
opt("o", "smartcase", true)

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn="yes"

-- opt('o', 'listchars', 'tab:▸ ,extends:❯,precedes:❮,trail:')
opt("o", "fillchars", "eob:█")
opt("o", "showbreak", "↪")

-- swap, undo, backup
opt("o", "swapfile", false)
opt("o", "backupdir", home .. "/.local/share/nvim/backup/")
vim.cmd [[ set undofile ]]

opt("w", "list", true)
vim.cmd "au BufRead,BufNewFile *.nix set filetype=nix"
-- }}}
-- GENERAL MAPPINGS {{{
vim.g.mapleader = " "

map("n", "<leader>w", ":w<CR>") -- save file
map("n", "<leader>sw", ":w !sudo -S tee %<CR>") -- save file using sudo
map("n", "<leader>ir", ":luafile ~/.config/nvim/init.lua<CR>") -- reload init.lua
map("n", "<leader>ie", ":edit ~/.config/nvim/init.lua<CR>") -- reload init.lua
map("n", "<ESC>", ":noh<CR>:cclose<CR>") -- stop search highlighting and close quickfix
map("n", "gh", ":help <C-r><C-w><CR>") -- goto help file for word under curor

map("n", "<leader>x", ":luafile %<CR>")

-- sort selected lines
map("v", "<leader>s", ":sort<CR>")

-- window movement
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- faster movement
map("n", "<M-h>", "^")
map("n", "<M-j>", "5j")
map("n", "<M-k>", "5k")
map("n", "<M-l>", "$")

map("v", "<M-h>", "^")
map("v", "<M-j>", "5j")
map("v", "<M-k>", "5k")
map("v", "<M-l>", "$")

map("t", "<M-h>", "^")
map("t", "<M-j>", "5j")
map("t", "<M-k>", "5k")
map("t", "<M-l>", "$")
-- }}}

-- TREESITTER {{{
plugin {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    local treeseitter = require("nvim-treesitter.configs")
    treeseitter.setup {
      ensure_installed = "maintained",
      highlight = {enable = true},
      indent = {enable = true}
    }
  end
}
-- highlights yanked text
vim.cmd [[ augroup highlight_yank ]]
vim.cmd [[   autocmd! ]]
vim.cmd [[   autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank() ]]
vim.cmd [[ augroup END ]]
-- }}}

-- START SCREEN {{{
plugin {
  "mhinz/vim-startify",
  config = function()
    vim.g.startify_lists = {
      {type = "dir", header = {"   MRU"}},
      {type = "commands", header = {"   Commands"}}
    }

    vim.g.startify_commands = {
      {g = {"Find Git Files", "lua require('telescope.builtin').git_files()"}},
      {u = {"Update Plugins", ":PluginUpdate"}}
    }
  end
}
-- }}}
-- WORKSPACE {{{
plugin {"airblade/vim-rooter"}
-- }}}

-- WINDOW {{{
RELOAD("relnod.window")
local window = require("relnod.window")
window.setup {
  top = {
    location = "top",
    size = 20
  },
  bottom = {
    location = "bottom",
    size = 20
  },
  left = {
    location = "left",
    size = 40
  },
  right = {
    location = "right",
    size = 80
  }
}
map(
  "n",
  "<A-v>",
  function()
    window.toggle("left")
  end
)
map(
  "n",
  "<A-b>",
  function()
    window.toggle("bottom")
  end
)
map(
  "n",
  "<A-n>",
  function()
    window.toggle("top")
  end
)
map(
  "n",
  "<A-m>",
  function()
    window.toggle("right")
  end
)
-- }}}
-- TERMINAL {{{
map("t", "<A-Esc>", "<C-\\><C-n>")
vim.cmd [[ autocmd TermOpen * setlocal nocursorline ]]

RELOAD("relnod/terminal")
local terminal = require("relnod/terminal")
for i = 1, 10, 1 do
  local termname = string.format("term%d", i)
  terminal.setup {
    [termname] = {
      window = "bottom",
      mappings = {
        n = {
          ["gf"] = actions.open_file_under_cursor
        }
      }
    }
  }
  map(
    "n",
    string.format("<A-%s>", i),
    function()
      terminal.toggle(termname)
    end
  )
  map(
    "t",
    string.format("<A-%s>", i),
    function()
      terminal.toggle(termname)
    end
  )
end
map(
  "n",
  "<A-t>",
  function()
    terminal.toggle("term1")
  end
)
map(
  "t",
  "<A-t>",
  function()
    terminal.toggle("term1")
  end
)
map(
  "n",
  "<A-r>",
  function()
    terminal.run_current_line("term1")
  end
)
map(
  "v",
  "<A-r>",
  function()
    terminal.run_selection("term1")
  end
)
-- }}}
-- QUICKFIX {{{
map("n", "<A-q>", ":copen<CR>")
map("n", "<C-j>", ":cnext<CR>")
map("n", "<C-k>", ":cprev<CR>")

-- RELOAD("relnod/quickfix")
-- local quickfix = require("relnod/quickfix")
-- quickfix.setup {
--   ["qf"] = {
--     window = "bottom"
--   }
-- }
-- map(
--   "n",
--   "<A-q>",
--   function()
--     quickfix.toggle("qf")
--   end
-- )
-- }}}
-- EXPLORER {{{
plugin {
  "scrooloose/nerdtree",
  lazy = true,
  config = function()
    vim.g.NERDTreeShowHidden = 1
    vim.g.NerdTreeWinSize = 70

    map("n", "<A-e>", ":NERDTreeToggle<CR>")

    vim.cmd "au FileType nerdtree nmap <buffer> a o"
  end
}
-- }}}
-- TELESCOPE {{{
plugin {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  requires = {
    {"nvim-lua/popup.nvim"},
    {"nvim-lua/plenary.nvim"},
    {
      "nvim-telescope/telescope-fzy-native.nvim",
      hook = {"git submodule init", "git submodule update"},
      config = function()
        require("telescope").load_extension("fzy_native")
      end
    }
  },
  config = function()
    local telescope = require("telescope")
    local tel_builtin = require("telescope.builtin")
    local tel_actions = require("telescope.actions")
    local tel_action_set = require("telescope.actions.set")
    local tel_action_state = require("telescope.actions.state")
    local tel_sorters = require("telescope.sorters")

    local function tel_actions_send_selected_to_qflist(...)
      tel_actions.send_selected_to_qflist(...)
      tel_actions.open_qflist(...)
      window.close("bottom")
      -- quickfix.open("qf")
    end
    local function tel_actions_send_to_qflist(...)
      tel_actions.send_to_qflist(...)
      tel_actions.open_qflist(...)
      window.close("bottom")
      -- quickfix.open("qf")
    end

    telescope.setup {
      defaults = {
        file_sorter = tel_sorters.get_fzy_sorter,
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
            ["<esc>"] = tel_actions.close,
            ["<C-w>"] = tel_actions_send_selected_to_qflist,
            ["<C-q>"] = tel_actions_send_to_qflist,
            ["<C-s>"] = tel_actions.select_horizontal,
            ["<C-x>"] = false
          }
        }
      },
      extensions = {
        fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true
        }
      }
    }

    local find_command = {
      "fd",
      "--type",
      "f",
      "--hidden",
      "-E",
      ".git"
    }

    local function tel_cmd(tel_command, opts)
      local options = {
        attach_mappings = function(_)
          tel_action_set.edit:replace(
            function(prompt_bufnr, command)
              local entry = tel_action_state.get_selected_entry()

              if not entry then
                print("[telescope] Nothing currently selected")
                return
              end

              local filename, row, col

              if entry.filename then
                filename = entry.path or entry.filename

                -- TODO: Check for off-by-one
                row = entry.row or entry.lnum
                col = entry.col
              elseif not entry.bufnr then
                -- TODO: Might want to remove this and force people
                -- to put stuff into `filename`
                local value = entry.value
                if not value then
                  print("Could not do anything with blank line...")
                  return
                end

                if type(value) == "table" then
                  value = entry.display
                end

                local sections = vim.split(value, ":")

                filename = sections[1]
                row = tonumber(sections[2])
                col = tonumber(sections[3])
              end

              local entry_bufnr = entry.bufnr

              require("telescope.actions").close(prompt_bufnr)

              if entry_bufnr then
                actions.open_buffer(entry_bufnr, command)
              else
                local path = require("telescope.path")
                filename =
                  path.normalize(vim.fn.fnameescape(filename), vim.loop.cwd())

                actions.open_file(filename, command, row, col)
              end
            end
          )

          return true
        end
      }
      if opts ~= nil then
        options = vim.tbl_extend("force", options, opts)
      end

      return function()
        tel_command(options)
      end
    end

    local edit_dotfiles =
      tel_cmd(
      tel_builtin.find_files,
      {
        prompt_title = "~ dotfiles ~",
        shorten_path = false,
        cwd = "~/.config/dotm/profiles/relnod",
        find_command = find_command
      }
    )

    local edit_notes =
      tel_cmd(
      tel_builtin.find_files,
      {
        prompt_title = "~ notes ~",
        shorten_path = false,
        cwd = "~/Notes",
        find_command = find_command
      }
    )

    local find_neovim_plugin =
      tel_cmd(
      tel_builtin.find_files,
      {
        prompt_title = "~ Plugins ~",
        shorten_path = false,
        cwd = "~/.local/share/nvim/site/pack/plugins",
        find_command = find_command
      }
    )

    map(
      "n",
      "<leader>ff",
      tel_cmd(tel_builtin.find_files, {find_command = find_command})
    )
    map("n", "<leader>fg", tel_cmd(tel_builtin.git_files))
    map("n", "<leader>fa", tel_cmd(tel_builtin.live_grep))
    _Search = _Search or ""
    map(
      "n",
      "<leader>qr",
      function()
        tel_cmd(
          tel_builtin.grep_string,
          {
            search = _Search
          }
        )()
      end
    )
    map(
      "n",
      "<leader>fs",
      function()
        local search = vim.fn.input("Grep For: ")
        _Search = search
        tel_cmd(
          tel_builtin.grep_string,
          {
            search = search
          }
        )()
      end
    )
    map("n", "<leader>fw", tel_cmd(tel_builtin.grep_string))
    map("v", "<leader>fw", tel_cmd(tel_builtin.grep_string))
    map(
      "n",
      "<leader>fb",
      tel_cmd(
        tel_builtin.buffers,
        {
          sort_lastused = true,
          ignore_current_buffer = true,
          sorter = tel_sorters.get_substr_matcher()
        }
      )
    )
    map(
      "n",
      "<leader>fc",
      function()
        tel_cmd(
          tel_builtin.find_files,
          {
            cwd = vim.fn.expand("%:p:h")
          }
        )()
      end
    )
    map("n", "<leader>fe", tel_cmd(tel_builtin.lsp_workspace_diagnostics))
    map("n", "<leader>fh", tel_cmd(tel_builtin.help_tags))
    map("n", "<leader>fk", tel_cmd(tel_builtin.keymaps))
    map("n", "<leader>fd", edit_dotfiles)
    map("n", "<leader>fn", edit_notes)
    map("n", "<leader>fp", find_neovim_plugin)
  end
}
-- }}}

-- COMPLETION {{{
opt("o", "completeopt", "menuone,noinsert,noselect") -- wildmenu, completion

plugin {
  "hrsh7th/nvim-compe",
  config = function()
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
        nvim_lsp = true,
        nvim_lua = true
      }
    }

    -- use <c-space> to force completion
    map("i", "<c-space>", '<C-r>=luaeval(\'require"compe"._complete()\')<CR>')
  end
}

plugin {
  "onsails/lspkind-nvim",
  lazy = true,
  config = function()
    require("lspkind").init {}
  end
}
-- }}}
-- LSP {{{
plugin {
  "neovim/nvim-lspconfig",
  lazy = true,
  config = function()
    local lspconfig = require "lspconfig"
    local on_attach = function(_, bufnr)
      local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
      end

      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      -- Mappings.
      local opts = {noremap = true, silent = true}
      -- Goto
      buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
      buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
      buf_set_keymap(
        "n",
        "gi",
        "<cmd>lua vim.lsp.buf.implementation()<CR>",
        opts
      )

      -- Find
      buf_set_keymap(
        "n",
        "<leader>r",
        "<cmd>lua require('telescope.builtin').lsp_references()<CR>",
        opts
      )
      buf_set_keymap(
        "n",
        "<leader>s",
        "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>",
        opts
      )

      -- Hover
      buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

      -- Code Action
      buf_set_keymap(
        "n",
        "<leader>a",
        "<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>",
        opts
      )
      buf_set_keymap(
        "v",
        "<leader>a",
        "<cmd>lua require('telescope.builtin').lsp_range_code_actions()<CR>",
        opts
      )

      -- Rename
      buf_set_keymap(
        "n",
        "<leader>m",
        "<cmd>lua vim.lsp.buf.rename()<CR>",
        opts
      )

      -- Diagnostics
      buf_set_keymap(
        "n",
        "<leader>d",
        "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
        opts
      )
      buf_set_keymap(
        "n",
        "<leader>;",
        "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",
        opts
      )
      buf_set_keymap(
        "n",
        "<leader>,",
        "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
        opts
      )

      -- Formating
      buf_set_keymap("n", "F", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
      buf_set_keymap(
        "v",
        "F",
        "<cmd>lua vim.lsp.buf.range_formatting()<CR>",
        opts
      )
    end

    lspconfig.sumneko_lua.setup {
      cmd = {"lua-language-server"},
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
            version = "LuaJIT",
            -- Setup your lua path
            path = vim.split(package.path, ";")
          },
          diagnostics = {
            enable = true,
            globals = {"vim", "RELOAD", "P"}
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
    local function organize_imports()
      local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
      }
      vim.lsp.buf.execute_command(params)
    end
    lspconfig.tsserver.setup {
      on_attach = function(client)
        -- Disable formatting. Using prettier via the efm server for this.
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
        on_attach(client)
      end,
      commands = {
        OrganizeImports = {
          organize_imports,
          description = "Organize Imports"
        }
      }
    }
    lspconfig.jedi_language_server.setup {
      on_attach = on_attach
    }
    lspconfig.gopls.setup {
      on_attach = on_attach
    }
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
    lspconfig.clangd.setup {
      on_attach = on_attach
    }
  end
}

plugin {
  "kosayoda/nvim-lightbulb",
  lazy = true,
  config = function()
    vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb { sign_priority = 5 } ]]
  end
}
-- }}}
-- GIT {{{
plugin {
  "rhysd/git-messenger.vim",
  lazy = true,
  config = function()
    map("n", "<leader>c", ":GitMessenger<CR>")

    plugin {"airblade/vim-gitgutter"}
    vim.g.gitgutter_map_keys = 0
  end
}
-- }}}
-- SEARCH {{{
plugin {"brooth/far.vim"}
--}}}

-- EDITORCONFIG {{{
plugin{ "editorconfig/editorconfig-vim" }
-- }}}

-- TEXT SURROUND {{{
plugin {"tpope/vim-surround", lazy = true}
plugin {"tpope/vim-repeat", lazy = true}
-- }}}
-- TEXT COMMENTING {{{
plugin {"tpope/vim-commentary", lazy = true}
-- }}}
-- TEXT ALIGN {{{
plugin {
  "godlygeek/tabular",
  lazy = true,
  config = function()
    map("v", "ga", ":Tabularize /")
  end
}
-- }}}

-- UI STATUSLINE {{{
plugin {
  "hoob3rt/lualine.nvim",
  requires = {{"kyazdani42/nvim-web-devicons"}},
  config = function()
    local lualine = require("lualine")
    lualine.status(
      {
        options = {
          theme = "onedark",
          section_separators = {"", ""},
          component_separators = {"", ""},
          icons_enabled = true
        }
      }
    )
  end
}
-- }}}
-- UI COLORSCHEME {{{
opt("o", "termguicolors", true) -- disable termguicolors
plugin {
  "joshdick/onedark.vim",
  config = function()
    -- Needed to ensure float background doesn't get odd highlighting
    -- https://github.com/joshdick/onedark.vim#onedarkset_highlight
    vim.cmd [[augroup colorset]]
    vim.cmd [[autocmd!]]
    vim.cmd [[autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" } })]]
    vim.cmd [[augroup END]]
    vim.cmd "colorscheme onedark" -- colorscheme
  end
}
-- }}}
-- UI LINE NUMBERS {{{
opt("w", "number", true) -- enable line numbers
opt("w", "relativenumber", true) -- enable relative line numbers
plugin {"jeffkreeftmeijer/vim-numbertoggle", lazy = true} -- disabled relative line numbers for non current buffer
-- }}}
-- UI CURSOR {{{
opt("w", "cursorline", true) -- enable line numbers
-- }}}
-- UI TAGS {{{
plugin {"valloric/MatchTagAlways", lazy = true}
-- }}}

-- TODO {{{
vim.cmd "au BufRead,BufNewFile *.todo set filetype=todo"
-- function RequireFtPlugin()
-- end
-- vim.cmd string.format("au BufRead,BufNewFile *.todo :lua require('/.config/nvim/ftplugin/todo')")
-- vim.cmd { "au BufRead,BufNewFile *.todo lua require('" .. home .. "/.config/nvim/ftplugin/todo')" }
-- }}}

-- LOCAL .nvimrc.lua {{{
-- Check if a ".nvimrc.lua" file exists in the current directory, if so run it.
if vim.fn.empty(vim.fn.glob(".nvimrc.lua")) == 0 then
  vim.cmd("luafile " .. ".nvimrc.lua")
end
-- }}}

-- vim:fdm=marker
