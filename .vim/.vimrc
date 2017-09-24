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
    autocmd FileType nerdtree nmap <buffer> <C-v> s
    autocmd FileType nerdtree nmap <buffer> <C-x> i
    autocmd FileType nerdtree nmap <buffer> . I
    autocmd FileType nerdtree nmap <buffer> <leader><tab> q
  augroup END

  function! NERDTreeEnableOrToggle()
    try
      NERDTreeToggle
    catch
      silent! NERDTree
    endtry
  endfunction

  function! NERDTreeNewOrReuse()
    if exists('t:netrwNERDTree')
      let nr = bufnr('%')
      exec "b " . t:netrwNERDTree
      let b:NERDTree._previousBuf = nr
    else
      e .
      let t:netrwNERDTree = bufname('%')
    endif
  endfunction

  map <C-n> :<C-r>=expand('%') =~ 'NERD_tree' ? 'normal q' : 'call NERDTreeNewOrReuse()'<CR><CR>

  function! NERDTreeFindCurrentBuffer()
    let path = expand("%:p")
    call NERDTreeNewOrReuse()
    let p = g:NERDTreePath.New(path)
    if !p.isUnder(b:NERDTree.root.path)
      call b:NERDTree.changeRoot(g:NERDTreeDirNode.New(p.getParent(), b:NERDTree))
    endif
    let node = b:NERDTree.root.reveal(p)
    call b:NERDTree.render()
    call node.putCursorHere(1,0)
  endfunction

  nmap n :<C-r>=expand('%') =~ 'NERD_tree' ? 'normal q' : 'call NERDTreeFindCurrentBuffer()'<CR><CR>

endif

" }}}

" ---------- undotree ---------- {{{

if v:version >= 703

  Plug 'mbbill/undotree'

  let g:undotree_SetFocusWhenToggle = 1

  nnoremap u :UndotreeToggle<CR>

endif

" }}}

" -------- vim-easymotion ------ {{{

if v:version >= 703
  Plug 'easymotion/vim-easymotion'

  if version >= 703
    nmap <leader>f <Plug>(easymotion-s2)

    let g:EasyMotion_off_screen_search = 0
    let g:EasyMotion_inc_highlight = 1
    let g:EasyMotion_history_highlight = 0
  endif
endif

" }}}

" ------------- YCM ------------ {{{

if v:version >= 703
  if !empty($__VIM_YCM__)

    if !empty($__VIM_COMPL__)
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

  endif
endif

" }}}

" ------------ python ---------- {{{

Plug 'hynek/vim-python-pep8-indent'

if v:version >= 703

  if !empty($__VIM_YCM__)
    Plug 'davidhalter/jedi-vim'
  endif

  " disable completions from jedi-vim, using YCM instead
  let g:jedi#completions_enabled = 0

  " two below fix showing argument list when using YCM
  let g:jedi#show_call_signatures_delay = 0
  let g:jedi#show_call_signatures = "0"

  let g:jedi#goto_command = "yjg"
  let g:jedi#documentation_command = "K"
  let g:jedi#usages_command = "yju"

  let g:jedi#goto_assignments_command = ""
  let g:jedi#completions_command = ""
  let g:jedi#rename_command = ""


  autocmd FileType python nmap <buffer> <C-]> g<C-]>
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
    " if fnamemodify() applied once, full_path may look like /blah/../ when a:dir_or_file is '..'
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

  function! s:git_root_or_cwd()
    return exists('b:git_dir') ? fugitive#repo().tree() : getcwd()
  endfunction

  function! s:all_files_git_root_or_cwd()
    let path = s:git_root_or_cwd()
    call fzf#vim#files(path, {
          \ 'source': 'ag -g "" --hidden -U --ignore .git/',
          \ 'options': '--preview "cat {}" --prompt "' . path . ' (Files)> "'
          \ })
  endfunction

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

  command! GitFilesOrCwd call s:git_files_if_in_repo()

  command! FilesGitRootOrCwd call s:all_files_git_root_or_cwd()

  command! Mru call s:fzf_mru()

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
  nnoremap <leader>a :FilesGitRootOrCwd<CR>

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

nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk

cnoreabbrev GG GitGutter

if !exists('g:vimrc_init')
  augroup my_enter
    autocmd VimEnter * GitGutterSignsDisable
    autocmd VimEnter * au! my_enter
  augroup END
endif


" }}}

" ------- better-whitespace ---- {{{

Plug 'ntpeters/vim-better-whitespace'

" }}}

" --------- colors/themes ------ {{{

Plug 'sjl/badwolf'
Plug 'w0ng/vim-hybrid'

Plug 'octol/vim-cpp-enhanced-highlight'

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'

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
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-commentary'

nnoremap <F8> :Make<CR>
nnoremap <C-F8> :Make!<CR>
nnoremap <F9> :Dispatch<CR>
nnoremap <C-F9> :Dispatch!<CR>
nnoremap <F10> :Start<CR>
nnoremap <C-F10> :Start!<CR>

autocmd FileType c,cpp setlocal commentstring=//\ %s

" }}}

" ---------- easy-align -------- {{{

Plug 'junegunn/vim-easy-align'

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

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

if !empty($__VIM_LATEX__)

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

endif

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

if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && version >= 700
  let &listchars = "tab:>\ ,trail:\u2022"
else
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<
endif
set list

set wildmenu
set wildmode=longest:full,full

" some options have to be set only at init
if !exists("g:vimrc_init")
  let g:vimrc_init = 1

  set background=dark
  " silent! colorscheme hybrid
  silent! colorscheme jellybeans

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
  silent! let &colorcolumn="120"

  " indentation options
  set autoindent
  set expandtab
  set shiftwidth=2
  set softtabstop=2
  set tabstop=2
  set smarttab

  " line numbers
  set nonumber
  silent! set norelativenumber

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
  set sidescrolloff=5
  set sidescroll=1

  set foldcolumn=0

  set nowrap
endif " exists("g:vimrc_init")

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

highlight ExtraWhitespace ctermbg=137 guibg=#cc4411

" hi! VertSplit guibg=#252525
" hi! MatchParen guifg=#5F5F87 guibg=#1d1f21
hi! clear TabLine
hi! clear TabLineFill
hi! TabLine guifg=#d5d8d6 guibg=#3c3c3c
hi! TabLineFill guifg=#d5d8d6 guibg=#3c3c3c

au BufReadPost,BufNewFile ~/.vimrc* set tw=0

" --------------- VIM OPTS END ------------- }}}

" ---------- VIM MAPPINGS --------- {{{

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

cabbrev Q q
cabbrev WQ wq
cabbrev Wq wq
cabbrev W w

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

nmap <leader><tab> :b#<CR>

" save current file
map <leader>w :w<CR>

" quickly edit/reload the vimrc file
nmap <silent> <leader>v :<C-R>=(expand('%:p')==$MYVIMRC)? 'so' : 'e'<CR> $MYVIMRC<CR>

" resizing splits more easily
nmap _ :exe "vertical resize " . ((winwidth(0) + 1) * 3/2)<CR>
nmap - :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
nmap _ :exe "resize " . ((winheight(0) + 1) * 3/2)<CR>
nmap - :exe "resize " . (winheight(0) * 2/3)<CR>

nmap cy "+y
vmap cy "+y
nmap cY "+Y
vmap cY "+Y

nmap cp "+p
vmap cp "+p
nmap cP "+P
vmap cP "+P

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

autocmd FileType help nnoremap <nowait> <buffer> q :quit<CR>

nnoremap cop :set <C-R>=&paste ? 'nopaste' : 'paste'<CR><CR>

nmap 0p "0p
vmap 0p "0p
nmap 0P "0P
vmap 0P "0P
nmap <silent> <leader>t :checktime<CR>

" refresh <nowait> ESC mappings
runtime after/plugin/ESCNoWaitMappings.vim

inoremap jj <esc>

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

function! SourceRange() range
  let tmpsofile = tempname()
  call writefile(getline(a:firstline, a:lastline), l:tmpsofile)
  execute "source " . l:tmpsofile
  call delete(l:tmpsofile)
endfunction
command! -range Source <line1>,<line2>call SourceRange()

cnoremap <C-p> <up>
cnoremap <C-n> <down>

cnoremap <C-a> <C-b>
cnoremap b <C-Left>
cnoremap f <C-Right>

" --------------- VIM MAPPINGS END -------------- }}}

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
