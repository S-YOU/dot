syntax region htmlPHP    start=/<?php/ end=/?>/
"syn region  htmlString   contained start=+"+ end=+"+ contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc,phpGreen
"syn region  htmlString   contained start=+'+ end=+'+ contains=htmlSpecialChar,javaScriptExpression,@htmlPreproc,phpGreen
syn region htmlPreProc start=+<?php+ end=+?>+
