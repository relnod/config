autocmd FileType php LanguageClientStart

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
inoremap <silent> <F5> <CR>:call LanguageClient_textDocument_completion()<CR>i
