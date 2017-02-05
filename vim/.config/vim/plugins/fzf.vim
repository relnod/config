noremap <silent><leader>ff :Files<CR>
noremap <silent><leader>fg :GFiles<CR>
noremap <silent><leader>fh :Helptags<CR>
noremap <silent><leader>ft :Tags<CR>
noremap <silent><leader>fm :Maps<CR>
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -f -g ""'
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit' }
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags *'
