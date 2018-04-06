call NERDTreeAddKeyMap({
        \ 'key': 'D',
        \ 'callback': 'NERDTreeMyDeleteHandler',
        \ 'quickhelpText': 'rma.shでカレントノードを削除する',
        \ 'scope': 'FileNode' })

function! NERDTreeMyDeleteHandler(node)
  if confirm(a:node.path.str() . " を本当に削除してよろしいですか？", "&Y\n&N") != 1
    return
  endif

  let escaped_path = a:node.path.str({"escape": 1})
  if exists("g:MyNERDTreeRemoveFileCmd")
    let rm_cmd = g:MyNERDTreeRemoveFileCmd
  else
    let rm_cmd = "rm"
  endif
  call system(rm_cmd . " " . escaped_path) 
  echomsg "削除しました"
  call a:node.parent.removeChild(a:node)
  call NERDTreeRender()
endfunction


call NERDTreeAddKeyMap({
        \ 'key': 'yy',
        \ 'callback': 'NERDTreeMyCopyPath',
        \ 'quickhelpText': 'パスをレジスタにヤンクする',
        \ 'scope': 'Node' })

function! NERDTreeMyCopyPath(node)
  let path = a:node.path.str()
  call setreg('"', path, 'v')
  echomsg "ヤンクしました: " . path
endfunction
