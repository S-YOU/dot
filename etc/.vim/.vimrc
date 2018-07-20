"==================================================================
"   Vim Setting 
"===================================================================

" 積極的に使うべき機能
" + で同じインデントの次の行へ移動
" V+ で同じインデントの範囲を選択。同様にd+で削除。
" <Space>ff でsyntaxにより折り畳む
"
" まだマッピングに使っていないキー
" <C-_>
" <C-\>

scriptencoding utf-8
set enc=utf-8

call plug#begin('~/.vim/plugged')
  Plug 'editorconfig/editorconfig-vim'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'henrik/vim-indexed-search'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  Plug 'scrooloose/nerdtree'
call plug#end()

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
set t_Co=256
set timeoutlen=2000
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
" grepなどで無視するディレクトリ
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
set ambiwidth=double

" ファイル --------------------------------------------------------
set nofixendofline
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
set cinoptions=t0,g0,(0
set cinkeys-=0#
set indentkeys-=0#
set smarttab
" タブの設定について
"    1. 基本は4
"    2. Rubyなどファイルタイプで決まっている場合はFileTypeで上書きする
"    3. プロジェクト固有のものは ~/.vimrc.local のMatchConfigで上書きする
" 設定もこの順番で行われる
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set shiftround
set backspace=indent,eol,start
set formatoptions=tcqnmM
set virtualedit=block
if has("xterm_clipboard")
  set clipboard=unnamed
endif

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
set statusline=%n:\ %F\ %m%{&buftype=='nofile'?'[NOFILE]':''}%{index(['i','R','Rv'],mode())!=-1?'\ \ --INSERT--\ ':''}%{&paste==1?'[PASTE]':''}%{WhatFunction()}%=%l,%v\ (%p%%)\ %{&ft}\ %{(&et?'space':'tab').':'.(&sw)}\ %{(&fenc!=''?&fenc:&enc).(&bomb?'bom':'').':'.strpart(&ff,0,1)}
set tabline=%!_MyTabLine()
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
set noshowmode

augroup Gdb
  au!
  au VimEnter * call _DetectGdb()
augroup END

function! _DetectGdb()
  if exists("$GDB_RUNNING")
    mark A
    sign define current_line text=> texthl=StatusLine
    sign define breakpoint text=.  texthl=Breakpoint
    exe "sign place 1 line=" . line(".") . " name=current_line file=" . expand("%:p")
    call _SetBreakpointSigns(_ReadGdbBreakpoints())
  endif
endfunction

function! _ReadGdbBreakpoints()
  let ret = []
  let fname = "/tmp/gdb-ed.tmp"
  if !filereadable(fname)
    return
  endif
  let lines = readfile(fname)
  for line in lines
    let a = split(line)
    if a[0] != "" && a[1] == "breakpoint"
      let enabled = a[3]
      if enabled == "y"
        let re = '\(\S\+\):\(\d\+\)$'
        let matchpos = match(line, re)
        let location = strpart(line, matchpos)
        let filename = substitute(location, re, '\1', '')
        let linenum = substitute(location, re, '\2', '')
        call add(ret, [filename, linenum])
      endif
    endif
  endfor
  return ret
endfunction

function! _SetBreakpointSigns(bps)
  try
    let current_file = expand("%:t")
    let bufnr = bufnr("%")
    let sign_id = 100
    for bp in a:bps
      let fname = bp[0]
      let linenum = bp[1]
      if fname == current_file
        exe "sign place " . sign_id . " line=" . linenum . " name=breakpoint buffer=" . bufnr
        let sign_id = sign_id + 1
      endif
    endfor
  catch
    echomsg v:exception
  endtry
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
inoremap <silent> <C-l> <Esc>g~awgi
vnoremap <silent> <C-l> g~
nnoremap <silent> n :<C-u>call _SearchNext("n")<CR>
nnoremap <silent> N :<C-u>call _SearchNext("N")<CR>
nnoremap <silent> <Esc>o <C-i>

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
nnoremap S :<C-u>%s;\C\<<C-r><C-w>\>;<C-r><C-w>;gc<Left><Left><Left>
noremap <silent> # :call _ToggleCommentSelection()<CR>
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
nnoremap <C-x><C-u> <Esc>mz:<C-u>.!urldecode<CR>`z
vnoremap <C-x><C-u> :!urldecode<CR>

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

" 関数を範囲選択
nnoremap vf ][v[[?^s*$<CR>
" for などのブロックを選択。カーソル位置を for の行におく必要がある。
nnoremap vb /{<CR>%v%0
" １つの引数を選択
nnoremap vaa ?\(,\\|(\)<CR>lv/\(,\\|)\)<CR>
nmap caa vaac

nnoremap <Space>o :<C-u>call _EnterPasteMode(1)<CR>I
nnoremap <Space>O :<C-u>call _EnterPasteMode(0)<CR>I

function! _EnterPasteMode(is_below)
  if getline(".") != ""
    if a:is_below
      call append(line("."), "")
      normal! j
    else
      call append(line(".") - 1, "")
      normal! k
    endif
  endif
  set paste
endfunction

" バッファ・ウィンドウ ----------------------------------------------
nnoremap <silent> <C-p> :<C-u>Files <C-r>=_GetProjectRoot()<CR><CR>
nnoremap <space>i :<C-u>Buffers<CR>
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
xnoremap <silent> <Space>r <C-c>:<C-u>call EvalSelection()<CR>

" 機能トグル
command! ShowTabstop echo (&list ? 'list' : 'nolist') (&et ? 'expandtab' : 'noexpandtab') 'ts=' . &ts . ' sts=' . &sts . ' sw=' . &sw
nnoremap <C-h> :bp<CR>
nnoremap <C-l> :bn<CR>
"nnoremap <C-l>      :nohl<CR>:redraw!<CR>:set list!<CR>:ShowTabstop<CR>
nnoremap <C-@>l     :set list!<CR>:ShowTabstop<CR>
nnoremap <C-@>2     :set ts=2 sts=2 sw=2<CR>:set ts?<CR>
nnoremap <C-@>4     :set ts=4 sts=4 sw=4<CR>:set ts?<CR>
nnoremap <C-@>8     :set ts=8 sts=8 sw=8<CR>:set ts?<CR>
nnoremap <C-@><C-e> :set expandtab!<CR>:set expandtab?<CR>
nnoremap <C-@><C-f> :set foldenable!<CR>:set foldenable?<CR>
nnoremap <C-@><C-n> :set number!<CR>:set number?<CR>
nnoremap <C-@><C-w> :set wrap!<CR>:set wrap?<CR>
nnoremap <C-@><C-u> :set cuc!<CR>
nnoremap <C-@><C-@> :noh<CR>:redraw!<CR>

" その他 ----------------------------------------------------------- 

" コマンドライン
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <expr> <C-d> (getcmdtype() == ":" && getcmdpos() == 1 ? "b \<C-d>"  : (getcmdpos()==strlen(getcmdline())+1 ? "\<C-d>" : "\<Del>"))
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
cnoremap <C-z> <C-r>=substitute(getreg('"'), '\n', '', 'g')<CR>

" コマンドラインへパスなどを挿入
cnoremap <expr> <C-t>  "代わりに C-j を使ってください"
cnoremap <expr> <C-j>  _GetProjectRoot() . "/\<C-d>"
cnoremap <expr> <C-x>d expand("%:p:h")
cnoremap <expr> <C-x>f expand("%:t")
cnoremap <expr> <C-x>p expand("%:p")

function! _GetProjectRoot()
  let a = system("pjroot")
  let a = substitute(a, "\n", "", "")
  if a == "not exist"
    let a = getcwd()
  end
  let a = substitute(a, expand("$HOME"), "~", "")
  return a
endfunction

command! CDPjRoot exe "cd " . _GetProjectRoot() | pwd

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

command! -nargs=+ Grep let shellpipe_save = &shellpipe | set shellpipe=&> | silent grep <args> | let &shellpipe=shellpipe_save | call _SetSearchRegister(<f-args>) | botright cw | redraw! | if len(getqflist()) == 0 | call _Echo("WarningMsg","検索結果: 0件") | endif | set hls
function! _SetSearchRegister(...) abort
  let len = len(a:000)
  let @/ = a:000[len - 1]
endfunction

" 読み込まれているバッファを対象にgrepする
nnoremap <space>b :<C-u>Brep<space>
nnoremap <Space>B :<C-u>Brep<Space><C-r><C-w>
command! -nargs=+ Brep call _Bufgrep(<f-args>)
function! _Bufgrep(...) abort
  let query = ''
  let ignorecase = 0
  let word_wise = 0
  for arg in a:000
    if arg == '-i'
      let ignorecase = 1
    elseif arg == '-w'
      let word_wise = 1
    else
      if query == ''
        let query = arg
      else
        let query .= ' ' . arg
      endif
    endif
  endfor
  let query = substitute(query, '/', '\\/', 'g')
  if word_wise
    let query = '\<' . query . '\>'
  endif
  if ignorecase
    let query = '\c' . query
  else
    let query = '\C' . query
  endif

  cclose
  call setqflist([])
  let bn = bufnr("%")
  exe "sil! bufdo! vimgrepadd /" . query . "/jg %"
  let qflen = len(getqflist())
  if qflen == 0
    sil! exe "b" . bn
    call _Echo("WarningMsg","検索結果: 0件")
  else
    cfirst
  endif
endfunction

" 全バッファに対して置換する
" 検索文字列：@/
" 置換文字列：第1引数
" 使い方: Replace hoge
" bufdo s@hoge@moge@gce との違いは、unlistedなバッファも対象にすること
command! -nargs=1 Replace call _ReplaceAll("<args>")

function! _ReplaceAll(replaced_str)
  let separator = "\x01"
  let cmd = "%s" . separator . separator . a:replaced_str . separator . "ge | sil update"

  if exists(":cfdo")
    exe "cfdo " . cmd
    return
  endif

  " QuickFixウィンドウで実行するとなぜかエラーが出るので、カーソルを別ウィンドウに移動する
  if &ft == "qf"
    wincmd w
  endif
  let orig_bufnr = bufnr("%")
  call _LoadAllFilesInQuickfixList()
  bufdo exe cmd
  exe "b" orig_bufnr
endfunction

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

function! DefineAbbrev(abb, content, type, modifier)
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

call DefineAbbrev('vd', 'var_dump(#CURSOR#)', 'i', '')
call DefineAbbrev('ph', '<?php  ?><left><left><left>', 'i', '')
call DefineAbbrev('pe', '<?php echo #CURSOR# ?>', 'i', '')
call DefineAbbrev('phe', '<?php echo #CURSOR# ?>', 'i', '')
call DefineAbbrev('phf', '<?php foreach (#CURSOR#): ?><Enter><?php endforeach; ?>', 'i', '')
call DefineAbbrev('phif', '<?php if (#CURSOR#): ?><Enter><?php endif; ?>', 'i', '')
call DefineAbbrev('iss', 'isset($#CURSOR#) ? $ : ''''', 'i', '')
call DefineAbbrev('css@', '<link rel="stylesheet" href="#CURSOR#">', 'i', '')
call DefineAbbrev('link@', '<link rel="stylesheet" href="#CURSOR#">', 'i', '')

function! DefineCommandAbbrev(abbrev, command)
  let len = strlen(a:abbrev)
  let cmd = printf("cnoreab <expr> %s (getcmdtype() == ':' && getcmdpos() == %d) ? '%s' : '%s'", a:abbrev, len + 1, a:command, a:abbrev)
  exe cmd
endfunction

call DefineCommandAbbrev('brep', 'Brep')
call DefineCommandAbbrev('mru', 'MRU')
call DefineCommandAbbrev('bd', 'Bclose')
call DefineCommandAbbrev('tt', 'CDPjRoot')

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

iab /// <Esc>:call _CommentCaption(strpart(_GetCommentSymbol(), 0, 1))<CR>
iab //- <Esc>:call _CommentCaption('-')<CR>
iab //= <Esc>:call _CommentCaption('=')<CR>

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
  au FileType qf nnoremap <buffer> p <CR><C-w>wj
  au FileType qf setlocal nobuflisted nonumber
  au FileType qf syn match qfError "warning" contained
  au FileType ruby        call Ruby_Setting() 
  au FileType eruby        call Ruby_Setting() 
  au FileType scheme      call Scheme_Setting()
  au FileType sh,bash,zsh call Sh_Setting()
  au FileType vb          call VB_Setting()
  au FileType vim         call Vim_Setting()
  au FileType *           call _SetDict()
  au InsertLeave * set nopaste
  au Syntax c,cpp,ruby,java,python,javascript,php,cs call _MySyntax() 
  au Syntax go call _GoSyntax() 
  au Syntax markdown call _MarkdownSyntax() 
  au Syntax * call _HighlightMixedIndent()
  if exists("##TextYankPost")
    au TextYankPost * call _TextYankPost(v:event)
  else
    source ~/.vim/macros/yanktofile.vim
  endif
  au VimEnter * call _VimEnter()
  au CursorHold * silent! checktime
  au WinEnter * checktime
augroup END

function! _TextYankPost(event)
  if a:event["operator"] == "y"
    call _YankToFile('0', 0)
    let @9 = @8
    let @8 = @7
    let @7 = @6
    let @6 = @5
    let @5 = @4
    let @4 = @3
    let @3 = @2
    let @2 = @1
    let @1 = @0
  endif
endfunction

function! _VimEnter()
  let g:initdir = getcwd()
  let g:pjroot = expand(_GetProjectRoot())
  let g:topdir = g:pjroot

  if filereadable(g:pjroot . "/Gemfile") && isdirectory(g:pjroot . "/public")
    let &path = &path . "," . g:pjroot . "/public"
  endif

  " * では大文字小文字を区別しないようにする。vim-indexed-searchのマッピングを上書きしたいので、VimEnterの中でマッピングする。
  nmap * /\C\<<C-r><C-w>\><CR>
  nmap g* :grep<space>-w <C-r><C-w>
endfunction

command! EnableSyntaxCheck let b:enable_syntax_check = 1
command! DisableSyntaxCheck let b:enable_syntax_check = 0
let g:syntaxCheckFunctions = {
      \ 'haskell' : 'Haskell_SyntaxCheck',
      \ 'javascript' : 'JS_SyntaxCheck',
      \ 'php' : 'PHP_SyntaxCheck',
      \ 'python' : 'Python_SyntaxCheck',
      \ 'ruby' : 'Ruby_SyntaxCheck',
      \ 'yaml' : 'YAML_SyntaxCheck',
      \ }
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
  if &ft == "ruby"
    syn keyword Continue  continue next       | hi Continue       cterm=None      ctermfg=1 ctermbg=None gui=None guifg=#007F7F
  else
    syn keyword Continue  continue            | hi Continue       cterm=None      ctermfg=1 ctermbg=None gui=None guifg=#007F7F
  endif
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
  set cinkeys+=0#
  set indentkeys+=0#
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
  syn match FunctionName display /\w\+(\@=/
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
  call DefineAbbrev('cl', 'System.Console.WriteLine(#CURSOR#);', 'i', '<buffer>')
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
  call DefineAbbrev('cl', 'console.log(#CURSOR#);', 'i', '<buffer>')
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

" カーソル下の単語を取得する。単語の境界はa:iskeywordにより定義される
function! _GetWordUnderCursor(iskeyword) abort
  let iskeyword_old = &iskeyword
  try
    if a:iskeyword != ""
      let &iskeyword = a:iskeyword
    endif
    return expand("<cword>")
  finally
    let &iskeyword = iskeyword_old
  endtry
endfunction

function! Go_Setting()
  let b:commentSymbol = '//'
  if executable("goimports")
    let g:go_fmt_command = "goimports"
  else
    call _Echo("WarningMsg", "goimportsをインストールするには: go get golang.org/x/tools/cmd/goimports")
  endif
  inoreab <buffer> ife if err != nil {<Enter>log.Fatal(err)<Enter>}<Esc><Up>w<C-r>=Eatchar('\s')<CR>
  nnoremap <buffer> [[ ?^\w.*{$<CR>:noh<CR>
endfunction
let g:go_highlight_trailing_whitespace_error = 0
let g:go_template_autocreate = 0

function! _GoSyntax()
  syn match FunctionName display /\w\+(\@=/
endfunction

function! JavaScript_Setting()
  let b:commentSymbol = "//"
  call DefineAbbrev('cl', 'console.log(#CURSOR#);', 'i', '<buffer>')
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
  "call DefineAbbrev('try', 'try {<Enter>;#CURSOR#<Enter><Up><End><Left><Left><Left><Left><Left><Left><Left><Left><Bs><Down>}<Enter>catch (Exception $ex) {<Enter>echo $ex->getMessage();<Enter>}<Enter>', 'i', '<buffer>')
  call DefineAbbrev('catch', 'catch (Exception $ex) {<Enter>echo $ex->getMessage();<Enter>}', 'i', '<buffer>')
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
  let g:ruby_indent_access_modifier_style = "outdent"
  "call DefineAbbrev('bb', 'byebug', '', '')
  hi rubyConstant ctermfg=19 ctermbg=None cterm=bold
  if !exists("b:_exec_system_last_cmd")
    if expand("%") =~ '_spec\.rb'
      let b:_exec_system_last_cmd = "0r!rspec " . expand("%:p")
    else
      let b:_exec_system_last_cmd = "0r!ruby " . expand("%:p")
    endif
  endif
  hi link rubyFunction FunctionName
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

function! YAML_SyntaxCheck()
  if !executable("ruby")
    return -1
  endif
  let result = system("ruby -ryaml -e 'YAML.parse(STDIN.read)' < " . shellescape(expand("%")))
  if result != ""
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

function! Sh_Setting()
  setlocal isk+=-
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

  let commentLineCount = 0
  let uncommentLineCount = 0
  let cl = a:firstline 
  while cl <= a:lastline
    let line = getline(cl)
    if strpart(line, match(line, "[^ \t]"), strlen(cs)) == cs
      let commentLineCount += 1
    else
      let uncommentLineCount += 1
    endif
    let cl += 1
  endwhile
  let deleteComment = (commentLineCount > uncommentLineCount)

  let cl = a:firstline
  if deleteComment
    while (cl <= a:lastline) 
        silent exe deleteCommentCommand
      normal! j
      let cl = cl + 1
    endwhile
  else
    let min = 999999
    let j_count = a:lastline - a:firstline
    for i in range(a:firstline, a:lastline)
      exe "normal! " . i . "G"
      normal! ^
      if getline(".") != ""
        let vc = virtcol(".")
        if vc < min
          let min = vc
        endif
      endif
    endfor
    if j_count != 0
      exe "normal! " . a:firstline . "G"
      exe "normal! " . min . "|"
      exe "normal! \<C-v>" . j_count . "jI" . cs
    else
      exe "normal! " . a:firstline . "G"
      exe "normal! I" . cs
    endif
  endif
  exe "normal! " . (a:lastline + 1) . "G"
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
command! -bang Bclose call _BufcloseCloseIt("<bang>")

function! _BufcloseCloseIt(bang)
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
    " 開き直したとき、新しいバッファ番号が振られるように、bwipeを使う
    "execute("bdelete" . l:currentBufNum)
    execute("bwipe" . a:bang . " " . l:currentBufNum)
  endif
endfunction

command! -range InsertSpaceBetweenHankakuZenkaku call InsertSpaceBetweenHankakuZenkaku()
function! InsertSpaceBetweenHankakuZenkaku() range
  '<,'>s/\%(\([^\t -~。、]\)\%([!"#$%&'*+_\-./0-9<=>?A-Za-z~]\)\@=\|\([!"#$%&'*+_\-./0-9<=>?A-Za-z~]\)\%([^\t -~。、]\)\@=\)/\1\2 /ge
endfunction

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
  let skip_same_indent_lines_at_first = 1 " 同じインデントの行が続く場合、スキップする
  while (line > 0 && line <= lastline)
    let line = line + stepvalue
    if skip_same_indent_lines_at_first && indent(line) == start_indent
      continue
    endif
    let skip_same_indent_lines_at_first = 0
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
nnoremap <silent> g+  <esc>:call _NextIndent(0, 1, 1, 1, 0)<cr>^
nnoremap <silent> g-  <esc>:call _NextIndent(0, 0, 1, 1, 0)<cr>^
" カレント行から同じインデントの行までを折りたたむ
nmap <silent> zq v+zf


function! _BufInfo()
  let bufnr = bufnr("%")
  let fullpath = expand("%:p")
  let ls = system('ls -l ' . shellescape(expand('%:p')))
  echo ls
  echo fullpath
  echo getfperm(fullpath)."  ".strftime("%Y-%m-%d %H:%M:%S",getftime(fullpath))."   ".NumberFormat(Bufsize())." bytes (" . FileSizeFormat(Bufsize()) . ")"
  echo "\nタイムスタンプを戻すには："
  call _EchoModifiedTime(fullpath)
  if exists("b:editorconfig_applied")
    echo ""
    echo "editorconfigが適用されています。"
  endif
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
  " 折り畳みが有効の場合、jkによる移動がおかしくなってしまうので、WhatFunctionを無効化する
  let mode = mode()
  " ヴィジュアルモード中にこの関数が呼ばれると、showcmdによる選択行数が表示されなくなってしまうので、
  " ヴィジュアルモードでは無効化する。
  if mode == "v" || mode == "V"
    return ""
  endif
  if &foldenable
    return ""
  endif
  if exists("g:WhatFunction_disable")
    return ""
  endif
  if &diff
    return ""
  endif
  let op = "("
  let cp = ")"
  if exists("w:WhatFunction_LastLine") && w:WhatFunction_LastLine == line(".")
    if exists("w:WhatFunction")
      return op . w:WhatFunction . cp
    endif
  endif
  let w:WhatFunction_LastLine = line(".")
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
  if &ft != "c" && &ft != "cpp"
    let w:WhatFunction = ""
    return ""
  endif 
  let proto = GetProtoLine() 
  if proto == ""
    let w:WhatFunction = "-"
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
  let w:WhatFunction = ret
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
  let proto = GetProtoLinePy() 
  if proto == ""
    let w:WhatFunction = "?"
    return "?"
  endif 
  let ret = substitute(proto, '^\s*\(def\|class\)\s*', '', '')
  let ret = substitute(ret, '(.*', '', '')
  let w:WhatFunction = ret
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
  let proto = GetProtoLinePHP() 
  if proto == ""
    let w:WhatFunction = "?"
    return "?"
  endif 
  let ret = substitute(proto, '.*function\s\+\(\w\+\).*', '\1', '')
  let w:WhatFunction = ret
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
function! Rename(name, bang) abort
  if stridx(a:name, '/') == -1
    let dir = expand("%:p:h") . '/'
  else
    let dir = ''
  endif
  let l:curfile = expand("%:p")
  let perm = getfperm(l:curfile)
  let v:errmsg = ""
  silent! exe "saveas" . a:bang . " " . fnameescape(dir . Trim(a:name))
  call setfperm(dir . a:name, perm)
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

function! _GetExecSystemDefault(...)
  if a:0 == 0
    let filepath = expand("%:p")
    let filename = expand("%")
  else
    let filename = a:1
  endif
  let ret = ""
  if 0
  elseif &ft ==? "c" || &ft ==? "cpp"
    let ret = "0r!gcc " . filename . " && ./a.out"
  elseif &ft ==? "javascript"
    let ret = "0r!node " . filename
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

  if mode != "selection"
    if filepath == ""
      echomsg "ファイル名がついていません"
      return
    elseif (!filereadable(filepath) || getbufvar(bufnr, "&modified")) && &buftype != "nofile"
      w
    endif
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
  elseif mode == 'selection'
    let cmd = _GetExecSystemDefault(expand("~/tmp/.EvalSelection.tmp"))
  else
    echomsg "ExecSystem: Invalid argument [" . a:mode . "]"
    return
  endif

  if mode != "selection"
    if getbufvar(bufnr, "auto_exec_count") == ""
      call setbufvar(bufnr, "auto_exec_count", 0)
    endif
    call setbufvar(bufnr, "auto_exec_count", getbufvar(bufnr, "auto_exec_count") + 1)
  endif

  if cmd != ""
    let b:_exec_system_last_cmd = cmd

    call ScratchBuffer("_out_", "split", "hide") | silent %d
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

  if mode != "selection"
    if getbufvar(bufnr, "auto_exec_count") == 1
      if confirm("保存時に自動実行するようにしますか？", "&Y\n&N") == 1
        let b:enable_auto_exec_system = 1
      endif
    endif
    if !exists("b:enable_auto_exec_system")
      let b:enable_auto_exec_system = 0
    endif
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
let g:go_version_warning = 0

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
let g:NERDTreeHighlightCursorline = 0
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
    "call _MyBE_Init()
    wincmd k
  endif
endfunction


" markdown で```rbの記法を有効にする
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'ruby', 'rb=ruby', 'javascript', 'js=javascript', 'php']

" vim-indexed-search
let g:indexed_search_colors = 0
let g:indexed_search_numbered_only = 1
let g:indexed_search_n_always_searches_forward = 0


function! MyFoldText()
  let line = getline(v:foldstart)
  let before = line
  let indent = matchstr(line, '^\t*')
  let line = substitute(line, '^\t*', StringRepeat(' ', &tabstop * strlen(indent)), '')
  return line . '          [' . (v:foldend - v:foldstart) . '行]'
endfunction

command! Fold call Fold()
" 全ての折りたたみを開くには zR
nnoremap <Space>ff :<C-u>Fold<CR>

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
  else
    set foldmethod=syntax foldenable
  endif
  normal! zM
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

" ビジュアルモードでプットしたときレジスタを置き換えないようにする
vnoremap p "_dP

command! CopyPath silent call _CopyPath("", 1, 0)
command! CopyPathWithLineNumber silent call _CopyPath("", 1, 1)
function! _CopyPath(prefix, full, with_line_number) abort
  let path = a:prefix
  let path .= a:full ? expand("%:p") : expand("%")
  if a:with_line_number
    let path .= ":" . line(".")
  endif
  let @" = path
  call _YankToFile('"', 1)
endfunction

function! _YankToFile(reg, show_message)
  let yankfile = "~/.yank"
  let lines = split(getreg(a:reg), "\n")
  let os_clipboard_msg = ""
  call writefile(lines, expand(yankfile), "b")
  if executable("pbcopy")
    call system("pbcopy < ~/.yank")
    let os_clipboard_msg .= " + OS clipboard"
  endif
  " http://www.evernote.com/l/ANNgwtCY7uFA1r3MQy2PUS_F2rVP3zA9ojM/
  "if $TERM =~ 'screen'
    "call system("USER=ao screen -X readbuf")
  "endif
  if a:show_message
    let line_count = len(lines)
    let msg = "Copied " . line_count . " lines to " . yankfile . os_clipboard_msg
    call _Echon("Normal", msg)
    "echon msg

    let msg2 = " [" . strpart(lines[0], 0, winwidth('.') - strlen(msg) - 15) . "]"
    call _Echon("Normal", msg2)
    "echon msg2
  endif
endfunction

" tabline {{{ --------------------------------------------------------------------------
let g:tabline_all_buffers = []        " tablineで管理する全バッファのリスト
let g:tabline_visible_buffers = []    " 今表示しているバッファのリスト

function! _GetBufInfoFromBufNum(bnum)
  let origname = bufname(a:bnum)
  let disp = substitute(origname, '.*/', '', '')
  if disp == ""
    let disp = " [No Name] "
  else
    let disp = " " . disp . " "
  endif
  let bufinfo = { "name": origname, "num": a:bnum, "disp": disp, "displen": strdisplaywidth(disp) }
  return bufinfo
endfunction

" tablineに表示する可能性のあるバッファの情報を集める
function! _UpdateBufferList()
  let bufnums = filter(range(1, bufnr("$")), 'bufexists(v:val) && buflisted(v:val)')
  let ret = copy(g:tabline_all_buffers)
  for bufnum in bufnums
    let bufinfo = _GetBufInfoFromBufNum(bufnum)

    " バッファがリネームされている可能性があるので、既存のデータを更新する
    let found_i = -1
    let i = 0
    for buf in ret
      if buf["num"] == bufnum
        let found_i = i
        break
      endif
      let i += 1
    endfor
    if found_i >= 0
      let ret[i]["num"] = bufinfo["num"]
      let ret[i]["disp"] = bufinfo["disp"]
      let ret[i]["name"] = bufinfo["name"]
      let ret[i]["displen"] = bufinfo["displen"]
    else
      call add(ret, bufinfo)
    endif
  endfor
  let g:tabline_all_buffers = ret
  return ret
endfunction

" 与えられたバッファのリストをtablineの文字列に変換する
function! _BufListToTabLine(buflist, curbufnr)
  let tl = ""
  let a = []
  for buf in a:buflist
    if buf["num"] == a:curbufnr
      call add(a, "%#TabLineSel#" . buf["disp"] . "%#TabLineFill#")
    else
      call add(a, buf["disp"])
    endif
  endfor
  return join(a, "|")
endfunction

function! _MyTabLine()
  let curbufnr = bufnr("%")

  " 非表示バッファがリストに含まれていたら削除する（NERDTreeなど、後からbuflistedをセットした場合に起こりうる）
  let i = 0
  for buf in g:tabline_all_buffers
    if !buflisted(buf["num"])
      call remove(g:tabline_all_buffers, i)
    endif
    let i += 1
  endfor
  " 非表示バッファがリストに含まれていたら削除する（NERDTreeなど、後からbuflistedをセットした場合に起こりうる）
  let i = 0
  for buf in g:tabline_visible_buffers
    if !buflisted(buf["num"])
      call remove(g:tabline_visible_buffers, i)
    endif
    let i += 1
  endfor

  " 可能な場合は表示順が変わらず、カレントバッファのハイライトだけが変わるようにする
  for buf in g:tabline_visible_buffers
    if buf["num"] == curbufnr
      return _BufListToTabLine(g:tabline_visible_buffers, curbufnr)
    endif
  endfor

  let lensum = 0
  let buflist = _UpdateBufferList()

  let current_i = -1
  let i = 0
  for buf in buflist
    let bnum = buf["num"]
    if bnum == curbufnr
      let current_i = i
    endif
    let i += 1
  endfor

  " カレントバッファがtablineに載せないものであれば、変えないようにする
  if current_i == -1
    return _BufListToTabLine(g:tabline_visible_buffers, curbufnr)
  endif

  let visible_buffers = []

  call add(visible_buffers, buflist[current_i])
  let lensum = buflist[current_i]["displen"]

  " 1. カレントより前の部分を追加
  let prev_i = current_i - 1
  while prev_i % 3 != 1 && prev_i >= 0
    if lensum + buflist[prev_i]["displen"] < &columns
      call insert(visible_buffers, buflist[prev_i]) " 2つのリストで参照が共有される
      let lensum += buflist[prev_i]["displen"] + 1  " |の分プラス1
      let prev_i -= 1
    else
      break
    endif
  endwhile

  " カレントより後の部分を追加
  let next_i = current_i + 1
  while next_i < len(buflist)
    if lensum + buflist[next_i]["displen"] < &columns
      call add(visible_buffers, buflist[next_i])  " 2つのリストで参照が共有される
      let lensum += buflist[next_i]["displen"] + 1  " |の分プラス1
      let next_i += 1
    else
      break
    endif
  endwhile

  " もしまだスペースが余っているならさらにカレントより前を追加
  while prev_i >= 0
    if lensum + buflist[prev_i]["displen"] < &columns
      call insert(visible_buffers, buflist[prev_i]) " 2つのリストで参照が共有される
      let lensum += buflist[prev_i]["displen"] + 1  " |の分プラス1
      let prev_i -= 1
    else
      break
    endif
  endwhile

  let g:tabline_visible_buffers = visible_buffers
  return _BufListToTabLine(visible_buffers, curbufnr)
endfunction

function! _UpdateShowTabline()
  if len(_UpdateBufferList()) >= 2
    set showtabline=2
  else
    set showtabline=0
  endif
endfunction

augroup TabLine
  au!
  au BufNewFile,BufReadPost,BufWritePost * call _UpdateShowTabline()
  au BufDelete * call _UpdateShowTabline()
augroup END

nnoremap <C-@><C-l> :<C-u>call _MoveBufferTab(+1)<CR>
nnoremap <C-@><C-h> :<C-u>call _MoveBufferTab(-1)<CR>
nnoremap <silent> <C-l> :<C-u>call _SwitchBufferTab(+1 * v:count1)<CR>
nnoremap <silent> <C-h> :<C-u>call _SwitchBufferTab(-1 * v:count1)<CR>
nnoremap <silent> <Space>l :<C-u>call BufRing_Back()<CR>
nnoremap <silent> <Space>h :<C-u>call BufRing_Forward()<CR>
" tabline }}} --------------------------------------------------------------------------

" バッファの順番を入れ替える
function! _MoveBufferTab(delta) abort
  let curbufnr = bufnr("%")

  let len = len(g:tabline_all_buffers)
  for j in range(len)
    let buf = g:tabline_all_buffers[j]
    if buf["num"] == curbufnr
      if j + a:delta < 0
        let k = len - 1
      elseif j + a:delta > len - 1
        let k = 0
      else
        let k = j + a:delta
      endif
      let tmp = g:tabline_all_buffers[j]
      let g:tabline_all_buffers[j] = g:tabline_all_buffers[k]
      let g:tabline_all_buffers[k] = tmp
      break
    endif
  endfor

  let len = len(g:tabline_visible_buffers)
  for i in range(len)
    let buf = g:tabline_visible_buffers[i]
    if buf["num"] == curbufnr
      if i + a:delta < 0
        let j = len - 1
      elseif i + a:delta > len - 1
        let j = 0
      else
        let j = i + a:delta
      endif
      let tmp = g:tabline_visible_buffers[i]
      let g:tabline_visible_buffers[i] = g:tabline_visible_buffers[j]
      let g:tabline_visible_buffers[j] = tmp
      " redraw
      "set showtabline=0
      set showtabline=2
      break
    endif
  endfor
endfunction

" :bp :bn の代わり
function! _SwitchBufferTab(delta) abort
  let curbufnr = bufnr("%")

  for i in range(len(g:tabline_all_buffers))
    let buf = g:tabline_all_buffers[i]
    if buf["num"] == curbufnr
      if i + a:delta >= len(g:tabline_all_buffers)
        let j = 0
      elseif i + a:delta < 0
        let j = len(g:tabline_all_buffers) - 1
      else
        let j = i + a:delta
      endif
      exe "b" . g:tabline_all_buffers[j]["num"]
      return
    endif
  endfor
  "if a:delta > 0
  "  bn
  "else
  "  bp
  "endif
endfunction

" バッファを最近使用した順で並べ替える
function! _ReorderBufferTabs() abort
  let not_found = 999999
  call sort(g:tabline_all_buffers, {a, b -> BufRing_IndexOf(b["num"], not_found) - BufRing_IndexOf(a["num"], not_found)})
  let g:tabline_visible_buffers = []    " 今表示しているバッファのリストをクリアする
  call _UpdateShowTabline()
endfunction
command! REO call _ReorderBufferTabs()
nnoremap <C-u> :<C-u>REO<CR>

function! _SaveSelectionToFile(filename) abort
  silent normal! gv"xy
  let reg = getreg('x')
  let lines = split(reg, '\n')
  call writefile(lines, a:filename)
  return lines
endfunction

function! EvalSelection()
  let ft = &ft
  let filename = expand("~/tmp/.EvalSelection.tmp")
  let lines = _SaveSelectionToFile(filename)
  if ft == "vim"
    exe "@x\<CR>"
    call _Echo("Question", "Sourced " . len(lines) . " lines.")
  else
    let cmd = b:_exec_system_last_cmd
    call ExecSystem("selection")
    let b:_exec_system_last_cmd = cmd
  endif
endfunction

" 指定されたディレクトリが存在しないなら作成して:eする
command! -nargs=1 -complete=file Xe call _EditAndCreateDirectoryIfNotExist("<args>", "e")
command! -nargs=1 -complete=file Xsp call _EditAndCreateDirectoryIfNotExist("<args>", "sp")
command! -nargs=1 -complete=file Xvs call _EditAndCreateDirectoryIfNotExist("<args>", "vs")
function! _EditAndCreateDirectoryIfNotExist(path, cmd) abort
  let dirname  = substitute(a:path, '/[^/]*$', '', '')
  let basename = substitute(a:path, '.*/', '', '')
  if !isdirectory(dirname)
    call mkdir(dirname, "p")
  endif
  exe "cd" dirname
  exe a:cmd  basename
endfunction

command! -nargs=? Toc call _Toc(<f-args>)
function! _Toc(...) abort
  if a:0 == 0
    if &ft == 'c' || &ft == 'cpp'
      let regexp = '^\w\+'
    elseif &ft == 'ruby' || &ft == 'python'
      let regexp = '\<\(def\|class\|module\) \w\+'
    else
      let regexp = '^#'
    endif
  else
    let regexp = a:1
  endif
  lclose
  exe 'sil! lvimgrep /' . regexp . '/ %'
  vert lw
  20wincmd |
  syn match FilenameAndPosition /^.*| / conceal
  setlocal conceallevel=3
  setlocal concealcursor=nvic
endfunction

"=============================================================================
"   ▲実験室  Experimental
"=============================================================================

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
