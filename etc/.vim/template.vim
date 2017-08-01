if exists("g:loaded_<?vim expand('%:t:r') ?>") || &cp
  finish
endif
let g:loaded_<?vim expand('%:t:r') ?> = 1

function! <?vim expand('%:t:r') ?>#FunctionName() abort
endfunction
