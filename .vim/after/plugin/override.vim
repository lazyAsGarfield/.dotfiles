command! -nargs=* -bang Ag AgGitRootOrCwd<bang> <args>
command! -bang -nargs=? -complete=dir Files FilesBetterPrompt<bang> <args>
silent! nunmap cgc
