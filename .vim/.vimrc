" ---------- PLUGINS -------------- {{{

set nocompatible
filetype off

set rtp+=~/.vim/vim-plug
let path='~/.vim/plugged'

call plug#begin(path)

Plug 'gmarik/Vundle.vim'
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
  if empty($__NO_CLANG_COMPL__)
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
  else
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
  endif
endif
Plug 'tpope/vim-fugitive'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'lazyAsGarfield/delimitMate'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree'
Plug 'junegunn/fzf', { 'dir': '`realpath ~/.vim`/../.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'flazz/vim-colorschemes'

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
" let &colorcolumn="80,".join(range(120,999),",")
let &colorcolumn="80,120"
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

" YCM settings
" default flags file for c-like langs for YCM
let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"

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

" insert :q easier
map <leader>q :q<CR>

" save current file
map <leader>w :w<CR>

" disable search highlighting
map <silent> <leader>n :noh<CR>

" easier switch to previous buffer
map <leader>b :b#<CR>

" delete current buffer without closing split
map <leader>D :BD<CR>

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
vnoremap yct :<c-u>YcmCompleter GetType<CR>

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

function! LastUsedBufferOrPrevious(bang) 
  if a:bang
    if CountListedBuffers() == 1 
      bd!
    elseif buflisted(bufname("#")) 
      b # 
      bd! #
    else 
      bp 
      bd! #
    endif 
  elseif getbufvar(bufname("%"), "&mod")
    echoerr "Unsaved changes (add ! to override)"
  else
    if CountListedBuffers() == 1 
      bd
    elseif buflisted(bufname("#")) 
      b # 
      bd #
    else 
      bp 
      bd #
    endif 
  endif
endfunction 

command! -bang BD call LastUsedBufferOrPrevious(<bang>0) 

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
  let git_root = join(split(fugitive#extract_git_dir(expand('%:p:h')), '/')[:-2], '/')
  if git_root == ''
    let path = expand('%:p:h')
    return fzf#vim#files(path, extend({
          \ 'source': 'ag -g "" --hidden -U --ignore .git/',
          \ 'options': '--prompt "' . path . ' (Files)>"'
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
  let git_root = join(split(fugitive#extract_git_dir(expand('%:p:h')), '/')[:-2], '/')
  return git_root == '' ? expand('%:p:h') : '/'.git_root
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
" (similar to CtrlP plugin)
function! s:relpath(filepath_or_name)
  let fullpath = fnamemodify(a:filepath_or_name, ':p')
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
  call filter(mru_list, 'findfile(v:val, cwd) == v:val')
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

