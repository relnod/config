let g:deoplete#enable_at_startup = 1

let g:deoplete#auto_complete_delay = 10

let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources.go = ['omni', 'buffer']
let g:deoplete#ignore_sources.c = ['omni']
let g:deoplete#ignore_sources.php = ['omni']

call deoplete#custom#set('clang2', 'mark', '')
