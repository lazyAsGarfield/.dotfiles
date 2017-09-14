hi MacroInstantiation cterm=italic guifg=LightBlue ctermfg=LightBlue

function! Strip(str)
  return substitute(a:str, '\v^(\n|\s)*(.{-})(\n|\s)*$', '\2', '')
endfunction

function! s:change_colors()
  try
    redir => s:h
    silent hi EnumConstant
    redir END
    silent! let s:h = Strip(split(s:h, 'xxx')[1])

    if exists('s:h')
      exec 'hi EnumConstant ' . s:h . ' cterm=italic'
    endif
  catch
  finally
    redir END
  endtry
endfunction

augroup set_cpp_hi
  au!
  au VimEnter,ColorScheme * call <SID>change_colors()
augroup END

" Don't indent namespace and template
function! CppNoNamespaceAndTemplateIndent()
  let l:cline_num = line('.')
  let l:cline = getline(l:cline_num)
  let l:pline_num = prevnonblank(l:cline_num - 1)
  let l:pline = getline(l:pline_num)
  while l:pline =~# '\(^\s*{\s*\|^\s*//\|^\s*/\*\|\*/\s*$\)'
    let l:pline_num = prevnonblank(l:pline_num - 1)
    let l:pline = getline(l:pline_num)
  endwhile
  let l:retv = cindent('.')
  let l:pindent = indent(l:pline_num)

  " experimental
  if l:cline =~# '^\s*>\s*$' &&
    (
    l:pline =~# '^\s*template' ||
    l:pline =~# '^\s*typename' ||
    l:pline =~# '^\s*class'
    )
    return l:pindent
  endif

  if l:pline =~# '^\s*template\s*<.*>\s*$'
    let l:retv = l:pindent
  elseif l:pline =~# '^\s*template\s*<\s*$'
    let l:retv = l:pindent + &shiftwidth
  elseif l:pline =~# '^\s*template\s*$'
    let l:retv = l:pindent
  elseif l:pline =~# '\s*typename\s*.*,\s*$'
    let l:retv = l:pindent
  elseif l:cline =~# '^\s*>.*$'
    let l:retv = l:pindent - &shiftwidth
  elseif l:pline =~# '\s*typename\s*.*>\s*$'
    let l:retv = l:pindent - &shiftwidth
  endif

  if l:pline =~# '\v^\s*(class|struct)\s+\w+\s*:\s*((public|protected|private)\s+)?\w+\s*$'
    if l:retv > l:pindent
      return l:retv - &shiftwidth
    endif
  endif

  return l:retv
endfunction

setlocal indentexpr=CppNoNamespaceAndTemplateIndent()
