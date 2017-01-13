set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.vim/dein'))

if v:version < 800 && !has('nvim')
    call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
    "call dein#add('Valloric/YouCompleteMe')
    call dein#add('Shougo/neocomplete')
elseif has('nvim')
    call dein#add('Shougo/deoplete.nvim')
    call dein#set_hook('deoplete.nvim', 'hook_source', 'execute "source" ~/.vim/plugins/deoplete.vimrc')
endif

call dein#add('Shougo/neco-Vim')

call dein#add('ctrlpvim/ctrlp.vim')
call dein#add('scrooloose/nerdtree')

call dein#add('altercation/vim-colors-solarized')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

call dein#add('shawncplus/phpcomplete.vim')

call dein#add('airblade/vim-gitgutter')

call dein#end()
call dein#save_state()

if !has('vim_starting')
    call dein#call_hook('source')
endif

if dein#check_install()
  call dein#install()
endif

let g:deocomplete#enable_at_startup = 1
filetype plugin indent on
