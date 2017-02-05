let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 0
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
let g:deoplete#omni_patterns =  get(g:,'deoplete#omni#omni_patterns',{})
let g:deoplete#omni_patterns.php = '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources.go = ['omni']
let g:deoplete#ignore_sources.c = ['omni']
call deoplete#custom#set('clang2', 'mark', '')
