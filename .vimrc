if !empty(glob("/usr/lib/python2.7/site-packages/powerline/bindings/vim/"))
set rtp+=/usr/lib/python2.7/site-packages/powerline/bindings/vim/
endif
if !empty(glob("/usr/lib/python3.5/site-packages/powerline/bindings/vim/"))
set rtp+=/usr/lib/python3.5/site-packages/powerline/bindings/vim/
endif

" Always show statusline
set laststatus=2

" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256
