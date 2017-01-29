let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_show_hidden = 1
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
            \ --ignore .git
            \ --ignore .svn
            \ --ignore .hg
            \ --ignore .DS_Store
            \ --ignore "**/*.pyc"
            \ -g ""'
let g:ctrlp_nerdtree_show_hidden = 1
nnoremap <leader>p :CtrlP <CR>
