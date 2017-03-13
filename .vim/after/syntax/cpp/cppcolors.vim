hi MacroInstantiation cterm=italic guifg=LightBlue ctermfg=LightBlue

try
  redir => s:h
  silent hi EnumConstant
  redir END
  silent! let s:h = Strip(split(s:h, 'xxx')[1])

  if exists('s:h')
    exec 'hi EnumConstant ' . s:h . ' cterm=italic'
  endif
catch
endtry
