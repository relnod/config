let g:autohighlight#active = 0
let g:autohighlight#delay = 600
let g:autohighlight#style ='guifg=NONE guibg=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline'
exe 'highlight WordOccurence ' . g:autohighlight#style

function! autohighlight#Toggle() abort
    if g:autohighlight#active
        let g:autohighlight#active=0
        call autohighlight#Disable()
    else
        let g:autohighlight#active=1
        call autohighlight#Enable()
    endif
endfunction

function! autohighlight#Enable() abort
    augroup autohighlight
        au CursorHold * call autohighlight#Highlight()
    augroup end
    exe 'setl updatetime=' . g:autohighlight#delay
endfunction

function! autohighlight#Disable() abort
    call clearmatches()
    au! autohighlight
    augroup! autohighlight
    setl updatetime=4000
endfunction

function! autohighlight#Highlight() abort
    call clearmatches()
    let l:match_word = '\V\<' . escape(expand('<cword>'), '\') . '\>'
    call matchadd('WordOccurence', l:match_word, 0)
endfunction
