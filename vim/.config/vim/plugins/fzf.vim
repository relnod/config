nnoremap <silent><leader>ff :Files<CR>
nnoremap <silent><leader>fg :GFiles<CR>
nnoremap <silent><leader>fl :FilesMru<CR>

nnoremap <silent><leader>fb :Buffers<CR>

nnoremap <silent><leader>fa :AgHidden<CR>
nnoremap <silent><leader>fw :AgHidden<space><C-R><C-W><CR>
nnoremap <silent><leader>fd :AgDir<space>

nnoremap <silent><leader>fh :Helptags<CR>
nnoremap <silent><leader>ft :Tags<CR>
nnoremap <silent><leader>fm :Maps<CR>
nnoremap <silent><leader>fc :Commits<CR>

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
