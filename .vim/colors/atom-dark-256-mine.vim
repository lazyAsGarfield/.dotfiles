
hi clear
if exists("syntax_on")
syntax reset
endif

set t_Co=256
let g:colors_name = expand("<sfile>:t:r")


hi Normal         cterm=NONE      ctermfg=231 ctermbg=234  gui=NONE      guifg=#F8F8F2 guibg=#1D1F21
hi Boolean        cterm=NONE      ctermfg=114              gui=NONE      guifg=#99CC99              
hi Character      cterm=NONE      ctermfg=155              gui=NONE      guifg=#A8FF60              
hi Number         cterm=NONE      ctermfg=114              gui=NONE      guifg=#99CC99              
hi String         cterm=NONE      ctermfg=155              gui=NONE      guifg=#A8FF60              
hi Conditional    cterm=NONE      ctermfg=117              gui=NONE      guifg=#92C5F7              
hi Constant       cterm=NONE      ctermfg=114              gui=NONE      guifg=#99CC99              
hi Cursor         cterm=NONE      ctermfg=255 ctermbg=243  gui=NONE      guifg=#F1F1F1 guibg=#777777
hi iCursor        cterm=NONE      ctermfg=255 ctermbg=243  gui=NONE      guifg=#F1F1F1 guibg=#777777
hi Debug          cterm=NONE      ctermfg=145              gui=NONE      guifg=#BCA3A3              
hi Define         cterm=NONE      ctermfg=81               gui=NONE      guifg=#66D9EF              
hi Delimiter      cterm=NONE      ctermfg=245              gui=NONE      guifg=#8F8F8F              
hi DiffAdd        cterm=NONE                  ctermbg=23   gui=NONE                    guibg=#13354A
hi DiffChange     cterm=NONE      ctermfg=243 ctermbg=237  gui=NONE      guifg=#69605D guibg=#4C4745
hi DiffDelete     cterm=NONE      ctermfg=89  ctermbg=16   gui=NONE      guifg=#960050 guibg=#1E0010
hi DiffText       cterm=NONE      ctermfg=254 ctermbg=237  gui=NONE      guifg=#F9F0F3 guibg=#4C4745
hi Directory      cterm=NONE      ctermfg=248              gui=NONE      guifg=#AAAAAA              
hi Error          cterm=NONE      ctermfg=16  ctermbg=124  gui=NONE      guifg=#A8FF60 guibg=#1E0010
hi ErrorMsg       cterm=NONE      ctermfg=117 ctermbg=235  gui=NONE      guifg=#92C5F7 guibg=#232526
hi Exception      cterm=NONE      ctermfg=186              gui=NONE      guifg=#DAD085              
hi Float          cterm=NONE      ctermfg=114              gui=NONE      guifg=#99CC99              
hi FoldColumn     cterm=NONE      ctermfg=59  ctermbg=16   gui=NONE      guifg=#566569 guibg=#181B1E
hi Folded         cterm=NONE      ctermfg=59  ctermbg=16   gui=NONE      guifg=#465457 guibg=#000000
hi Function       cterm=NONE      ctermfg=186              gui=NONE      guifg=#DAD085              
hi Identifier     cterm=NONE      ctermfg=146              gui=NONE      guifg=#B6B7EB              
hi Ignore         cterm=NONE      ctermfg=244 ctermbg=234  gui=NONE      guifg=#808080              
hi IncSearch      cterm=NONE      ctermfg=16  ctermbg=180  gui=NONE      guifg=#C4BE89 guibg=#000000
hi Keyword        cterm=NONE      ctermfg=117              gui=NONE      guifg=#92C5F7              
hi Label          cterm=NONE      ctermfg=155              gui=NONE      guifg=#A8FF60              
hi Macro          cterm=NONE      ctermfg=180              gui=NONE      guifg=#C4BE89              
hi SpecialKey     cterm=NONE      ctermfg=59               gui=NONE      guifg=#465457              
hi MatchParen     cterm=bold      ctermfg=145 ctermbg=238  gui=bold      guifg=#B7B9B8 guibg=#444444
hi ModeMsg        cterm=bold      ctermfg=155              gui=bold      guifg=#A8FF60              
hi MoreMsg        cterm=bold      ctermfg=155              gui=bold      guifg=#A8FF60              
hi Operator       cterm=NONE      ctermfg=117              gui=NONE      guifg=#92C5F7              
hi Pmenu          cterm=NONE      ctermfg=81  ctermbg=16   gui=NONE      guifg=#66D9EF guibg=#000000
hi PmenuSel       cterm=NONE      ctermfg=81  ctermbg=239  gui=NONE                    guibg=#808080
hi PmenuSbar      cterm=NONE      ctermfg=81  ctermbg=232  gui=NONE                    guibg=#080808
hi PmenuThumb     cterm=NONE      ctermfg=81  ctermbg=16   gui=NONE      guifg=#66D9EF guibg=Black  
hi PreCondit      cterm=NONE      ctermfg=186              gui=NONE      guifg=#DAD085              
hi PreProc        cterm=NONE      ctermfg=186              gui=NONE      guifg=#DAD085              
hi Question       cterm=bold      ctermfg=81               gui=bold      guifg=#66D9EF              
hi Repeat         cterm=NONE      ctermfg=117              gui=NONE      guifg=#92C5F7              
hi Search         cterm=NONE      ctermfg=16  ctermbg=156  gui=NONE      guifg=#000000 guibg=#B4EC85
hi SignColumn     cterm=NONE      ctermfg=186 ctermbg=235  gui=NONE      guifg=#DAD085 guibg=#232526
hi SpecialChar    cterm=NONE      ctermfg=117              gui=NONE      guifg=#92C5F7              
hi SpecialComment cterm=NONE      ctermfg=244              gui=NONE      guifg=#7C7C7C              
hi Special        cterm=NONE      ctermfg=81  ctermbg=234  gui=NONE      guifg=#66D9EF              
hi Statement      cterm=NONE      ctermfg=117              gui=NONE      guifg=#92C5F7              
hi StatusLine     cterm=NONE      ctermfg=59               gui=NONE      guifg=#455354              
hi StatusLineNC   cterm=reverse   ctermfg=232 ctermbg=244  gui=reverse   guifg=#808080 guibg=#080808
hi StorageClass   cterm=NONE      ctermfg=146              gui=NONE      guifg=#B6B7EB              
hi Structure      cterm=NONE      ctermfg=81               gui=NONE      guifg=#66D9EF              
hi Tag            cterm=NONE      ctermfg=117              gui=NONE      guifg=#92C5F7              
hi Title          cterm=bold      ctermfg=146              gui=bold      guifg=#B6B7EB              
hi Todo           cterm=bold      ctermfg=231 ctermbg=234  gui=italic    guifg=#FFFFFF              
hi Typedef        cterm=NONE      ctermfg=81               gui=NONE      guifg=#66D9EF              
hi Type           cterm=NONE      ctermfg=81               gui=NONE      guifg=#66D9EF              
hi Underlined     cterm=underline ctermfg=244              gui=underline guifg=#808080              
hi VertSplit      cterm=reverse   ctermfg=232 ctermbg=244  gui=reverse   guifg=#808080 guibg=#080808
hi VisualNOS      cterm=NONE                  ctermbg=59   gui=NONE                    guibg=#403D3D
hi Visual         cterm=NONE                  ctermbg=59   gui=NONE                    guibg=#403D3D
hi WarningMsg     cterm=NONE      ctermfg=16  ctermbg=130  gui=NONE      guifg=#FFFFFF guibg=#333333
hi WildMenu       cterm=NONE      ctermfg=81  ctermbg=16   gui=NONE      guifg=#66D9EF guibg=#000000
hi TabLineFill    cterm=reverse   ctermfg=234 ctermbg=234  gui=reverse   guifg=#1D1F21 guibg=#1D1F21
hi TabLine        cterm=underline,bold        ctermbg=238  gui=NONE      guifg=#808080 guibg=#1D1F21
hi TabLineSel     cterm=bold                  ctermbg=235  gui=NONE      guifg=#808080 guibg=#1D1F21
hi Comment        cterm=italic    ctermfg=244              gui=italic    guifg=#7C7C7C              
hi CursorLine     cterm=NONE      ctermfg=253 ctermbg=238  gui=NONE                    guibg=#293739
hi CursorLineNr   cterm=bold      ctermfg=251              gui=bold      guifg=#B6B7BE              
hi CursorColumn   cterm=NONE      ctermfg=253 ctermbg=240  gui=NONE                    guibg=#293739
hi ColorColumn    cterm=NONE                  ctermbg=235  gui=NONE                    guibg=#2A2B2F
hi LineNr         cterm=NONE      ctermfg=243 ctermbg=235  gui=NONE      guifg=#566467 guibg=#232526
hi NonText        cterm=bold      ctermfg=59               gui=bold      guifg=#465457              
hi SpecialKey     cterm=NONE      ctermfg=59               gui=NONE      guifg=#465457              

" YCM colors
hi YcmErrorSign      cterm=NONE     ctermfg=166 ctermbg=235
hi YcmWarningSign    cterm=NONE     ctermfg=229 ctermbg=235
hi YcmErrorLine      cterm=NONE                 ctermbg=52
hi YcmWarningLine    cterm=NONE                   
hi YcmErrorSection   cterm=NONE                 ctermbg=100 
hi YcmWarningSection cterm=NONE                 ctermbg=58 

if has("spell")
    hi SpellBad   cterm=undercurl               ctermbg=88 gui=undercurl                   guisp=#FF0000
    hi SpellCap   cterm=undercurl               ctermbg=88 gui=undercurl                   guisp=#7070F0
    hi SpellLocal cterm=undercurl ctermfg=87               gui=undercurl                   guisp=#70F0F0
    hi SpellRare  cterm=undercurl ctermfg=231              gui=undercurl                   guisp=#FFFFFF
endif

" Must be at the end, because of ctermbg=234 bug.
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark
