nnoremap K :<C-u>call _KeywordProgInNewWindow(expand("<cword>"))<CR>
xnoremap K "zy:<C-u>call _KeywordProgInNewWindow(@z)<CR>

function! _KeywordProgInNewWindow(word)
  let word = a:word
  let command = &keywordprg
  if strpart(command, 0, 1) == ":"
    normal! K
    return
  endif
  Scratch
  normal! G
  exe "r!" . command . " '" . word . "'"
  normal! `[0zt
endfunction
