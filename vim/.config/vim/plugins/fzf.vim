noremap <silent><leader>ff :Files<CR>
noremap <silent><leader>fg :GFiles<CR>
noremap <silent><leader>fh :Helptags<CR>
noremap <silent><leader>ft :Tags<CR>
noremap <silent><leader>fm :Maps<CR>
noremap <silent><leader>fc :Commits<CR>
noremap <silent><leader>fw :Ag <C-R><C-W><CR>
noremap <silent><leader>fa :AgDir 
noremap <silent><leader>fl :LEdit<CR>

let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -f -g ""'
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit' }
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags *'

command! -nargs=* -complete=file AgDir
    \ call fzf#vim#grep(
    \   'ag --hidden --ignore .git -f "." ' . <q-args>, 
    \   0, {'down': '40%'}
    \ )

command! -nargs=* -complete=file LEdit 
    \ call fzf#run({
    \   'source': "ag --hidden --ignore .git -g '.' | xargs ls -l --time-style +'%s' | sort -k 6 -n -r | awk '{print $7}'",
    \   'sink': 'edit', 'down': '40%'
    \ })
