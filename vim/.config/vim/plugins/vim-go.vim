let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

if has('nvim')
    au Filetype go nmap <leader>rt <PLUG>(go-run-tab)
    au Filetype go nmap <leader>rs <PLUG>(go-run-split)
    au Filetype go nmap <leader>rv <PLUG>(go-run-vertical)
endif
