let g:LanguageClient_serverCommands = {
    \ 'python': ['~/tools/repos/palantir/python-language-server/pyls'],
    \ 'go': ['go-langserver'],
    \ 'php': ['php', '~/dev/repos/felixfbecker/php-language-server/bin/php-language-server.php'],
    \ 'javascript': ['node', '~/dev/repos/sourcegraph/javascript-typescript-langserver/lib/language-server-stdio.js'],
\ }

" autocmd FileType php LanguageClientStart

nnoremap <silent>sh :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent>sd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent>sr :call LanguageClient_textDocument_references()<CR>
nnoremap <silent>se :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent>ss :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <silent>sf :call LanguageClient_textDocument_formatting()<CR>
nnoremap <silent>sw :call LanguageClient_workspace_symbol()<CR>
