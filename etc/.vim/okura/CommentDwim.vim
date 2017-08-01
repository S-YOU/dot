" Emacs comment-dwim like commenging plugin
"

nnoremap <Esc>; :call <SID>CommentDwim()<CR>
inoremap <Esc>; <Esc>:call <SID>CommentDwim()<CR>

function! CommentDwim_SetCol(n)
  let col =(a:n / 4) * 4
  let b:CommentDwim_col = col
  let g:CommentDwim_col = col
endfunction

function! s:CommentDwim()
  if exists("b:CommentDwim_col")
    let col = b:CommentDwim_col
  elseif exists("g:CommentDwim_col")
    let col = g:CommentDwim_col
  else
    let col = 48
  endif
  let col = (col / 4) * 4

  if exists("b:commentSymbol")
    let symbol = b:commentSymbol
    let endSymbol = ""
  elseif &ft ==? "c" || &ft ==? "cpp" || &ft ==? "java" || &ft ==? "php"
    let symbol = "/*"
    let endSymbol = " */"
  elseif &ft ==? "lisp" || &ft ==? "scheme"
    let symbol = ";"
    let endSymbol = ""
  else
    let symbol = "#"
    let endSymbol = ""
  endif

  let line = getline(".")
  " blank line
  if line =~ '^\s*$'
    exe "normal! a".symbol."\<space>".endSymbol
    normal! ==$
    if endSymbol != ""
      exe "normal! ".(strlen(endSymbol)-1)."h"
      startinsert
    else
      startinsert!
    endif
    return
  endif

  let sts_save = &sts
  let &sts = &ts
  let idx = stridx(line, symbol)
  if idx < 0
    exe "normal! A\<tab>".symbol."\<space>".endSymbol
  endif
  let line = getline(".")
  let idx = stridx(line, symbol)
  if idx - 1 > 0
    exe "normal! 0".(idx-1)."l"
  elseif idx == 0
    exe "normal! 0i\<tab>"
  else
    normal! 0
  endif

  if virtcol(".") < col
    while virtcol(".") < col
      exe "normal! a\<tab>"
    endwhile
  else
    while virtcol(".") > col && strpart(getline("."), col(".")-2, 1) =~ '\s'
      normal! xh
    endwhile
  endif

  let &sts = sts_save

  if endSymbol == ""
    startinsert!
  else
    exe "normal! ".(strlen(symbol)+2)."l"
    startinsert
  endif
endfunction
