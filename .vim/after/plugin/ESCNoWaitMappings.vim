" it has to be done after any other esc/alt bindings
" alt + key send's esc sequence + key, so vim waits for key after esc when
" something is mapped to alt + key, don't want it
silent! nunmap 
silent! vunmap 
silent! iunmap 
nnoremap <nowait>  
vnoremap <nowait>  
inoremap <nowait>  

au BufReadPost * snoremap <nowait>  
