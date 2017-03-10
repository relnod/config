let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 0
let g:deoplete#enable_smart_case = 0
let g:deoplete#enable_camel_case = 0
let g:deoplete#enable_refresh_always = 0
let g:deoplete#auto_complete_delay = 50
" let g:deoplete#auto_complete_start_length = 10

" let g:deoplete#omni#functions = {}
" let g:deoplete#omni#functions.javascript = [
"   \ 'tern#Complete',
"   \ 'jspc#omni'
" \]

let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources.go = ['omni']
let g:deoplete#ignore_sources.c = ['omni']

call deoplete#custom#set('clang2', 'mark', '')
