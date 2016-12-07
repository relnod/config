""""""""""""""""""""""""""""""""""""""
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

Plugin 'ervandew/supertab'

call vundle#end()
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""COCLORSCHEME
" COCLORSCHEME
""""""""""""""""""""""""""""""""""""""
set background=dark
colorscheme elflord


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
syntax on

" Filetype
"filetype on
"filetype plugin on
"filetype indent on
