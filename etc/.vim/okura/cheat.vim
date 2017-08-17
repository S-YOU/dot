if &cp || exists("g:loaded_cheat")
 finish
endif
let g:loaded_cheat = 1

" ~/svn/cheat/の中のチートシートをすぐに開けるようにする

command! -nargs=* Cheat call _Cheat(<f-args>)
command! -nargs=* Ct    call _Cheat(<f-args>)

function! _Cheat(...)
  let type = &ft
  let cheat_top_dir = expand("~/svn/cheat/")
  if a:0 >= 1
    let type = a:1
  endif

  if type == ""
    e ~/svn/cheat
    return
  endif

  let dir = cheat_top_dir . type . "/"
  let cheat_path = dir . type . ".md"
  if !isdirectory(dir)
    call mkdir(dir, "p")
  endif
  exe "e" cheat_path
endfunction
