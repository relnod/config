noremap <silent><leader>ff :Files<CR>
noremap <silent><leader>fg :GFiles<CR>
noremap <silent><leader>fl :LEdit<CR>

noremap <silent><leader>fb :Buffers<CR>
noremap <silent><leader>fn :BufferAll<CR>

noremap <silent><leader>fa :Ag<CR>
noremap <silent><leader>fw :Ag <C-R><C-W><CR>
noremap <silent><leader>fd :AgDir<space>

noremap <silent><leader>fh :Helptags<CR>
noremap <silent><leader>ft :Tags<CR>
noremap <silent><leader>fm :Maps<CR>
noremap <silent><leader>fc :Commits<CR>


let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit' }
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags'
let g:fzf_layout = { 'down': '40%' }


command! -nargs=* -complete=file AgDir
    \ call fzf#run(fzf#wrap({
    \   'source': 'ag --hidden --ignore .git -f "." ' . <q-args>,
    \ }))

command! -nargs=0 LEdit
    \ call fzf#run(fzf#wrap({
    \   'source': "ag --hidden --ignore .git -g '.' " .
    \             "| xargs -L 100 -d '\n' ls -l --time-style +'%s' " .
    \             "| sort -k 6 -n -r --parallel 16 | awk '{print $7}'",
    \ }))

function! s:buflist()
    redir => ls
    silent ls!
    redir END
    return split(ls, '\n')
endfunction

command! -nargs=0 BufferAll
    \ call fzf#vim#buffers({
    \   'source':  reverse(<sid>buflist()),
    \ })
