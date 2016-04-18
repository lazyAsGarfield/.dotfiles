" ---------- PLUGINS -------------- {{{

set nocompatible
filetype off

set rtp+=~/.vim/vim-plug
let path='~/.vim/plugged'

call plug#begin(path)

Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'kien/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'hynek/vim-python-pep8-indent'
Plug 'rking/ag.vim'
Plug 'easymotion/vim-easymotion'
Plug 'davidhalter/jedi-vim'
Plug 'tpope/vim-unimpaired'
if empty($__NO_YCM__)
  if empty($__NO_COMPL__)
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --omnisharp-completer' }
  else
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
  endif
endif
Plug 'tpope/vim-fugitive'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'lazyAsGarfield/delimitMate'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree'
Plug 'junegunn/fzf', { 'dir': '`readlink -f ~/.vim`/../.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'flazz/vim-colorschemes'
Plug 'junegunn/goyo.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Shougo/unite.vim'
Plug 'Shougo/neossh.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'tpope/vim-endwise'
Plug 'airblade/vim-gitgutter'
Plug 'moll/vim-bbye'
Plug 'ntpeters/vim-better-whitespace'

call plug#end()

filetype plugin indent on

" --------------- PLUGINS END --------------- }}}

" ---------- VIM OPTS ------------- {{{

silent! colorscheme atom-dark-256-mine

if has("gui_running")

  " set guifont=DejaVu\ Sans\ Mono\ for\ Powerline
  " set guifont=Consolas:h10

  " start maximized
  " autocmd GUIEnter * simalt ~s

  " just make window larger (if above dosn't work):
  winpos 0 0
  set lines=100 columns=420

endif

" enable mouse if possible
if has('mouse')
  set mouse+=a
endif

" tmux options
if &term =~ '^screen' && exists('$TMUX')
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

" when editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

" 80/120 columns marker
" silent! let &colorcolumn="80,".join(range(120,999),",")
silent! let &colorcolumn="80,120"
" call matchadd('ColorColumn', '\%=80v', -10)

" enable syntax highlighting
syntax on

" timeout for key codes (delayed ESC is annoying)
set ttimeoutlen=0

" indentation options
set autoindent
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set smarttab

" enable persistent undo + its settings
if has("persistent_undo")
  set undolevels=15000
  set undofile
  set undodir=$HOME/.vim/.undodir/
endif

" completion options
set completeopt=menuone,preview

" do not indent visibility keywords in C++ classes, indent lambdas
" set cindent
set cinoptions=g0,j1

" display line numbers
set number

" set folding method
set foldmethod=marker

" diff options
set diffopt+=vertical

" do not create a backup file
set nobackup
set noswapfile

" Automatically read a file that has changed on disk
set autoread

" number of command line history lines kept
set history=500

" default encoding
set encoding=utf-8

" split settings
set splitbelow
set splitright

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" show the cursor position all the time
set ruler

" display incomplete commands
set showcmd

" do incremental searching
set incsearch

" set search highlighting, bo do not highlight for now
set hlsearch
noh

" line endings settings
set fileformats=unix,dos

" always show status line
set laststatus=2

" show at least 5 lines below/above cursor
set scrolloff=5

" allow to hide buffer with unsaved changes
set hidden

" no characters in separators
set fillchars=""

" foldenable + foldcolumn
" silent! set nofoldenable
if &foldenable
  silent! set foldcolumn=1
else
  silent! set foldcolumn=0
endif

" disable that annoying beeping
autocmd GUIEnter * set vb t_vb=

" set filetype for .shellrc file
autocmd BufRead $DOTFILES_DIR/.shellrc set ft=sh

" --------------- VIM OPTS END ------------- }}}

" ---------- PLUGIN OPTS ---------- {{{

" NERDTree plugin options
let NERDTreeMouseMode = 3

" vim-commentary settings
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s
autocmd FileType cmake setlocal commentstring=#\ %s

" jedi-vim settings
" two below fix showing argument list when using YCM
let g:jedi#show_call_signatures_delay = 0
let g:jedi#show_call_signatures = "0"

let g:jedi#use_splits_not_buffers = "right"
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>u"
" let g:jedi#completions_command = "<C-Space>"
" let g:jedi#completions_command = "<Tab>"
let g:jedi#completions_command = ""
let g:jedi#rename_command = "<leader>r"

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

" --------------- PLUGIN OPTS END ---------- }}}

" ---------- VIM MAPPINGS --------- {{{

" change leader key
let mapleader=","

" open/close quickfix/location-list window
noremap \Q :copen<CR>
noremap \q :cclose<CR>
noremap \L :lopen<CR>
noremap \l :lclose<CR>

" close preview window
noremap \p <C-w>z

" moving around wrapped lines more naturally
noremap j gj
noremap k gk

" easier quitting
map <leader>q :q<CR>

" save current file
map <leader>w :w<CR>

" disable search highlighting
map <silent> <leader>n :noh<CR>

" easier switch to previous buffer
map <leader>b :b#<CR>

" delete current buffer without closing split
" map <leader>D :BD<CR>

" quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" resizing splits more easily
nmap + :exe "vertical resize " . ((winwidth(0) + 1) * 3/2)<CR>
nmap - :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

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

imap CP +

" easier redrawing - sometimes strange artifacts are visible
map <leader>r :redraw!<CR>

" substitute all occurences of text selected in visual mode
vnoremap <C-r><C-r> "hy:%s/<C-r>h/<C-r>h/g<left><left>
vnoremap <C-r><C-e> "hy:%s/\<<C-r>h\>/<C-r>h/g<left><left>

" moving around splits more easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

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

function! GetUnityDoc()
  if &filetype == "cs" && expand("%:p") =~ "Unity"
    call system("git web--browse -b google-chrome " .
          \ "https://docs.unity3d.com/ScriptReference/30_search.html?q=" .
          \ @h . " >/dev/null 2>&1")
    if v:shell_error
      call system("git web--browse " .
            \ "https://docs.unity3d.com/ScriptReference/30_search.html?q=" .
            \ @h . " >/dev/null 2>&1")
    endif
  endif
endfunction

nnoremap <leader>ud "hyiw:call GetUnityDoc()<CR>
vnoremap <leader>ud "hy:<C-u>call GetUnityDoc()<CR>

" --------------- VIM MAPPINGS END -------------- }}}

" ---------- PLUGIN MAPPINGS ------ {{{

" YCM mappings
nnoremap ycg :YcmCompleter GoTo<CR>
nnoremap ycc :YcmForceCompileAndDiagnostics<CR>
nnoremap ycf :YcmCompleter FixIt<CR>
nnoremap ycd :YcmCompleter GetDoc<CR>
nnoremap yci :YcmShowDetailedDiagnostic<CR>
nnoremap yct :YcmCompleter GetType<CR>
" vnoremap yct :<c-u>YcmCompleter GetType<CR>

" delimitMate mappings
imap <C-k> <Plug>delimitMateJumpMany
imap <C-l> <Plug>delimitMateS-Tab
imap <C-h> <Plug>delimitMateS-BS
imap <C-j> <C-k><CR>

" Undotree plugin
nnoremap <C-t> :UndotreeToggle<CR>

" NERDTree plugin
function! NERDTreeEnableOrToggle()
  try
    NERDTreeToggle
  catch
    silent! NERDTree
  endtry
endfunction

map <C-n> :call NERDTreeEnableOrToggle()<CR>
map <leader><leader>n :NERDTreeFind<CR>

" FZF list
" <C-f> is mapped in commands section deal more wisely with git repos
" <C-b> is mapped in commands for better prompt
" nmap <C-f> :Files<CR>
" nmap <C-b> :Buffers<CR>

" no need for mapping, using fzf instead
let g:ctrlp_map = ''

" CtrlP plugin
let g:ctrlp_cmd = 'call CallCtrlP()'

func! CallCtrlP()
    if exists('g:called_ctrlp')
        CtrlPLastMode
    else
        let g:called_ctrlp = 1
        " CtrlPMRU
        CtrlP
    endif
endfunc

" EasyAlign mappings
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Easymotion mappings
nmap <leader><leader>t <Plug>(easymotion-t2)
nmap <leader><leader>f <Plug>(easymotion-f2)
nmap <leader><leader>T <Plug>(easymotion-T2)
nmap <leader><leader>F <Plug>(easymotion-F2)

nmap <leader>t <Plug>(easymotion-t)
nmap <leader>f <Plug>(easymotion-f)
nmap <leader>T <Plug>(easymotion-T)
nmap <leader>F <Plug>(easymotion-F)

" tab as omnicomplete key, but not at beginning of
" file and not on non-letter char
" YCM overrides tab mapping, therefore it's not needed
" let g:tab_completion = 1

" function! ToggleTabCompletion()
"   let g:tab_completion = !g:tab_completion
"   if g:tab_completion
"     echo 'Tab completion enabled'
"   else
"     echo 'Tab completion disabled'
"   endif
" endfunction

" nmap c<Tab> :call ToggleTabCompletion()<CR>

" function! InsertTabWrapper()
"     let col = col('.') - 1
"     if !col || getline('.')[col - 1] !~ '\k' || !g:tab_completion
"         return "\<tab>"
"     else
"         return "\<C-n>"
"     endif
" endfunction

" inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
" inoremap <S-Tab> <C-p>

" --------------- PLUGIN MAPPINGS END -------------- }}}

" ---------- VIM COMMANDS --------- {{{

" open buffer [number] in vertical split
command! -nargs=? VB vert sb <args>

" buffer delete without closing split
function! CountListedBuffers()
  let cnt = 0
  for nr in range(1, bufnr('$'))
    if buflisted(nr)
      let cnt += 1
    endif
  endfor
  return cnt
endfunction

" function! LastUsedBufferOrPrevious(bang)
"   if a:bang
"     if CountListedBuffers() == 1 || bufwinnr('#') > -1
"       bd!
"     elseif buflisted(bufnr("#"))
"       b #
"       bd! #
"     else
"       bp
"       bd! #
"     endif
"   elseif getbufvar(bufnr("%"), "&mod")
"     echoerr "Unsaved changes (add ! to override)"
"   else
"     if CountListedBuffers() == 1 || bufwinnr('#') > -1
"       bd
"     elseif buflisted(bufnr("#"))
"       b #
"       bd #
"     else
"       bp
"       bd #
"     endif
"   endif
" endfunction

" command! -bang BD call LastUsedBufferOrPrevious(<bang>0)

" --------------- VIM COMMANDS END -------------- }}}

" ---------- PLUGIN COMMANDS ------ {{{

function! s:full_path(dir_or_file)
  " if fnamemodify() applied once, full_path may look like /blah/../
  " if a:dir_or_file is '..'
  return fnamemodify(fnamemodify(a:dir_or_file, ':p'), ':p')
endfunction

command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, extend({
      \ 'source': 'ag -g "" --hidden -U --ignore .git/',
      \ 'options': '--prompt "' . (<q-args> ? getcwd() :
      \ s:full_path(<q-args>) . ' (Files)> "'
      \ }, <bang>0 ? {} : g:fzf#vim#default_layout))

function! s:git_files_if_in_repo(bang)
  let expanded = expand('%:p:h')
  if expanded =~ '^\(scp\|ftp\)://'
    let expanded = getcwd()
  endif
  let git_root = join(split(fugitive#extract_git_dir(expanded), '/')[:-2], '/')
  if git_root == ''
    return fzf#vim#files(expanded, extend({
          \ 'source': 'ag -g "" --hidden -U --ignore .git/',
          \ 'options': '--prompt "' . expanded . ' (Files)>"'
          \ }, a:bang ? {} : g:fzf#vim#default_layout))
  else
    let git_root = '/' . git_root
    let save_cwd = fnameescape(getcwd())
    let cdCmd = (haslocaldir() ? 'lcd!' : 'cd!')
    try
      exec cdCmd . fnameescape(git_root)
      call fzf#vim#gitfiles(extend({
            \ 'options': '--prompt "' . git_root . ' (GitFiles)> "'
            \ }, a:bang ? {} : g:fzf#vim#default_layout))
    finally
      exec cdCmd . save_cwd
    endtry
  endif
endfunction

command! -bang GitFilesOrCurrent call s:git_files_if_in_repo(<bang>0)

command! -bang BuffersBetterPrompt call fzf#vim#buffers(extend({
      \ 'options': '--prompt "Buffers> "'
      \ }, <bang>0 ? {} : g:fzf#vim#default_layout))

function! s:git_root_or_current_dir()
  let expanded = expand('%:p:h')
  if expanded =~ '^\(scp\|ftp\)://'
    return getcwd()
  endif
  let git_root = join(split(fugitive#extract_git_dir(expanded), '/')[:-2], '/')
  return git_root == '' ? expanded : '/'.git_root
endfunction

function! s:all_files_git_root_or_current_dir(bang)
  let path = s:git_root_or_current_dir()
  call fzf#vim#files(path, extend({
        \ 'source': 'ag -g "" --hidden -U --ignore .git/',
        \ 'options': '--prompt "' . path . ' (Files)> "'
        \ }, a:bang ? {} : g:fzf#vim#default_layout))
endfunction

command! -bang FilesGitRootOrCurrent call s:all_files_git_root_or_current_dir(<bang>0)

" expands path relatively to current dir or git root if possible
" or to cwd if editing over ssh/ftp
" (similar to CtrlP plugin)
function! s:relpath(filepath_or_name)
  let fullpath = fnamemodify(a:filepath_or_name, ':p')
  " if fullpath =~ '^(ssh|ftp)://'
  "   fullpath = getcwd()
  " endif
  let save_cwd = fnameescape(getcwd())
  let cdCmd = (haslocaldir() ? 'lcd!' : 'cd!')
  try
    exec cdCmd . fnameescape(s:git_root_or_current_dir())
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
" and to transform path to proper version (as it may be relative to
" dir of current file, not necessarily to cwd)
function! s:mru_sink(lines)
  let key = remove(a:lines, 0)
  let cmd = get(s:default_action, key, 'e')
  let save_cwd = fnameescape(getcwd())
  let cdCmd = (haslocaldir() ? 'lcd!' : 'cd!')
  try
    exec cdCmd . fnameescape(s:git_root_or_current_dir())
    let full_path_lines = map(a:lines, 'fnameescape(fnamemodify(v:val, ":p"))')
  finally
    exec cdCmd . save_cwd
  endtry
  augroup fzf_swap
    autocmd SwapExists * let v:swapchoice='o'
          \| call s:warn('E325: swap file exists: '.expand('<afile>'))
  augroup END
  let empty = empty(expand('%')) && line('$') == 1 && empty(getline(1)) && !&modified
  try
    for item in full_path_lines
      if empty
        exec 'e' item
        let empty = 0
      else
        exec cmd item
      endif
    endfor
  finally
    silent! autocmd! fzf_swap
  endtry
endfunction

let g:mru_full_path = 0

function! s:mru_list_without_nonexistent()
  if empty(expand('%'))
    let mru_list = ctrlp#mrufiles#list()
  else
    let mru_list = ctrlp#mrufiles#list()[1:]
  endif
  let cwd = fnameescape(getcwd())
  call filter(mru_list, '!empty(findfile(v:val, cwd))')
  return mru_list
endfunction

function! s:fzf_mru(bang)
  if g:mru_full_path == 0
    call fzf#run({
          \ 'source':  map(s:mru_list_without_nonexistent(), 's:color_path(s:relpath(v:val))'),
          \ 'sink*': function("s:mru_sink"),
          \ 'options': '-m -x +s --prompt "' . s:git_root_or_current_dir() .
          \ ' (MRU)> " --ansi --expect='.join(keys(s:default_action), ','),
          \ 'down':    '40%'
          \ })
  else
    call fzf#run(extend({
          \ 'source':  map(s:mru_list_without_nonexistent(), 'fnamemodify(v:val, ":p")'),
          \ 'sink*': function("s:mru_sink"),
          \ 'options': '-m -x +s --prompt "(MRU)> " --ansi --expect='.join(keys(s:default_action), ','),
          \ }, a:bang ? {} : g:fzf#vim#default_layout ))
  endif
endfunction

command! -bang Mru call s:fzf_mru(<bang>0)

function! s:ag_in(bang, ...)
  let tokens  = a:000
  let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
  let query   = (filter(copy(tokens), 'v:val !~ "^-"'))
  let save_cwd = fnameescape(getcwd())
  let cdCmd = (haslocaldir() ? 'lcd!' : 'cd!')
  " in case path is relative:
  " we want it to be relative to dir of current file, not cwd
  try
    exec cdCmd . fnameescape(expand('%:p:h'))
    let dir = s:full_path(a:1)
  finally
    exec cdCmd . save_cwd
  endtry
  call fzf#vim#ag(join(query[1:], ' '), ag_opts . '--ignore .git/', extend({
        \ 'dir': dir,
        \ 'options': '--prompt "' . dir . ' (Ag)> "'
        \ }, a:bang ? {} : g:fzf#vim#default_layout))
endfunction

function! s:ag_with_opts(arg, bang)
  let tokens  = split(a:arg)
  let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
  let query   = join(filter(copy(tokens), 'v:val !~ "^-"'))
  let dir = s:git_root_or_current_dir()
  call fzf#vim#ag(query, ag_opts . ' --ignore .git/', extend({
        \ 'dir': dir,
        \ 'options': '--prompt "' . dir . ' (Ag)> "'
        \ }, a:bang ? {} : g:fzf#vim#default_layout))
endfunction

command! -nargs=+ -complete=dir -bang AgIn call s:ag_in(<bang>0, <f-args>)
command! -nargs=+ -complete=dir -bang Agin call s:ag_in(<bang>0, <f-args>)

command! -nargs=* -bang AgGitRootOrCurrent call s:ag_with_opts(<q-args>, <bang>0)
command! -nargs=* -bang Ag AgGitRootOrCurrent<bang> <args>

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
  let [key, str] = a:key_with_str
  if tolower(key) == s:yank_key
    call s:yank_to_buffer(a:key_with_str, 0)
  else
    call s:paste_buffer(a:key_with_str, 0)
  endif
endfunction

function! s:registers_sink_visual(key_with_str)
  let [key, str] = a:key_with_str
  if tolower(key) == s:yank_key
    call s:yank_to_buffer(a:key_with_str, 1)
  else
    call s:paste_buffer(a:key_with_str, 1)
  endif
endfunction

command! -nargs=? Regs call fzf#run({
      \ 'source':  s:get_all_registers(),
      \ 'sink*': function('s:registers_sink' . (<args>0 ? '_visual' : '')),
      \ 'options': '-e -x +s --prompt "(Regs)> " --ansi --expect=alt-p,' .  s:yank_key,
      \ 'down':    '40%'
      \ })

nnoremap cof :let g:mru_full_path=!g:mru_full_path<CR>
nnoremap [of :let g:mru_full_path=1<CR>
nnoremap ]of :let g:mru_full_path=0<CR>

nnoremap <C-f> :GitFilesOrCurrent<CR>
nnoremap <C-b> :BuffersBetterPrompt<CR>
nnoremap <C-g> :FilesGitRootOrCurrent<CR>
nnoremap <C-p> :Mru<CR>

" good way of detecting if in visual mode
" a bit experimental mappings
nnoremap RR :Regs<CR>
vnoremap RR :<c-u>Regs 1<CR>
" inoremap RR  <ESC>:<C-u>Regs<CR>i

" --------------- PLUGIN COMMANDS END -------------- }}}



" new stuff, not categorized yet

" default flags files for c-like langs for YCM
autocmd filetype cpp let g:ycm_global_ycm_extra_conf = "/home/garfield/.vim/ycm/cpp/.ycm_extra_conf.py"
autocmd filetype c let g:ycm_global_ycm_extra_conf = "/home/garfield/.vim/ycm/c/.ycm_extra_conf.py"

set nowrap

let g:goyo_width=120
let g:goyo_height='95%'

nmap MM :Goyo<CR>

function! s:goyo_enter()
  silent !tmux set -w status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowmode
  set noshowcmd
  let g:scrolloff_saved=&scrolloff
  set scrolloff=999
  Goyo x95%
endfunction

function! s:goyo_leave()
  silent !tmux set -w status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showmode
  set showcmd
  exec 'set scrolloff=' . g:scrolloff_saved
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

autocmd filetype help nnoremap <nowait> <buffer> q :quit<CR>
" autocmd filetype help nnoremap <buffer>  :quit<CR>

autocmd filetype undotree nmap <nowait> <buffer> q :quit<CR>
autocmd filetype undotree nmap <buffer> <C-j> j
autocmd filetype undotree nmap <buffer> <C-k> k
autocmd filetype undotree nmap <buffer>  :quit<CR>

" autocmd filetype nerdtree nmap <buffer>  :quit<CR>
autocmd filetype nerdtree nmap <buffer> <C-v> s
autocmd filetype nerdtree nmap <buffer> <C-x> i
autocmd filetype nerdtree nmap <buffer> <C-j> j
autocmd filetype nerdtree nmap <buffer> <C-k> k
autocmd filetype nerdtree nmap <buffer> . I

autocmd! filetype unite
autocmd filetype unite nunmap <buffer> <C-h>
autocmd filetype unite nunmap <buffer> <C-k>
autocmd filetype unite imap <buffer> <C-j> <Plug>(unite_loop_cursor_up)
autocmd filetype unite imap <buffer> <C-k> <Plug>(unite_loop_cursor_down)

autocmd! filetype vimfiler
autocmd filetype vimfiler nunmap <buffer> <C-l>
autocmd filetype vimfiler nmap <buffer> <C-k> <Plug>(vimfiler_loop_cursor_up)
autocmd filetype vimfiler nmap <buffer> <C-j> <Plug>(vimfiler_loop_cursor_down)
autocmd filetype vimfiler nmap <buffer> ? <Plug>(vimfiler_help)
autocmd filetype vimfiler nmap <buffer> o <Plug>(vimfiler_expand_or_edit)
autocmd filetype vimfiler nmap <buffer> u <Plug>(vimfiler_switch_to_parent_directory)
autocmd filetype vimfiler nmap <buffer> i <Plug>(vimfiler_cd_input_directory)
autocmd filetype vimfiler nmap <buffer> C <Plug>(vimfiler_cd_file)
autocmd filetype vimfiler nmap <buffer> I <Plug>(vimfiler_toggle_visible_ignore_files)
autocmd filetype vimfiler nmap <buffer> s <Plug>(vimfiler_split_edit_file)
autocmd filetype vimfiler nmap <buffer> <C-v> <Plug>(vimfiler_split_edit_file)

map TT :VimFilerExplorer<CR>
map TC :exec 'VimFilerExplorer ' . substitute(expand('%:p:h'), 'scp', 'ssh', '')<CR>

let g:tmux_navigator_no_mappings = 1

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

" typing in wrong order may be annoying
" map q<leader> :q<CR>

let g:gitgutter_override_sign_column_highlight = 0

hi GitGutterAdd          cterm=bold ctermfg=46  ctermbg=235
hi GitGutterChange       cterm=bold ctermfg=105 ctermbg=235
hi GitGutterDelete       cterm=bold ctermfg=196 ctermbg=235
hi GitGutterChangeDelete cterm=bold ctermfg=126 ctermbg=235

" those are better visible
let g:gitgutter_sign_modified = '#'
let g:gitgutter_sign_removed = 'v'
let g:gitgutter_sign_modified_removed = '#v'

function! s:gitgutter_toggle_wrapper()
  GitGutterToggle
  if gitgutter#utility#is_active()
    echo "GitGutter enabled"
  else
    echo "GitGutter disabled"
  endif
endfunction

command! GitGutterToggleWrapper call s:gitgutter_toggle_wrapper()

nmap <silent> cog :GitGutterToggleWrapper<CR>

highlight ExtraWhitespace ctermbg=137

function! s:toggle_whitespace_wrapper()
  ToggleWhitespace
  if g:better_whitespace_enabled == 1
    echo "BetterWhitespaces enabled"
  else
    echo "BetterWhitespaces disabled"
  endif
endfunction

command! ToggleWhitespaceWrapper call s:toggle_whitespace_wrapper()

nmap <silent> co<space> :ToggleWhitespaceWrapper<CR>
nmap <space>st :StripWhitespace<CR>

map <leader>D :Bdelete<CR>

autocmd filetype gitcommit nnoremap <nowait> <buffer> ? :help fugitive-:Gstatus<CR>

