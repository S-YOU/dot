nnoremap <silent><C-a> :cal SmartHome("n")<CR>
nnoremap <silent><C-e> :cal SmartEnd("n")<CR>
vnoremap <silent><C-a> <Esc>:cal SmartHome("v")<CR>
vnoremap <silent><C-e> <Esc>:cal SmartEnd("v")<CR>

"vnoremap <silent><C-e> <Esc>:cal SmartEnd("v")<CR>
"smart home function
function! SmartHome(mode)
  let curcol = col(".")

  if &wrap
    normal! g^
  else
    normal! ^
  endif
  if col(".") == curcol
    if &wrap
      normal! g0
    else
      normal! 0
    endif
  endif

  if a:mode == "v"
    normal msgv`s
  endif

  return ""
endfunction

"smart end function
function! SmartEnd(mode)
  let curcol = col(".")
  let lastcol = a:mode == "i" ? col("$") : col("$") - 1

  "gravitate towards ending for wrapped lines
  if curcol < lastcol - 1
    call cursor(0, curcol + 1)
  endif

  if curcol < lastcol
    if &wrap
      normal g$
    else
      normal $
    endif
  else
    normal g_
  endif

  "correct edit mode cursor position, put after current character
  if a:mode == "i"
    call cursor(0, col(".") + 1)
  endif

  if a:mode == "v"
    normal msgv`s
  endif

  return ""
endfunction 
