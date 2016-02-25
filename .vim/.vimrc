" --------------- VUNDLE --------------- {{{
set nocompatible
filetype off

" check if Vundle exists
if isdirectory($HOME . '/.vim/bundle/')

  set rtp+=~/.vim/bundle/Vundle.vim
  let path='~/.vim/bundle'

  call vundle#begin(path)

  Plugin 'gmarik/Vundle.vim'
  Plugin 'tpope/vim-surround'
  Plugin 'scrooloose/nerdtree'
  Plugin 'tpope/vim-commentary' 
  Plugin 'kien/ctrlp.vim'
  Plugin 'bling/vim-airline'
  Plugin 'hynek/vim-python-pep8-indent'
  Plugin 'rking/ag.vim'
  Plugin 'easymotion/vim-easymotion'
  Plugin 'davidhalter/jedi-vim'
  Plugin 'tpope/vim-unimpaired'
  Plugin 'Valloric/YouCompleteMe'
  Plugin 'tpope/vim-fugitive'
  Plugin 'octol/vim-cpp-enhanced-highlight'
  Plugin 'Raimondi/delimitMate'
  Plugin 'junegunn/vim-easy-align'

  call vundle#end()

endif

filetype plugin indent on
                                 
" --------------- VUNDLE END --------------- }}}

" --------------- MISC ----------------- {{{
set nocompatible

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

" autochange directory to the one opened file is in
" set autochdir

" default encoding
set encoding=utf-8

" split settings
set splitbelow
set splitright

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" show the cursor position all the time
set ruler

" highlight cursor column/line - now done with 'cox' from vim-unimpaired
" set cursorcolumn
" set cursorline

" display incomplete commands
set showcmd

" do incremental searching
set incsearch

" set search highlighting, bo do not highlight now 
set hlsearch
noh

" line endings
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

" CtrlP plugin 
" let g:ctrlp_working_path_mode = 0 

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

" disable completions from jedi-vim, using YCM instead
let g:jedi#completions_enabled = 0

" disable youcompleteme
" let g:loaded_youcompleteme = 1

" delimitMate opts
let delimitMate_expand_cr=2
let delimitMate_expand_space=1
let delimitMate_balance_matchpairs=1
let delimitMate_matchpairs = "(:),[:],{:},<:>"
let delimitMate_smart_matchpairs = '^\%(\w\|[£$]\|[^[:space:][:punct:]]\)'

"}}}

" --------------- MAPPINGS ------------- {{{

" change leader key 
let mapleader=","

" open/close quickfix/location-list window
noremap \Q :copen<CR>
noremap \q :cclose<CR>
noremap \L :lopen<CR>
noremap \l :lclose<CR>
" close preview window
noremap \p <C-w>z

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

" scroll by whole pages
map <a-u> <PageUp>
map <a-d> <PageDown>

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

" NERDTree plugin 
" if exists('g:loaded_nerd_tree')

  function! NERDTreeEnableOrToggle() 
    try 
      NERDTreeToggle 
    catch 
      silent! NERDTree 
    endtry 
  endfunction 

  map <C-n> :call NERDTreeEnableOrToggle()<CR> 
  map <leader><leader>n :NERDTreeFind<CR> 

" endif

" CtrlP plugin
" if exists('g:loaded_ctrlp')

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

" endif

" Easymotion mappings
nmap <leader><leader>t <Plug>(easymotion-t2)
nmap <leader><leader>f <Plug>(easymotion-f2)
nmap <leader><leader>T <Plug>(easymotion-T2)
nmap <leader><leader>F <Plug>(easymotion-F2)

nmap <leader>t <Plug>(easymotion-t)
nmap <leader>f <Plug>(easymotion-f)
nmap <leader>T <Plug>(easymotion-T)
nmap <leader>F <Plug>(easymotion-F)

" --------------- MAPPINGS END -------------- }}}

" --------------- COMMANDS ------------ {{{

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

" --------------- COMMANDS END -------------- }}}

