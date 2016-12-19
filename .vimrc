"""""""""""""""""""""""""""""""""""""
" POWERLINE
""""""""""""""""""""""""""""""""""""""
" python2.7
" local
if !empty(glob("~/.local/lib/python2.7/site-packages/powerline/bindings/vim/"))
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
endif
" python3.5
"global
if !empty(glob("/usr/lib/python3.5/site-packages/powerline/bindings/vim/"))
set rtp+=/usr/lib/python3.5/site-packages/powerline/bindings/vim/
endif

" Always show statusline
set laststatus=2

" Use 256 colours 
set t_Co=256


""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""
" Requirements
set nocompatible
filetype off

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'


Plugin 'scrooloose/nerdtree'
Plugin 'altercation/vim-colors-solarized'
"Plugin 'ervandew/supertab'

call vundle#end()
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""
" COCLORSCHEME
""""""""""""""""""""""""""""""""""""""
set background=dark
colorscheme solarized

""""""""""""""""""""""""""""""""""""""
" FORMATTING
""""""""""""""""""""""""""""""""""""""
" Tabs
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Auto Indentation
set autoindent
set textwidth=80

""""""""""""""""""""""""""""""""""""""
" FORMATTING
""""""""""""""""""""""""""""""""""""""
" Show linenumbers
set number

" Syntax

syntax enable

" Filetype
"filetype on
"filetype plugin on
"filetype indent on


""""""""""""""""""""""""""""""""""""""
" MOVE
""""""""""""""""""""""""""""""""""""""
" MOVE LINES UP/DOWN

" Normal Mode
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
" INSERT MODE
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
" VISUAL MODE
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv



""""""""""""""""""""""""""""""""""""""
" TABS
""""""""""""""""""""""""""""""""""""""
nnoremap <C-p> :tabprevious<CR>
nnoremap <C-n> :tabnext<CR>
nnoremap <C-x> :tabclose<CR>
