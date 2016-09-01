" Extracted from https://github.com/klen/python-mode
" with small modifications

if !&magic
  finish
endif

if &ft == 'python'
  nnoremap <buffer> ]]  :<C-U>call pymode#motion#move('<Bslash>v^(class<bar>def)<Bslash>s', '')<CR>
  nnoremap <buffer> [[  :<C-U>call pymode#motion#move('<Bslash>v^(class<bar>def)<Bslash>s', 'b')<CR>
  nnoremap <buffer> ]C  :<C-U>call pymode#motion#move('<Bslash>v^(class)<Bslash>s', '')<CR>
  nnoremap <buffer> [C  :<C-U>call pymode#motion#move('<Bslash>v^(class)<Bslash>s', 'b')<CR>
  nnoremap <buffer> ]M  :<C-U>call pymode#motion#move('^<Bslash>s*def<Bslash>s', '')<CR>
  nnoremap <buffer> [M  :<C-U>call pymode#motion#move('^<Bslash>s*def<Bslash>s', 'b')<CR>

  onoremap <buffer> ]]  :<C-U>call pymode#motion#move('<Bslash>v^(class<bar>def)<Bslash>s', '')<CR>
  onoremap <buffer> [[  :<C-U>call pymode#motion#move('<Bslash>v^(class<bar>def)<Bslash>s', 'b')<CR>
  onoremap <buffer> ]C  :<C-U>call pymode#motion#move('<Bslash>v^(class)<Bslash>s', '')<CR>
  onoremap <buffer> [C  :<C-U>call pymode#motion#move('<Bslash>v^(class)<Bslash>s', 'b')<CR>
  onoremap <buffer> ]M  :<C-U>call pymode#motion#move('^<Bslash>s*def<Bslash>s', '')<CR>
  onoremap <buffer> [M  :<C-U>call pymode#motion#move('^<Bslash>s*def<Bslash>s', 'b')<CR>

  vnoremap <buffer> ]]  :call pymode#motion#vmove('<Bslash>v^(class<bar>def)<Bslash>s', '')<CR>
  vnoremap <buffer> [[  :call pymode#motion#vmove('<Bslash>v^(class<bar>def)<Bslash>s', 'b')<CR>
  vnoremap <buffer> ]M  :call pymode#motion#vmove('^<Bslash>s*def<Bslash>s', '')<CR>
  vnoremap <buffer> [M  :call pymode#motion#vmove('^<Bslash>s*def<Bslash>s', 'b')<CR>

  onoremap <buffer> C  :<C-U>call pymode#motion#select('^<Bslash>s*class<Bslash>s', 0)<CR>
  onoremap <buffer> aC :<C-U>call pymode#motion#select('^<Bslash>s*class<Bslash>s', 0)<CR>
  onoremap <buffer> iC :<C-U>call pymode#motion#select('^<Bslash>s*class<Bslash>s', 1)<CR>
  vnoremap <buffer> aC :<C-U>call pymode#motion#select('^<Bslash>s*class<Bslash>s', 0)<CR>
  vnoremap <buffer> iC :<C-U>call pymode#motion#select('^<Bslash>s*class<Bslash>s', 1)<CR>

  onoremap <buffer> M  :<C-U>call pymode#motion#select('^<Bslash>s*def<Bslash>s', 0)<CR>
  onoremap <buffer> aM :<C-U>call pymode#motion#select('^<Bslash>s*def<Bslash>s', 0)<CR>
  onoremap <buffer> iM :<C-U>call pymode#motion#select('^<Bslash>s*def<Bslash>s', 1)<CR>
  vnoremap <buffer> aM :<C-U>call pymode#motion#select('^<Bslash>s*def<Bslash>s', 0)<CR>
  vnoremap <buffer> iM :<C-U>call pymode#motion#select('^<Bslash>s*def<Bslash>s', 1)<CR>
endif
