if exists("g:loaded_mygf") || &cp
  finish
endif
let g:loaded_mygf = 1

" /から始まるパスに対応したgf
function! mygf#MyGF(cf) abort
  if a:cf == ""
    let cfile = expand("<cfile>")
  else
    let cfile = a:cf
  endif

  try
    exe "find!" cfile
  catch /E345/
    let dirs = _GetAllDirectoriesToRoot()
    " Rails対応
    for d in dirs
      " appディレクトリがあったら、publicも検索パスに加える
      if d =~ "app$"
        call add(dirs, d . "/../public")
      endif
    endfor
    for d in dirs
      let path = d . "/" . cfile
      if filereadable(path)
        try
          exe "e" path
        catch
        endtry
        return
      endif
    endfor
    " 見つからなかったらCtrlPを使う
    if exists("g:ctrlp_default_input")
      let old = g:ctrlp_default_input
    else
      let old = ""
    endif
    let g:ctrlp_default_input = substitute(cfile, '.*/', '', '') 
    CtrlP
    let g:ctrlp_default_input = old
  endtry
endfunction
