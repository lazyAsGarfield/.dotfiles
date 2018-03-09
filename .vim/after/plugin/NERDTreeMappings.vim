if exists('g:loaded_nerd_tree')

  if exists('s:done_once')
    finish
  endif
  let s:done_once = 1

  function! NERDTree_dir_h(dir)
    let dir = a:dir
    if dir.isRoot()
      call nerdtree#ui_glue#upDir(1)
    elseif dir.isOpen
      call dir.close()
      call b:NERDTree.render()
      call dir.putCursorHere(0, 0)
    else
      let parent = dir.parent
      if parent ==# {} || parent.isRoot()
        call nerdtree#ui_glue#upDir(1)
      else
        while g:NERDTreeCascadeOpenSingleChildDir && !parent.parent.isRoot()
          if parent.parent.getVisibleChildCount() == 1
            call parent.close()
            let parent = parent.parent
          else
            break
          endif
        endwhile
        call parent.close()
        call b:NERDTree.render()
        call parent.putCursorHere(0, 0)
      endif
    endif
  endfunction

  function! NERDTree_H(dir)
    call nerdtree#ui_glue#upDir(1)
  endfunction

  function! NERDTree_file_h(node)
    let parent = a:node.parent
    if parent ==# {} || parent.isRoot()
      call nerdtree#ui_glue#upDir(1)
    else
      while g:NERDTreeCascadeOpenSingleChildDir && !parent.parent.isRoot()
        if parent.parent.getVisibleChildCount() == 1
          call parent.close()
          let parent = parent.parent
        else
          break
        endif
      endwhile
      call parent.close()
      call b:NERDTree.render()
      call parent.putCursorHere(0, 0)
    endif
  endfunction

  function! NERDTree_dir_l(dir)
    let dir = a:dir
    call dir.activate()
    if dir.getVisibleChildCount() > 0
      let child = dir.getChildByIndex(0, 1).putCursorHere(0,0)
    endif
  endfunction

  function! NERDTree_file_l(node)
    call a:node.activate({'reuse': 'all', 'where': 'p'})
  endfunction

  function! NERDTree_file_L(node)
    call b:NERDTree.changeRoot(a:node)
  endfunction

  function! NERDTree_bookmark_l(bm)
    call a:bm.activate(b:NERDTree, !a:bm.path.isDirectory ? {'where': 'p'} : {})
  endfunction

  call NERDTreeAddKeyMap({
        \ 'key': 'h',
        \ 'callback': 'NERDTree_dir_h',
        \ 'quickhelpText': 'if opened - close, close parent or up dir otherwise',
        \ 'scope': 'DirNode' })

  call NERDTreeAddKeyMap({
        \ 'key': 'h',
        \ 'callback': 'NERDTree_file_h',
        \ 'quickhelpText': 'close parent or go up if parent is root',
        \ 'scope': 'FileNode' })

  call NERDTreeAddKeyMap({
        \ 'key': 'H',
        \ 'callback': 'NERDTree_H',
        \ 'quickhelpText': 'close parent/up dir',
        \ 'scope': 'DirNode' })

  call NERDTreeAddKeyMap({
        \ 'key': 'H',
        \ 'callback': 'NERDTree_H',
        \ 'quickhelpText': 'close parent/up dir',
        \ 'scope': 'FileNode' })

  call NERDTreeAddKeyMap({
        \ 'key': 'l',
        \ 'callback': 'NERDTree_dir_l',
        \ 'quickhelpText': 'open/close',
        \ 'scope': 'DirNode' })

  call NERDTreeAddKeyMap({
        \ 'key': 'L',
        \ 'callback': 'NERDTree_file_L',
        \ 'quickhelpText': 'open/close',
        \ 'scope': 'DirNode' })

  call NERDTreeAddKeyMap({
        \ 'key': 'l',
        \ 'callback': 'NERDTree_file_l',
        \ 'quickhelpText': 'open in previous window',
        \ 'scope': 'FileNode' })

  call NERDTreeAddKeyMap({
        \ 'key': 'l',
        \ 'callback': 'NERDTree_bookmark_l',
        \ 'quickhelpText': 'open bookmark',
        \ 'scope': 'Bookmark' })

endif
