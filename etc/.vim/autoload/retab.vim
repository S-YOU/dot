if exists("g:loaded_retab") || &cp
  finish
endif
let g:loaded_retab = 1

function! retab#Retab(from, to) range abort
  execute "setlocal ts=" . a:from . " sts=" . a:from . " noet"
  execute a:firstline . "," . a:lastline . "retab!"
  execute "setlocal ts=" . a:to . " sts=" . a:to . " et"
  execute a:firstline . "," . a:lastline . "retab"
endfunction
