" ---------- PLUGINS -------------- {{{

set nocompatible
filetype off

set rtp+=~/.vim/vim-plug
let path='~/.vim/plugged'

call plug#begin(path)

Plug 'tpope/vim-surround'
if v:version >= 703
  Plug 'scrooloose/nerdtree'
  Plug 'mbbill/undotree'
  Plug 'bmalkus/vim-easymotion'
  if empty($__NO_YCM__)
    if empty($__NO_COMPL__)
      Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
    else
      Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
    endif
    Plug 'davidhalter/jedi-vim'
  endif
endif
if v:version >= 704
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
endif
Plug 'kien/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'hynek/vim-python-pep8-indent'
Plug 'rking/ag.vim'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'lazyAsGarfield/delimitMate'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'dir': '`readlink -f ~/.vim`/../.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-endwise'
Plug 'airblade/vim-gitgutter'
Plug 'moll/vim-bbye'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-sleuth'
Plug 'junegunn/limelight.vim'
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-repeat'

" Extracted from https://github.com/klen/python-mode
Plug '~/.vim/plugin/python-mode-motions'

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

" completion options
set completeopt=menuone,preview

" do not create a backup file
" set nobackup
" set noswapfile
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

  " silent! colorscheme atom-dark-256-mine
  silent! colorscheme Tomorrow-Night-Eighties-Mine

  if has("gui_running")

    " set guifont=DejaVu\ Sans\ Mono\ for\ Powerline
    " set guifont=Consolas:h10

    " start maximized
    " autocmd GUIEnter * simalt ~s

    " just make window larger (if above dosn't work):
    winpos 0 0
    set lines=100 columns=420

  endif

  " when editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " 80/120 columns marker
  " silent! let &colorcolumn="80,".join(range(120,999),",")
  silent! let &colorcolumn="80,120"
  " call matchadd('ColorColumn', '\%=80v', -10)

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

" ---------- PLUGIN OPTS ---------- {{{

" NERDTree plugin options
let NERDTreeMouseMode = 2

" vim-commentary settings
autocmd FileType c,cpp,cs,java,cuda,cuda.cpp setlocal commentstring=//\ %s
autocmd FileType gnuplot setlocal commentstring=#\ %s
autocmd FileType cmake setlocal commentstring=#\ %s

" jedi-vim settings
" two below fix showing argument list when using YCM
let g:jedi#show_call_signatures_delay = 0
let g:jedi#show_call_signatures = "0"

let g:jedi#use_splits_not_buffers = "right"
let g:jedi#goto_command = "yjg"
let g:jedi#goto_assignments_command = "yja"
let g:jedi#goto_definitions_command = "yjd"
let g:jedi#documentation_command = "yjd"
let g:jedi#usages_command = "yju"
" let g:jedi#completions_command = "<C-Space>"
" let g:jedi#completions_command = "<Tab>"
let g:jedi#completions_command = ""
let g:jedi#rename_command = "yjr"

" disable completions from jedi-vim, using YCM instead
let g:jedi#completions_enabled = 0

let g:ycm_complete_in_comments = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_always_populate_location_list = 1

let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['re!\w+', '->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,perl6,scala,vb,elixir,go' : ['.'],
  \   'python' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }

autocmd FileType cuda set ft=cuda.cpp

" disable youcompleteme
" let g:loaded_youcompleteme = 1

" delimitMate opts
let delimitMate_expand_cr=2
let delimitMate_expand_space=1
let delimitMate_balance_matchpairs=1
let delimitMate_matchpairs = "(:),[:],{:}"
let delimitMate_smart_matchpairs = '^\%(\w\|[£$]\|[^[:space:][:punct:]]\)'

" Undotree settings
let g:undotree_SetFocusWhenToggle = 1

let g:goyo_width=120
let g:goyo_height='95%'

let g:limelight_default_coefficient = 0.54
let g:limelight_paragraph_span = 1

let g:tmux_navigator_no_mappings = 1

let g:gitgutter_override_sign_column_highlight = 0

" those are better visible
let g:gitgutter_sign_modified = '#'
let g:gitgutter_sign_removed = 'v'
let g:gitgutter_sign_modified_removed = '#v'

highlight ExtraWhitespace ctermbg=137

" --------------- PLUGIN OPTS END ---------- }}}

" ---------- VIM MAPPINGS --------- {{{

" change leader key
let mapleader=" "
let maplocalleader=" "

" open/close quickfix/location-list window
noremap [wq :bot copen<CR>
noremap ]wq :cclose<CR>
noremap [wl :bot lopen<CR>
noremap ]wl :lclose<CR>

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

nmap cry "0
vmap cry "0
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

imap +P a+

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

" ---------- PLUGIN COMMANDS ------ {{{

function! s:full_path(dir_or_file)
  " if fnamemodify() applied once, full_path may look like /blah/../
  " if a:dir_or_file is '..'
  return fnamemodify(fnamemodify(a:dir_or_file, ':p'), ':p')
endfunction

command! -bang -nargs=? -complete=dir FilesBetterPrompt call fzf#vim#files(<q-args>, extend({
      \ 'source': 'ag -g "" --hidden -U --ignore .git/',
      \ 'options': '--prompt "' . (<q-args> ? getcwd() : s:full_path(<q-args>)) . ' (Files)> "'
      \ }, <bang>0 ? {} : g:fzf#vim#default_layout))

function! s:is_remote()
  let file = expand('%')
  return file =~# '^\(scp\|ftp\)://' || file =~# '^//'
endfunction

function! s:mru_list_without_nonexistent()
  if empty(expand('%')) || s:is_remote() || &readonly
    let mru_list = ctrlp#mrufiles#list()
  else
    let mru_list = ctrlp#mrufiles#list()[1:]
  endif
  let cwd = fnameescape(getcwd())
  call filter(mru_list, '!empty(findfile(v:val, cwd))')
  return mru_list
endfunction

function! s:git_files_if_in_repo(bang)
  let expanded = expand('%:p:h')
  if s:is_remote()
    let expanded = getcwd()
  endif
  if ! exists('b:git_dir')
    let expanded = getcwd()
    return fzf#vim#files(expanded, extend({
          \ 'source': 'ag -g "" --hidden -U --ignore .git/',
          \ 'options': '--prompt "' . expanded . ' (Files)> "'
          \ }, a:bang ? {} : g:fzf#vim#default_layout))
  else
    let git_root = fugitive#repo().tree()
    let save_cwd = fnameescape(getcwd())
    let cdCmd = (haslocaldir() ? 'lcd!' : 'cd!')
    try
      exec cdCmd . git_root
      let z = { 'options': '--prompt "' . git_root . ' (GitFiles)> "' }
      echo z
      call fzf#vim#gitfiles('', extend({
            \ 'options': '--prompt "' . git_root . ' (GitFiles)> "'
            \ }, a:bang ? {} : g:fzf#vim#default_layout))
    finally
      exec cdCmd . save_cwd
    endtry
  endif
endfunction

command! -bang GitFilesOrCwd call s:git_files_if_in_repo(<bang>0)

command! -bang BuffersBetterPrompt call fzf#vim#buffers(extend({
      \ 'options': '--prompt "Buffers> "'
      \ }, <bang>0 ? {} : g:fzf#vim#default_layout))

function! s:git_root_or_cwd()
  if s:is_remote()
    return getcwd()
  endif
  return exists('b:git_dir') ? fugitive#repo().tree() : getcwd()
endfunction

function! s:all_files_git_root_or_cwd(bang)
  let path = s:git_root_or_cwd()
  call fzf#vim#files(path, extend({
        \ 'source': 'ag -g "" --hidden -U --ignore .git/',
        \ 'options': '--prompt "' . path . ' (Files)> "'
        \ }, a:bang ? {} : g:fzf#vim#default_layout))
endfunction

command! -bang FilesGitRootOrCwd call s:all_files_git_root_or_cwd(<bang>0)

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

function! s:fzf_mru(bang)
  call fzf#run({
        \ 'source':  map(s:mru_list_without_nonexistent(), 's:color_path(s:relpath(v:val))'),
        \ 'sink*': function("s:mru_sink"),
        \ 'options': '-m -x +s --prompt "' . s:git_root_or_cwd() .
        \ ' (MRU)> " --ansi --expect='.join(keys(s:default_action), ','),
        \ 'down':    '40%'
        \ })
endfunction

command! -bang Mru call s:fzf_mru(<bang>0)

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
  call fzf#vim#ag(join(query[1:], ' '), ag_opts . ' --ignore .git/', extend({
        \ 'dir': dir,
        \ 'options': '--prompt "' . dir . ' (Ag)> "'
        \ }, a:bang ? {} : g:fzf#vim#default_layout))
endfunction

function! s:ag_with_opts(bang, ...)
  let tokens  = a:000
  let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
  let query   = join(filter(copy(tokens), 'v:val !~ "^-"'))
  let dir = s:git_root_or_cwd()
  call fzf#vim#ag(query, ag_opts . ' --ignore .git/', extend({
        \ 'dir': dir,
        \ 'options': '--prompt "' . dir . ' (Ag)> "'
        \ }, a:bang ? {} : g:fzf#vim#default_layout))
endfunction

command! -nargs=+ -complete=dir -bang Agin call s:ag_in(<bang>0, <f-args>)

command! -nargs=* -bang Agcwd exec 'Agin<bang>'  getcwd() '<args>'
command! -nargs=* -bang AgGitRootOrCwd call s:ag_with_opts(<bang>0, <f-args>)
" Ag command is set in after/plugin/override.vim

cab ag Ag
cab agin Agin
cab agcwd Agcwd

function! s:ansi(str, col, bold)
  return printf("\x1b[%s%sm%s\x1b[m", a:col, a:bold ? ';1' : '', a:str)
endfunction

for [s:c, s:a] in items({'black': 30, 'red': 31, 'green': 32, 'yellow': 33, 'blue': 34, 'magenta': 35, 'cyan': 36})
  exec "function! s:".s:c."(str, ...)\n"
        \ "  return s:ansi(a:str, ".s:a.", get(a:, 1, 0))\n"
        \ "endfunction"
endfor

function! s:get_all_registers()
  let reg_names = '"-+0123456789abcdefghijklmnopqrstuvwxyz=*:.%~/'
  let res = []
  for name in split(reg_names, '\zs')
    let content = eval('@' . name)
    let reg_str = s:blue('["' . name . ']') . ' ' . content
    let reg_str = substitute(reg_str, '\n', s:yellow('\\n', 1), 'g')
    if ! empty(content)
      call add(res, reg_str)
    endif
  endfor
  return res
endfunction

function! s:paste_buffer(key_with_str, visual)
  let [key, str] = a:key_with_str
  let reg = str[1:2]
  exec 'normal ' . (a:visual ? 'gv' : '') . reg . (empty(key) ? 'p' : 'P')
endfunction

let s:yank_key = 'alt-c'

function! s:yank_to_buffer(key_with_str, visual)
  let [key, str] = a:key_with_str
  let reg = str[1:2]
  exec 'normal ' . (a:visual ? 'gv'.reg.'y' : reg.'yy')
endfunction

function! s:registers_sink(key_with_str)
  if len(a:key_with_str) > 1
    let [key, str] = a:key_with_str
    if tolower(key) == s:yank_key
      call s:yank_to_buffer(a:key_with_str, 0)
    else
      call s:paste_buffer(a:key_with_str, 0)
    endif
  endif
endfunction

function! s:registers_sink_visual(key_with_str)
  if len(a:key_with_str) > 1
    let [key, str] = a:key_with_str
    if tolower(key) == s:yank_key
      call s:yank_to_buffer(a:key_with_str, 1)
    else
      call s:paste_buffer(a:key_with_str, 1)
    endif
  endif
endfunction

command! -nargs=? Regs call fzf#run({
      \ 'source':  s:get_all_registers(),
      \ 'sink*': function('s:registers_sink' . (<args>0 ? '_visual' : '')),
      \ 'options': '-e -x +s --prompt "(Regs)> " --ansi --expect=alt-p,' .  s:yank_key,
      \ 'down':    '40%'
      \ })

function! s:goyo_enter()
  if !empty($TMUX)
    silent! !tmux set -w status off
    silent! !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  let g:scrolloff_saved=&scrolloff
  set scrolloff=999
  Goyo x95%
  silent! Limelight
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
  silent! colorscheme Tomorrow-Night-Eighties-Mine
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" --------------- PLUGIN COMMANDS END -------------- }}}

" ---------- PLUGIN MAPPINGS ------ {{{

if version >= 703

  " YCM mappings
  nnoremap ycg :YcmCompleter GoTo<CR>
  nnoremap ycc :YcmForceCompileAndDiagnostics<CR>
  nnoremap ycf :YcmCompleter FixIt<CR>
  nnoremap ycd :YcmCompleter GetDoc<CR>
  nnoremap ycdd :YcmShowDetailedDiagnostic<CR>
  nnoremap ycl :YcmDiags<CR>
  nnoremap yct :YcmCompleter GetType<CR>
  nnoremap ycr :YcmRestartServer<CR>

  " NERDTree plugin
  function! NERDTreeEnableOrToggle()
    try
      NERDTreeToggle
    catch
      silent! NERDTree
    endtry
  endfunction

  map <C-n> :call NERDTreeEnableOrToggle()<CR>

endif

" delimitMate mappings
imap <C-k> <Plug>delimitMateJumpMany
imap <C-l> <Plug>delimitMateS-Tab
imap <C-h> <Plug>delimitMateS-BS
imap <C-j> <C-k><CR>

" no need for mapping, using fzf instead
let g:ctrlp_map = ''

" EasyAlign mappings
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

nmap MM :Goyo<CR>

if executable('fzf')
  nnoremap <C-p> :Mru<CR>
  nnoremap <C-b> :BuffersBetterPrompt<CR>
  nnoremap <leader>ss :GitFilesOrCwd<CR>
  nnoremap <leader>sf :Files<CR>
  nnoremap <leader>sr :FilesGitRootOrCwd<CR>

  " good way of detecting if in visual mode
  " a bit experimental mappings
  nnoremap <leader>l :Regs<CR>
  vnoremap <leader>l :<c-u>Regs 1<CR>
else
  nnoremap <silent> <C-p> :CtrlPMRU<CR>
  nnoremap <silent> <C-b> :CtrlPBuffer<CR>
  nnoremap <silent> <C-f> :CtrlP<CR>
endif

nmap LL :Limelight!!<CR>
autocmd FileType nerdtree silent! nunmap LL
autocmd FileType nerdtree autocmd BufEnter <buffer> silent! nunmap LL
autocmd FileType nerdtree autocmd BufLeave <buffer> silent! nmap LL :Limelight!!<CR>

autocmd FileType undotree nmap <nowait> <buffer> q :quit<CR>
autocmd FileType undotree nmap <buffer> <C-j> j
autocmd FileType undotree nmap <buffer> <C-k> k
autocmd FileType undotree nmap <buffer> <nowait>  :quit<CR>

" autocmd FileType nerdtree nmap <buffer>  :quit<CR>
autocmd FileType nerdtree nmap <buffer> <C-v> s
autocmd FileType nerdtree nmap <buffer> <C-x> i
autocmd FileType nerdtree nmap <buffer> <C-j> j
autocmd FileType nerdtree nmap <buffer> <C-k> k
autocmd FileType nerdtree nmap <buffer> . I

let g:NERDTreeMapJumpLastChild = '<C-f>'
let g:NERDTreeMapJumpFirstChild = '<C-b>'
let g:NERDTreeMapJumpNextSibling = 'J'
let g:NERDTreeMapJumpPrevSibling = 'K'

function! Navigate(dir)
  if a:dir == 'l'
    if exists(':TmuxNavigateLeft')
      TmuxNavigateLeft
    else
      normal h
    endif
  elseif a:dir == 'r'
    if exists(':TmuxNavigateRight')
      TmuxNavigateRight
    else
      normal l
    endif
  elseif a:dir == 'u'
    if exists(':TmuxNavigateUp')
      TmuxNavigateUp
    else
      normal k
    endif
  elseif a:dir == 'd'
    if exists(':TmuxNavigateDown')
      TmuxNavigateDown
    else
      normal j
    endif
  endif
endfunction

nnoremap <silent> <C-h> :call Navigate('l')<CR>
nnoremap <silent> <C-j> :call Navigate('d')<CR>
nnoremap <silent> <C-k> :call Navigate('u')<CR>
nnoremap <silent> <C-l> :call Navigate('r')<CR>

nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk

map <leader>D :Bdelete<CR>

autocmd FileType gitcommit nnoremap <nowait> <buffer> ? :help fugitive-:Gstatus<CR>

" --------------- PLUGIN MAPPINGS END -------------- }}}


" new stuff, not categorized yet

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
autocmd CursorMoved,BufLeave * if ! haslocaldir() | let g:_cwd = getcwd() | endif

if ! exists('g:_starting_cd')
  let g:_starting_cd = getcwd()
endif

nmap <silent> <leader>ds :exec 'cd' g:_starting_cd \| let g:_cwd = getcwd() \| pwd<CR>
nmap <silent> <leader>dg :CdRootGitRoot<CR>
nmap <silent> <leader>dc :if ! haslocaldir() \| lcd %:p:h \|
      \ echo '<local> ' . getcwd() \| else \| exec 'cd ' . g:_cwd \|
      \ echo '<global> ' .  getcwd() \| endif<CR>

function! RemoveFromQF(ind)
  let qf = getqflist()
  let ind = a:ind - 1
  if ind == 0
    call setqflist(qf[1:])
  else
    call setqflist(qf[:ind-1] + qf[ind+1:])
    exec ind+1
  endif
  if len(qf) == 1
    cclose
  endif
endfunction

autocmd FileType qf nnoremap <silent> <nowait> <buffer> d :call RemoveFromQF(line('.'))<CR>

let g:UltiSnipsExpandTrigger = 'e'
let g:UltiSnipsListSnippets = 's'
let g:UltiSnipsJumpForwardTrigger = 'f'
let g:UltiSnipsJumpBackwardTrigger = 'b'

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

nnoremap <silent> t :tabnew<CR>
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

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap b <C-Left>
cnoremap f <C-Right>

autocmd CmdwinEnter : noremap <buffer> <CR> <CR>q:
autocmd CmdwinEnter : imap <buffer> <CR> <CR>q:
autocmd CmdwinEnter * nnoremap <buffer> q :quit<CR>

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
" set cinoptions+=m1
" set cinoptions+=M1
set cinoptions+=j1
set cinoptions+=J1

" Sometimes autocommands interfere with each other and break syntax
" Let's fix it
au! syntaxset BufEnter *

nmap n :NERDTreeFind<CR>

let g:airline_left_sep=''
let g:airline_right_sep=''

nmap g :TagbarToggle<CR>

let g:tagbar_map_openfold = 'l'
let g:tagbar_map_closefold = 'h'

" Undotree plugin
nnoremap u :UndotreeToggle<CR>

set cscopequickfix=s-,c-,d-,i-,t-,e-,g-,f-

let g:tagbar_autofocus = 1

if has("cscope")

    " use both cscope and ctag
    set cscopetag

    " check cscope for definition of a symbol before checking ctags
    set csto=0

    " show msg when cscope db added
    set cscopeverbose

    function! s:maybe_open_qf()
        let qf = getqflist()
        if len(qf) > 1
            bot copen
            wincmd p
        endif
    endfunction

    for [bind, prefix] in [['<C-\>', ''], ['<C-@>', 'vert s'], ['<C-@><C-@>', 's']]
        for cmd in ['s', 'g', 'c', 't', 'e', 'd']
            exec 'nmap <silent> ' . bind . cmd . ' :' . prefix . 'cs find ' . cmd . ' <C-R>=expand("<cword>")<CR><CR> \| :call <SID>maybe_open_qf()<CR>'
            exec 'nmap <silent> ' . bind . 'f :' . prefix . 'cs find f <C-R>=expand("<cfile>")<CR><CR> \| :call <SID>maybe_open_qf()<CR>'
            exec 'nmap <silent> ' . bind . 'i :' . prefix . 'cs find i ^<C-R>=expand("<cfile>")<CR>$<CR> \| :call <SID>maybe_open_qf()<CR>'
        endfor
    endfor

    cab csa cs add
    cab csh cs help
    cab csf cs find
    cab csk cs kill
    cab csr cs reset
    cab css cs show

endif

let g:NERDMenuMode = 3
let g:NERDRemoveExtraSpaces = 1
let g:NERDSpaceDelims = 1
" prevent double space after '#' in python
let g:NERDAltDelims_python = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'

let g:cpp_experimental_template_highlight = 1

" default flags files for c-like langs for YCM
" won't work as g:ycm_global_ycm_extra_conf is read only at vim startup
" autocmd FileType cpp let g:ycm_global_ycm_extra_conf = expand("$HOME/.vim/ycm/cpp/.ycm_extra_conf.py")
" autocmd FileType c let g:ycm_global_ycm_extra_conf = expand("$HOME/.vim/ycm/c/.ycm_extra_conf.py")
" autocmd FileType cuda.cpp let g:ycm_global_ycm_extra_conf = expand("$HOME/.vim/ycm/cuda/.ycm_extra_conf.py")

let g:ycm_global_ycm_extra_conf = expand("$HOME/.vim/ycm/.ycm_extra_conf.py")

let g:ycm_warning_symbol = '>'
let g:ycm_error_symbol = '>>'
let g:ycm_collect_identifiers_from_tags_files = 1

silent! set shortmess+=c

nmap <leader>p p
nmap <leader>x x
nmap <leader><tab> :b#<CR>
nmap , <space>

nmap <leader>; :


if version >= 703

  " Easymotion mappings
  " nmap <leader><leader>t <Plug>(easymotion-t2)
  " nmap <leader><leader>f <Plug>(easymotion-f2)
  " nmap <leader><leader>T <Plug>(easymotion-T2)
  " nmap <leader><leader>F <Plug>(easymotion-F2)

  " nmap <leader>t <Plug>(easymotion-t)
  " nmap <leader>f <Plug>(easymotion-f)
  " nmap <leader>T <Plug>(easymotion-T)
  " nmap <leader>F <Plug>(easymotion-F)

  nmap <leader>f <Plug>(easymotion-sn-to)

  let g:EasyMotion_timeout_len = 400
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

" easier switch to previous buffer
nmap <leader>B :b#<CR>
nmap <leader>b <C-b>

silent! set relativenumber

nmap f :normal A fo<C-v><Esc>e<C-v><Esc>]m%ofc<C-v><Esc>e<C-v><Esc><C-v><C-o>k^<CR>:foldc<CR>

" refresh <nowait> ESC mappings
runtime after/plugin/ESCNoWaitMappings.vim

inoremap jj 

nnoremap cop :set <C-R>=&paste ? 'nopaste' : 'paste'<CR><CR>
nnoremap co<space> :<C-R>=b:better_whitespace_enabled ? 'DisableWhitespace' : 'EnableWhitespace'<CR><CR>
nnoremap cog :<C-R>=gitgutter#utility#is_active() ? 'GitGutterDisable' : 'GitGutterEnable'<CR><CR>

nmap <leader>N <Plug>(easymotion-bd-n)

nmap <leader>= =

let g:NERDTreeCascadeSingleChildDir = 0

" save current file
map <leader>w :w<CR>

map <leader>2 <C-w>

" quickly edit/reload the vimrc file
nmap <silent> <leader>.e :e $MYVIMRC<CR>
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>.s :so $MYVIMRC<CR>

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
  elseif l:pline =~# '^\s*namespace.*'
    let l:retv = 0
  endif
  return l:retv
endfunction

autocmd FileType cpp setlocal indentexpr=CppNoNamespaceAndTemplateIndent()

let s:src_ext = ['c', 'cpp', 'c\+\+', 'hpp', 'h\+\+']
let s:header_ext = ['h', 'hpp', 'h\+\+']
let s:src_ext_str = '(' . join(s:src_ext,'|') . ')'
let s:header_ext_str = '(' . join(s:header_ext,'|') . ')'

function! s:header_files()
  call fzf#vim#files(getcwd(), {
        \ 'source': "ag -g '\\." .  s:header_ext_str . "$'",
        \ 'options': '--prompt "' . getcwd() . ' (Headers)> "'
        \ })
endfunction

function! s:src_files()
  call fzf#vim#files(getcwd(), {
        \ 'source': "ag -g '\\." .  s:src_ext_str . "$'",
        \ 'options': '--prompt "' . getcwd() . ' (Sources)> "'
        \ })
endfunction

function! Find_src_or_header(cmd)
  let fname = expand('%:t:r')
  let loc = getcwd()
  if loc =~? 'inc\(l\(ude\)\?\)\?$' || fname =~? 'src$'
    let loc .= '/..'
  endif
  let cmd = "ag " . loc . " -g '" . fname . "\."
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

command! HeaderFiles call <SID>header_files()
command! SrcFiles call <SID>src_files()

autocmd FileType cpp,c nmap <buffer> <silent> <leader>sh :HeaderFiles<CR>
autocmd FileType cpp,c nmap <buffer> <silent> <leader>ss :SrcFiles<CR>
autocmd FileType cpp,c nmap <buffer> <silent> <leader>ax :call Find_src_or_header("sp")<CR>
autocmd FileType cpp,c nmap <buffer> <silent> <leader>av :call Find_src_or_header("vsp")<CR>
autocmd FileType cpp,c nmap <buffer> <silent> <leader>as :call Find_src_or_header("e")<CR>

" let g:loaded_youcompleteme = 1

let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsSnippetsDir = $DOTFILES_DIR . '/.vim/UltiSnips'
