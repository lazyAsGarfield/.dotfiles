" ---------- PLUGINS -------------- {{{

set nocompatible
filetype off

set rtp+=~/.vim/vim-plug
let path='~/.vim/plugged'

call plug#begin(path)

" change leader key
let mapleader=" "
let maplocalleader=" "

" ---------- nerdtree ---------- {{{

if v:version >= 703

  Plug 'scrooloose/nerdtree'

  let g:NERDTreeMouseMode = 2
  let g:NERDTreeMapJumpLastChild = '<C-f>'
  let g:NERDTreeMapJumpFirstChild = '<C-b>'
  let g:NERDTreeMapJumpNextSibling = 'J'
  let g:NERDTreeMapJumpPrevSibling = 'K'
  let g:NERDMenuMode = 3
  let g:NERDTreeCascadeSingleChildDir = 0

  augroup my_nerdtree_maps
    au!
    " autocmd FileType nerdtree nmap <buffer>  :quit<CR>
    autocmd FileType nerdtree nmap <buffer> <C-v> s
    autocmd FileType nerdtree nmap <buffer> <C-x> i
    autocmd FileType nerdtree nmap <buffer> <C-j> j
    autocmd FileType nerdtree nmap <buffer> <C-k> k
    autocmd FileType nerdtree nmap <buffer> . I
  augroup END

  function! NERDTreeEnableOrToggle()
    try
      NERDTreeToggle
    catch
      silent! NERDTree
    endtry
  endfunction

  map <C-n> :call NERDTreeEnableOrToggle()<CR>

  nmap n :NERDTreeFind<CR>

endif

" }}}

" ---------- undotree ---------- {{{

if v:version >= 703

  Plug 'mbbill/undotree'

  let g:undotree_SetFocusWhenToggle = 1

  autocmd FileType undotree nmap <nowait> <buffer> q :quit<CR>
  autocmd FileType undotree nmap <buffer> <C-j> j
  autocmd FileType undotree nmap <buffer> <C-k> k
  autocmd FileType undotree nmap <buffer> <nowait>  :quit<CR>

  nnoremap u :UndotreeToggle<CR>

endif

" }}}

" -------- vim-easymotion ------ {{{

if v:version >= 703
  Plug 'bmalkus/vim-easymotion'
endif

" }}}

" ------------- YCM ------------ {{{

if v:version >= 703
  if !empty($__YCM__)

    if !empty($__COMPL__)
      Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
    else
      Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
    endif

    " let g:loaded_youcompleteme = 1
    let g:ycm_complete_in_comments = 1
    let g:ycm_seed_identifiers_with_syntax = 1
    " let g:ycm_add_preview_to_completeopt = 1
    " let g:ycm_autoclose_preview_window_after_insertion = 0
    let g:ycm_always_populate_location_list = 1
    let g:ycm_semantic_triggers =  {
          \   'c' : ['->', '.'],
          \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
          \             're!\[.*\]\s'],
          \   'ocaml' : ['.', '#'],
          \   'cpp,objcpp' : ['->', '.', '::'],
          \   'perl' : ['->'],
          \   'php' : ['->', '::'],
          \   'cs,java,javascript,typescript,d,perl6,scala,vb,elixir,go' : ['.'],
          \   'python' : ['.'],
          \   'ruby' : ['.', '::'],
          \   'lua' : ['.', ':'],
          \   'erlang' : [':'],
          \ }

          " \   'cpp,objcpp' : ['re!\w+', '->', '.', '::'],

    let g:ycm_global_ycm_extra_conf = expand("$HOME/.vim/ycm/.ycm_extra_conf.py")
    let g:ycm_warning_symbol = '>'
    let g:ycm_error_symbol = '>>'
    let g:ycm_collect_identifiers_from_tags_files = 1

    nnoremap ycg :YcmCompleter GoTo<CR>
    nnoremap ycc :YcmForceCompileAndDiagnostics<CR>
    nnoremap ycf :YcmCompleter FixIt<CR>
    nnoremap ycd :YcmCompleter GetDoc<CR>
    nnoremap ycdd :YcmShowDetailedDiagnostic<CR>
    nnoremap ycl :YcmDiags<CR>
    nnoremap yct :YcmCompleter GetType<CR>
    nnoremap ycr :YcmRestartServer<CR>

  endif
endif

" }}}

" ---------- jedi-vim ---------- {{{

if v:version >= 703

  if !empty($__YCM__)
    Plug 'davidhalter/jedi-vim'
  endif

  " disable completions from jedi-vim, using YCM instead
  let g:jedi#completions_enabled = 0

  " two below fix showing argument list when using YCM
  let g:jedi#show_call_signatures_delay = 0
  let g:jedi#show_call_signatures = "0"

  " let g:jedi#use_splits_not_buffers = "right"
  let g:jedi#goto_command = "yjg"
  let g:jedi#goto_assignments_command = "yja"
  let g:jedi#documentation_command = "K"
  let g:jedi#usages_command = "yju"
  " let g:jedi#completions_command = "<C-Space>"
  " let g:jedi#completions_command = "<Tab>"
  let g:jedi#completions_command = ""
  let g:jedi#rename_command = "yjr"

  autocmd FileType python nmap <C-]> yjg

  autocmd FileType python nnoremap <C-LeftMouse> <LeftMouse>:call jedi#goto()<CR>


endif

" }}}

" ---------- ultisnips --------- {{{

if v:version >= 704 && ( has('python3') || has('python') )

  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

  let g:UltiSnipsExpandTrigger = 'e'
  let g:UltiSnipsListSnippets = 's'
  let g:UltiSnipsJumpForwardTrigger = 'f'
  let g:UltiSnipsJumpBackwardTrigger = 'b'

  let g:UltiSnipsEditSplit = 'vertical'
  let g:UltiSnipsSnippetsDir = $DOTFILES_DIR . '/.vim/UltiSnips'

endif

" }}}

" --------- delimitMate -------- {{{

Plug 'lazyAsGarfield/delimitMate'

let delimitMate_expand_cr=2
let delimitMate_expand_space=1
let delimitMate_balance_matchpairs=1
let delimitMate_matchpairs = "(:),[:],{:}"
let delimitMate_smart_matchpairs = '^\%(\w\|[£$]\|[^[:space:][:punct:]]\)'

au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]

imap <C-k> <Plug>delimitMateJumpMany
imap <C-l> <Plug>delimitMateS-Tab
imap <C-h> <Plug>delimitMateS-BS
imap <C-j> <C-k><CR>

" }}}

" -------- goyo/limelight ------ {{{

Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'

let g:goyo_width=120
let g:goyo_height='95%'

let g:limelight_default_coefficient = '0.54'
let g:limelight_paragraph_span = 1

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

function! s:goyo_enter()
  if !empty($TMUX)
    silent! !tmux set -w status off
    silent! !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  let g:scrolloff_saved=&scrolloff
  " set scrolloff=999
  Goyo x95%
  " silent! Limelight
endfunction

function! s:goyo_leave()
  if !empty($TMUX)
    silent! !tmux set -w status on
    silent! !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  exec 'set scrolloff=' . g:scrolloff_saved
  silent! Limelight!
  " silent! colorscheme Tomorrow-Night-Eighties-Mine
endfunction

nmap <leader>mm :Goyo<CR>
nmap <leader>ml :Limelight!!<CR>

" }}}

" -------- tmux-navigator ------ {{{

" Plug 'christoomey/vim-tmux-navigator'

" let g:tmux_navigator_no_mappings = 1

" function! Navigate(dir)
"   if a:dir == 'l'
"     if exists(':TmuxNavigateLeft')
"       TmuxNavigateLeft
"     else
"       normal h
"     endif
"   elseif a:dir == 'r'
"     if exists(':TmuxNavigateRight')
"       TmuxNavigateRight
"     else
"       normal l
"     endif
"   elseif a:dir == 'u'
"     if exists(':TmuxNavigateUp')
"       TmuxNavigateUp
"     else
"       normal k
"     endif
"   elseif a:dir == 'd'
"     if exists(':TmuxNavigateDown')
"       TmuxNavigateDown
"     else
"       normal j
"     endif
"   endif
" endfunction

" " when .vimrc loaded by other apps, like qt creator, use standard bindings
" if version >= 700
"   nnoremap <silent> <C-h> :call Navigate('l')<CR>
"   nnoremap <silent> <C-j> :call Navigate('d')<CR>
"   nnoremap <silent> <C-k> :call Navigate('u')<CR>
"   nnoremap <silent> <C-l> :call Navigate('r')<CR>
" else
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" endif

" }}}

" ---------- fzf/ctrlp --------- {{{

Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kien/ctrlp.vim'

let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'

nmap <leader>b <C-b>

if !executable('fzf')

  nnoremap <silent> <C-b> :CtrlPBuffer<CR>
  nnoremap <silent> <C-f> :CtrlP<CR>

else

  function! s:full_path(dir_or_file)
    " if fnamemodify() applied once, full_path may look like /blah/../
    " if a:dir_or_file is '..'
    return fnamemodify(fnamemodify(a:dir_or_file, ':p'), ':p')
  endfunction

  command! -nargs=? -complete=dir FilesBetterPrompt call fzf#vim#files(<q-args>, {
        \ 'source': 'ag -g "" --hidden -U --ignore .git/',
        \ 'options': '--preview "cat {}" --prompt "' . (<q-args> ? getcwd() : s:full_path(<q-args>)) . ' (Files)> "'
        \ })

  function! s:mru_list_without_nonexistent()
    if empty(expand('%')) || &readonly
      let mru_list = ctrlp#mrufiles#list()
    else
      let mru_list = ctrlp#mrufiles#list()[1:]
    endif
    let cwd = fnameescape(getcwd())
    call filter(mru_list, '!empty(findfile(v:val, cwd))')
    return mru_list
  endfunction

  function! s:git_files_if_in_repo()
    let expanded = expand('%:p:h')
    if ! exists('b:git_dir')
      let expanded = getcwd()
      return fzf#vim#files(expanded, {
            \ 'source': 'ag -g "" --hidden -U --ignore .git/',
            \ 'options': '--preview "cat {}" --prompt "' . expanded . ' (Files)> "'
            \ })
    else
      let git_root = fugitive#repo().tree()
      let save_cwd = fnameescape(getcwd())
      let cdCmd = (haslocaldir() ? 'lcd!' : 'cd!')
      try
        exec cdCmd . git_root
        call fzf#vim#gitfiles('', {
              \ 'options': '--preview "cat {}" --prompt "' . git_root . ' (GitFiles)> "'
              \ })
      finally
        exec cdCmd . save_cwd
      endtry
    endif
  endfunction

  command! GitFilesOrCwd call s:git_files_if_in_repo()

  function! s:git_root_or_cwd()
    return exists('b:git_dir') ? fugitive#repo().tree() : Get_cpp_root(getcwd())
  endfunction

  function! s:all_files_git_root_or_cwd()
    let path = s:git_root_or_cwd()
    call fzf#vim#files(path, {
          \ 'source': 'ag -g "" --hidden -U --ignore .git/',
          \ 'options': '--preview "cat {}" --prompt "' . path . ' (Files)> "'
          \ })
  endfunction

  command! FilesGitRootOrCwd call s:all_files_git_root_or_cwd()

  " expands path relatively to cwd or git root if possible
  " (similar to CtrlP plugin)
  function! s:relpath(filepath_or_name)
    let fullpath = fnamemodify(a:filepath_or_name, ':p')
    let save_cwd = fnameescape(getcwd())
    let cdCmd = (haslocaldir() ? 'lcd!' : 'cd!')
    try
      exec cdCmd . fnameescape(s:git_root_or_cwd())
      let ret = fnamemodify(fullpath, ':.')
    finally
      exec cdCmd . save_cwd
    endtry
    return ret
  endfunction

  function! s:ansi(str, col, bold)
    return printf("\x1b[%s%sm%s\x1b[m", a:col, a:bold ? ';1' : '', a:str)
  endfunction

  for [s:c, s:a] in items({'black': 30, 'red': 31, 'green': 32, 'yellow': 33, 'blue': 34, 'magenta': 35, 'cyan': 36})
    exec "function! s:".s:c."(str, ...)\n"
          \ "  return s:ansi(a:str, ".s:a.", get(a:, 1, 0))\n"
          \ "endfunction"
  endfor

  function! s:color_path(path)
    if a:path =~ '^/'
      return s:yellow(a:path)
    else
      return s:magenta(a:path)
    endif
  endfunction

  let s:default_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit' }

  " below function is used in order to get actions like ctrl-v etc.
  " and to transform path to proper version
  function! s:mru_sink(lines)
    if len(a:lines) <= 1
      return
    endif
    let key = remove(a:lines, 0)
    let cmd = get(s:default_action, key, 'e')
    let save_cwd = fnameescape(getcwd())
    let cdCmd = (haslocaldir() ? 'lcd!' : 'cd!')
    try
      exec cdCmd . fnameescape(s:git_root_or_cwd())
      let full_path_lines = map(a:lines, 'fnameescape(fnamemodify(v:val, ":p"))')
    finally
      exec cdCmd . save_cwd
    endtry
    if len(a:lines) > 1
      augroup fzf_swap
        autocmd SwapExists *
              \ let v:swapchoice='o'
              \| let b:swapname = v:swapname
      augroup END
    endif
    let empty = empty(expand('%')) && line('$') == 1 && empty(getline(1)) && !&modified
    try
      for item in full_path_lines
        if empty
          exec 'e' item
          let empty = 0
        else
          exec cmd item
        endif
        if exists('b:swapname')
          augroup swap_exists_once
            autocmd InsertEnter <buffer>
                  \ echohl ErrorMsg
                  \| echom 'E325: swap file exists: ' . b:swapname
                  \| sleep 2
                  \| echohl None
                  \| autocmd! swap_exists_once
          augroup END
        endif
      endfor
    finally
      silent! autocmd! fzf_swap
    endtry
  endfunction

  function! s:fzf_mru()
    call fzf#run({
          \ 'source':  map(s:mru_list_without_nonexistent(), 's:color_path(s:relpath(v:val))'),
          \ 'sink*': function("s:mru_sink"),
          \ 'options': '-m -x +s --prompt "' . s:git_root_or_cwd() .
          \ ' (MRU)> " --ansi --expect='.join(keys(s:default_action), ','),
          \ 'down':    '40%'
          \ })
  endfunction

  command! Mru call s:fzf_mru()

  function! s:ag_in(bang, ...)
    let tokens  = a:000
    let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
    let query   = (filter(copy(tokens), 'v:val !~ "^-"'))
    let save_cwd = fnameescape(getcwd())
    let cdCmd = (haslocaldir() ? 'lcd!' : 'cd!')
    " in case provided path is relative:
    " treat it as relative to dir of current file, not cwd
    try
      exec cdCmd . fnameescape(expand('%:p:h'))
      let dir = s:full_path(a:1)
    finally
      exec cdCmd . save_cwd
    endtry
    call fzf#vim#ag(join(query[1:], ' '), ag_opts . ' --ignore .git/', {
          \ 'dir': dir,
          \ 'options': '--preview "$DOTFILES_DIR/ag_fzf_preview_helper.sh {}" --prompt "' . dir . ' (Ag)> "'
          \ }, a:bang ? 1 : 0)
  endfunction

  function! s:ag_with_opts(bang, ...)
    let tokens  = a:000
    let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
    let query   = join(filter(copy(tokens), 'v:val !~ "^-"'))
    let dir = s:git_root_or_cwd()
    call fzf#vim#ag(query, ag_opts . ' --ignore .git/', {
          \ 'dir': dir,
          \ 'options': '--preview "$DOTFILES_DIR/ag_fzf_preview_helper.sh {}" --prompt "' . dir . ' (Ag)> "'
          \ }, a:bang ? 1 : 0)
  endfunction

  command! -nargs=+ -complete=dir -bang Agin call s:ag_in(<bang>0, <f-args>)

  command! -nargs=* -bang Agcwd exec 'Agin<bang>'  getcwd() '<args>'
  command! -nargs=* -bang AgGitRootOrCwd call s:ag_with_opts(<bang>0, <f-args>)

  runtime after/plugin/overrideAg.vim

  cnoreabbrev ag Ag
  cnoreabbrev agin Agin
  cnoreabbrev agcwd Agcwd

  let g:ctrlp_map = ''

  nnoremap <C-p> :Mru<CR>
  nnoremap <C-b> :Buffers<CR>
  nnoremap <leader>g :GitFilesOrCwd<CR>
  nnoremap <leader>s :FilesGitRootOrCwd<CR>

endif

" }}}

" ------------- git ------------ {{{

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

let g:gitgutter_override_sign_column_highlight = 0

" those are better visible
let g:gitgutter_sign_modified = '#'
let g:gitgutter_sign_removed = 'v'
let g:gitgutter_sign_modified_removed = '#v'

autocmd FileType gitcommit nnoremap <nowait> <buffer> ? :help fugitive-:Gstatus<CR>

nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk

" }}}

" ------- better-whitespace ---- {{{

Plug 'ntpeters/vim-better-whitespace'

" }}}

" --------- colors/themes ------ {{{

Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
Plug 'sjl/badwolf'
Plug 'w0ng/vim-hybrid'

Plug 'octol/vim-cpp-enhanced-highlight'

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

if v:version >= 703
  if !empty($__YCM__)
    " Plug 'jeaye/color_coded', { 'do': 'mkdir -p build && cd $_ && cmake .. && make install' }
  endif
endif

let g:airline_left_sep=''
let g:airline_right_sep=''

let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

" }}}

" ------------ tpope ----------- {{{

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-dispatch'

nnoremap <F8> :Make<CR>
nnoremap <C-F8> :Make!<CR>
nnoremap <F9> :Dispatch<CR>
nnoremap <C-F9> :Dispatch!<CR>
nnoremap <F10> :Start<CR>
nnoremap <C-F10> :Start!<CR>

" }}}

" ------------ python ---------- {{{

" Extracted from https://github.com/klen/python-mode
Plug '~/.vim/plugin/python-mode-motions'
Plug 'hynek/vim-python-pep8-indent'

" }}}

" ---------- easy-align -------- {{{

Plug 'junegunn/vim-easy-align'

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" }}}

" ------------ tagbar ---------- {{{

Plug 'majutsushi/tagbar'

let g:tagbar_autofocus = 1
let g:tagbar_map_openfold = 'l'
let g:tagbar_map_closefold = 'h'

nmap g :TagbarToggle<CR>

" }}}

" ----------- vim-bbye --------- {{{

Plug 'moll/vim-bbye'

map <leader>D :Bdelete<CR>

" }}}

" -------- nerdcommenter ------- {{{

Plug 'scrooloose/nerdcommenter'

let g:NERDRemoveExtraSpaces = 1
let g:NERDSpaceDelims = 1
" prevent double space after '#' in python
let g:NERDAltDelims_python = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCustomDelimiters = {
      \ 'glsl': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
      \ }

" }}}

" ---------- incsearch --------- {{{

Plug 'haya14busa/incsearch.vim'

let g:incsearch#auto_nohlsearch = 1

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" }}}

" ------------ latex ----------- {{{

Plug 'lervag/vimtex'

let g:tex_flavor = "latex"

au FileType tex let b:delimitMate_quotes = "\" '"
au FileType tex set textwidth=120

augroup latexSurround
  autocmd!
  autocmd FileType tex call s:latexSurround()
augroup END

function! s:latexSurround()
  let b:surround_{char2nr("e")}
        \ = "\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}"
  let b:surround_{char2nr("c")} = "\\\1command: \1{\r}"
endfunction

" }}}

call plug#end()

filetype plugin indent on

" some options get overriden by plugins when re-sourcing vimrc, set them to
" desired values
runtime after/plugin/override.vim


" --------------- PLUGINS END --------------- }}}

" ---------- VIM OPTS ------------- {{{

" enable mouse if possible
if has('mouse')
  set mouse+=a
endif

" tmux options
if ( &term =~ '^screen' || &term =~ '^tmux' ) && exists('$TMUX')
  " tmux knows the extended mouse mode
  set ttymouse=xterm2
  " tmux will send xterm-style keys when xterm-keys is on
  exec "set <xUp>=\e[1;*A"
  exec "set <xDown>=\e[1;*B"
  exec "set <xRight>=\e[1;*C"
  exec "set <xLeft>=\e[1;*D"
  exec "set <xHome>=\e[1;*H"
  exec "set <xEnd>=\e[1;*F"
  exec "set <Insert>=\e[2;*~"
  exec "set <Delete>=\e[3;*~"
  exec "set <PageUp>=\e[5;*~"
  exec "set <PageDown>=\e[6;*~"
  exec "set <xF1>=\e[1;*P"
  exec "set <xF2>=\e[1;*Q"
  exec "set <xF3>=\e[1;*R"
  exec "set <xF4>=\e[1;*S"
  exec "set <F5>=\e[15;*~"
  exec "set <F6>=\e[17;*~"
  exec "set <F7>=\e[18;*~"
  exec "set <F8>=\e[19;*~"
  exec "set <F9>=\e[20;*~"
  exec "set <F10>=\e[21;*~"
  exec "set <F11>=\e[23;*~"
  exec "set <F12>=\e[24;*~"
endif

" mouse fix for columns > 220
if has('mouse_sgr')
  set ttymouse=sgr
endif

" enable syntax highlighting
syntax on

" timeout for key codes (delayed ESC is annoying)
set ttimeoutlen=0

" enable persistent undo + its settings
if has("persistent_undo")
  if isdirectory($HOME . '/.vim/.undodir') == 0
    :silent !mkdir -p $HOME/.vim/.undodir >/dev/null 2>&1
  endif
  set undolevels=15000
  set undofile
  set undodir=$HOME/.vim/.undodir/
endif

if isdirectory($HOME . '/.vim/.backupdir') == 0
  :silent !mkdir -p $HOME/.vim/.backupdir >/dev/null 2>&1
endif
set backupdir=$HOME/.vim/.backupdir//
set backup

if isdirectory($HOME . '/.vim/.swapdir') == 0
  :silent !mkdir -p $HOME/.vim/.swapdir >/dev/null 2>&1
endif
set directory=$HOME/.vim/.swapdir//
set swapfile

" completion options
set completeopt=menuone

set novisualbell
set belloff=all

" Automatically read a file that has changed on disk
set autoread

" number of command line history lines kept
set history=10000

" default encoding
set encoding=utf-8

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" do incremental searching
set incsearch

" set search highlighting, bo do not highlight for now
set hlsearch
noh

" line endings settings
set fileformats=unix,dos

" always show status line
set laststatus=2

" allow to hide buffer with unsaved changes
set hidden

" no characters in separators
set fillchars=""

" disable that annoying beeping
autocmd GUIEnter * set vb t_vb=

" display incomplete commands
set showcmd

set lazyredraw

" some options have to be set only at init
if !exists("g:vimrc_init")
  let g:vimrc_init = 1

  set background=dark
  silent! colorscheme hybrid

  hi! VertSplit guibg=#252525
  hi! MatchParen guifg=#5F5F87 guibg=#1d1f21
  hi! clear TabLine
  hi! clear TabLineFill
  hi! TabLine guifg=#d5d8d6 guibg=#3c3c3c
  hi! TabLineFill guifg=#d5d8d6 guibg=#3c3c3c

  if has('termguicolors')
    set termguicolors
    let &t_8f = "[38;2;%lu;%lu;%lum"
    let &t_8b = "[48;2;%lu;%lu;%lum"
  endif

  set guioptions-=r
  set guioptions-=L

  " when editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " 80/120 columns marker
  silent! let &colorcolumn="80,120"

  " indentation options
  set autoindent
  set expandtab
  set shiftwidth=2
  set softtabstop=2
  set tabstop=2
  set smarttab

  " display line numbers
  set number

  " set folding method
  set foldmethod=marker

  " diff options
  set diffopt+=vertical

  " split settings
  set splitbelow
  set splitright

  " show the cursor position all the time
  set ruler

  " show at least 5 lines below/above cursor
  set scrolloff=5

  " foldenable + foldcolumn
  " silent! set nofoldenable
  if &foldenable
    silent! set foldcolumn=1
  else
    silent! set foldcolumn=0
  endif

  set nowrap
endif " exists("g:vimrc_init")

" --------------- VIM OPTS END ------------- }}}

" ---------- VIM MAPPINGS --------- {{{

function! s:toggleWindow(name)
  for i in range(1, winnr('$'))
    let bnum = winbufnr(i)
    if getbufvar(bnum, '&buftype') == 'quickfix'
      let dict = getwininfo(win_getid(i))
      if len(dict) > 0 && get(dict[0], 'quickfix', 0) && !get(dict[0], 'loclist', 0)
        cclose
      elseif len(dict) > 0 && get(dict[0], 'quickfix', 0) && get(dict[0], 'loclist', 0)
        lclose
      endif
      return
    endif
  endfor

  exec 'bot ' . a:name . 'open'
endfunction

" open/close quickfix/location-list window
noremap <silent> \q :call <SID>toggleWindow('c')<CR>
noremap <silent> \l :call <SID>toggleWindow('l')<CR>
noremap <silent> \c :call <SID>toggleWindow('C')<CR>

" moving around wrapped lines more naturally
noremap j gj
noremap k gk

" easier quitting
map <leader>q :q<CR>

" disable search highlighting
map <silent> <leader>n :noh<CR>

" resizing splits more easily
nmap _ :exe "vertical resize " . ((winwidth(0) + 1) * 3/2)<CR>
nmap - :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
nmap _ :exe "resize " . ((winheight(0) + 1) * 3/2)<CR>
nmap - :exe "resize " . (winheight(0) * 2/3)<CR>

" registers
nmap cr "
vmap cr "

nmap crc "+
vmap crc "+

nmap cy "+y
vmap cy "+y
nmap cY "+Y
vmap cY "+Y

nmap cp "+p
vmap cp "+p
nmap cP "+P
vmap cP "+P

" substitute all occurences of text selected in visual mode
vnoremap <C-r><C-r> "hy:%s/<C-r>h/<C-r>h/g<left><left>
vnoremap <C-r><C-e> "hy:%s/\<<C-r>h\>/<C-r>h/g<left><left>

" it's handy to have those when using byobu, as Shift + arrows moves around
" byobu's splits
nnoremap <C-Left> <C-w>h
nnoremap <C-Down> <C-w>j
nnoremap <C-Up> <C-w>k
nnoremap <C-Right> <C-w>l

func! ChangeFold()
  if (&foldenable == 1)
    set nofoldenable
    set foldcolumn=0
    echo 'Folding disabled'
  else
    set foldenable
    set foldcolumn=1
    echo 'Folding enabled'
  endif
endfunc

map zi :call ChangeFold()<CR>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

autocmd FileType help nnoremap <nowait> <buffer> q :quit<CR>

autocmd FileType qf nnoremap <nowait> <buffer> q :quit<CR>

" --------------- VIM MAPPINGS END -------------- }}}

function! s:cd_to_root_if_git_repo()
  if exists('b:git_dir')
    exec 'cd' fugitive#repo().tree()
    let g:_cwd = getcwd()
    pwd
  else
    echo 'Not in git repo'
  endif
endfunction

command! CdRootGitRoot call s:cd_to_root_if_git_repo()

autocmd VimEnter * if ! haslocaldir() | let g:_cwd = getcwd()  | endif
autocmd BufLeave * if ! haslocaldir() | let g:_cwd = getcwd() | endif

if ! exists('g:_starting_cd')
  let g:_starting_cd = getcwd()
endif

nmap <silent> <leader>ds :exec 'cd' g:_starting_cd \| let g:_cwd = getcwd() \| pwd<CR>
nmap <silent> <leader>dg :CdRootGitRoot<CR>
nmap <silent> <leader>dc :if ! haslocaldir() \| lcd %:p:h \|
      \ echo '<local> ' . getcwd() \| else \| exec 'cd ' . g:_cwd \|
        \ echo '<global> ' .  getcwd() \| endif<CR>
nmap <silent> <leader>dp :echo '=haslocaldir() ? '<local> ' : '<global> '<CR>' . getcwd()<CR>

function! MoveToPrevTab(...)
  let l:line = line('.')
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:last = tabpagenr() == tabpagenr('$')
  let l:only = winnr('$') == 1
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1 && a:0 == 0
    close!
    if (!l:last && l:only) || !l:only
      tabprev
    endif
    vsp
  else
    close!
    exe tabpagenr() - 1 . "tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
  exe l:line
endfunc

function! MoveToNextTab(...)
  let l:line = line('.')
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr && a:0 == 0
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    vsp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
  exe l:line
endfunc

nnoremap <silent> t :tabnew %<CR>
nnoremap <silent> x :sp<CR>
nnoremap <silent> v :vsp<CR>

nnoremap <silent> . :call MoveToNextTab()<CR>
nnoremap <silent> , :call MoveToPrevTab()<CR>

nnoremap <silent> > :call MoveToNextTab(1)<CR>
nnoremap <silent> < :call MoveToPrevTab(1)<CR>

nnoremap h gT
nnoremap <silent> H :tabm-1<CR>
nnoremap l gt
nnoremap <silent> L :tabm+1<CR>

vmap K k

" Cstyle indentation settings
set cinoptions=
set cinoptions+=l1
set cinoptions+=g0
set cinoptions+=N-s
set cinoptions+=t0
set cinoptions+=(0
set cinoptions+=u0
" set cinoptions+=U1
" set cinoptions+=w1
set cinoptions+=W1s
set cinoptions+=k2s
set cinoptions+=m1
" set cinoptions+=M1
set cinoptions+=j1
set cinoptions+=J1

" Sometimes autocommands interfere with each other and break syntax
" Let's fix it
au! syntaxset BufEnter *

silent! set shortmess+=c

nmap <leader>` p
nmap <leader>x x
nmap <leader><tab> :b#<CR>
nmap , <space>


if version >= 703
  nmap <leader>f <Plug>(easymotion-sn-to)

  let g:EasyMotion_timeout_len = 500
  let g:EasyMotion_off_screen_search = 0
  let g:EasyMotion_inc_highlight = 1
  let g:EasyMotion_history_highlight = 0

endif

" typing in wrong order may be annoying
" map q<leader> :q<CR>
command! Q q
command! Wq wq
command! WQ wq
command! W w

nnoremap <leader>z z

silent! set norelativenumber

" refresh <nowait> ESC mappings
runtime after/plugin/ESCNoWaitMappings.vim

nnoremap cop :set <C-R>=&paste ? 'nopaste' : 'paste'<CR><CR>
nnoremap co<space> :<C-R>=b:better_whitespace_enabled ? 'DisableWhitespace' : 'EnableWhitespace'<CR><CR>
nnoremap cog :<C-R>=gitgutter#utility#is_active() ? 'GitGutterDisable' : 'GitGutterEnable'<CR><CR>

" save current file
map <leader>w :w<CR>

" quickly edit/reload the vimrc file
nmap <silent> <leader>v :<C-R>=(expand('%')==$MYVIMRC)? 'so' : 'e'<CR> $MYVIMRC<CR>

" easier redrawing - sometimes strange artifacts are visible
map <leader><leader>r :redraw!<CR>

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

autocmd FileType cpp setlocal indentexpr=CppNoNamespaceAndTemplateIndent()

let s:src_ext = ['c', 'cpp', 'c\+\+', 'hpp', 'h\+\+']
let s:header_ext = ['h', 'hpp', 'h\+\+']
let s:src_ext_str = '(' . join(s:src_ext,'|') . ')'
let s:header_ext_str = '(' . join(s:header_ext,'|') . ')'

function! s:cust_cpp_proj_file_loc()
  let loc = expand('%:p:h')
  while loc != '/'
    let f = loc . '/.cpp_project_root'
    if filereadable(f)
      return loc
    endif
    let loc = simplify(loc . '/..')
  endwhile
  return ''
endfunction

function! Get_cpp_root(...)
  if exists('b:git_dir')
    return fugitive#repo().tree()
  endif

  let loc = expand('%:p:h')
  let orig = loc

  if exists('b:cpp_root')

    if b:cpp_root != ""
      return b:cpp_root
    endif

  else

    let f = s:cust_cpp_proj_file_loc()
    if f != ''
      if getfsize(f) == 0
        return loc
      else
        let r = readfile(f)
        let r = map(r, 'v:val =~ "^/" ? fnamemodify(v:val, ":p") : fnamemodify("' . fnamemodify(f, ':p:h') . '" . "/" . v:val, ":p")')
        let r = filter(r, 'isdirectory(v:val) && "' . orig . '" =~# v:val' )
        if len(r) > 0
          let b:cpp_root = r[0]
          return r[0]
        endif
      endif
    endif

    let b:cpp_root = ''

  endif

  if loc =~? 'inc\(l\(ude\)\?\)\?$' || loc =~? 'src$'
    let loc .= '/..'
    return simplify(loc)
  elseif loc =~? 'inc\(l\(ude\)\?\)\?/[^/]\+$'
    let loc .= '/../..'
    return simplify(loc)
  endif

  return a:0 > 0 ? a:1 : orig
endfunction

function! s:header_files()
  let loc = Get_cpp_root()
  call fzf#vim#files(loc, {
        \ 'source': "ag -g '\\." .  s:header_ext_str . "$'",
        \ 'options': '--preview "cat {}" --prompt "' . getcwd() . ' (Headers)> "'
        \ })
endfunction

function! s:src_files(...)
  let loc = Get_cpp_root()
  call fzf#vim#files(loc, {
        \ 'source': "ag -g '\\." .  (a:0 > 0 ? a:1 : s:src_ext_str) . "$'",
        \ 'options': '--preview "cat {}" --prompt "' . getcwd() . ' (Sources)> "'
        \ })
endfunction

function! Find_src_or_header(cmd)
  let fname = expand('%:t:r')
  let loc = Get_cpp_root()
  let cmd = "ag " . loc . " -g '\\b" . fname . "\\b\."
  let is_header = index(s:header_ext, expand('%:e')) != -1
  if is_header
    let cmd .= s:src_ext_str
  else
    let cmd .= s:header_ext_str
  endif
  let cmd .= "$'"
  let files = systemlist(cmd)
  if len(files) > 0
    exe a:cmd files[0]
  else
    if is_header
      echo "Did not find source file"
    else
      echo "Did not find header file"
    endif
  endif
endfunction

function! Find_include_header(cmd)
  let line = getline(line('.'))
  if line !~ '^#include '
    echo 'Not on #include line'
    return
  endif
  let fname = substitute(getline(line('.')), '^#include ["<]\(.*\)[">]$', '\1', "")
  let loc = Get_cpp_root()
  let cmd = "ag " . loc . " -g '\\b" . fname . "$'"
  let files = systemlist(cmd)
  if len(files) > 0
    exe a:cmd files[0]
  else
    echo "Did not find header file"
  endif
endfunction

function! Edit_CMakeLists(cmd)
  let loc = expand('%:p:h')
  while loc != '/'
    let f = loc . '/CMakeLists.txt'
    if filereadable(f)
      exec a:cmd . ' ' . f
      return
    endif
    let loc = simplify(loc . '/..')
  endwhile
  echo "Did not find CMakeLists.txt"
endfunction

command! HeaderFiles call <SID>header_files()
command! -nargs=? SrcFiles call <SID>src_files(<args>)

autocmd FileType cpp,c,cmake nmap <buffer> <silent> <leader>ah :HeaderFiles<CR>
autocmd FileType cpp,c,cmake nmap <buffer> <silent> <leader>as :SrcFiles<CR>
autocmd FileType cpp,c,cmake nmap <buffer> <silent> <leader>at :call Find_src_or_header("e")<CR>
autocmd FileType cpp,c,cmake nmap <buffer> <silent> <leader>ag :call Find_include_header("vsp")<CR>
autocmd FileType cpp,c nmap <buffer> <silent> <leader>al :call Edit_CMakeLists("vsp")<CR>

nmap 0y "0y
vmap 0y "0y
nmap 0p "0p
vmap 0p "0p
nmap 0Y "0Y
vmap 0Y "0Y
nmap 0P "0P
vmap 0P "0P
nmap <silent> <leader>t :checktime<CR>

function! SourceRange() range
  let tmpsofile = tempname()
  call writefile(getline(a:firstline, a:lastline), l:tmpsofile)
  execute "source " . l:tmpsofile
  call delete(l:tmpsofile)
endfunction
command! -range Source <line1>,<line2>call SourceRange()

nnoremap <silent> <leader>. :let pos = getpos('.') \|
      \ exec pos[1] . "," . pos[1] . "Source" \|
      \ call setpos('.', pos)<CR>

vmap <silent> <leader>. :Source<CR>

vmap <leader>s :sort<CR>

function! s:CheckForModelines()
   if !exists('+modelines') || &modelines < 1 || ( !&modeline && !exists('b:checked_modeline') )
     return -1
   endif
   let mlines = []
   if &modelines > line('$')
     sil exe '%g/\<vim:\|\<vi:\|\<ex:/let mlines = mlines + [getline(".")]'
   else
     sil exe '1,'.&modelines.'g/\<vim:\|\<vi:\|\<ex:/let mlines = mlines + [getline(".")]'
     sil exe '$-'.(&modelines-1).',$g/\<vim:\|\<vi:\|\<ex:/let mlines = mlines + [getline(".")]'
   endif
   if len(mlines) > 0
     echo join(mlines, "\n")
     let ans = confirm('Modelines found! Execute?', "&Yes\n&No", 2)
     let &l:modeline = (ans == 1)
     let b:checked_modeline = 1
   endif
endfunction

augroup modelines
  au!
  au BufReadPost * call s:CheckForModelines()
augroup END

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

function! Strip(str)
  return substitute(a:str, '\v^(\n|\s)*(.{-})(\n|\s)*$', '\2', '')
endfunction

highlight ExtraWhitespace ctermbg=137 guibg=#cc4411

inoremap jj <esc>
