"-----------------------------------------------------------------------------
"   私家版 IncBufSwitch
"   * より Emacs の iswitchb 風にした
"   * C-c でもキャンセルできるようにした
"   * タブで選択できるようにした
"-----------------------------------------------------------------------------

if 1
command! IncBufSwitch :call IncBufferSwitch()
hi link IncBufSwitchCurrent  Search
hi IncBufSwitchOnlyOne cterm=reverse ctermfg=1 ctermbg=6 cterm=bold

function! PartialBufSwitch(partialName, first)
  let lastBuffer = bufnr("$")
  let g:ibs_buflist = ''
  let flag = 0
  let i = 1
  while i <= lastBuffer
    if (bufexists(i) != 0 && buflisted(i))
      let filename = expand("#" . i . ":t")
      if (match(filename, a:partialName) > -1)
        if flag == g:ibs_tabStop
          if a:first == 0
            let g:ibs_current_buffer = i
          endif
        endif
        let g:ibs_buflist = g:ibs_buflist .','. expand("#" . i . ":t")
        let flag = flag + 1
      endif
    endif
    let i = i + 1
  endwhile
  let g:ibs_buflist = substitute(g:ibs_buflist, '^,', '', '')

  if flag == g:ibs_tabStop + 1
    let g:ibs_tabStop = - 1
  endif
  return flag
endfunction

function! IncBufferSwitch()
  let origBufNr = bufnr("%")
  let g:ibs_current_buffer = bufnr("%")
  let partialBufName = ""
  let g:ibs_tabStop = 0

  let cnt = PartialBufSwitch('', 1)
  echon "ibs: "
  if cnt == 1
    echon ' {'
    echohl IncBufSwitchCurrent | echon g:ibs_buflist | echohl None
    echon '}'
  else
    echon ' {'. g:ibs_buflist .'}'
  endif

  while 1
    let flag = 0
    let rawChar = getchar()
    if rawChar == 13  " <CR>
      exe "silent buffer " . g:ibs_current_buffer
      break
    endif
    if rawChar == 27 || rawChar == 3 " <ESC> or <C-c>
      "echon "\r                                                                                   "
      let g:ibs_current_buffer = origBufNr
      break
    endif
    if rawChar == "\<BS>"
      let g:ibs_tabStop = 0
      if strlen(partialBufName) > 0
        let partialBufName = strpart(partialBufName, 0, strlen(partialBufName) - 1)
        if strlen(partialBufName) == 0
          let flag = 1
          if bufnr("%") != origBufNr
            let g:ibs_current_buffer = origBufNr
          endif
        endif
      else
        if bufnr("%") != origBufNr
          let g:ibs_current_buffer = origBufNr
        endif
        break
      endif
    elseif rawChar == 9 " TAB -- find next matching buffer
      let g:ibs_tabStop = (g:ibs_tabStop == -1) ? 0 : g:ibs_tabStop + 1
    else
      let nextChar = nr2char(rawChar)
      let partialBufName = partialBufName . nextChar
    endif

    let matchcnt = PartialBufSwitch(partialBufName, flag)
    if matchcnt == 0
      let partialBufName = strpart(partialBufName, 0, strlen(partialBufName) - 1)
      let matchcnt = PartialBufSwitch(partialBufName, flag)
    endif
    redraw
    echon "\ribs: " . partialBufName
    call ShowBuflist(partialBufName, matchcnt)
  endwhile
endfunction

function! ShowBuflist(partialName, matchcnt)
  let lastBuffer = bufnr("$")
  let i = 1
  let first = 1
  echon " {"
  while i <= lastBuffer
    if (bufexists(i) != 0 && buflisted(i))
      let filename = expand("#" . i . ":t")
      if (a:partialName != "" && match(filename, a:partialName) > -1)
        if first
          let first = 0
        else
          echon ","
        endif
        if (g:ibs_current_buffer == i)
          if a:matchcnt == 1
            echohl IncBufSwitchOnlyOne
          else
            echohl IncBufSwitchCurrent
          endif
        endif
        echon filename
        echohl None
      endif
    endif
    let i = i + 1
  endwhile
  echon "}"
endfunction
endif
