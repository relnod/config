let g:LanguageClient_serverCommands = {
    \ 'python': ['~/tools/repos/palantir/python-language-server/pyls'],
    \ 'go': ['go-langserver'],
\ }

" autocmd FileType php LanguageClientStart

nnoremap <silent>sh :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent>sd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent>sr :call LanguageClient_textDocument_references()<CR>
nnoremap <silent>se :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent>sd :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <silent>sw :call LanguageClient_workspace_symbol()<CR>
