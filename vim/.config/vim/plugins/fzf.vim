nnoremap <silent><leader>ff :Files<CR>
nnoremap <silent><leader>fg :GFiles<CR>
nnoremap <silent><leader>fx :GFilesModified<CR>
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
    let l:searchword = a:word
    if l:searchword ==# ''
        let l:searchword = '.'
    endif
    call fzf#vim#grep("rg --hidden -g '!.git' '" . l:searchword . "'", 1)
endfunction

command! -nargs=* AgHidden call s:aghidden(<q-args>)

command! -nargs=1 -complete=file AgDir
    \ call fzf#vim#grep(
    \   "rg --hidden -g '!.git' --files '.' " . <q-args>, 1
    \ )

command! -nargs=0 GFilesModified
    \ call fzf#run(fzf#wrap({
    \   'source': "git ls-files --other --modified --exclude-standard"
    \ }))

command! -nargs=0 FilesMru
    \ call fzf#run(fzf#wrap({
    \   'source': "rg --hidden -g '!.git' --files '.' " .
    \             "| xargs -L 100 -d '\n' ls -l --time-style +'%s' " .
    \             "| sort -k 6 -n -r --parallel 16 | awk '{print $7}'",
    \ }))
