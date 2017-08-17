let s:cwd = getcwd()
if s:cwd =~ '/app/'
  let g:cakephp_dir = substitute(s:cwd, 'app/.*', 'app', '')
endif

command! Cmodel call Cmodel()
command! Cview  call Cview()
command! Ccon   call Ccontroller()

"nnoremap <silent> <C-wCToggle()<CR>
nnoremap <silent> <C-w>C :call Ccontroller()<CR>
nnoremap <silent> <C-w>M :call Cmodel()<CR>
nnoremap <silent> <C-w>V :call Cview()<CR>

function! _PHP_ToggleFile()
  let type = Cake_DetectType(expand("%:p"))
  if type == 'view'
    call Cmodel()
  elseif type == 'model'
    call Ccontroller()
  elseif type == 'controller'
    call Cview()
  endif
endfunction

function! Cake_DetectType(fullpath)
  let fulldir = substitute(a:fullpath, '\(.*/\)', '\1', '')
  let dir = substitute(fulldir, '.*/', '', '')
  let basename = substitute(a:fullpath, '.*/', '', '')

  if basename =~# '\.ctp'
    return 'view'
  elseif basename =~# '_controller'
    return 'controller'
  elseif basename =~# '\.php'
    return 'model'
  else
    return '?'
  endif
endfunction

function! Cake_GetCurrentFileBase()
  let fullpath = expand('%:p')
  let basename = substitute(fullpath, '.*/', '', '')
  let type = Cake_DetectType(fullpath)
  if type == 'view'
    let base = substitute(fullpath, '.*views/', '', '')
    let base = substitute(base, '/.*', '', '')
  elseif type == 'controller'
    let base = substitute(basename, '_controller\..*', '', '')
  elseif type == 'model'
    let base = substitute(basename, '\.php', '', '')
  else
    let base = ''
  endif
  return base
endfunction

function! Cmodel()
  let base = Cake_GetCurrentFileBase()
  if base == ''
    echo "Error!"
    return
  endif
  let files = split(glob(g:cakephp_dir . '/models/' . strpart(base, 0, strlen(base)-2) . '*.php'), '\n')
  if len(files) == 1
    exe 'e ' . files[0]
  else
    exe 'e ' . g:cakephp_dir . '/models/'
  endif
endfunction

function! Cview()
  let base = Cake_GetCurrentFileBase()
  if base == ''
    echo "Error!"
    return
  endif
  let lnum = search('\s*function\s\+\w\+(', 'bcnW')
  if lnum == 0
    let viewfile = ''
  else
    let action = substitute(getline(lnum), '^\s*function\s\+', '', '')
    let action = substitute(action, '\W.*', '', '')
    let viewfile = matchstr(action, '\w\+') . '.ctp'
  endif
  if filereadable(g:cakephp_dir . '/views/' . base . '/' . viewfile)
    exe 'e ' . g:cakephp_dir . '/views/' . base . '/' . viewfile
  else
    exe 'e ' . g:cakephp_dir . '/views/' . base . '/index.ctp'
  endif
endfunction

function! Ccontroller()
  let base = Cake_GetCurrentFileBase()
  if base == ''
    echo "Error!"
    return
  endif
  echomsg "base = " . base
  let files = split(glob(g:cakephp_dir . '/controllers/' . strpart(base, 0, strlen(base) - 2) . '*.php'), '\n')
  if len(files) == 1
    exe 'e ' . files[0]
  else
    exe 'e ' . g:cakephp_dir . '/controllers/'
  endif
endfunction
