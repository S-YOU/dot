"===================================================================
"   Vim Setting 
"===================================================================

" 積極的に使うべき機能
" + で同じインデントの次の行へ移動
" V+ で同じインデントの範囲を選択。同様にd+で削除。
" :Fold （何にマップしようか）
" d, で大文字まで削除。c, で大文字まで修正（キャメルケースを編集するのに便利）
"
" まだマッピングに使っていないキー
" <C-_>
" <C-\>

scriptencoding utf-8
set enc=utf-8

if $SHELL =~ 'bash'
  let $BASH_ENV = '~/.alias'
endif

"===================================================================
" 全般  General
"===================================================================
set nocompatible
syntax enable
filetype plugin on
filetype indent on 
set modeline
set helplang=ja
set runtimepath+=~/vimdoc-ja
set runtimepath^=~/.vim/bundle/ctrlp
set runtimepath^=~/.vim/bundle/nerdtree
set runtimepath^=~/.vim/bundle/vim-go
set runtimepath^=~/.vim/bundle/editorconfig-vim-master
nnoremap <silent> <C-p> :<C-u>CtrlPMixed<CR>
let g:ctrlp_root_markers = ['.svn', '.git', 'Gemfile']
set t_Co=256
set timeoutlen=300
set updatetime=500
set viminfo='600,s100,h
set diffopt=filler,iwhite

if &term =~ 'xterm'
  " Home
  set t_kh=[1~
  " End
  set t_@7=[4~
endif

let mapleader='\'
" grepやCtrlPなどで無視するディレクトリ
let exclude_dirs = split($IGNORED_DIRS, ":")

" Cygwin
if filereadable("/cygwin.bat")
  colorscheme aoyama_256
  let g:netrw_cygwin=1
else
  colorscheme aoyama_256
endif


" 日本語  ---------------------------------------------------------
set fencs=ucs-bom,utf-8,iso-2022-jp-3,eucjp-ms,cp932,latin1
"if &encoding !=# 'utf-8'
"  set encoding=japan
"  set fileencoding=japan
"endif
"if has('iconv')
"  let s:enc_euc = 'euc-jp'
"  let s:enc_jis = 'iso-2022-jp'
"  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
"    let s:enc_euc = 'eucjp-ms'
"    let s:enc_jis = 'iso-2022-jp-3'
"  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
"    let s:enc_euc = 'euc-jisx0213'
"    let s:enc_jis = 'iso-2022-jp-3'
"  endif
"  if &encoding ==# 'utf-8'
"    let s:fileencodings_default = &fileencodings
"    if has('mac')
"      let &fileencodings = s:enc_jis .','. s:enc_euc
"      let &fileencodings = &fileencodings .','. s:fileencodings_default
"    else
"      let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
"      let &fileencodings = &fileencodings .','. s:fileencodings_default
"    endif
"    unlet s:fileencodings_default
"  else
"    let &fileencodings = &fileencodings .','. s:enc_jis
"    set fileencodings+=utf-8,ucs-2le,ucs-2
"    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
"      set fileencodings+=cp932
"      set fileencodings-=euc-jp
"      set fileencodings-=euc-jisx0213
"      set fileencodings-=eucjp-ms
"      let &encoding = s:enc_euc
"      let &fileencoding = s:enc_euc
"    else
"      let &fileencodings = &fileencodings .','. s:enc_euc
"    endif
"  endif
"  unlet s:enc_euc
"  unlet s:enc_jis
"endif
set ambiwidth=double

" ファイル --------------------------------------------------------
set nobackup
set backupskip=/tmp/*,/private/tmp/*
if isdirectory(expand("~/tmp"))
  set directory=~/tmp
else
  set noswapfile
endif
set hidden
set autoread
set suffixes& suffixes-=.h
" = をファイル名の一部と認識させない
set isfname& isfname-==
set confirm
if v:version >= 703
  set undofile
endif

" 編集 ------------------------------------------------------------ 
set autoindent nosmartindent
set smarttab
" タブの設定について
"    1. 基本は4
"    2. Rubyなどファイルタイプで決まっている場合はFileTypeで上書きする
"    3. プロジェクト固有のものは ~/.vimrc.local のMatchConfigで上書きする
" 設定もこの順番で行われる
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set shiftround
set cinoptions=t0,g0,(0
set backspace=indent,eol,start
set formatoptions=tcqnmM
set virtualedit=block
if has("xterm_clipboard")
  set clipboard=unnamed
endif
set pastetoggle=<F10>
nnoremap <F10> :<C-u>exe "normal" (getline(".")==""?"I":"o")<CR>i<C-o>:set paste<CR>
nmap <Space>o <F10>
nmap <Space>O O<F10>

" カーソル移動 -----------------------------------------------------
set showmatch matchtime=1
set matchpairs+=<:>
set whichwrap+=h,l,<,>,[,],b,s,~
set sidescroll=1
set sidescrolloff=4
set nostartofline

" 表示 -------------------------------------------------------------
set number
set nowrap
set nolist listchars=tab:^\ 
"set ruler
"set ruf=%45(%12f%=\ %m%{'['.(&fenc!=''?&fenc:&enc).']'}\ %l-%v\ %p%%\ [%02B]%)
set statusline=%n:\ %F:%l,%v\ %m%{&buftype=='nofile'?'[NOFILE]':''}%{index(['i','R','Rv'],mode())!=-1?'\ \ --INSERT--\ ':''}%{&paste==1?'[PASTE]':''}%{WhatFunction()}%=%{(&et?'space':'tab').':'.(&sw)}\ %{(&fenc!=''?&fenc:&enc).(&bomb?'bom':'').':'.strpart(&ff,0,1)}\ %p%%\ %02B
set showcmd
set report=0
set cmdheight=1
set cmdwinheight=20
set laststatus=2
set shortmess+=I
set nofoldenable
set foldnestmax=5
set foldtext=MyFoldText()
set notitle noicon
set vb t_vb=
" --MORE-- を表示しない
"set nomore
set lazyredraw
set synmaxcol=300
" showmodeにしていると、PHPの引数表示が上書きされてしまう
set showmode

augroup Gdb
  au!
  au VimEnter * call _DetectGdb()
augroup END

function! _DetectGdb()
  if exists("$GDB_RUNNING")
    mark A
    sign define current_line text=> texthl=StatusLine
    exe "sign place 1 line=" . line(".") . " name=current_line file=" . expand("%:p")
  endif
endfunction

" 検索 -------------------------------------------------------------
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan
set keywordprg=man\ -S\ 2:3\ -a
" vgにより「:grep console」でカレントディレクトリから大文字小文字を区別せず検索できる
set grepprg=vg\ --from-vim
set grepformat=%f:%l:%c:%m,%f:%l:%m
set tags+=*.tags,tags;,file-tags;

" 補完・履歴 -------------------------------------------------------
if exists('+wildignorecase')
  set wildignorecase
endif
set wildignore+=*.o
"set wildignore+=*/.git/*,*/bundle/*,*/vendor/*
set wildmenu
set wildmode=list:full
set history=50
set noshowfulltag
set wildoptions=tagfile
set cdpath+=~
set dictionary=~/.vim/dict/dict.txt,~/.vim/dict/dbdict.txt,~/.vim/dict/colornames.txt
set thesaurus=~/.vim/dict/thesaurus.txt
set complete+=k

" ウィンドウ -------------------------------------------------------
set splitbelow
set splitright
set sessionoptions+=resize
set previewheight=5
set helpheight=14

" マウス -----------------------------------------------------------
set mouse=
"set ttymouse=xterm

if has('persistent_undo')
  set undodir=~/.vimundo
  let undodir = expand('~/.vimundo')
  if !isdirectory(undodir)
    call mkdir(undodir)
    echomsg "ディレクトリ " . undodir . " を作成しました"
  endif
endif


"=============================================================================
"   マッピング  Mappings
"=============================================================================
" カーソル移動 ----------------------------------------------------- 
noremap <silent> j gj
noremap <silent> k gk
noremap <silent> <C-j> 3j
noremap <silent> <C-k> 3k
nnoremap <silent> w :<C-u>call ForwardWord(1)<CR>
nnoremap <silent> b :<C-u>call BackwardWord(1)<CR>
nnoremap <silent> } :<C-u>call ForwardParagraph()<CR>
onoremap <silent> } :<C-u>call ForwardParagraph()<CR>
xnoremap <silent> } <Esc>:<C-u>call ForwardParagraph()<CR>mzgv`z
nnoremap <silent> [[ :<C-u>let scrolloff_old = &scrolloff<CR>:set scrolloff=6<CR>[[:let &scrolloff = scrolloff_old<CR>
nnoremap <silent> ]] :<C-u>let scrolloff_old = &scrolloff<CR>:set scrolloff=6<CR>]]:let &scrolloff = scrolloff_old<CR>
vnoremap <Esc> <Esc>`<
xnoremap <silent> y y`>
noremap <silent> ) /)\\|;\\|\\./e<CR>:call _RemoveLastSearchHistory()<CR>
noremap <silent> ( /)\\|;\\|\\./e<CR>:call _RemoveLastSearchHistory()<CR>
inoremap <silent><C-a> <Esc>I
inoremap <silent> <expr><C-e> pumvisible() ? "\<C-e>" : "\<End>"
inoremap <silent> <C-@> <C-x><C-o>
nnoremap <silent> n :<C-u>call _SearchNext("n")<CR>
nnoremap <silent> N :<C-u>call _SearchNext("N")<CR>
nnoremap <silent> <C-x><C-o> <C-i>

function! _SearchNext(dir)
  let line = line(".")
  let wrapped = 0
  set scrolloff=4
  if a:dir ==# "n"
    try
      exe "normal! " . v:count1 . "n"
    catch /E486/
      call _Echo("ErrorMsg", "E486: Pattern not found: " . @/)
      return
    endtry
    if line(".") < line
      let wrapped = 1
    endif
  else
    try
      exe "normal! " . v:count1 . "N"
    catch /E486/
      call _Echo("ErrorMsg", "E486: Pattern not found: " . @/)
      return
    endtry
    if line(".") > line
      let wrapped = 1
    endif
  endif
  set scrolloff=0
  if wrapped
    call _Echo("WarningMsg", "Search wrapped")
  else
    echo @/
  endif
endfunction


" 編集 -------------------------------------------------------------
" タグを閉じる
" smartindent, cindentによる「#でインデント削除」を無効化する
inoremap # X<BS>#
noremap # :call _ToggleCommentSelection()<CR>
inoremap <C-z> <C-o>:set paste<CR><C-r>"<C-o>:set nopaste<CR>
inoremap <C-b> <left>
inoremap <C-f> <right>
inoremap <C-d> <Del>
" 選択範囲の単語を置換
xnoremap s y:%s@\V\<<C-R>"\>@@g<Left><Left>
nnoremap <silent> d<CR> :call delete_blank_lines#DeleteBlankLines()<CR>
" <C-u> をアンドゥできるようにする。insert.jax 参照
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
onoremap <space> /\S<CR>:call _RemoveLastSearchHistory()<CR>
onoremap q /["',.{}()[\]<>]<CR>:call _RemoveLastSearchHistory()<CR>
onoremap s /["']<CR><C-o>:call _RemoveLastSearchHistory()<CR>
nnoremap vis :<C-u>call _SelectString('i')<CR>
nnoremap vas :<C-u>call _SelectString('a')<CR>
nnoremap dis :<C-u>call _SelectString('i')<CR>d
nnoremap das :<C-u>call _SelectString('a')<CR>d
nnoremap cis :<C-u>call _SelectString('i')<CR>c
nnoremap cas :<C-u>call _SelectString('a')<CR>c

" ビジュアルモードで選択する
function! _Visual(start, end)
  call setpos('.', a:end)
  normal! mz
  call setpos('.', a:start)
  normal! v`z
endfunction

" 文字列をビジュアルモードで選択する
function! _SelectString(mode)
  if search("[\"']", 'W')
    let close_pos = getpos('.')
    let quote_char = getline('.')[col('.') - 1]
    echomsg "quote_char = " . quote_char
    if search(quote_char, 'bW')
      let open_pos = getpos('.')
      " 誤動作防止のため、同一行の中だけに制限しておく
      if open_pos[1] != close_pos[1]
        return
      endif
      if a:mode == 'i'
        let open_pos[2] = open_pos[2] + 1
        let close_pos[2] = close_pos[2] - 1
        call _Visual(open_pos, close_pos)
      elseif a:mode == 'a'
        call _Visual(open_pos, close_pos)
      endif
    else
      return
    endif
  else
    return
  endif
endfunction

nnoremap vs v/["']/e-1<CR>v:nohl<CR>gv
" カレント行、または選択範囲に全角と半角の間にスペースを入れる
nnoremap <silent> <space>J V:InsertSpaceBetweenHankakuZenkaku<CR>
xnoremap <silent> <space>J <Esc>:InsertSpaceBetweenHankakuZenkaku<CR>
nnoremap <C-x>p :<C-u>r ~/tmp/screen-hardcopy.txt<CR>

"iabbrev /// <Esc>j:FB<CR><BS>
vnoremap p "0p
" 関数を範囲選択
nnoremap vf ][v[[?^s*$<CR>
" for などのブロックを選択。カーソル位置を for の行におく必要がある。
nnoremap vb /{<CR>%v%0
" １つの引数を選択
nnoremap vaa ?\(,\\|(\)<CR>lv/\(,\\|)\)<CR>
nmap caa vaac


" バッファ・ウィンドウ ----------------------------------------------
nnoremap <silent> <space>h :call BufRing_Back()<CR>
nnoremap <silent> <space>l :call BufRing_Forward()<CR>
"nnoremap <silent> <space>l :bn<CR>
nnoremap <space>i :<C-u>let g:ctrlp_default_input=''<CR>:CtrlPBuffer<CR>
nnoremap <silent> <C-d> :<C-u>call _ShowNERDTree()<CR>
nnoremap <silent> <expr> <tab> (getline(".")[col(".")-1]==' ' ? "s\<tab>\<Esc>l" : "i\<tab>\<Esc>l")
nnoremap <silent> <space><space> i<space><Esc>l
"noremap gf gF
nnoremap gf :<C-u>call mygf#MyGF("")<CR>
vnoremap gf :<C-u>call mygf#MyGF(GetSelectedText())<CR>
nnoremap <C-w><C-f> :<C-u>sp<CR>:<C-u>call mygf#MyGF("")<CR>
nnoremap <silent> _ :A<CR>

" プログラミング
nnoremap <silent> <space>P :call _ShowFunctionHint(expand("<cword>"), 1)<CR>
nnoremap <silent> <C-g>l :<C-u>Gitlog<CR>
nnoremap <silent> <C-g><C-l> :<C-u>Gitlog<CR>

nnoremap <silent> <C-w><C-o> :<C-u>call CloseOtherWindows()<CR>
" winfixheight or winfixwidth されたウィンドウを除いて閉じる
function! CloseOtherWindows()
  let w = winnr()
  for winnr in range(winnr("$"), 1, -1)
    if winnr == w
      continue
    endif
    exe winnr . "wincmd w"
    if !(&winfixheight || &winfixwidth) 
      sil! close
    endif
  endfor
  1wincmd w
endfunction

" ファンクションキーはどれに何を割り当てたか覚えづらい
" F5-F8 プログラミング関連
nnoremap <silent> <F1> :<C-u>Out call _BufInfo()<CR>
nnoremap <silent> <F2> :<C-u>cp<CR>
nnoremap <silent> <F3> :<C-u>cn<CR>
nnoremap <silent> <F4> :<C-u>runtime macros/vimsh.vim<CR>
nnoremap <silent> <Space>r :<C-u>call ExecSystem('last')<CR>
nnoremap <silent> <Space>a :<C-u>SetAutoExec<CR>
nnoremap <silent> <Space>R :<C-u>call ExecSystem('input')<CR>

" 機能トグル
command! ShowTabstop echo (&list ? 'list' : 'nolist') (&et ? 'expandtab' : 'noexpandtab') 'ts=' . &ts . ' sts=' . &sts . ' sw=' . &sw
nnoremap <C-l>      :nohl<CR>:redraw!<CR>:set list!<CR>:ShowTabstop<CR>
nnoremap <C-l><C-l> :nohl<CR>:redraw!<CR>:set list!<CR>:ShowTabstop<CR>
nnoremap <C-l>2     :set ts=2 sts=2 sw=2<CR>:set ts?<CR>
nnoremap <C-l>4     :set ts=4 sts=4 sw=4<CR>:set ts?<CR>
nnoremap <C-l>8     :set ts=8 sts=8 sw=8<CR>:set ts?<CR>
nnoremap <C-l><C-e> :set expandtab!<CR>:set expandtab?<CR>
nnoremap <C-l><C-f> :set foldenable!<CR>:set foldenable?<CR>
nnoremap <C-l><C-n> :windo set number!<CR>:set number?<CR>
nnoremap <C-l><C-w> :set wrap!<CR>:set wrap?<CR>
nnoremap <C-l><C-u> :set cuc!<CR>
nnoremap <silent> <space>* :<C-u>let @/ = '\<' . expand("\<cword\>") . '\>'<CR>:set hls<CR>
"nnoremap <C-l> :noh<CR><C-l>

" その他 ----------------------------------------------------------- 

" コマンドライン
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <expr> <C-d> (getcmdpos()==strlen(getcmdline())+1 ? "\<C-d>" : "\<Del>")
" / で検索時、<C-j>を押すとマッチの末尾に移動
cnoremap <expr> <C-j> (getcmdtype()=="/" \|\| getcmdtype()=="?") ? "\<C-e>/e+1\<CR>" : "\<C-e>"
cnoremap <C-f> <Right>
cnoremap <expr> <C-g> (getcmdtype()=="/" \|\| getcmdtype()=="?") ? ".*" : "\<C-a>"
cnoremap <expr> <C-k> _ToggleSearchType()
function! _ToggleSearchType()
  let prefix = '\V\<'
  let suffix = '\>'
  let prefix_len = strlen(prefix)
  let suffix_len = strlen(suffix)

  let cmdtype = getcmdtype()
  if cmdtype == "/" || cmdtype == "?"
    let cmdline = getcmdline()
    if strpart(cmdline, 0, prefix_len) == prefix
      return "\<C-u>" . strpart(cmdline, prefix_len, strlen(cmdline) - prefix_len - suffix_len)
    else
      return "\<C-u>" . prefix . cmdline . suffix
    endif
  else
    return ""
  endif
endfunction
cnoremap <expr> <C-l> _ToggleSearchIgnorecase()
function! _ToggleSearchIgnorecase()
  let cmdtype = getcmdtype()
  if cmdtype == "/" || cmdtype == "?"
    let cmdline = getcmdline()
    if stridx(cmdline, '\c') >= 0
      return "\<C-u>" . substitute(cmdline, '\\c', '', '')
    else
      return "\<C-u>" . cmdline . '\c'
    endif
  else
    return ""
  endif
endfunction
" コマンドラインで<C-r>/したとき\<hoge\>の\<と\>を表示しないようにする
function! _GetLastSearchedWord()
  return substitute(getreg('/'), '^\\<\|\\>$', '', 'g')
endfunction
cnoremap <expr> <C-r>/ _GetLastSearchedWord()
inoremap <expr> <C-r>/ _GetLastSearchedWord()

" コマンドラインへパスなどを挿入
cnoremap <expr> <C-t>  _GetProjectRoot() . "/\<C-d>"
cnoremap <expr> <C-x>d expand("%:p:h")
cnoremap <expr> <C-x>f expand("%:t")
cnoremap <expr> <C-x>p expand("%:p")

function! _GetProjectRoot()
  let a = system("pjroot")
  let a = substitute(a, "\n", "", "")
  if a == "not exist"
    let a = g:topdir
  end
  let a = substitute(a, expand("$HOME"), "~", "")
  return a
endfunction

inoremap <C-x><C-f> <C-o>:set completefunc=CompleteFiles<CR><C-x><C-u>

fun! CompleteFiles(findstart, base)
  if a:findstart
    " 単語の始点を検索する
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ "[^ \t\"'=]"
      let start -= 1
    endwhile
    return start
  else
    " "a:base" にマッチする月を探す
    let res = []
    let paths = filter(split(&path, ","), 'v:val != ""')
    if a:base[0] == "~"
      let base = expand("$HOME") . strpart(a:base, 1)
    else
      let base = a:base
    end
    if base[0] == "/"
      let paths = [""] + paths  " 空文字列を含めることにより、/も検索対象にする
      let slashlen = 0
    else
      let base = "/" . base
      let slashlen = 1
    endif
    for p in paths
      let plen = strlen(p)
      for m in glob(p . base . "*", 1, 1)
        let tmp = strpart(m, plen + slashlen)
        if a:base[0] == "~"
          let tmp = substitute(tmp, $HOME, "~", "")
        endif
        call add(res, tmp)
      endfor
    endfor
    return res
  endif
endfun

nmap g* :grep<space>-w <C-r><C-w>

cabbrev <expr> grep _GetGrepCommand("pjroot")
cabbrev <expr> grepapp _GetGrepCommand("app")
function! _GetGrepCommand(dirtype)
  if a:dirtype == "top"
    let dir = g:topdir
  elseif a:dirtype == "pjroot"
    let dir = g:pjroot
  elseif a:dirtype == "app"
    let dir = g:pjroot . "/app"
  else
    let dir = g:topdir
  end
  let cmdline = getcmdline()
  let cmdname = strpart(cmdline, 0, getcmdpos())
  if cmdname =~ '^\w\+$' && getcmdtype()==':'
    return 'cd ' . dir . ' | Grep'
  else
    return 'grep'
  endif
endfunction

function! _Echo(highlight, msg)
  exe "echohl " . a:highlight
  echomsg a:msg
  echohl None
endfunction

function! _Echon(highlight, msg)
  exe "echohl " . a:highlight
  echon a:msg
  echohl None
endfunction

command! -nargs=+ Grep silent grep <args> | botright cw | redraw! | if len(getqflist()) == 0 | call _Echo("WarningMsg","検索結果: 0件") | endif
cabbrev brep Brep
command! -nargs=+ Brep call _Bufgrep(<f-args>)
function! _Bufgrep(query)
  cclose
  call setqflist([])
  let bn = bufnr("%")
  exe "sil! bufdo! vimgrepadd /" . a:query . "/j %"
  let qflen = len(getqflist())
  if qflen == 0
    sil! exe "b" . bn
    call _Echo("WarningMsg","検索結果: 0件")
  else
    cfirst
    cw
    let winheight = qflen > 10 ? 10 : qflen
    exe winheight . "wincmd _"
    redraw!
  endif
endfunction
" 全バッファに対して置換する
" 使い方: Replace s@hoge@moge@
" bufdo s@hoge@moge@gce との違いは、unlistedなバッファも対象にすること
command! -nargs=1 Replace call _ReplaceAll("<args>")

function! _LoadAllFilesInQuickfixList()
  let orig_bufnr = bufnr("%")
  let bufnrs = uniq(map(getqflist(), 'v:val["bufnr"]'))
  for bufnr in bufnrs
    if bufexists(bufnr)
      exe "b" bufnr
      set buflisted
    endif
  endfor
  exe "b" orig_bufnr
endfunction

function! _ReplaceAll(s_cmd)
  let orig_bufnr = bufnr("%")
  call _LoadAllFilesInQuickfixList()
  let cmd = "%" . a:s_cmd . "gce"
  bufdo exe cmd
  exe "b" orig_bufnr
endfunction


"=============================================================================
"   短縮入力  Abbreviation
"=============================================================================

inoreab cmain #include <stdio.h><cr>#include <stdlib.h><cr>#include <string.h><cr><cr>int main(int argc, char *argv[])<cr>{<cr>printf("main\n");<cr>return 0;<cr>}<Esc>{<down><down><down>^<left>
inoreab cppmain #include <stdio.h><cr>#include <stdlib.h><cr>#include <string.h><cr>#include <vector><cr>#include <list><cr>#include <map><cr>#include <algorithm><cr><cr>using namespace std;<cr><cr>int main(int argc, char *argv[])<cr>{<cr>return 0;<cr>}<Esc>{
inoreab shmain <Esc>:%d<CR>:0r~/.vim/_template.sh<CR>:set ft=sh<CR>
inoreab rubymain <Esc>:%d<CR>:0r~/.vim/_template.rb<CR>:set ft=ruby<CR>
"inoremap <C-j> <Esc>/\(break;\\|{\\|}\)\s*$<CR>:noh<CR>o
inoreab date@ <C-r>=strftime("%Y-%m-%d")<CR>
inoreab time@ <C-r>=strftime("%H:%M")<CR>
inoreab datetime@ <C-r>=strftime("%Y-%m-%d %H:%M")<CR>
noreab alerT alert
noreab printF printf
noreab fpf fprintf(stderr,);<Left><Left>
noreab transtate translate

function! DefineAbbreb(abb, content, type, modifier)
  exe a:type . "noreab " . a:modifier . " " . a:abb . " " . a:content . "<C-r>=_FinishAbbreb()<CR>"
endfunction
function! _FinishAbbreb()
  call Eatchar('\\s')
  let str = '#CURSOR#'
  if search(str, 'bW') > 0
    normal! 8x
  endif
  return ''
endfunction

call DefineAbbreb('vd', 'var_dump(#CURSOR#)', 'i', '')
call DefineAbbreb('ph', '<?php  ?><left><left><left>', 'i', '')
call DefineAbbreb('pe', '<?php echo #CURSOR# ?>', 'i', '')
call DefineAbbreb('phe', '<?php echo #CURSOR# ?>', 'i', '')
call DefineAbbreb('phf', '<?php foreach (#CURSOR#): ?><Enter><?php endforeach; ?>', 'i', '')
call DefineAbbreb('phif', '<?php if (#CURSOR#): ?><Enter><?php endif; ?>', 'i', '')
call DefineAbbreb('iss', 'isset($#CURSOR#) ? $ : ''''', 'i', '')
call DefineAbbreb('css@', '<link rel="stylesheet" href="#CURSOR#">', 'i', '')
call DefineAbbreb('link@', '<link rel="stylesheet" href="#CURSOR#">', 'i', '')



"=============================================================================
"   コマンド  Commands
"=============================================================================

command! Utf8 e ++enc=utf-8
command! Euc e ++enc=euc-jp
command! Sjis e ++enc=cp932
command! Jis e ++enc=iso-2022-jp
command! Dos w ++ff=dos | e
command! Unix w ++ff=unix | e
command! -nargs=? Out call Out("<args>")
command! -nargs=* Gxx set makeprg=g++\ $GXXFLAGS\ <args>\ % | make
command! -nargs=* Gcc set makeprg=gcc\ $GCCFLAGS\ <args>\ % | make
command! Ev e ~/.vimrc
command! Evl e ~/.vimrc.local
command! -nargs=? A  echo "Command A is deprecated. Use <C-x><C-h> instead."
command! -nargs=? AA echo "Command AA is deprecated. Use <C-x>h instead."
command! -nargs=? VA echo "Command VS is deprecated. Use <C-x>H instead."
nnoremap <C-x><C-h> :<C-u>call ToggleSourceAndHeader("e")<CR>
nnoremap <C-x>h     :<C-u>call ToggleSourceAndHeader("sp")<CR>
nnoremap <C-x>H     :<C-u>call ToggleSourceAndHeader("vs")<CR>
command! Li echo '//-を使ってください'
command! LLi echo '//=を使ってください'

command! ShowIsKeyword let ft_save=&ft|new|set bt=nofile bh=delete|let &ft=ft_save|call append('.',join(map(range(0x20,0x7e),'nr2char(v:val)'),''))|normal! /\k<CR>:nohl<CR>:set ft=<CR>
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
command! TestKeys runtime macros/testkeys.vim

iab //- <Esc>:call _CommentCaption2('-')<CR>
iab //= <Esc>:call _CommentCaption('=')<CR>
iab #- <Esc>:call _CommentCaption2('-')<CR>
iab #= <Esc>:call _CommentCaption('=')<CR>

function! _GetCommentSymbol()
  if exists("b:commentSymbol")
    return b:commentSymbol
  else
    return '#'
  endif
endfunction

function! _CommentCaption(ch)
  let line = line(".")
  let last_line = line("$")
  if line == 1
  elseif line != last_line
    d
    -1
  endif
  let fo_save = &fo
  set fo=
  let cs = _GetCommentSymbol()
  let virtcol = virtcol(".")
  if virtcol < 78
    let len = 78 - virtcol
  else
    let len = 10
  endif
  set paste
  execute "normal! o" . cs
  execute "normal! " . len . "a" . a:ch
  execute "normal! o" . cs . "  "
  execute "normal! o" . cs
  execute "normal! " . len . "a" . a:ch
  if line == 1
    1d
    normal! ``
  elseif line == last_line
    exe line "d"
    normal! ``
  endif
  normal! =2kj$
  set nopaste 
  let &fo = fo_save
  startinsert!
endfunction

function! _CommentCaption2(ch)
  let line = line(".")
  let last_line = line("$")
  if line == 1
  elseif line != last_line
    d
    -1
  endif
  let fo_save = &fo
  set fo=
  let cs = _GetCommentSymbol()
  let virtcol = virtcol(".")
  if virtcol < 75
    let len = 75 - virtcol
  else
    let len = 10
  endif
  set paste
  execute "normal! o" . cs
  execute "normal!  a {{{ "
  execute "normal! " . len . "a" . a:ch
  if line == 1
    1d
    normal! ``
  elseif line == last_line
    exe line "d"
    normal! ``
  endif
  set nopaste 
  exe "normal! ==^" . (1+strlen(a:ch)) . "l"
  let &fo = fo_save
  augroup CommentCaption2
    au!
    au InsertLeave * silent yank | silent put | s@{{{@}}}@ | call _DeleteCommentCaption2AuGroup()
  augroup END
  startinsert
endfunction

function! _DeleteCommentCaption2AuGroup()
  augroup CommentCaption2
    au!
  augroup END
endfunction

command! FB call _FunctionDescription()
command! WhatColor call _WhatColor(line('.'), col('.'))
command! Fixdir let g:fixdir=getcwd()
command! Top exe "cd " . g:topdir
command! Settop call Settop(getcwd())

function! _GetColor(line, col)
  let line = a:line
  let col = a:col
  " 透明なsyntaxそのものは返さない
  let synID         = synID(line, col, 1)
  " 透明なsyntaxそのものも返す
  "let synID_trans   = synID(line, col, 0)

  if synID == 0
    let synID_linked  = ''
    let hi_name       = 'Normal'
    let linked_name   = 'Normal'
    let ctermfg       = 'None'
    let ctermbg       = 'None'
  else
    let synID_linked  = synIDtrans(synID)
    let hi_name       = synIDattr(synID, "name")
    let linked_name   = synIDattr(synID_linked, "name")
    let ctermfg       = synIDattr(synID_linked, "fg")
    let ctermbg       = synIDattr(synID_linked, "bg")
  endif

  let ret = { 'hi_name': hi_name, 'linked_name': linked_name, 'synID_linked': synID_linked, 'ctermfg': ctermfg, 'ctermbg': ctermbg }
  return ret
endfunction

function! _WhatColor(line, col)
  let c = _GetColor(a:line, a:col)
  echo printf('%s (%s) ctermfg=%s ctermbg=%s', c['hi_name'], c['linked_name'], c['ctermfg'] < 0 ? 'None' : c['ctermfg'], c['ctermbg'] < 0 ? 'None' : c['ctermbg'])
endfunction

command! -nargs=0 UpForeColor call _ChangeColor(1, 0)
command! -nargs=0 DownForeColor call _ChangeColor(-1, 0)
command! -nargs=0 UpBackColor call _ChangeColor(0, 1)
command! -nargs=0 DownBackColor call _ChangeColor(0, -1)

function! _ChangeColor(fg_delta, bg_delta)
  let color = _GetColor(line('.'), col('.'))
  let new_ctermfg = color['ctermfg'] + a:fg_delta
  let new_ctermbg = (color['ctermbg'] == '-1') ? 'None' : (color['ctermbg'] + a:bg_delta)
  if new_ctermfg >= 256
    let new_ctermfg = 0
  endif
  if new_ctermbg >= 256
    let new_ctermbg = 0
  endif
  let cmd = printf("hi %s ctermfg=%s ctermbg=%s", color['hi_name'], new_ctermfg, new_ctermbg)
  exe cmd
  echomsg cmd
endfunction

function! Settop(dir)
  let g:topdir = a:dir
endfunction

function! Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunction!

if argv(0) =~ "mlreplace.rb"
  let g:fixdir=getcwd()
endif

augroup MyAutocmd
  au!
  au BufNewFile *.* call LoadTemplate2()
  au BufNewFile,BufReadPost  *.c,*.h,*.cpp,*.d,*.java   let b:commentSymbol="//"
  au BufNewFile,BufReadPost *.bas set ft=vb
  au BufNewFile,BufReadPost *tags set list ts=16
  au BufRead,BufNewFile svn-commit* sil 1,3d | new | setl bufhidden=hide buftype=nofile noswapfile | if exists("g:topdir") | exe "cd" g:topdir | endif | silent 0r!svn --diff-cmd diff diff
  au BufReadPost * call _MemorizeModifiedTime()
  au BufReadPost * if &modifiable && search('[^ -~\t]', 'wcn', 200) == 0 | set fenc= | endif
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
  au BufReadPost * let b:SetExecutable_off = 1
  au BufReadPost *.dat setl list
  au BufReadPost *.jax if &modifiable | call Help_Setting() | endif
  au BufReadPost *.thtml,*.inc set ft=php
  au BufReadPost gita.tmp  nnoremap <silent> <C-d> :exe "cd" g:topdir<CR>:!clear && git diff <C-r><C-f><CR>
  au BufReadPost *.gitcommit  set filetype=gitcommit
  au BufWritePost * call SetExecutable()
  au BufWritePost * call _AutoExecSystem()
  au BufWritePost * if !(exists('b:enable_syntax_check') && b:enable_syntax_check == 0) |  call GUSyntaxCheck(&ft) | endif
  au BufWritePost * if &ft == "" | filetype detect | endif 
  au FileType c           call C_Setting() 
  au FileType cpp         call Cpp_Setting() 
  au FileType cs          call Csharp_Setting()
  au FileType css         call HTML_Setting()
  au FileType eruby       call _EnableCloseTagByCtrlP()
  au FileType go          call Go_Setting()
  au FileType haskell     call Haskell_Setting()
  au FileType help setlocal sts=8|set indentkeys-=0{| hi LongLine guibg=#ffff00 | match LongLine /\%80c/ | hi Ignore ctermfg=1 guifg=#ff0000 | syn match Error /^</
  au BufReadPost  COMMIT_EDITMSG  1
  au FileType html        call HTML_Setting()
  au FileType javascript  call JavaScript_Setting()
  au FileType lisp        call Lisp_Setting()
  au FileType lua         let b:commentSymbol="--"
  au FileType markdown    call Markdown_Setting() 
  au FileType nerdtree    call Nerdtree_Setting()
  au FileType perl        call Perl_Setting()
  au FileType php         call PHP_Setting()
  au FileType python      call Python_Setting()
  au FileType qf call AdjustWindowHeight(1)
  au FileType qf call _Echo("MoreMsg", "F2 F3で移動できます")
  au FileType qf nnoremap <buffer> p <CR><C-w>wj
  au FileType qf setlocal nobuflisted
  au FileType qf syn match qfError "warning" contained
  au FileType ruby        call Ruby_Setting() 
  au FileType eruby        call Ruby_Setting() 
  au FileType scheme      call Scheme_Setting()
  au FileType vb          call VB_Setting()
  au FileType vim         call Vim_Setting()
  au FileType *           call _SetDict()
  au InsertLeave * set nopaste
  au Syntax c,cpp,ruby,java,python,javascript,php,cs call _MySyntax() 
  au Syntax markdown call _MarkdownSyntax() 
  au Syntax * call _HighlightMixedIndent()
  au VimEnter * call _VimEnter()
  au CursorHold * silent! checktime
  au WinEnter * checktime
augroup END

function! _VimEnter()
  let g:topdir=getcwd()
  let g:pjroot = expand(_GetProjectRoot())

  if filereadable(g:pjroot . "/Gemfile") && isdirectory(g:pjroot . "/public")
    let &path = &path . "," . g:pjroot . "/public"
  endif
endfunction

command! EnableSyntaxCheck let b:enable_syntax_check = 1
command! DisableSyntaxCheck let b:enable_syntax_check = 0
let g:syntaxCheckFunctions = { 'php' : 'PHP_SyntaxCheck', 'javascript' : 'JS_SyntaxCheck', 'ruby' : 'Ruby_SyntaxCheck', 'python' : 'Python_SyntaxCheck', 'haskell' : 'Haskell_SyntaxCheck' }
function! GUSyntaxCheck(ft)
  if has_key(g:syntaxCheckFunctions, a:ft)
    let Func = function(g:syntaxCheckFunctions[a:ft])
    call Func()
  endif
endfunction

" インサートモードでの補完にはignorecaseを適用しない
augroup NoIgnoreCaseInInsertCompletion
  au!  
  au InsertEnter * let ignore_case_old = &ignorecase | set noignorecase
  au InsertLeave * let &ignorecase = ignore_case_old
augroup END

augroup AutoCd
  au BufEnter,BufWritePost * if !exists('g:fixdir') && &buftype == "" && expand("%") != "" && isdirectory(expand("%:p:h")) |exe "lcd " . escape(expand("%:p:h"), ' (){}''"') |elseif exists("g:topdir")|exe "lcd ".g:topdir|endif
augroup END

function! SetExecutable()
  if exists("b:SetExecutable_off")
    return
  endif
  if strpart(getline(1),0,2) == "#!" && !executable(expand("%:p"))
    if confirm("Do chmod +x ?", "&Y\n&N") == 1
      redraw
      call system("chmod +x ".shellescape(expand("%:p")))
      if v:shell_error == 0
        call _Echo("Question", "Set permission to execute.")
      else
        echoerr "Failed to set permission to execute."
      endif
    endif
    let b:SetExecutable_off = 1
  endif
endfunction

function! _MySyntax()
  syn keyword Return    return exit         | hi Return         cterm=bold      ctermfg=1 ctermbg=None gui=bold guifg=red
  syn keyword Break     break last          | hi Break          cterm=None      ctermfg=1 ctermbg=None gui=None guifg=#0000ff
  syn keyword Continue  continue next       | hi Continue       cterm=None      ctermfg=1 ctermbg=None gui=None guifg=#007F7F
  syn keyword Debug     DEBUG debug dprintf | hi Debug          cterm=underline ctermfg=1 ctermbg=None gui=bold guifg=#ff00ff guibg=#ffffff
  syn keyword Fallthrough fallthrough       | hi Fallthrough    cterm=None      ctermfg=3 ctermbg=None gui=underline guifg=red 
  syn keyword cppPublic   public            | hi cppPublic      cterm=None      ctermfg=2 ctermbg=None gui=None guifg=#0000ff
  syn keyword cppPrivate  protected private | hi cppPrivate     cterm=bold      ctermfg=3 ctermbg=None gui=None guifg=#006600 ctermfg=darkred
  syn match Not /!=\@!/ | hi Not cterm=bold ctermfg=1 ctermbg=None
  syn match   Operator /\(&&\|||\|==\)/
  hi link phpStatement Return
endfunction

function! _MarkdownSyntax()
  syn match MarkdownNewline /  $/ | hi MarkdownNewline ctermbg=230
endfunction

" スペースとタブが混在している行をハイライトする
function! _HighlightMixedIndent()
  syn match MixedIndent /^ \+\t\+\|^\t\+ \+/
  hi MixedIndent ctermbg=224 guibg=LightRed
endfunction


"============================================================================
" ファイルタイプ別の設定
"============================================================================

function! C_Setting()
  if !exists("g:c_tags_set")
    let &tags .= ",".substitute(glob("~/.vim/tags/*.tags"), "\n", ",", "g")
    let g:c_tags_set = 1
  endif
  setlocal isk&
  setlocal nosmartindent
  setlocal fo-=o
  setlocal omnifunc=_MyCComplete
  " インデントレベルを合わせて貼り付け
  nnoremap <buffer> p p=`]`]
  "nnoremap <buffer> n n:redraw<CR>:echo WhatFunction()<CR>
  "nnoremap <buffer> N N:redraw<CR>:echo WhatFunction()<CR>
  inoreab <buffer> switch switch () {<CR>}<Up><C-o>$<C-o>F)<C-r>=Eatchar('\s')<CR>
  inoreab <buffer> case case x:<CR>break;<Up><BS><BS><BS>
  inoreab <buffer> default: default:<CR>break; <Up>
  "inoremap <expr> <CR> ElectricEnter() 
  let b:match_words = &matchpairs 

  " .h 中の関数の宣言へジャンプ
  nnoremap gh yiw:AS<CR>/<C-R>"<CR>
  " 関数プロトタイプヒント
  call InstallFunctionHint()
  syn match FunctionName /\w\+(\@=/
endfunction 

function! _MyCComplete(findstart, base)
  if getline(".") =~ '#include'
    return _CCompleteInclude(a:findstart, a:base)
  else
    return ccomplete#Complete(a:findstart, a:base)
  endif
endfunction

function! _CCompleteInclude(findstart, base)
  if a:findstart
    let line = getline('.')
    let i = max([strridx(line, '"'), strridx(line, '<')])
    if i == -1
      return -1
    else
      return i + 1
    endif
  else
    let res = []
    let basedirList = ['/usr/include/', '/usr/local/include/']
    for basedir in basedirList
      let slashidx = strridx(a:base, '/')
      if slashidx == -1
        let dir = basedir
      else
        let dir = basedir . strpart(a:base, 0, slashidx + 1)
      endif
      for f in split(glob(dir . '*.h'), "\n")
        let f = substitute(f, basedir, '', '')
        if f =~? '^' . a:base
          call add(res, f)
        endif
      endfor
    endfor
    return res
  endif
endfunction
function! Cpp_Setting()
  call C_Setting()
endfunction

function! Csharp_Setting()
  let b:commentSymbol = "//"
  call DefineAbbreb('cl', 'System.Console.WriteLine(#CURSOR#);', 'i', '<buffer>')
endfunction


function! Haskell_Setting()
  syn match HaskellFunction /^\w\+.*::.*$/
  syn match HaskellNegativeError /\s-\d\+/
  hi link HaskellNegativeError Error
  hi HaskellFunction cterm=None ctermfg=None ctermbg=157
  "hi link HaskellFunction hsLineComment
  setlocal list expandtab
  nnoremap <buffer> K :call GUReference(expand('<cword>'), 'r!href', '[href]')<CR>:set ft=haskell<CR>
  let b:commentSymbol = "--"
  setlocal fo -=o
  setlocal iskeyword+='
endfunction

function! Help_Setting()
  setlocal ft=help
  setlocal list
  setlocal isk+=',-,\|
  setlocal tw=0
  setlocal fo=mM
  setlocal conceallevel=0
  syn match Error /\%>79v.*/
endfunction

function! HTML_Setting()
  setlocal noet nolist
  setlocal completefunc=HTMLComplete
  setlocal indentkeys=
  setlocal iskeyword+=-,@
  setlocal dictionary+=~/.vim/dict/htmldict.txt
  inoremap <buffer> <C-x><C-c> <C-o>ma</<C-x><C-o><Esc>`aa
  call DefineAbbreb('cl', 'console.log(#CURSOR#);', 'i', '<buffer>')
  let b:commentSymbol = '//'
  call _EnableCloseTagByCtrlP()
endfunction

function! _EnableCloseTagByCtrlP()
  setlocal omnifunc=htmlcomplete#CompleteTags
  inoremap <buffer> <expr> / _CloseTagByCtrlP()
endfunction

function! _CloseTagByCtrlP()
  let line = getline(".")
  let char = line[col(".") - 2]
  if char == "<"
    if line =~ '^\s*<$'
      return "/\<C-g>u\<C-x>\<C-o>\<Esc>==gi"
    else
      return "/\<C-g>u\<C-x>\<C-o>"
    endif
  else
    return "/"
  endif
endfunction

function! Go_Setting()
  let b:commentSymbol = '//'
endfunction


function! JavaScript_Setting()
  let b:commentSymbol = "//"
  call DefineAbbreb('cl', 'console.log(#CURSOR#);', 'i', '<buffer>')
endfunction

function! Lisp_Setting()
  setlocal list expandtab
  let b:commentSymbol = ";"
endfunction

function! Perl_Setting()
  setlocal nosmartindent
  setlocal complete-=i
endfunction


function! PHP_Setting()
  "setlocal iskeyword+=-
  let b:commentSymbol = "//"
  setlocal autoindent
  " ↓/**のコメントがおかしくなる
  "setlocal indentkeys=0{,0},:,0#,!^F,o,O,e,0=,0),=EO,=else,=cat,=fina,=END,0\\
  setlocal formatoptions=nmMqrwcb
  "nnoremap <buffer> <F5> :!php %<CR>
  nnoremap <C-^> :call ToggleMVC()<CR>
  "nnoremap <buffer> K :call GUReference(expand('<cword>'), 'php', '[php]')<CR>:set ft=php<CR>
  "nnoremap  <buffer> K :sil exe "PHPMan ".expand("<cword>")<CR>
  hi smartyZone cterm=bold
  syn keyword cakephp controller action
  hi cakephp cterm=None ctermfg=5
  syn cluster phpAddStrings add=cakephp
  call InstallFunctionHint()
  nnoremap <silent> vf :<C-u>call PHP_SelectFunction()<CR>
  setlocal indentkeys=0{,0},0),:,!^F,o,O,e,*<Return>,=*/
  "call DefineAbbreb('try', 'try {<Enter>;#CURSOR#<Enter><Up><End><Left><Left><Left><Left><Left><Left><Left><Left><Bs><Down>}<Enter>catch (Exception $ex) {<Enter>echo $ex->getMessage();<Enter>}<Enter>', 'i', '<buffer>')
  call DefineAbbreb('catch', 'catch (Exception $ex) {<Enter>echo $ex->getMessage();<Enter>}', 'i', '<buffer>')
  call _EnableCloseTagByCtrlP()
endfunction


function! JS_SyntaxCheck()
  if executable("js")
    let cmd = "js -C"
  elseif executable("node")
    let cmd = "node -c"
  else
    return -1
  endif
  let result = system(cmd . " " . expand("%"))
  if result != ""
    echo result
    return 0
  endif
  return 1
endfunction

function! Markdown_Setting()
  let b:_exec_system_last_cmd = "0r!md2html #"
endfunction

" 直前のエラーメッセージを表示するには g< が使える
function! Haskell_SyntaxCheck()
  if !executable("stack")
    return -1
  endif
  if _IsEnableAutoExecSystem()
    return 0
  endif
  let result = system("stack --verbosity silent ghc -- ".expand("%") . " -e 'return 0'")
  if result !~? "^0"
    echo result
    return 0
  endif
  return 1
endfunction

function! PHP_SelectFunction()
  if getline('.') =~ 'function\s'
    normal! j
  endif
  call search('^[\w\s]*function .*{', 'bce')
  normal! %v%0
endfunction

function! PHP_SyntaxCheck()
  if !executable("php")
    return -1
  endif
  let result = system("php -lq ".expand("%"))
  if result !~? "^No syntax errors"
    echo result
    return 0
  endif
  return 1
endfunction

command! -nargs=1 PHPMan call _PHPMan("<args>")
function! _PHPMan(name)
  if executable("w3m")
    call ScratchBuffer("[PHPMan]", "split", "delete") | %d
    "new | setlocal bt=nofile bh=delete
    if &enc ==? "cp932" || &enc ==? "sjis"
      let locale = "ja_JP.SJIS"
    elseif &enc ==? "utf8" || &enc ==? "utf-8"
      let locale = "ja_JP.UTF-8"
    elseif &enc ==? "euc-jp"
      let locale = "ja_JP.EUC-JP"
    else
      let locale = "C"
    end
    exe "r!export LANG=".locale." && w3m -dump http://www.php.net/ja/".a:name
    if search("^説明")
      exe "normal! 2kz\<CR>"
    endif
    set ft=php
  else
    echo "w3m does not exist."
  endif
endfunction

function! Python_Setting()
  setlocal ts=4 sts=4 sw=4 et list
  setlocal nosmartindent
  " :h errorformat /python より
  set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
endfunction

function! Ruby_Setting()
  setlocal ts=2 sts=2 sw=2 et
  inoreab <buffer> ei each_with_index
  inoreab <buffer> bp binding.pry<Space><Space><Space>###BREAKPOINT###
  inoreab <buffer> bench <Esc>:r ~/.vim/bench.rb<CR>
  call DefineAbbreb('bb', 'byebug', '', '')
  hi rubyConstant ctermfg=19 ctermbg=None cterm=bold
  if !exists("b:_exec_system_last_cmd")
    let b:_exec_system_last_cmd = "0r!ruby " . expand("%:p")
  endif
endfunction 

function! Ruby_SyntaxCheck()
  if !executable("ruby")
    return -1
  endif
  let result = system("ruby -c ".expand("%"))
  if result !~? "Syntax OK"
    echo result
    return 0
  endif
  return 1
endfunction

function! Python_SyntaxCheck()
  if executable("pyflakes")
    let result = system("pyflakes ".expand("%"))
  else
    let result = system("python3 -m py_compile ".expand("%"))
  endif
  if result != ""
    echo result
    return 0
  endif
  return 1
endfunction

function! Scheme_Setting()
  " Emacs と同じ
  inoremap <buffer> <Esc><C-b> <C-o>%
  inoremap <buffer> <Esc><C-f> <C-o>%<Right>
  nnoremap <silent> <buffer> <F3> ==j
  onoremap <buffer> s a)
  nnoremap <buffer> vs va)
  nnoremap <buffer> \p p:'[,']s@^@; @g<CR>`[2li=> <Esc>:noh<CR>
  let b:commentSymbol = ";"
  let $PAGER="cat"
  let @d = '#?='
  " use, load しているファイルを補完対象に含める。gf などにも関係。
  setlocal suffixesadd=.scm
  setlocal include=(use\ \\\|(load\
  setlocal includeexpr=substitute(substitute(v:fname,'\\./','','g'),'\\.','/','g')
  setlocal path+=/usr/share/gauche/0.8.12/lib
  syn match Error /^Error.*/
endfunction

function! VB_Setting()
  set formatoptions+=ro
  nnoremap <buffer> [[ ?\<\(function\\|sub\\|property\)\>.*(<CR>:noh<CR>
  nnoremap <buffer> ]] /\<\(function\\|sub\\|property\)\>.*(<CR>:noh<CR>
  "setlocal statusline=%n:%f:%{substitute(getcwd(),'.*/','','')}\ %m[%{VB_WhatFunction()}]%=%{(&fenc!=''?&fenc:&enc).':'.strpart(&ff,0,1)}\ %l-%v\ %p%%\ %02B
endfunction

function! VB_WhatFunction()
  let lnum = search('\<\(function\|sub\|property\)\>.*\(\w\+\)(', 'bcnW')
  if lnum == 0
    return "-"
  endif
  let line = getline(lnum) 
  if line =~ "declare function" || line =~ '^\s*'''
    return "-"
  endif
  return matchstr(line, '\w\+(\@=') 
endfunction

function! Vim_Setting()
  setlocal ts=8 sts=2 sw=2 et list
  setlocal tw=0
  let b:commentSymbol="\""
  setlocal formatoptions-=o
  setlocal keywordprg=:help
  " 選択した範囲を vim コマンドとして実行する
  vnoremap <space>e y:@"<CR>
endfunction


"============================================================================
" Grand Unified Programming Environment
" BUGS: まだ unify している途中である。
"============================================================================

" C/C++用のインクルードガード
function! _IncludeGuard()
    let fl = getline(1)
    if fl =~ "^#if"
        return
    endif
    let basename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
    normal! gg
    execute "normal! i#ifndef " . basename . "_INCLUDED"
    execute "normal! o#define " . basename .  "_INCLUDED\<CR>\<CR>\<CR>\<CR>\<CR>"
    execute "normal! Go#endif   /* " . basename . "_INCLUDED */"
    4
endfunction 

" 現在行をコメントトグル
" 選択中はその範囲を
function! _ToggleCommentSelection() range
  let cs = _GetCommentSymbol()
  "let deleteCommentCommand = "normal! ^" . strlen(cs) . "x"
  let deleteCommentCommand = "s@" . cs . "@@e"

  let cl = a:firstline 
  let line = getline(cl)
  if strpart(line, match(line, "[^ \t]"), strlen(cs)) == cs
    let deleteComment = 1
  else
    let deleteComment = 0
  endif 

  while (cl <= a:lastline) 
    if deleteComment
      silent exe deleteCommentCommand
    else
      execute "normal! I" . cs
    endif
    normal! j
    let cl = cl + 1
  endwhile
endfunction

function! _FunctionDescription()
  let indent = &et ? '    ' : "\t"
  let out = []
  call add(out, '/**')
  call add(out, indent . '@brief ')
  " 1行上が空行になっているところまで移動
  exe "normal! ?^\\s*$\<CR>"
  " { までをヤンク
  exe "normal! j\"zy/{\<CR>"
  let line = substitute(@z, '\n', '', 'g')
  let b = stridx(line, '(')
  let e = stridx(line, ')')
  " () の中身を取得
  let innerParen = strpart(line, b+1, e-b-1)
  let fields = split(innerParen, ',')
  let params = []
  for f in fields
    " ポインタの * を型名にくっつける
    let f = substitute(f, '\*\s*', '* ', 'g')
    let f = substitute(f, '\s*\*', '*', 'g')
    " 配列の [] を消去
    let f = substitute(f, '\[.*\]', '', 'g')
    " 空白で区切った最後が仮引数
    call add(params, split(f)[-1])
  endfor
  let width = max(map(copy(params), 'strlen(v:val)'))
  for p in params
    " 可変長引数の ... と void は @param に書かない
    if p != '...' && p != 'void'
      call add(out, indent .'@param ' . p . repeat(' ', width-strlen(p)+1))
    end
  endfor
  let voidpos = match(line, '\<void\>')
  if voidpos >= 0 && voidpos < b
    call add(out, indent . "@return なし")
  elseif line =~ '\<\(\w\+\)::\~\?\1\>'
    " コンストラクタ・デストラクタなら @return は書かない
  else
    call add(out, indent . "@return ")
  endif
  call add(out, '*/')
  call append(line(".")-1, out)
  exe "normal! ?brief \<CR>"
  startinsert!
endfunction


" ウィンドウを閉じることなくバッファをデリート;
command! Bclose call _BufcloseCloseIt()

function! _BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete" . l:currentBufNum)
  endif
endfunction

command! -range InsertSpaceBetweenHankakuZenkaku call InsertSpaceBetweenHankakuZenkaku()
function! InsertSpaceBetweenHankakuZenkaku() range
  '<,'>s/\%(\([^\t -~。、]\)\%([!"#$%&'*+_\-./0-9<=>?A-Za-z~]\)\@=\|\([!"#$%&'*+_\-./0-9<=>?A-Za-z~]\)\%([^\t -~。、]\)\@=\)/\1\2 /ge
endfunction


nnoremap <silent> H :<C-U>call HContext()<CR>
nnoremap <silent> L :<C-U>call LContext()<CR>
vnoremap <silent> H <Esc>:<C-U>call HContext()<CR>mzgv`z
vnoremap <silent> L <Esc>:<C-U>call LContext()<CR>mzgv`z
func! HContext()
  let c = col(".")
  let l = line(".")
  let w = winline()
  exe "normal! " . v:count1 . "H"
  if c == col(".") && l == line(".") && w == winline()
    exe "normal! \<C-f>"
  endif
endfunc

func! LContext()
  let c = col(".")
  let l = line(".")
  let w = winline()
  exe "normal! " . v:count1 . "L"
  if c == col(".") && l == line(".") && w == winline()
    exe "normal! \<C-b>"
  endif
endfunc


" 選択範囲内から検索;
" ちゃんと n や N もその範囲内だけになる;
function! RangeSearch(direction)
    call inputsave()
    let g:srchstr = input(a:direction)
    call inputrestore()
    if strlen(g:srchstr) > 0
        let g:srchstr = g:srchstr.
                    \ '\%>'.(line("'<")-1).'l'.
                    \ '\%<'.(line("'>")+1).'l'
    else
        let g:srchstr = ''
    endif
    set hls
endfunction
command! -nargs=0 -range RangeSearch call RangeSearch('/')|if strlen(g:srchstr) > 0|exe '/'.g:srchstr|endif
command! -nargs=0 -range RangeSearchBackward call RangeSearch('?')|if strlen(g:srchstr) > 0|exe '?'.g:srchstr|endif

" 数値を増加させながら行複製
nnoremap & :<C-U>call IncrementingCopy(v:count ? v:count : 1,"[", "]")<CR> 
function! IncrementingCopy(n, open, close)
  let i=0
  while i < a:n
    normal! yyp
    "s@\[[0-9]\+\]@\=(a:open.(strpart(submatch(0),1)+1).a:close)@ge 
    s@[0-9]\+@\=(submatch(0)+1)@ge 
    let i=i+1
  endwhile 
endfunction

function! Out(command)
  let is_system = 0
  if a:command =~ '^\s*!'
    let is_system = 1
  endif
  if is_system
    let command = substitute(a:command, '^\s*!', '', '')
    let @q = system(command)
  else
    redir @q
    silent exe a:command
    redir END
  endif

  if !exists("b:outbuf")
    call ScratchBuffer("[Out]", "split", "delete")
    sil $put q
    call AdjustWindowHeight(4)
    if is_system
      sil normal! '[kdd
    else
      sil 1,2d
      "sil $d
    endif
    sil! exe "normal! '[z\<CR>"
    let b:outbuf = 1
  else
    normal! G5o
    $put q
    exe "normal! '[z\<CR>"
  endif
endfunction

" 「'」と「"」をトグルする
nnoremap <silent> "" :<C-u>call _ToggleQuote()<CR>
function! _ToggleQuote()
  let save_cursor = getcurpos()

  " どちらかのクォートを検索
  cal search('\(\\\)\@<!\(' . "'" . '\|"\)', 'bc', line('.'))
  let char = getline(".")[col(".")-1]

  if char == "'"
    let replaced = "\""
  elseif char == "\""
    let replaced = "'"
  else
    call _Echo("WarningMsg", "クォートが見つかりませんでした")
    return
  endif
  exe "normal! r" . replaced

  let close_pos = search('\(\\\)\@<!' . char, '')
  exe "normal! r" . replaced

  call setpos('.', save_cursor)
endfunction

function! InsertIfdef() range
  let sym = input("symbol:")
  call append(a:firstline-1, "#ifdef " . sym)
  call append(a:lastline+1, "#endif // " . sym)
endfunction
command! -nargs=0 -range Ifdef <line1>, <line2>:call InsertIfdef()


function! _NextIndent(exclusive, fwd, lowerlevel, skipblanks, offset)
  let line = line('.')
  let column = col('.')
  let lastline = line('$')
  let start_indent = indent(line)
  let stepvalue = a:fwd ? 1 : -1 
  let is_consecutive = 1
  while (line > 0 && line <= lastline)
    let line = line + stepvalue
    if ( ! a:lowerlevel && indent(line) == start_indent ||  a:lowerlevel && indent(line) < start_indent)
      if (! a:skipblanks || strlen(getline(line)) > 0)
        if (a:exclusive)
          let line = line - stepvalue
        endif
        let line += a:offset
        exe line
        exe "normal! " column . "|"
        return
      endif
    endif
  endwhile
endfunc 
" Moving back and forth between lines of same or lower indentation.
" 同じインデントへ移動（下方向）
nnoremap <silent> +  :call _NextIndent(0, 1, 0, 1, 0)<cr>^
" 同じインデントへ移動（上方向）
nnoremap <silent> -  <esc>:call _NextIndent(0, 0, 0, 1, 0)<cr>^
onoremap <silent> +  V:<C-u>call _NextIndent(0, 1, 0, 1, 0)<cr>
onoremap <silent> -  V:<C-u>call _NextIndent(0, 0, 0, 1, 0)<cr>
xnoremap <silent> +  <esc>:call _NextIndent(0, 1, 0, 1, 0)<cr>m'gv''
xnoremap <silent> -  <esc>:call _NextIndent(0, 0, 0, 1, 0)<cr>m'gv''


function! _BufInfo()
  let bufnr = bufnr("%")
  let fullpath = expand("%:p")
  let ls = system('ls -l ' . shellescape(expand('%:p')))
  echo ls
  echo fullpath
  echo getfperm(fullpath)."  ".strftime("%Y-%m-%d %H:%M:%S",getftime(fullpath))."   ".NumberFormat(Bufsize())." bytes (" . FileSizeFormat(Bufsize()) . ")"
  echo "\nタイムスタンプを戻すには："
  call _EchoModifiedTime(fullpath)
endfunction

onoremap <silent> , :<C-u>call _UntilCapitalLetter()<CR>
function! _UntilCapitalLetter()
  call search('[A-Z_]', '', line('.'))
endfunction


function! ForwardWord(no_move_line)
  "call search('\(\W\|^\)\w', 'e')
  let i = 0
  while i < v:count1
    let c = matchstr(getline("."), ".", col(".") - 1)
    let stopline = a:no_move_line ? line(".") : 0

    if c =~ '\W'
      call search('\(\W\|^\)\w\|[^\x00-\xFF]', 'eW', stopline)
    elseif c =~ '[\x00-\xFF]'
      call search('\(\W\|^\)\w\|[^\x00-\xFF]', 'eW', stopline)
      " 2017-02-11 スペース区切りでも止まるようにした
      " call search('\(\W\|^\)\w\|[^\x00-\xFF]\|\s\S', 'eW', stopline)
    else
      normal! w
    endif
    let i = i + 1
  endwhile
endfunction

function! BackwardWord(no_move_line)
  let i = 0
  while i < v:count1
    let c = matchstr(getline("."), ".", col(".") - 1)
    let stopline = a:no_move_line ? line(".") : 0

    if c =~ '\W'
      call search('\(\W\|^\)\w', 'beW', stopline)
    elseif c =~ '[\x00-\xFF]'
      call search('\(\W\|^\)\w', 'beW', stopline)
      " 2017-02-11 スペース区切りでも止まるようにした
      "call search('\(\W\|^\)\w\|\s\S', 'beW', stopline)
    else
      normal! b
    endif
    let i = i + 1
  endwhile
endfunction

function! ForwardParagraph()
  let cnt = v:count1
  let i = 0
  while i < cnt
    if !search('^\s*\n.*\S','W')
      normal! G$
      return
    endif
    let i = i + 1
  endwhile
endfunction

function! GetProtoLine()
  let ret       = ""
  let line_save = line(".")
  let col_save  = col(".")
  let top       = line_save - winline() + 1
  let so_save = &so
  let &so = 0
  let istypedef = 0
  " find closing brace
  keepjumps let closing_lnum = search('^}','cW')
  if closing_lnum > 0
    if getline(line(".")) =~ '\w\s*;\s*$'
      let istypedef = 1
      let closingline = getline(".")
    endif
    " go to the opening brace
    keepjumps normal! %
    " if the start position is between the two braces
    if line(".") <= line_save
      if istypedef
        let ret = matchstr(closingline, '\w\+\s*;')
      else 
        " find a line contains function name
        keepjumps let lnum = search('\w\+(','bcnW')
        if lnum > 0
          let ret = getline(lnum)
        endif
      endif
    endif
  endif
  " restore position and screen line
  exe "keepjumps normal! " . top . "Gz\<CR>"
  keepjumps call cursor(line_save, col_save)
  let &so = so_save
  return ret
endfunction


" Cの場合、[[で十分そう
function! WhatFunction()
  let op = "("
  let cp = ")"
  if exists("b:WhatFunction_LastLine") && b:WhatFunction_LastLine == line(".")
    return op . b:WhatFunction . cp
  endif
  if &ft == "c"
    return op . WhatFunction_C() . cp
  elseif op == "python"
    return op . WhatFunction_Py() . cp
  elseif op == "php"
    return op . WhatFunction_PHP() . cp
  else
    return ""
  endif
endfunction

function! WhatFunction_C()
  let b:WhatFunction_LastLine = line(".")
  if &ft != "c" && &ft != "cpp"
    let b:WhatFunction = ""
    return ""
  endif 
  let proto = GetProtoLine() 
  if proto == ""
    let b:WhatFunction = "-"
    return "-"
  endif 
  if stridx(proto, '(') > 0
    let ret = matchstr(proto, '\w\+(\@=')
  elseif proto =~# '\<struct\>'
    let ret = matchstr(proto, 'struct\s\+\w\+')
  elseif proto =~# '\<class\>'
    let ret = matchstr(proto, 'class\s\+\w\+')
  else
    let ret = strpart(proto, 0, 15) . "..."
  endif 
  let b:WhatFunction = ret
  return ret
endfunction

function! GetProtoLinePy()
  let ret       = ""
  let line_save = line(".")
  let col_save  = col(".")
  let top       = line_save - winline() + 1
  let so_save = &so
  let &so = 0
  let istypedef = 0
  let lnum = search('^\s*\(def\|class\)','bncW')
  return getline(lnum)
endfunction


function! WhatFunction_Py()
  let b:WhatFunction_LastLine = line(".")
  let proto = GetProtoLinePy() 
  if proto == ""
    let b:WhatFunction = "?"
    return "?"
  endif 
  let ret = substitute(proto, '^\s*\(def\|class\)\s*', '', '')
  let ret = substitute(ret, '(.*', '', '')
  let b:WhatFunction = ret
  return ret
endfunction

function! GetProtoLinePHP()
  let ret       = ""
  let line_save = line(".")
  let col_save  = col(".")
  let top       = line_save - winline() + 1
  let so_save = &so
  let &so = 0
  let istypedef = 0
  let lnum = search('function\s\+\w\+(','bncW')
  return getline(lnum)
endfunction

function! WhatFunction_PHP()
  if exists("b:WhatFunction_LastLine") && b:WhatFunction_LastLine == line(".")
    return b:WhatFunction
  endif
  let b:WhatFunction_LastLine = line(".")
  let proto = GetProtoLinePHP() 
  if proto == ""
    let b:WhatFunction = "?"
    return "?"
  endif 
  let ret = substitute(proto, '.*function\s\+\(\w\+\).*', '\1', '')
  let b:WhatFunction = ret
  return ret
endfunction



" ==========================================================================
" ▼ 共通に使うライブラリ関数 Library
" ==========================================================================
function! Trim(str)
  return substitute(a:str, '\%(^\s\+\|\s\+$\)', '', 'g')
endfunction

function! TrimLeft(str)
  return substitute(a:str, '^\s\+', '', 'g')
endfunction

function! TrimRight(str)
  return substitute(a:str, '\s\+$', '', 'g')
endfunction

function! StringCount(str, needle)
  let result = 0
  let pos = 0
  while 1
    let pos = stridx(a:str, a:needle, pos)
    if pos < 0
      break
    endif
    let result += 1
    let pos += strlen(a:needle)
  endwhile
  return result
endfunction

function! StringRepeat(str, count)
  let s = ""
  let i = 0
  while i < a:count
    let s = s . a:str
    let i = i + 1
  endwhile
  return s
endfunction

function! GetSelectedText()
  let a_save = @a
  silent normal! gv"ay
  let selected = @a
  let @a = a_save
  return selected
endfunction

function! GetParagraphText()
  exe "normal! vip\<Esc>"
  return GetSelectedText()
endfunction

function! Bufsize()
  return line2byte(line("$") + 1) - 1
endfunction

function! FileSizeFormat(num)
  let num = a:num
  if num < 1024
    return num . ' B'
  elseif num < 1024 * 1024
    return (num / 1024) . ' KB'
  elseif num < 1024 * 1024 * 1024
    return (num / 1024 / 1024) . ' MB'
  elseif num < 1024 * 1024 * 1024
    return (num / 1024 / 1024 / 1024) . ' GB'
  endif
endfunction

" 数値を3桁カンマ区切り文字列にする
function! NumberFormat(num)
  let num = a:num
  let ret = ''

  if num > 0
    let sign = 1
  elseif num < 0
    let sign = -1
    let num = -1 * num
  elseif num == 0
    return '0'
  endif

  while num > 0
    let next = num / 1000
    if next > 0
      let ret = ',' . printf('%03d', num % 1000) . ret
    else
      let ret = (num % 1000) . ret
    endif
    let num = next
  endwhile

  if sign < 0
    let ret = '-' . ret
  endif

  return ret
endfunction

function! GetBufferNumberByName(name, ignorecase)
  let buflist = filter(range(1, bufnr("$")), 'bufexists(v:val)')
  for bufnr in buflist
    if (a:ignorecase && bufname(bufnr) ==? a:name) || bufname(bufnr) ==# a:name
      return bufnr
    end
  endfor
  return -1
endfunction

" 指定した名前を持つバッファが既に存在するならそこにカーソルを移動。
" 存在しないなら作成。
function! SingletonBuffer(name, splitcmd)
  let name = a:name
  if bufexists(name)
    let bufnr = GetBufferNumberByName(name, 0)
    let winlist = WindowContains(bufnr)
    if empty(winlist)
      exe a:splitcmd
      exe "b " . bufnr
    else
      exe winlist[0] . "wincmd w"
    endif
  else
    exe a:splitcmd
    exe "sil e " . escape(name, ' ')
  endif
endfunction

command! -nargs=? Scratch call Scratch("<args>")
function! Scratch(cmd)
  call ScratchBuffer("SCRATCH", "split", "hide") 
  exe a:cmd
endfunction
function! ScratchBuffer(name, split, bufhidden)
  call SingletonBuffer(a:name, a:split)
  exe "set buftype=nofile bufhidden=" . a:bufhidden
  set noswapfile
  nnoremap <silent> <buffer> q :close<CR>
endfunction

" 指定したバッファを含んでいるウィンドウ番号のリストを返す。
function! WindowContains(bufnr)
  return filter(range(1, winnr("$")), 'winbufnr(v:val)==' . a:bufnr)
endfunction

function! _FindWindow(cond)
  return filter(range(1, winnr("$")), a:cond)
endfunction

function! AdjustWindowHeight(minheight)
  let current_h = winheight(".")
  let height = line("$") + 1
  if height < a:minheight 
    let height = a:minheight
  endif
  if current_h >  height
    exe height . "wincmd _"
  endif
  setlocal winfixheight
endfunction

" バッファ内でパターンにマッチするテキストを返す
function! GetTextByPattern(pattern, flags)
  let spos = searchpos(a:pattern, '' . a:flags)
  let epos = searchpos(a:pattern, 'e' . a:flags)
  return join(GetLines(spos[0], spos[1], epos[0], epos[1]), "\n")
endfunction

" バッファ内のテキストを取得する
function! GetLines(sl, sc, el, ec)
  let lines = map(range(a:sl, a:el), 'getline(v:val)')
  if a:sl == a:el
    let lines[0] = strpart(lines[0], a:sc - 1, a:ec - a:sc + 1)
  else
    let lines[0]  = strpart(lines[0],  a:sc - 1)
    let lines[-1] = strpart(lines[-1], 0, a:ec)
  end
  return lines
endfunction

" ==========================================================================
" ▲ 共通に使うライブラリ関数
" ==========================================================================


nnoremap <C-w>gf :call GfInOtherWindow()<CR>
function! GfInOtherWindow()
  if winnr("$") != 1
    only
  endif
  sp
  normal! gF
endfunction

"nnoremap <CR> :call OpenInOtherWindow()<CR>
function! OpenInOtherWindow()
  let fname = b:cwd . "/" . getline(".")
  wincmd w
  exe "e " . fname
endfunction

function! _RemoveLastSearchHistory()
  call histdel("search", -1)
  let @/=histget("search", -1)
  nohlsearch
endfunction

function! _ExpandTemplate()
  silent %s@<?vim\(.\{-}\)?>@\=eval(submatch(1))@ge
endfunction

function! LoadTemplate2()
  let suffix = expand("%:e")
  let template = expand("~/.vim/template." . suffix)
  if file_readable(template)
    exe "0r " . template
    silent $d
    call _ExpandTemplate()
    1
  else
    if suffix ==? "cl"
      call append(0, ["#!/usr/bin/env clisp"])
    elseif suffix ==? "h" || suffix ==? "inl"
      call _IncludeGuard() 
    else
      return
    endif
  endif
endfunction


" Christian J. Robinson <infynity@onewest.net>
" http://www.vim.org/scripts/script.php?script_id=1928
command! -nargs=* -complete=file -bang Rename :call Rename("<args>", "<bang>")
function! Rename(name, bang)
  if stridx(a:name, '/') == -1
    let dir = expand("%:p:h") . '/'
  else
    let dir = ''
  endif
  let l:curfile = expand("%:p")
  let v:errmsg = ""
  silent! exe "saveas" . a:bang . " " . fnameescape(dir . a:name)
  if v:errmsg =~# '^$\|^E329'
    if expand("%:p") !=# l:curfile && filewritable(expand("%:p"))
      silent exe "bwipe! " . l:curfile
      if delete(l:curfile)
        echoerr "Could not delete " . l:curfile
      endif
    endif
  else
    echoerr v:errmsg
  endif
endfunction

function! _GetExecSystemDefault()
  let filepath = expand("%:p")
  let filename = expand("%")
  let ret = ""
  if 0
  elseif &ft ==? "c" || &ft ==? "cpp"
    let ret = "0r!gcc " . filename . " && ./a.out"
  elseif &ft ==? "javascript"
    let ret = "0r!js " . filename
  elseif &ft ==? "perl"
    let ret = "0r!perl " . filename
  elseif &ft ==? "php"
    let ret = "0r!php " . filename
  elseif &ft ==? "python"
    let ret = "0r!python " . filename
  elseif &ft ==? "ruby"
    let ret = "0r!ruby " . filename
  elseif &ft ==? "sh"
    let ret = "0r!bash " . filename
  elseif &ft ==? "vbs"
    let ret = "0r!cygstart " . filename
  elseif &ft ==? "go"
    let ret = "0r!go run " . filename
  elseif &ft ==? "scheme"
    let ret = "0r!gosh " . filename
  elseif &ft ==? "markdown"
    let ret = "0r!make "
  else
    let ret = "0r!a " . filename
  endif
  return ret
endfunction

function! ExecSystem(mode, ...)
  let filepath = expand("%:p")
  let bufnr = bufnr("%")
  let winnr = winnr()
  let dir = getcwd()
  let out_windows = _FindWindow('bufname(winbufnr(v:val))=="_out_"')
  for w in out_windows
    exe w . "wincmd c"
  endfor
  let orig_winheight = winheight(".")

  let mode = a:mode

  if filepath == ""
    echomsg "ファイル名がついていません"
    return
  elseif (!filereadable(filepath) || getbufvar(bufnr, "&modified")) && &buftype != "nofile"
    w
  endif

  " コマンドを入力
  if mode == 'last' && !exists('b:_exec_system_last_cmd')
    let mode = 'input'
  endif

  if mode == 'input' "コマンドを入力させる
    if exists('b:_exec_system_last_cmd')
      let input_default = b:_exec_system_last_cmd
    else
      let input_default = _GetExecSystemDefault()
    endif
    let cmd = input("Vim:", input_default)
  elseif mode == 'last' " 前回と同じ
    let cmd = b:_exec_system_last_cmd
  elseif mode == 'argument'  " 関数の引数でコマンドを指定
    let cmd = a:000[0]
  else
    echomsg "ExecSystem: Invalid argument [" . a:mode . "]"
    return
  endif

  if getbufvar(bufnr, "auto_exec_count") == ""
    call setbufvar(bufnr, "auto_exec_count", 0)
  endif
  call setbufvar(bufnr, "auto_exec_count", getbufvar(bufnr, "auto_exec_count") + 1)
  if cmd != ""
    let b:_exec_system_last_cmd = cmd

    call ScratchBuffer("_out_", "split", "hide") | %d
    setlocal nobuflisted
    exe "chdir " . dir
    sil! exec cmd

    if strpart(cmd, 0, 3) == '0r!'
      silent normal! Gdd
    endif

    let current_h = winheight(".")
    let height = line("$") + 1
    if height > orig_winheight / 2
      let height = orig_winheight / 2
    endif
    exe height . "wincmd _"
    setlocal winfixheight
    setlocal nonu
    normal! 1G
  endif
  exe winnr . "wincmd w"
  redraw

  if getbufvar(bufnr, "auto_exec_count") == 1
    if confirm("保存時に自動実行するようにしますか？", "&Y\n&N") == 1
      let b:enable_auto_exec_system = 1
    endif
  endif
  if !exists("b:enable_auto_exec_system")
    let b:enable_auto_exec_system = 0
  endif
endfunction

command! -nargs=? SetAutoExec call _SetAutoExec(<q-args>)
function! _SetAutoExec(arg)
  if !exists("b:enable_auto_exec_system")
    let b:enable_auto_exec_system = 0
  endif
  if a:arg == "1"
    let b:enable_auto_exec_system = 1
  elseif a:arg == "0"
    let b:enable_auto_exec_system = 0
  else
    let b:enable_auto_exec_system = !b:enable_auto_exec_system
  endif
  echo "AutoExec " . (b:enable_auto_exec_system ? "on" : "off")
endfunction
function! _AutoExecSystem()
  if exists('b:_exec_system_last_cmd') && _IsEnableAutoExecSystem()
    call ExecSystem('last')
  endif
endfunction
function! _IsEnableAutoExecSystem()
  return (exists('b:enable_auto_exec_system') && b:enable_auto_exec_system)
endfunction

command! -nargs=* Repeat call _Repeat(<f-args>)
" 現在行の #i#を置換し、繰り返す
" 現在行の #printf("%03d", i)#で001～
function! _Repeat(...)
  if a:0 < 2
    let i   = str2nr(input("i="))
    let max = str2nr(input("to:"))
    let step = 1
  else
    let i   = str2nr(a:1)
    let max = str2nr(a:2)
    if exists("a:3")
      let step = a:3
    else
      let step = 1
    endif
  endif
  let line = getline(".")
  delete _

  while i <= max
    call append(line(".")-1, substitute(line, '#\(.\{-}\)#', '\=eval(submatch(1))', 'g'))
    "normal! j
    let i = i + step
  endwhile
endfunction

augroup LoadLocalVim
  au!
  au VimEnter * call _LoadLocalVim()
augroup Load

function! _LoadLocalVim()
  let start_dir = getcwd()
  let prev_dir = ""
  while 1
    let cur_dir = getcwd()
    if cur_dir == prev_dir
      exe "lcd " . escape(start_dir, ' ')
      break
    endif
    if filereadable(".vimrc.local") && getcwd() != expand("$HOME")
      source .vimrc.local
      "call _Echo("Question", "LoadLocalVim: Loaded " . cur_dir . "/local.vim")
    endif
    let prev_dir = cur_dir
    silent lcd ..
  endwhile
endfunction

function! _GetAllDirectoriesToRoot()
  let start_dir = getcwd()
  let prev_dir = ""
  let ret = []
  while 1
    let cur_dir = getcwd()
    if cur_dir == prev_dir
      exe "lcd " . escape(start_dir, ' ')
      return ret
    endif
    call add(ret, cur_dir)
    let prev_dir = cur_dir
    silent lcd ..
  endwhile
endfunction

function! ToggleSourceAndHeader(opencmd, ...)
  let dirname = expand("%p:h")
  let basename = expand("%:p:r")
  let suffix = expand("%:e")
  let ft = &ft
  if a:0 >= 1 && a:1 != ''
    let af = basename . "." . a:1
  else
    let af = ""
    if suffix ==? "c"
      let af = basename . ".h"
    elseif suffix ==? "cpp"
      if filereadable(basename . ".hpp")
        let af = basename . ".hpp"
      else
        let af = basename . ".h"
      endif
    elseif suffix ==? "h"
      if filereadable(basename . ".cpp")
        let af = basename . ".cpp"
      else
        let af = basename . ".c"
      endif
    elseif suffix ==? "php"
      if file_readable(basename . "_v.inc")
        let af = basename . "_v.inc"
      elseif file_readable(basename . ".inc")
        let af = basename . ".inc"
      else
        call _PHP_ToggleFile()
      endif
    elseif suffix ==? "ctp"
      call _PHP_ToggleFile()
    elseif suffix ==? "inc"
      let af = substitute(basename, '_v$', '', '') . ".php"
    else
      " それ以外の場合:
      " globして見つける
      let pattern = basename . ".*"
      let files = glob(pattern, 0, 1)
      let af = ""
      if len(files) > 0
        call add(files, files[0])
        for i in range(0, len(files) - 2)
          let file = files[i]
          let suf = substitute(file, '.*\.', '', '')
          if suf == suffix
            let af = files[i + 1]
          endif
        endfor
      endif
      if af == ""
        call _Echo("WarningMsg", "切り替えるべきファイルが見つかりません")
        return
      endif
    endif
  endif
  exe a:opencmd af
endfunction



command! RemoveThis call _RemoveThis()
function! _RemoveThis()
  let name = expand('%:t')
  call system('rm ' . shellescape(expand('%:p')))
  Bclose
  echomsg "Removed " . name
endfunction

"=============================================================================
"   プラグイン設定  Plugsin settings
"=============================================================================
let g:ruby_indent_access_modifier_style = "outdent"

runtime macros/matchit.vim

" format.vim
let g:format_allow_over_tw = 0

" netrw
let g:netrw_use_errorwindow = 0
let g:netrw_uid = "s-aoyama"
let g:netrw_liststyle=3   " ツリースタイル
let g:netrw_winsize = -25 " マイナスなら絶対値、プラスならパーセンテージ
let g:netrw_browse_split = 4 " 0:デフォルト 1:横分割 2:縦分割 3:新タブ 4:Pと同様
let g:netrw_keepdir = 0 " 0だとディレクトリ上で<CR>を押したときcdする

" NERDTree
let g:NERDTreeWinPos =  'right'
let g:NERDTreeMapPreview =  'f'
let g:NERDTreeMapToggleFilters =  'a'
let g:NERDTreeAutoDeleteBuffer=1
let g:NERDTreeShowHidden=1
let g:NERDTreeIgnore=['\.o$']
let g:MyNERDTreeRemoveFileCmd = executable("rma.sh") ? "rma.sh" : "rm"

function! Nerdtree_Setting()
  nmap <buffer> <expr> <C-n> _Nerdtree_Preview("down")
  nmap <buffer> <expr> <C-p> _Nerdtree_Preview("up")
  nmap <buffer> <C-j> 3j
  nmap <buffer> <C-k> 3k
  nnoremap <buffer> <C-f> <C-w><C-p><C-f><C-w><C-p>
  nnoremap <buffer> <C-b> <C-w><C-p><C-b><C-w><C-p>
  nnoremap <buffer> <C-e> <C-w><C-p>3<C-e><C-w><C-p>
  nnoremap <buffer> <C-y> <C-w><C-p>3<C-y><C-w><C-p>
endfunction

function! _Nerdtree_Preview(dir)
  let regexp = '/$'
  if a:dir == "down"
    let line = Trim(getline(line(".") + 1))
    if line =~ regexp
      return "j"
    else
      return "jf"
    endif
  else
    let line = Trim(getline(line(".") - 1))
    if line =~ regexp
      return "k"
    else
      return "kf"
    endif
  endif
endfunction

function! _ShowNERDTree()
  if &ft == 'nerdtree'
    wincmd p
    return
  end
  let idx = index(map(range(1,winnr("$")), 'getwinvar(v:val, "&ft")'), 'nerdtree')
  if idx != -1
    exe (idx + 1) . "wincmd w"
  else
    NERDTree
  endif
endfunction

" markdown で```rbの記法を有効にする
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'ruby', 'rb=ruby', 'javascript', 'js=javascript', 'php']

" CtrlP
" ctrlp_follow_symlinks
"   0 - don't follow symbolic links.
"   1 - follow but ignore looped internal symlinks to avoid duplicates.
"   2 - follow all symlinks indiscriminately.
let g:ctrlp_follow_symlinks = 2
let g:ctrlp_switch_buffer = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](' . join(map(exclude_dirs, "substitute(v:val, '\\.', '\\.', 'g')"), '|') . ')$',
  \ 'file': '\v\.(o)$',
  \ }

function! MyFoldText()
  let line = getline(v:foldstart)
  let before = line
  let indent = matchstr(line, '^\t*')
  let line = substitute(line, '^\t*', StringRepeat(' ', &tabstop * strlen(indent)), '')
  return line . '          [' . (v:foldend - v:foldstart) . '行]'
endfunction

command! Fold call Fold()

function! Fold()
  set foldmethod=manual
  if &ft == 'php'
    let save_cursor = getpos(".")
    normal! gg0
    while search('function\s\+\w\+(', 'ceW')
      if search('{', 'c')
        normal! zf%j
      endif
    endwhile
    call setpos(".", save_cursor)
  endif
endfunction

function! _MemorizeModifiedTime()
  if !exists('b:modified_time_list')
    let b:modified_time_list = []
  endif
  call add(b:modified_time_list, getftime(expand("%:p")))
endfunction

function! _EchoModifiedTime(fullpath)
  if !exists('b:modified_time_list')
    let b:modified_time_list = []
  endif
  for time in b:modified_time_list
    echo "!touch -t " . strftime("%Y%m%d%H%M.%S", time) . " " . a:fullpath
  endfor
endfunction

" カレントファイルのパスを正規表現でマッチングしてオプションをセットするプラグイン
augroup MatchConfig
  au!
  au BufNewFile,BufReadPost * call _MatchConfig()
augroup END

function! _MatchConfig()
  if !exists('g:MatchConfig')
    return
  endif

  if exists('b:editorconfig_applied')
    return
  endif

  let path = expand('%:p')

  for config in g:MatchConfig
    if path =~? config["regexp"]
      let cmd = config["cmd"]
      exe cmd
    endif
  endfor
endfunction

function! SetMatchConfig(regexp, cmd)
  if !exists('g:MatchConfig')
    let g:MatchConfig = []
  endif
  call add(g:MatchConfig, {"regexp": a:regexp, "cmd": a:cmd})
endfunction

call SetMatchConfig('.*\.rb', "setlocal ts=2 sts=2 sw=2 et")
call SetMatchConfig('Makefile', "setlocal noet")

function! _SetDict()
  exe "setlocal dictionary+=~/.vim/dict/" . &ft . "dict.txt"
endfunction
command! Dict exe "e ~/.vim/dict/" . &ft . "dict.txt"

"=============================================================================
"   ▼実験室  Experimental
"=============================================================================

function! _GetKeywordBeforeCursor()
  let str = strpart(getline('.'),0,col('.')-1)
  let str = substitute(str, '\W*$', '', '')
  let word = matchstr(str, '\k\+$')
  return word
endfunction

function! _FunctionHint()
  let word = _GetKeywordBeforeCursor()
  if word == "if" || word == "for" || word == "while" || word == "switch" || word == ""
    return ''
  endif
  call _ShowFunctionHint(word, 0)
  return ''
endfunction

function! InstallFunctionHint()
  "inoremap <silent> <buffer> ( (<C-o>:call _FunctionHint()<CR>
  " <expr>でマッピングすると、補完して直後に(を押したとき、ヒントが表示されない
  inoremap <silent> <buffer> ( (<C-r>=_FunctionHint()<CR>
  " showmodeにしていると、PHPの引数表示が上書きされてしまう
  set noshowmode
endfunction

if has("python")
function! _ShowFunctionHint(word, insert)
  if !exists('g:_show_function_hint_inited')
    pyf ~/.vim/macros/hint.py
    py import vim
    let g:_show_function_hint_inited = 1
  endif
  let word = a:word
  let insert = a:insert
  py << PY_END
the_hint = hint.get(vim.eval('&ft'), vim.eval('word'))
if the_hint != None and vim.eval('insert') == '1':
    vim.current.buffer.append(vim.eval('_GetCommentSymbol()') + ' ' + the_hint, vim.current.window.cursor[0] - 1)
    vim.current.window.cursor = (vim.current.window.cursor[0] + 1, vim.current.window.cursor[1])
vim.command('echohl Search | echomsg "%s" | echohl None' % (the_hint)) 
PY_END
endfunction
else
function! _ShowFunctionHint(word, insert)
  let word = a:word
  let view = winsaveview()
  if !bufexists('HINT')
    exe "sil! e ~/.vim/ftplugin/" . &ft . "/HINT"
  else
    sil! b HINT
  endif
  set nobuflisted
  1
  if word != search('^'.word."\t")
    let x =  substitute(getline("."), "^[^\t]*\t", "", "")
  else
    let x = ""
  endif
  let @h = x
  sil! b#
  call winrestview(view)
  call _Echo("Search", x)
endfunction
endif

" 巨大なファイルを読みこむとき
" ・シンタックスオフ
" ・スワップファイルを作らない
" など
augroup LargeFile
  au!
  autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > 1024 * 1024 * 1 | set eventignore+=FileType | setlocal noswapfile | let b:IsLargeFile = 1 | else | set eventignore-=FileType | endif
augroup END

command! -range=% Ret24 <line1>,<line2> call retab#Retab(2, 4)
command! -range=% Ret42 <line1>,<line2> call retab#Retab(4, 2)

" ペーストしたときカーソルを末尾へ移動。さらにgvで範囲選択できるように
nmap p pv`]v

" ビジュアルモードでヤンクするたびに~/.yankに保存する
" screenで<C-t><C-v>で貼り付けられる
" ~/svn/bin/yankコマンドで取得できる
" もしyにマップするのがまずいようだったらYとか<C-y>に変える
vnoremap <silent> y y:call _YankToFile('0', 0)<CR>`]
nnoremap <silent> yy yy:call _YankToFile('0', 0)<CR>
" 現在のレジスタを~/.yankに保存し、screenで<C-t><C-v>で貼り付けられるようにする
nnoremap <silent> <C-x><C-y> :call _YankToFile('0', 1)<CR>
nnoremap <silent> <C-x><C-b> :let @0 = "b " . expand("%").":".line(".")<CR>:call _YankToFile('0', 1)<CR>
command! PutFromFile r ~/.yank
function! _YankToFile(reg, show_message)
  let yankfile = "~/.yank"
  let lines = split(getreg(a:reg), "\n")
  call writefile(lines, expand(yankfile), "b")
  " http://www.evernote.com/l/ANNgwtCY7uFA1r3MQy2PUS_F2rVP3zA9ojM/
  "if $TERM =~ 'screen'
    "call system("USER=ao screen -X readbuf")
  "endif
  if a:show_message
    if getregtype(a:reg) ==# "v"
      let msg = "Copied " . lines[0] . " to " . yankfile
    else
      let msg = "Copied " . len(lines) . " lines to " . yankfile
    endif
    echomsg msg
  endif
endfunction
"=============================================================================
"   ▲実験室  Experimental
"=============================================================================

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
