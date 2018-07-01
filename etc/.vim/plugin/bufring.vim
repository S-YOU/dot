if &cp || exists("g:loaded_bufring")
 finish
endif
if v:version < 700
 echoerr "bufring: this plugin requires Vim 7.0 or later"
 finish
endif
let g:loaded_bufring = 1

" Public Interface ----------------------

" global
function! GetBufferRing()
  return s:bufferRing
endfunction

function! BufRing_Forward()
  " サイズが固定されているウィンドウは特殊なバッファを表示していることが多いため、移動しない
  if &winfixwidth || &winfixheight
    call s:Echo("ウィンドウサイズが固定されているため、バッファを移動しません", "WarningMsg")
    return
  endif

  for i in range(1, bufnr("$"))
    if s:IsVisit(i) && index(s:bufferRing, i) < 0
      call s:OpenBuffer(i)
      return
    endif
  endfor
  if len(s:bufferRing) >= 0
    let bufnr = s:Ring_Left(s:bufferRing)
    if s:IsVisit(bufnr)
      call s:OpenBuffer(bufnr)
    endif
  endif
  "echo s:bufferRing
endfunction

function! BufRing_Back()
  " サイズが固定されているウィンドウは特殊なバッファを表示していることが多いため、移動しない
  if &winfixwidth || &winfixheight
    call s:Echo("ウィンドウサイズが固定されているため、バッファを移動しません", "WarningMsg")
    return
  endif

  for i in range( bufnr("$"), 1, -1)
    if s:IsVisit(i) && index(s:bufferRing, i) < 0
      call s:OpenBuffer(i)
      return
    endif
  endfor
  if len(s:bufferRing) >= 0
    let bufnr = s:Ring_Right(s:bufferRing)
    if s:IsVisit(bufnr)
      call s:OpenBuffer(bufnr)
    endif
  endif
  "echo s:bufferRing
endfunction

function! BufRing_IndexOf(bufnr, not_found) abort
  let i = index(s:bufferRing, a:bufnr)
  if i < 0
    return a:not_found
  endif
  return i
endfunction


" Implementation ----------------------

augroup BufRing
  au!
  au VimEnter * call s:BufRing_Init()
  au BufEnter * call s:BufRing_Add(expand("<abuf>"))
  au BufDelete * call s:BufRing_Remove(expand("<abuf>"))
augroup END

let s:bufferRing = []

function! s:BufRing_Init()
  let s:bufferRing = []
  let i = 2
  while bufexists(i)
    if buflisted(i)
      call add(s:bufferRing, i)
    endif
    let i += 1
  endwhile
  call add(s:bufferRing, 1)
endfunction

function! s:BufRing_Add(bufnr)
  let bufnr = str2nr(a:bufnr)
  if s:IsVisit(bufnr)
    call s:Ring_Push(s:bufferRing, bufnr)
  endif
endfunction

function! s:BufRing_Remove(bufnr)
  let idx = index(s:bufferRing, a:bufnr + 0)
  if idx >= 0
    call remove(s:bufferRing, idx)
  endif
endfunction



" 含まれていれば末尾へ移動。いなければ末尾に追加
function! s:Ring_Push(list, item)
  let idx = index(a:list, a:item)
  if idx >= 0
    call remove(a:list, idx)
  endif
  call add(a:list, a:item)
  return a:list
endfunction

" 最後の要素を削除。それを返す
function! s:Ring_Pop(list)
  if len(a:list) > 0
    return remove(a:list, -1)
  endif
endfunction

" 末尾の要素を返す
function! s:Ring_Get(list)
  while 1
    if empty(a:list)
      return 0
    endif
    let last = a:list[-1]
    if s:IsVisit(last)
      return last
    else
      call remove(a:list, -1)
    endif
  endwhile
endfunction

" 右回転
function! s:Ring_Right(list)
  if len(a:list) > 0
    let item = a:list[-1]
    call remove(a:list, -1)
    call insert(a:list, item)
  endif
  return s:Ring_Get(a:list)
endfunction

" 左回転
function! s:Ring_Left(list)
  if len(a:list) > 0
    let item = a:list[0]
    call add(a:list, item)
    call remove(a:list, 0)
  endif
  return s:Ring_Get(a:list)
endfunction

" 移動すべきバッファかどうか
function! s:IsVisit(bufnr)
  " 存在して:lsで表示されるバッファのみ
  return a:bufnr != 0 && bufexists(a:bufnr) && buflisted(a:bufnr) && getbufvar(a:bufnr, "&buftype") == ""
endfunction

" バッファを開く
function! s:OpenBuffer(bufnr)
  sil exe "b " . a:bufnr
endfunction

function! s:Echo(msg, hl)
  exe "echohl " . a:hl
  exe "echomsg '" . a:msg . "'"
  echohl None
endfunction

