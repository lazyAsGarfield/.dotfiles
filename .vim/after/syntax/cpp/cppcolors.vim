hi MacroInstantiation cterm=italic guifg=LightBlue ctermfg=LightBlue


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

au VimEnter,ColorScheme * call <SID>change_colors()
