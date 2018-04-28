" TextYankPostが実装されていないVimのためのフォールバック

if exists("g:loaded_yanktofile") || &cp
  finish
endif
let g:loaded_yanktofile = 1

" ヤンクするたびに~/.yankに保存する
" screenで<C-t><C-v>で貼り付けられる
vnoremap <silent> y y:call _YankToFile('0', 0)<CR>`]
nnoremap <silent> yy yy:call _YankToFile('0', 0)<CR>
nnoremap <silent> <C-x><C-y> :call _YankToFile('0', 1)<CR>
