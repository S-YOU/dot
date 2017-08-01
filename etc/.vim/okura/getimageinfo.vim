
nnoremap <C-y>i :<C-u>call _InsertImageInfo()<CR>

function! _InsertImageInfo()
  let img_info = _GetImageInfo(expand("<cfile>"))
  let @z = printf(' width="%d" height="%d"', img_info[0], img_info[1])
  normal! f"l"zP
endfunction

function! _GetImageInfo(fn)
  if executable('identify')
    let fn = a:fn
    let img_info = system('identify -format "%wx%h" "'.a:fn.'"')
    let img_size = split(substitute(img_info, '\n', '', ''), 'x')
    if len(img_size) != 2
      return [-1, -1]
    endif
    return img_size
  else
      return [-1, -1]
  endif
endfunction

