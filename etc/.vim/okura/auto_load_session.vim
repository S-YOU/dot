function! AutoLoadSession()
  let g:sessionfile = getcwd() . "/Session.vim"
  if (argc() == 0 && filereadable(g:sessionfile))
    call _Echo("WarningMsg", "Session file exists. Load this? (y/n): ")
    while 1
      let c = getchar()
      if c == char2nr("y")
        so Session.vim
        return
      elseif c == char2nr("n")
        return
      endif
    endwhile
  endif
endfunction 

function! AutoSaveSession()
  if exists(g:sessionfile)
    exe "mks! " . g:sessionfile
  endif
endfunction

" オートコマンド
augroup AutoLoadSettion
  au!
  au VimEnter * call AutoLoadSession()
  au VimLeave * call AutoSaveSession() 
augroup END

