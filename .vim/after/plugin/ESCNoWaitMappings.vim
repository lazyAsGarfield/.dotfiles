" it has to be done after any other esc/alt bindings
" alt + key send's esc sequence + key, so vim waits for key after esc when
" something is mapped to alt + key, don't want it
silent! nunmap <esc>
silent! vunmap <esc>
silent! iunmap <esc>
silent! cunmap <esc>
nnoremap <nowait> <esc> <esc>
vnoremap <nowait> <esc> <esc>
inoremap <nowait> <esc> <esc>
cnoremap <nowait> <esc> <C-c>

augroup esc_mapping
  au!
  au BufReadPost * snoremap <nowait> <esc> <esc>
augroup END
