if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

function! <SID>GoFmt()
    let l:curw=winsaveview()
    let l:tmpname=tempname()
    call writefile(getline(1, '$'), l:tmpname)
    call system("goimports " . l:tmpname . " > /dev/null 2>&1")
    if v:shell_error == 0
        try | silent undojoin | catch | endtry
        silent %!goimports
    endif
    call delete(l:tmpname)
    call winrestview(l:curw)
endfun

augroup vimgo
    au BufWritePre *.go :call <SID>GoFmt()
    au FileType go set foldmethod=syntax
    au FileType go set nofoldenable
    au FileType go set foldnestmax=1
augroup end
