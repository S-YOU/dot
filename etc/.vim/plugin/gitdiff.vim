" HEADとのdiffを表示するプラグイン

if exists("g:loaded_gitdiff") || &cp
  finish
endif
let g:loaded_gitdiff = 1

function! gitdiff#GitDiff() abort
  let dir = expand("%:p:h")
  let path = substitute(expand("%"), '.*/', '', '')
  let cmd = printf("git show HEAD:./%s", path)
  vnew
  set buftype=nofile
  exe "cd " . dir
  exe "silent r!" . cmd
  1d
  diffthis
  wincmd W
  diffthis
endfunction

command! GitDiff call gitdiff#GitDiff()
