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
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
Plug 'tpope/vim-fugitive'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'Raimondi/delimitMate'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree'
Plug 'junegunn/fzf', { 'dir': '`realpath ~/.vim`/../.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

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
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
  execute "set <xHome>=\e[1;*H"
  execute "set <xEnd>=\e[1;*F"
  execute "set <Insert>=\e[2;*~"
  execute "set <Delete>=\e[3;*~"
  execute "set <PageUp>=\e[5;*~"
  execute "set <PageDown>=\e[6;*~"
  execute "set <xF1>=\e[1;*P"
  execute "set <xF2>=\e[1;*Q"
  execute "set <xF3>=\e[1;*R"
  execute "set <xF4>=\e[1;*S"
  execute "set <F5>=\e[15;*~"
  execute "set <F6>=\e[17;*~"
  execute "set <F7>=\e[18;*~"
  execute "set <F8>=\e[19;*~"
  execute "set <F9>=\e[20;*~"
  execute "set <F10>=\e[21;*~"
  execute "set <F11>=\e[23;*~"
  execute "set <F12>=\e[24;*~"
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

nmap cry "0
vmap cry "0
nmap crc "+
vmap crc "+

" easier yank/paste from clipboard 
nmap cy "+y
vmap cy "+y
nmap cY "+Y
vmap cY "+Y

nmap cp "+p
vmap cp "+p
nmap cP "+P
vmap cP "+P

vmap <leader>0 "0p
nmap yp "0p
nmap yP "0P

" easier redrawing - sometimes strange artifacts are visible
map <leader>r :redraw!<CR>

" substitute all occurences of text selected in visual mode 
vnoremap <C-r><C-r> "hy:%s/<C-r>h//g<left><left>
vnoremap <C-r><C-e> "hy:%s/\<<C-r>h\>//g<left><left>

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

" foldenable + foldcolumn
silent! set nofoldenable
silent! set foldcolumn=0

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

" --------------- VIM MAPPINGS END -------------- }}}

" ---------- PLUGIN MAPPINGS ------ {{{

" YCM mappings
nnoremap ygt :YcmCompleter GoTo<CR>
nnoremap yc :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>fi :YcmCompleter FixIt<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
vnoremap <leader>gt :<BS><BS><BS><BS><BS>YcmCompleter GetType<CR>

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
" nmap <C-f> :Files<CR>
nmap <C-b> :Buffers<CR>

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

function! s:git_root_or_current_dir()
  let git_root = join(split(fugitive#extract_git_dir(expand('%:p:h')), '/')[:-2], '/')
  return git_root == '' ? expand('%:p:h') : fnameescape('/'.git_root)
endfunction

command! -bang FilesGitRootOrCurrent call
\ fzf#vim#files(s:git_root_or_current_dir(), <bang>0 ? {} : g:fzf#vim#default_layout)

nnoremap <C-f> :FilesGitRootOrCurrent<CR>

function! s:ag_in(bang, ...)
  let tokens  = a:000
  let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
  let query   = (filter(copy(tokens), 'v:val !~ "^-"'))
  call fzf#vim#ag(join(query[1:], ' '), ag_opts, extend({'dir': a:1}, a:bang ? {} : g:fzf#vim#default_layout))
endfunction

command! -nargs=+ -complete=dir -bang AgIn call s:ag_in(<bang>0, <f-args>)
command! -nargs=+ -complete=dir -bang Agin call s:ag_in(<bang>0, <f-args>)

function! s:ag_with_opts(arg, bang)
  let tokens  = split(a:arg)
  let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
  let query   = join(filter(copy(tokens), 'v:val !~ "^-"'))
  call fzf#vim#ag(query, ag_opts, a:bang ? {} : g:fzf#vim#default_layout)
endfunction

command! -nargs=* -bang Ag call s:ag_with_opts(<q-args>, <bang>0)

" expands path relatively to current dir or git root if possible
" (similar to CtrlP plugin)
function! s:realpath(filepath_or_name)
  let fullpath = fnamemodify(a:filepath_or_name, ':p')
  let cwd = getcwd()
  execute 'cd' . s:git_root_or_current_dir()
  let ret = fnamemodify(fullpath, ':.')
  execute 'cd' . fnameescape(cwd)
  return ret
endfunction

command! Mru call fzf#run({
\  'source':  map(ctrlp#mrufiles#list()[1:], 's:realpath(v:val)'),
\  'sink':    'e',
\  'options': '-x +s',
\  'down':    '40%'})

nnoremap <C-p> :Mru<CR>

" --------------- PLUGIN COMMANDS END -------------- }}}

