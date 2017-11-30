" カンマ区切りのテキストのフィールドを入れ替えるためのプラグイン

if exists("g:loaded_move_separator") || &cp
  finish
endif
let g:loaded_move_separator = 1

" aaa:bbb:ccc

" 最後にputしたテキストのセパレータを前か後ろに移動させる
" :さしすせそあいうえお:かきくけこ
" <Space>>
" =>
" さしすせそ:あいうえお:かきくけこ
function! _MoveSeparatorInLastPutText(move_to_end)
  let s = col("'[")
  let e = col("']")
  if a:move_to_end
    normal! mb`[ma"zx`bp
  else
    normal! mb`[ma`]"zx`aP
  endif
endfunction

nnoremap <silent> <Space>> :<C-u>call _MoveSeparatorInLastPutText(1)<CR>
nnoremap <silent> <Space>< :<C-u>call _MoveSeparatorInLastPutText(0)<CR>

"function! _MoveSeparator(str, separator_is_at_first)
"  if a:separator_is_at_first
"    return strpart(a:str, 1) . strpart(a:str, 0, 1)
"  else
"    let len = strlen(a:str)
"    return strpart(a:str, len - 1, 1)  . strpart(a:str, 0, len - 1)
"  endif
"endfunction

"function! _StartWith(str, needle)
"  return strpart(a:str, 0, strlen(a:needle)) == a:needle
"endfunction
"
"function! _EndWith(str, needle)
"  return strpart(a:str, strlen(a:str) - strlen(a:needle)) == a:needle
"endfunction
