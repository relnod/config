" vim:fdm=marker

" TDOD's:
" - jump to last cursor position
" - mapping for moving up and down a few lines

" 1. PLUGINS {{{
" 1.1 Requirements {{{

" disable compatibility for vi
set nocompatible

filetype off

filetype plugin indent off

" }}}
" 1.2 Instalation {{{

" Plugins are managed with dein
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/vim/dein'))

call dein#add('Shougo/vimproc.vim', {'build' : 'make'})

call dein#add('scrooloose/nerdtree')
call dein#add('ctrlpvim/ctrlp.vim')

call dein#add('altercation/vim-colors-solarized')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

"call dein#add('Valloric/YouCompleteMe')
call dein#add('Shougo/neocomplete')
call dein#add('shawncplus/phpcomplete.vim')

call dein#add('airblade/vim-gitgutter')

call dein#end()

" }}}
" 1.3 Customization {{{
" 1.3.1 CtrlP {{{

let g:ctrlp_working_path_mode = 'ra'

nnoremap <leader>p :CtrlP<CR>

" }}}
" 1.3.2 Airline {{{

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'

" }}}
" 1.3.2 PHPComplete {{{

au Filetype php setlocal ofu=phpcomplete#CompletePHP

" }}}
" }}}
" }}}
" 2. Looks {{{
" Use 256 colours
set t_Co=256 " TODO: move elsewhere

" only redraw when needed
set lazyredraw

" 2.1 Theme {{{

set background=dark
colorscheme solarized

set guifont=Hack:h9

" }}}
" 2.2 Statusline {{{

" Always show statusline
set laststatus=2

" @see 1.3.2 Airline

" }}}
" 2.3 Code {{{

" show line number
set number
" show relative line numbers
set relativenumber

"set ruler

set cursorline

" enable syntax highting
syntax on

" Tabs " TODO: move elsewhere?
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Auto Indentation " TODO: move elsewhere?
set autoindent
set smartindent
set textwidth=80

" }}}
" }}}
" 3. Mappings {{{

" 3.1 General {{{

" Map Leader Key to Space
:let mapleader = "\<space>"


" Refresh .vimrc
nnoremap <leader>vr :so ~/.vimrc <CR>

" Open .vimrc
nnoremap <leader>vo :e  ~/.vimrc <CR>

" Toggle Highlight Search
noremap <leader>st :set invhlsearch<CR> " TODO: remap

" }}}

" 3.2 Movement {{{

" 3.2.1 Cursor {{{

" Move in Insert Mode
imap <C-h> <C-o>h
imap <C-j> <C-o>j
imap <C-k> <C-o>k
imap <C-l> <C-o>l

" faster hjkl movement " TODO: make text objects ?
nnoremap <S-h> ^
nnoremap <S-J> G
nnoremap <S-k> gg
nnoremap <S-l> $

" }}}

" 3.2.2 Text {{{

" Move Line Up/Down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" }}}

" }}}

" 3.3 Navigation {{{

" 3.3.1 Buffers {{{

" hide buffers when :e
" set hidden

nmap <leader>o :enew<CR>
nmap <leader>l :bnext<CR>
nmap <leader>h :bprevious<CR>
nmap <leader>q :bp <BAR> bd #<CR>
nmap <leader>bl :ls<CR>

" }}}

" 3.3.2 Window {{{

" TODO: remap window movement

" }}}

" 3.3.3 Tab {{{

nnoremap <leader>tl :tabnext<CR>
nnoremap <leader>th :tabprevious<CR>
nnoremap <leader>to :tabedit<CR>
nnoremap <leader>tq :tabclose<CR>

" }}}

" }}}

" }}}
" 4. Misc {{{
" 4.1 Search {{{

" search as characters are entere
set incsearch

" }}}
" }}}
