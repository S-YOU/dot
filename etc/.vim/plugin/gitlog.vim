" 左側のウィンドウにgit logを表示し、
" エンターを押すとgit diffするプラグイン

function! _Gitlog()
  let dir = getcwd()
  sil only
  vnew
  let prev_file = expand("#:t")
  let b:prev_file = prev_file
  let b:dir = dir
  r!git log #
  " git logウィンドウに対する設定
  exe "cd " . dir
  set ft=git
  set buftype=nofile
  1
  call append(0, "<CR>で現在とのdiffを表示します")
  call append(1, "<C-f>でコミットのshowを表示します")
  nnoremap <buffer> <CR> :call _Gitlog_Diff()<CR>
  nnoremap <buffer> <C-f> :call _Gitlog_Show()<CR>
  nnoremap <buffer> u u:diffoff<CR>
endfunction

function! _Gitlog_Back()
  exe "b" b:gitlog_bufnr
endfunction

function! _GetCommitHash(line)
  if a:line !~# "^commit"
    throw "commitで始まる行の上で実行して下さい"
  endif
  let commit = substitute(a:line, 'commit ', '', '')
  let short_hash = strpart(commit, 0, 7)
  return short_hash
endfunction

function! _Gitlog_Diff()
  " 現在位置をjumplistに入れる
  exe "normal! " . line(".") . "G"
  let prev_file = b:prev_file
  let short_hash = _GetCommitHash(getline("."))
  keepjumps enew
  let b:gitlog_bufnr = bufnr("#")
  " commitウィンドウに対する設定
  exe "cd " . getbufvar(b:gitlog_bufnr, "dir")
  nnoremap <buffer> <space>h :<C-u>call _Gitlog_Back()<CR>
  set buftype=nofile bufhidden=wipe
  sil exe "keepjumps r!git show " . short_hash . ":./" . prev_file
  sil keepjumps 1d
  exe "file commit-" . short_hash
  diffoff
  diffthis
  wincmd p
  diffthis
  wincmd p
endfunction

function! _Gitlog_Show()
  let prev_file = b:prev_file
  let short_hash = _GetCommitHash(getline("."))
  enew
  let b:gitlog_bufnr = bufnr("#")
  " commitウィンドウに対する設定
  exe "cd " . getbufvar(b:gitlog_bufnr, "dir")
  nnoremap <buffer> <space>h :<C-u>call _Gitlog_Back()<CR>
  set buftype=nofile bufhidden=wipe
  sil exe "keepjumps r!git show " . short_hash
  sil keepjumps 1d
  keepjumps 1,3s@^@# @
  set ft=gitcommit
endfunction

augroup Gitlog
  au!
  au BufDelete commit-* diffoff
augroup END

command! Gitlog call _Gitlog()
