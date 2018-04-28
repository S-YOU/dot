" URLのクエリーパラメータの名前と値をハイライトする
syn region  zshString           matchgroup=zshStringDelimiter start=+"+ end=+"+
                                \ contains=zshQuoted,@zshDerefs,@zshSubst,queryParamName,queryParamValue fold
syn region  zshString           matchgroup=zshStringDelimiter start=+'+ end=+'+ contains=queryParamName,queryParamValue fold

syn match   queryParamName           '\w\+=\@=' contained
syn match   queryParamValue          '=\@<=[^&"\']\+' contained

hi queryParamName ctermfg=4 cterm=bold
hi queryParamValue ctermfg=5 cterm=bold

" zshから<C-x><C-e>で起動されたかどうか判定
if expand("%:p") =~ '/tmp/\w\+'
  setlocal wrap
  setlocal nonumber
endif
setlocal synmaxcol=0
