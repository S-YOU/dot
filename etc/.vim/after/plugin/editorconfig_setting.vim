if !exists("g:loaded_EditorConfig")
  finish
endif

if exists("g:loaded_editorconfig_setting") || &cp
  finish
endif
let g:loaded_editorconfig_setting = 1

let g:EditorConfig_exec_path = "~/.vim/bundle/editorconfig-vim-master/plugin/editorconfig-core-py/main.py"
let g:EditorConfig_max_line_indicator = "none"
let g:EditorConfig_verbose = 0

function! EditorConfigHook(config)
  let b:editorconfig_applied = 1
endfunction

call editorconfig#AddNewHook(function('EditorConfigHook'))
