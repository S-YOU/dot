" Grand Unified Reference

if &cp || exists("g:loaded_GUR")
 finish
endif
if v:version < 700
 echoerr "GUR: this plugin requires Vim >= 7.0"
 finish
endif
let g:loaded_GUR = 1

let g:GUR_dict = {
      \ "c"            : ["r!man -a %s | col -b", 1],
      \ "cpp"          : ["r!man -a %s | col -b", 1],
      \ "perl"         : ["r!perldoc -T -t -f %s", 1],
      \ "php"          : ["r!w3m -dump http://www.php.net/ja/%s", 1],
      \ "python"       : ["r!pydoc %s", 1],
      \ "ruby"         : ["r!refe %s", 1],
      \ "default"      : ["r!man -a %s | col -b", 1],
      \ "default_count": ["r!man %d %s | col -b", 1]
      \ }

let g:GUR_winheight = 16
let g:GUR_wincolumn = 80

nnoremap K  :<C-u>call GUReference(&ft, "")<CR>
xnoremap K  <Esc>:<C-u>call GUReference(&ft, <SID>GetVisualRegionString())<CR>
command! -nargs=+ GUR call GUReference(<f-args>)

let s:separator = "==============================================="

function! GUReference(...)
  if a:0 == 1
    call _GUReference(&ft, a:1, v:count)
  elseif a:0 == 2
    call _GUReference(a:1, a:2, v:count)
  else
    echoerr "Usage: GUReference [lang] keyword"
  endif
endfunction

function! _GUReference(language, word, cnt)
  try
    let bufnr_save = bufnr("%")
    if exists("b:GUR_language")
      let language = b:GUR_language
    else
      let language = a:language
    endif
    let isk_save = &l:isk
    let pos_save = getpos(".")
    let re_number = '[0-9]\+$'

    " Extract the word.
    if a:word != ""
      let word = a:word
    else
      if language ==? "vim"
        normal! K
        return
      else
        let line = strpart(getline('.'), 0, col('.'))
        let re = '\(\S\+\)\.\k*$'
        let match = matchstr(line, re)
        let receiver = substitute(match, re, '\1', '')

        let syntax = synIDattr(synID(line("."),col("."),1),"name")
        if 0
          " dummy
        elseif language ==? "c" || language ==? "cpp"
          let word = expand("<cword>")
        elseif language ==? "html"
          let word = expand("<cword>")
        elseif language ==? "javascript"
          let word = expand("<cword>")
        elseif language ==? "perl"
          let word = expand("<cword>")
        elseif language ==? "php"
          let word = expand("<cword>")
        elseif language ==? "python"
          if syntax =~ 'String'
            let word = "__builtin__.str"
          elseif expand("<cword>") =~? re_number
            let word = "__builtin__.int"
          else
            if receiver =~ "[\"']$"
              let word = "__builtin__.str." . expand("<cword>")
            elseif receiver =~? re_number
              let word = "__builtin__.int." . expand("<cword>")
            else
              let word = expand("<cword>")
            endif
          endif
        elseif language ==? "ruby"
          setlocal isk+=#,!,?
          if syntax =~ 'String'
            let word = "String"
          elseif expand("<cword>") =~? re_number
            let word = "Integer"
          else
            let sp = search('^==== \k\+ ====$', 'bWn', line(".") - 200 >= 0 ? line(".") - 200 : 0)
            if sp
              " in _GUR_ruby buffer
              let module_name = matchstr(getline(sp), '\k\+')
              let word = module_name . "#" . expand("<cword>")
            else
              if receiver =~ "[\"']$"
                let word = "String#" . expand("<cword>")
              elseif receiver =~? re_number
                let word = "Integer#" . expand("<cword>")
              else
                let word = expand("<cword>")
              endif
            endif
          endif
        else
          let word = expand("<cword>")
        endif
      endif
    endif

    " Setup the result buffer.
    if !(has_key(g:GUR_dict, language) && g:GUR_dict[language][1] == 0)
      exe winnr("$")."wincmd w"
      call SingletonBuffer("_GUR_", "split")
      let b:GUR_language = language
      setlocal bt=nofile
      nnoremap <buffer> q :close<CR>
      nnoremap <silent> <C-p> :call <SID>GUR_Back()<CR>
      nnoremap <silent> <C-n> :call <SID>GUR_Forward()<CR>
      set winfixheight
      let winheight = -1
      if exists("b:GUR_winheight")
        let winheight = b:GUR_winheight
      elseif exists("g:GUR_winheight")
        let winheight = g:GUR_winheight
      endif
      if winheight > 0
        exe "normal! " . winheight . "\<C-w>_"
      endif
      normal! G
      call append(line("$"), s:separator)
      normal! G
    endif

    let escaped_word = shellescape(word, '%#')
    let dont_move = 0

    " Do look-up command.
    if has_key(g:GUR_dict, language)
      let cmd = "sil " . printf(g:GUR_dict[language][0], escaped_word)
    else
      if a:cnt == 0
        let cmd = "sil " . printf(g:GUR_dict["default"][0], escaped_word)
      else
        let cmd = "sil " . printf(g:GUR_dict["default_count"][0], a:cnt, escaped_word)
      endif
    endif
    echomsg cmd
    exe cmd
  finally
    let &l:isk = isk_save
  endtry

  if !dont_move
    exe "normal! `[kz\<CR>"
  endif

endfunction

function! s:GUR_Back()
  call search('^'.s:separator, 'bW')
  exe "normal! z\<CR>"
endfunction

function! s:GUR_Forward()
  call search('^'.s:separator, 'W')
  exe "normal! z\<CR>"
endfunction


function! s:GetVisualRegionString()
  " save the register
  let old_reg=getreg('a')
  let old_regmode=getregtype('a')

  silent normal! gv"ay
  let selected=@a

  " restore it
  call setreg('a', old_reg, old_regmode)
  return selected
endfunction

function! s:GetBufferNumberByName(name, ignorecase)
  let buflist = filter(range(1, bufnr("$")), 'bufexists(v:val)')
  for bufnr in buflist
    if (a:ignorecase && bufname(bufnr) ==? a:name) || bufname(bufnr) ==# a:name
      return bufnr
    end
  endfor
  return -1
endfunction
