" Vim color file
" vim: set list noet sts=12
" for 256 colors terminal
" Maintainer: Aoyama, Shotaro <aosho235@gmail.com>
" Last Change:  2015/05/19

" オンライン・カラースキームエディタ
" http://bytefluent.com/vivify/

" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
set bg&

" Remove all existing highlighting and set the defaults.
hi clear
" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "aoyama_256"

hi Comment              cterm=None              ctermfg=28              ctermbg=None
"hi Comment              cterm=None              ctermfg=16              ctermbg=157
hi Constant             cterm=None              ctermfg=None            ctermbg=None
hi Continue             cterm=None              ctermfg=131             ctermbg=None
hi Cursor               cterm=None              ctermfg=None            ctermbg=None
hi CursorColumn         cterm=None              ctermfg=None            ctermbg=157
hi CursorLine           cterm=None              ctermfg=None            ctermbg=51
hi DiffAdd              cterm=None              ctermfg=232             ctermbg=158
hi diffAdded            cterm=None              ctermfg=232             ctermbg=158
hi diffRemoved          cterm=None              ctermfg=None            ctermbg=225
hi DiffChange           cterm=None              ctermfg=None            ctermbg=None 
hi DiffDelete           cterm=bold              ctermfg=None            ctermbg=225
"hi DiffText             cterm=bold              ctermfg=None            ctermbg=111
hi DiffText             cterm=None              ctermfg=7               ctermbg=199
hi Directory            cterm=None              ctermfg=blue            ctermbg=None
hi Error                cterm=None              ctermfg=white           ctermbg=cyan
hi ErrorMsg             cterm=None              ctermfg=16              ctermbg=217
hi Folded               cterm=None              ctermfg=232             ctermbg=189
hi Function             cterm=None              ctermfg=232             ctermbg=None
hi FunctionName cterm=bold ctermfg=93 ctermbg=none

hi HintHL               cterm=None              ctermfg=None            ctermbg=None
hi Identifier           cterm=None              ctermfg=None            ctermbg=None
hi IncSearch            cterm=None              ctermfg=7               ctermbg=50
hi LineNe               cterm=None              ctermfg=lightgreen      ctermbg=lightcyan
hi LineNr               cterm=None              ctermfg=1               ctermbg=None
hi Macro                cterm=None              ctermfg=129             ctermbg=None
hi MatchParen           cterm=reverse           ctermfg=190             ctermbg=16
hi Normal               cterm=None              ctermfg=None            ctermbg=None
hi Pmenu                cterm=None              ctermfg=232             ctermbg=253
hi PmenuSel             cterm=None              ctermfg=232             ctermbg=120
hi PmenuSbar            cterm=None              ctermfg=248             ctermbg=None
hi PmenuThumb           cterm=reverse           ctermfg=None            ctermbg=173
hi PreCondit            cterm=bold              ctermfg=129             ctermbg=None
hi PreProc              cterm=None              ctermfg=darkyellow      ctermbg=None
hi Question             cterm=None              ctermfg=None            ctermbg=85
hi Search               cterm=None              ctermfg=None            ctermbg=80
hi Special              cterm=None              ctermfg=129             ctermbg=None            " 文字列中の\など
hi SpecialKey           cterm=None              ctermfg=240             ctermbg=None            " set listしているときのタブの ^
hi Statement            cterm=None              ctermfg=blue            ctermbg=None
hi StatusLine           cterm=bold              ctermfg=231             ctermbg=63
hi StatusLineNC         cterm=reverse           ctermfg=None            ctermbg=None
hi String               cterm=None              ctermfg=197             ctermbg=None
hi Structure            cterm=None              ctermfg=red             ctermbg=None
hi Title                cterm=None              ctermfg=None            ctermbg=None
hi Todo                 cterm=None              ctermfg=232             ctermbg=227
hi Type                 cterm=None              ctermfg=4               ctermbg=None
hi VertSplit            cterm=reverse           ctermfg=None            ctermbg=None
hi Visual               cterm=None              ctermfg=None            ctermbg=49
hi WarningMsg           cterm=None              ctermfg=232             ctermbg=220
hi WildMenu             cterm=None              ctermfg=241             ctermbg=229

" html
hi htmlH1               cterm=None              ctermfg=None            ctermbg=None
hi htmlPreProc          cterm=None              ctermfg=0               ctermbg=43
hi htmlPHP              cterm=None              ctermfg=0               ctermbg=43              " *.html の中の <?php ～ ?>

" php
hi phpVarSelector       cterm=None              ctermfg=129             ctermbg=None            " $hoge の $ の部分

" Markdown
hi! def link markdownError    Normal
hi! def link markdownItalic   Normal
hi markdownHeadingDelimiter cterm=Bold          ctermfg=None            ctermbg=229
hi markdownH1           cterm=Bold              ctermfg=None            ctermbg=229
hi markdownH2           cterm=Bold              ctermfg=None            ctermbg=229
hi markdownH3           cterm=Bold              ctermfg=None            ctermbg=229
hi markdownH4           cterm=Bold              ctermfg=None            ctermbg=229
hi markdownH5           cterm=Bold              ctermfg=None            ctermbg=229
hi markdownH6           cterm=Bold              ctermfg=None            ctermbg=229
hi markdownCode         cterm=None              ctermfg=5               ctermbg=None

hi pythonTripleString cterm=Bold ctermfg=28
hi pythonTripleQuotes cterm=Bold ctermfg=28

hi Breakpoint           cterm=None              ctermfg=124             ctermbg=124

"Cursor		カーソル下の文字
"CursorIM	Cursorと同じだが、IMEモードにいるとき使われる|CursorIM|。
"CursorColumn	'cursorcolumn'がオンになっているときのカーソルがある画面上の桁
"CursorLine	'cursorline'がオンになっているときのカーソルがある画面上の行
"Directory	ディレクトリ名(とリストにある特別な名前)
"DiffAdd		diffモード: 追加された行 |diff.txt|
"DiffChange	diff モード: 変更された行 |diff.txt|
"DiffDelete	diff モード: 削除された行 |diff.txt|
"DiffText	diff モード: 変更された行中の変更されたテキスト |diff.txt|
"ErrorMsg	コマンドラインに現れるエラーメッセージ
"VertSplit	垂直分割したウィンドウの区切りとなる桁
"Folded		閉じた折り畳みの行
"FoldColumn	'foldcolumn'
"SignColumn	目印|signs|が表示される行。
"IncSearch	'incsearch'のハイライト; ":s///c"で置換されたテキストにも使わ
"LineNr		":number"と":#"コマンドの行番号。オプション'number'がセットさ
"MatchParen	カーソル下の文字、または直後の文字が括弧であるとき、その文字と
"ModeMsg		'showmode'のメッセージ (例. "-- INSERT --")
"MoreMsg		|more-prompt|
"NonText		ウィンドウの端の'~'と'@'、'showbreak'で設定された文字など、実
"Normal		通常のテキスト
"Pmenu		ポップアップメニュー: 通常の項目。
"PmenuSel	ポップアップメニュー: 選択されている項目。
"PmenuSbar	ポップアップメニュー: スクロールバー。
"PmenuThumb	ポップアップメニュー: スクロールバーのつまみ部分。
"Question	ヒットエンタープロンプト|hit-enter|とyes/noクエスチョン
"Search		最後に検索した語のハイライト('hlsearch')を参照。
"SpecialKey	":map"でリストされるメタキーと特別なキー。テキスト中の
"SpellBad	スペルチェッカに認識されない単語。|spell|
"SpellCap	大文字で始まるべき単語。 |spell|
"SpellLocal	スペルチェッカによって他の地域で使われると判断される単語。
"SpellRare	スペルチェッカによってまず使わないと判断される単語。|spell|
"StatusLine	カレントウィンドウのステータスライン
"StatusLineNC	非カレントウィンドウのステータスライン。
"TabLine		タブページの行の、アクティブでないタブページのラベル
"TabLineFill	タブページの行の、ラベルがない部分
"TabLineSel	タブページの行の、アクティブなタブページのラベル
"Title		":set all"、":autocmd"などによる出力のタイトル。
"Visual		ビジュアルモード選択
"VisualNOS	vimが"Not Owning the Selection"のときのビジュアルモード選択。
"WarningMsg	警告メッセージ
"WildMenu	'wildmenu'補完における現在の候補
"GUI使用時には、これらのグループを使ってメニューやスクロールバー、ツールチップ
"Menu		メニューのフォント、文字、背景。ツールバーにも使われる。
"Scrollbar	メインウィンドウのスクロールバーの文字と背景。
"Tooltip		ツールチップのフォント、文字、背景。
