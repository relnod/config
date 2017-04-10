noremap <silent><leader>ff :Files<CR>
noremap <silent><leader>fg :GFiles<CR>
noremap <silent><leader>fl :FilesMru<CR>

noremap <silent><leader>fb :Buffers<CR>

noremap <silent><leader>fa :AgHidden<CR>
noremap <silent><leader>fw :AgHidden<space><C-R><C-W><CR>
noremap <silent><leader>fd :AgDir<space>

noremap <silent><leader>fh :Helptags<CR>
noremap <silent><leader>ft :Tags<CR>
noremap <silent><leader>fm :Maps<CR>
noremap <silent><leader>fc :Commits<CR>

vnoremap <silent><leader>fa :Ag<space><SID>get_visual_selection()<CR>


let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit' }
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags'
let g:fzf_layout = { 'down': '40%' }

function! s:aghidden(word) abort
    let searchword = a:word
    if searchword == ''
        let searchword = '.'
    endif
    call fzf#vim#grep('ag --hidden --ignore .git "' . searchword . '"', 1)
endfunction

command! -nargs=* AgHidden call s:aghidden(<q-args>)

command! -nargs=* -complete=file AgDir
    \ call fzf#vim#grep(
    \   'ag --hidden --ignore .git -f "." ' . <q-args>, 1
    \ )

command! -nargs=0 FilesMru
    \ call fzf#run(fzf#wrap({
    \   'source': "ag --hidden --ignore .git -g '.' " .
    \             "| xargs -L 100 -d '\n' ls -l --time-style +'%s' " .
    \             "| sort -k 6 -n -r --parallel 16 | awk '{print $7}'",
    \ }))
