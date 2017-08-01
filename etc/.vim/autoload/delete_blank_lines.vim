if exists("g:loaded_delete_blank_lines") || &cp
  finish
endif
let g:loaded_delete_blank_lines = 1

function! delete_blank_lines#DeleteBlankLines() abort
  if search('\S','bW')
    let b = line('.') + 1
  else
    let b = 1
  endif
  if search('^\s*\n.*\S', 'eW')
    let e = line('.') - 1
  else
    let e = line('$')
  endif
  if b == e
    exe b . "d"
  else
    exe (b+1) . "," . e  . "d"
    exe b
  endif
endfunction
