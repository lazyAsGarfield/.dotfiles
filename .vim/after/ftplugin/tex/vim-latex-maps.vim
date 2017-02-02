" Adapted from: github.com/vim-latex/vim-latex

if exists('s:doneOnce')
	finish
endif
let s:doneOnce = 1

let s:Tex_Leader = '`'

let s:RemoveLastHistoryItem = ':call histdel("/", -1)|let @/=s:Tex_LastSearchPattern'

function! VEnclose(vstart, vend, VStart, VEnd)
	" its characterwise if
	" 1. characterwise selection and valid values for vstart and vend.
	" OR
	" 2. linewise selection and invalid values for VStart and VEnd
	if (visualmode() ==# 'v' && (a:vstart != '' || a:vend != '')) || (a:VStart == '' && a:VEnd == '')

		let newline = ""
		let _r = @r

		let normcmd = "normal! \<C-\>\<C-n>`<v`>\"_s"

		exe "normal! \<C-\>\<C-n>`<v`>\"ry"
		if @r =~ "\n$"
			let newline = "\n"
			let @r = substitute(@r, "\n$", '', '')
		endif

		" In exclusive selection, we need to select an extra character.
		if &selection == 'exclusive'
			let movement = 8
		else
			let movement = 7
		endif
		let normcmd = normcmd.
					\ a:vstart."!!mark!!".a:vend.newline.
					\ "\<C-\>\<C-N>?!!mark!!\<CR>v".movement."l\"_s\<C-r>r\<C-\>\<C-n>"

		" this little if statement is because till very recently, vim used to
		" report col("'>") > length of selected line when `> is $. on some
		" systems it reports a -ve number.
		if col("'>") < 0 || col("'>") > strlen(getline("'>"))
			let lastcol = strlen(getline("'>"))
		else
			let lastcol = col("'>")
		endif
		if lastcol - col("'<") != 0
			let len = lastcol - col("'<")
		else
			let len = ''
		endif

		" the next normal! is for restoring the marks.
		let normcmd = normcmd."`<v".len."l\<C-\>\<C-N>"

		" First remember what the search pattern was. s:RemoveLastHistoryItem
		" will reset @/ to this pattern so we do not create new highlighting.
		let s:Tex_LastSearchPattern = @/

		silent! exe normcmd
		" this is to restore the r register.
		call setreg("r", _r, "c")
		" and finally, this is to restore the search history.
		execute s:RemoveLastHistoryItem

	else

		exec 'normal! `<O'.a:VStart."\<C-\>\<C-n>"
		exec 'normal! `>o'.a:VEnd."\<C-\>\<C-n>"
		if &indentexpr != ''
			silent! normal! `<kV`>j=
		endif
		silent! normal! `>
	endif
endfunction

function! <SID>Tex_FontFamily(font,fam)
	let vislhs = matchstr(tolower(a:font), '^.\zs.*')
	exe "vnoremap <silent> ".s:Tex_Leader.vislhs.
				\" \<C-\\>\<C-N>:call VEnclose('\\text".vislhs."{', '}', '{\\".vislhs.a:fam."', '}')<CR>"
endfunction

call <SID>Tex_FontFamily("FBF","series")
call <SID>Tex_FontFamily("FMD","series")

call <SID>Tex_FontFamily("FTT","family")
call <SID>Tex_FontFamily("FSF","family")
call <SID>Tex_FontFamily("FRM","family")

call <SID>Tex_FontFamily("FUP","shape")
call <SID>Tex_FontFamily("FSL","shape")
call <SID>Tex_FontFamily("FSC","shape")
call <SID>Tex_FontFamily("FIT","shape")

" the \emph is special.
exe "vnoremap <silent> ".s:Tex_Leader."em \<C-\\>\<C-N>:call VEnclose('\\emph{', '}', '{\\em', '\\/}')<CR>"
