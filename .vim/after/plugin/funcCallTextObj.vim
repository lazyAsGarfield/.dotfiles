function! s:matches(chars, char)
  if type(a:chars) == v:t_list
    return index(a:chars, a:char) != -1
  else
    return a:char =~ a:chars
  endif
endfunction

function! s:find_previous(chars, lst, pos, count_lvls)
  let ind = a:pos - 1
  let lvl = 0
  let ignore = index(['Special', 'String'], synIDattr(synIDtrans(synID(line('.'), a:pos, 0)), 'name')) != -1 &&
        \ index(['Special', 'String'], synIDattr(synIDtrans(synID(line('.'), a:pos - 1, 0)), 'name')) != -1
  while ind >= 0
    let curr = a:lst[ind]
    if !a:count_lvls && s:matches(a:chars, curr)
      return ind + 1
    elseif a:count_lvls
      if (curr == "'" || curr == '"') && ind != a:pos - 1
        let ignore = !ignore
      elseif ignore
        let ind -= 1
        continue
      elseif s:matches([')', '}', ']'], curr)
        let lvl += 1
      elseif s:matches(['(', '{', '['], curr) && lvl > 0
        let lvl -= 1
      elseif lvl == 0 && s:matches(a:chars, curr)
        return ind + 1
      endif
    endif
    let ind -= 1
  endwhile
  return -1
endfunction

function! s:find_next(chars, lst, pos, count_lvls)
  let ind = a:pos - 1
  let lvl = 0
  let ignore = index(['Special', 'String'], synIDattr(synIDtrans(synID(line('.'), a:pos, 0)), 'name')) != -1 &&
        \ index(['Special', 'String'], synIDattr(synIDtrans(synID(line('.'), a:pos + 1, 0)), 'name')) != -1
  while ind < len(a:lst)
    let curr = a:lst[ind]
    if !a:count_lvls && s:matches(a:chars, curr)
      return ind + 1
    elseif a:count_lvls
      if (curr == "'" || curr == '"') && ind != a:pos - 1
        let ignore = !ignore
      elseif ignore
        let ind += 1
        continue
      elseif s:matches(['(', '{', '['], curr)
        let lvl += 1
      elseif s:matches([')', '}', ']'], curr) && lvl > 0
        let lvl -= 1
      elseif lvl == 0 && s:matches(a:chars, curr)
        return ind + 1
      endif
    endif
    let ind += 1
  endwhile
  return -1
endfunction

function! ArgTextObjI()
  return ArgTextObj()
endfunction

function! ArgTextObjA()
  return ArgTextObj(1)
endfunction

function! ArgTextObj(...)
  let line_lst = split(getline('.'), '\zs')
  let pos = col('.')
  let beg = s:find_previous(['('], line_lst, pos, 1)
  if beg == -1
    return 0
  endif
  let arg_end = s:find_next([',', ')'], line_lst, beg + 1, 1)
  if arg_end == -1
    return 0
  endif
  let arg_beg = beg + 1
  while arg_end <= pos
    let arg_beg = arg_end
    let arg_end = s:find_next([',', ')'], line_lst, arg_end + 1, 1)
    if arg_end == -1
      return 0
    endif
  endwhile
  if a:0 == 0
    if line_lst[arg_beg-1] == ','
      let arg_beg += 1
    endif
    let arg_beg = s:find_next('[^ ]', line_lst, arg_beg, 0)
    let arg_end = s:find_previous('[^ ]', line_lst, arg_end-1, 0) + 1
  else
    if arg_beg == beg + 1 && !s:matches('[)]', line_lst[arg_end-1])
      let arg_end = s:find_next('[^ ),]', line_lst, arg_end, 0)
    endif
  endif
  return ['v', [0, line('.'), arg_beg, 0], [0, line('.'), arg_end - 1, 0]]
endfunction

" nmap ff :echo ArgTextObj()<CR>
