set runtimepath^=~/.vim
set runtimepath+=~/.vim/after

" map Leader key to Space
let g:mapleader = "\<space>"

" Plugins {{{

call plug#begin('~/.vim/plugged')

" COMPLETION
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } " {{{
let g:deoplete#enable_at_startup = 1
" }}}
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'Shougo/neosnippet.vim' " {{{
let g:neosnippet#snippets_directory='~/.config/nvim/snippets/'

imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
" }}}
Plug 'Shougo/neosnippet-snippets'

" LANGUAGE
" A collection of language plugins
Plug 'sheerun/vim-polyglot'
Plug 'https://github.com/w0rp/ale' " {{{
let g:ale_linters = {
\  'javascript': ['eslint', 'flow'],
\}
nnoremap ]a :ALEPrevious<CR>
nnoremap [a :ALENext<CR>
" }}}
Plug 'autozimu/LanguageClient-neovim' " {{{

let g:LanguageClient_serverCommands = {
    \ 'python': ['~/tools/repos/palantir/python-language-server/pyls'],
    \ 'go': ['go-langserver'],
    \ 'php': ['php', '~/dev/repos/felixfbecker/php-language-server/bin/php-language-server.php'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'typescript': ['javascript-typescript-stdio'],
\ }

" autocmd FileType php LanguageClientStart

nnoremap <leader>sh :call LanguageClient_textDocument_hover()<CR>
nnoremap <leader>sd :call LanguageClient_textDocument_definition()<CR>
nnoremap <leader>sr :call LanguageClient_textDocument_references()<CR>
nnoremap <leader>se :call LanguageClient_textDocument_rename()<CR>
nnoremap <leader>ss :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <leader>sf :call LanguageClient_textDocument_formatting()<CR>
nnoremap <leader>sw :call LanguageClient_workspace_symbol()<CR>
" }}}
" Viml
Plug 'Shougo/neco-vim', { 'for': 'vim' }
" PHP
Plug 'StanAngeloff/php.vim', { 'for': 'php' } " {{{
function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END
" }}}
" SMARTY
Plug 'blueyed/smarty.vim'
" Go
Plug 'fatih/vim-go', { 'for': 'go' } " {{{
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_fold_enable = ['block']

let g:go_fmt_command = 'goimports'

augroup vimgo
    au FileType go nnoremap <leader>r :GoRename<CR>
    au FileType go nnoremap <leader>tco :GoCoverageToggle<CR>

    au FileType go set foldmethod=syntax
    au FileType go set nofoldenable
    au FileType go set foldnestmax=1
augroup end
" }}}
Plug 'sebdah/vim-delve', { 'for': 'go' } " {{{
augroup godebug
    au FileType go nnoremap <leader>dd :DlvDebug<CR>
    au FileType go nnoremap <leader>db :DlvToggleBreakpoint<CR>
    au FileType go nnoremap <leader>dt :DlvTest<CR>
augroup end
" }}}
" Javascript/Typescript
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'leafgarland/typescript-vim'
" Elm
Plug 'ElmCast/elm-vim'
" C/C++
Plug 'rhysd/vim-clang-format', { 'for': 'cpp' }
" Less
Plug 'groenewege/vim-less', { 'for': 'less' }
" Rust
Plug 'racer-rust/vim-racer', { 'for': 'rust' } " {{{
let g:racer_cmd = '~/.cargo/bin/racer'

augroup vimrust
    au FileType rust nnoremap gd <Plug>(rust-def)
    au FileType rust nnoremap gs <Plug>(rust-def-split)
    au FileType rust nnoremap gx <Plug>(rust-def-vertical)
    au FileType rust nnoremap gc <Plug>(rust-doc)
augroup end
" }}}
Plug 'roxma/nvim-cm-racer', { 'for': 'rust' }

" NAVIGATION
Plug 'airblade/vim-rooter' " {{{
let g:rooter_silent_chdir=1
" }}}
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " {{{
let g:NERDTreeShowHidden=1
let g:NerdTreeWinSize=70

nnoremap <F3> :NERDTreeToggle<CR>

augroup nerdtree
    au FileType nerdtree nmap <buffer> a o
augroup end
" }}}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim' " {{{
nnoremap <silent><leader>ff :Files<CR>
nnoremap <silent><leader>fg :GFiles<CR>

nnoremap <silent><leader>fb :Buffers<CR>

nnoremap <silent><leader>fl :Lines<CR>
nnoremap <silent><leader>fa :FindWord<CR>
vnoremap <silent><leader>fa :FindWord<space><SID>get_visual_selection()<CR>
nnoremap <silent><leader>fw :FindWord<space><C-R><C-W><CR>
nnoremap <silent><leader>fd :FindDir<space>

nnoremap <silent><leader>fh :Helptags<CR>
nnoremap <silent><leader>ft :Tags<CR>
nnoremap <silent><leader>fm :Maps<CR>
nnoremap <silent><leader>fc :Commits<CR>

let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit' }
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags'
let g:fzf_layout = { 'down': '40%' }

function! s:find_word(word) abort
    let l:searchword = a:word
    if l:searchword ==# ''
        let l:searchword = '.'
    endif
    call fzf#vim#grep("rg --hidden -g '!.git' -g '!vendor' --column --color 'always' '" . l:searchword . "'", 1)
endfunction

function! s:find_dir(dir) abort
    call fzf#vim#grep("rg --hidden -g '!.git' --files '.' " . a:dir, 1)
endfunction

function! s:find_files_mru() abort
    call fzf#run(fzf#wrap({
    \   'source': "rg --hidden -g '!.git' --files '.' " .
    \             "| xargs -L 100 -d '\n' ls -l --time-style +'%s' " .
    \             "| sort -k 6 -n -r --parallel 16 | awk '{print $7}'",
    \ }))
endfunction

function! s:find_git_files_mru() abort
    call fzf#run(fzf#wrap({'source': 'git ls-files --other --modified --exclude-standard'}))
endfunction

command! -nargs=* FindWord call s:find_word(<q-args>)
command! -nargs=1 -complete=file FindDir call s:find_dir(<q-args>)
command! -nargs=0 GFilesMru call s:find_git_files_mru()
command! -nargs=0 FilesMru call s:find_files_mru()
" }}}

" LOOKS
Plug 'altercation/vim-colors-solarized'
Plug 'daylerees/colour-schemes', { 'rtp': 'vim/' }
Plug 'joshdick/onedark.vim'
Plug 'valloric/MatchTagAlways'
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" GIT
Plug 'airblade/vim-gitgutter' " {{{
let g:gitgutter_map_keys = 0
nnoremap ]h <Plug>GitGutterNextHunk
nnoremap [h <Plug>GitGutterPrevHunk
" }}}
Plug 'tpope/vim-fugitive' " {{{
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Glog<CR>
" }}}

" UTILS
Plug 'irrationalistic/vim-tasks' " {{{
augroup tasks
    autocmd FileType tasks setlocal tw=100000
augroup END
" }}}
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'junegunn/vim-easy-align' " {{{
vmap <leader>a <Plug>(EasyAlign)
" }}}
Plug 'justinmk/vim-sneak' " {{{
map s <Plug>Sneak_s
map S <Plug>Sneak_S
" }}}

" MISC
Plug 'editorconfig/editorconfig-vim'
Plug 'benizi/vim-automkdir'
Plug 'tweekmonster/nvimdev.nvim'

call plug#end()
" }}}
" Settings {{{

filetype plugin indent on
syntax enable

set list

set inccommand=split

" search
set ignorecase

" wildmenu
set completeopt="menuone,noinsert"

set wildignore+=*/.git/**/*
set wildignore+=tags
set wildignorecase

" colors
set termguicolors
set t_Co=256
set background=dark
colorscheme onedark

set mouse=a

" statusline
set laststatus=2
set noshowmode

" show line number
set number

set scrolloff=2
set matchtime=4

" buffers
set hidden

" tab/space
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" indentation
set autoindent
set smartindent
set cindent
set textwidth=80

" undo/backup
set noswapfile
set undodir=~/.vim/tmp/undo//
set undofile
set backupdir=~/.vim/tmp/backup//
set backup

" }}}
" Mappings {{{

nnoremap Y y$

nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
" opposite to <S-j>
nnoremap <S-k> i<CR><ESC>

nnoremap <leader>vr :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>vo :tabnew ~/.config/nvim/init.vim<CR>
nnoremap <leader>so :source %<CR>

" toggle options
nnoremap <leader>ts :set hlsearch!<CR>
nnoremap <leader>tc :set cursorline!<CR>
nnoremap <leader>to :call autohighlight#Toggle()<CR>

" search
nnoremap <ESC> :noh<CR>

" faster movement
nnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>

nnoremap <M-h> ^
nnoremap <M-j> 5j
nnoremap <M-k> 5k
nnoremap <M-l> $

vnoremap <M-h> ^
vnoremap <M-j> 5j
vnoremap <M-k> 5k
vnoremap <M-l> $

" tab navigation
nnoremap <leader>h :tabprevious<CR>
nnoremap <leader>l :tabnext<CR>

" }}}

" vim:fdm=marker
