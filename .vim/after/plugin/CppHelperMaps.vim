augroup once_cpp_helper_maps
  autocmd VimEnter * if Get_cpp_root('') != '' | nmap <buffer> <silent> <leader>ah :HeaderFiles<CR> | endif
  autocmd VimEnter * if Get_cpp_root('') != '' | nmap <buffer> <silent> <leader>as :SrcFiles<CR> | endif
  autocmd VimEnter * if Get_cpp_root('') != '' | nmap <buffer> <silent> <leader>at :call Find_src_or_header("e")<CR> | endif
  autocmd VimEnter * if Get_cpp_root('') != '' | nmap <buffer> <silent> <leader>ag :call Find_include_header("vsp")<CR> | endif
  autocmd VimEnter * au! once_cpp_helper_maps
augroup END
