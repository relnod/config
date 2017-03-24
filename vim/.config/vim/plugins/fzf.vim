noremap <silent><leader>ff :Files<CR>
noremap <silent><leader>fg :GFiles<CR>
noremap <silent><leader>fh :Helptags<CR>
noremap <silent><leader>ft :Tags<CR>
noremap <silent><leader>fm :Maps<CR>
noremap <silent><leader>fc :Commits<CR>
noremap <silent><leader>fw :Ag <C-R><C-W><CR>
noremap <silent><leader>fa :AgDir 

let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -f -g ""'
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit' }
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags *'

function! s:fzf_ag_dir(cmd)
  call fzf#vim#grep('ag --hidden --ignore .git -f "." ' . a:cmd, 0, {'down': '40%'})
endfunction

autocmd! VimEnter * command! -nargs=* -complete=file AgDir :call s:fzf_ag_dir(<q-args>)

function! s:fzf_file_history()
    let s:cmd = "ag --hidden --ignore .git -g '.' | xargs ls -l --time-style +'%s' | sort -k 6 -n -r | awk '{print $7}'"
    call fzf#run({'source': s:cmd, 'down': '40%'})
endfunction

noremap <silent><leader>fl :call <SID>fzf_file_history()<CR>
