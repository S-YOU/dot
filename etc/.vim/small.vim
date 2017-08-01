scriptencoding utf-8
set enc=utf-8

set nocompatible
syntax enable
filetype plugin on
filetype indent on 

set helplang=ja

set t_Co=256
if &term == 'xterm'
  set t_@7=[4~
  set t_kN=[6~
endif

" 日本語  ---------------------------------------------------------
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    if has('mac')
      let &fileencodings = s:enc_jis .','. s:enc_euc
      let &fileencodings = &fileencodings .','. s:fileencodings_default
    else
      let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
      let &fileencodings = &fileencodings .','. s:fileencodings_default
    endif
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  unlet s:enc_euc
  unlet s:enc_jis
endif

set laststatus=2
set statusline=%n:%F:(%l,%v)\ %m%{&paste==1?'[PASTE]':''}%=%{(&fenc!=''?&fenc:&enc).':'.strpart(&ff,0,1)}\ %p%%\ %02B
set number
set ambiwidth=double
if isdirectory(expand("~/tmp"))
  set directory=~/tmp
else
  set noswapfile
endif
set hidden
set incsearch
set ignorecase
set smartcase
set autoindent smartindent
set smarttab
set tabstop=4 softtabstop=4 shiftwidth=4
set splitbelow splitright


nnoremap <C-j> 3j
nnoremap <C-k> 3k

" netrw
let g:netrw_liststyle=3   " ツリースタイル
let g:netrw_winsize = -25 " マイナスなら絶対値、プラスならパーセンテージ
let g:netrw_browse_split = 4 " 0:デフォルト 1:横分割 2:縦分割 3:新タブ 4:Pと同様
let g:netrw_keepdir = 1 " 0だとディレクトリ上で<CR>を押したときcdする
