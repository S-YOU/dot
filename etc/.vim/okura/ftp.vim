" Simple ftp put/get plugin

let g:is_ftp_start = 0

if has('python')

function! FTP_sendcmd(cmd)
	if !g:is_ftp_start | call FTP_start() | endif
python << EOF
try:
	print ftp.sendcmd(vim.eval('a:cmd'))
except:
	# retry once
	try:
		vim.command('FTPSTART')
		print ftp.sendcmd(vim.eval('a:cmd'))
	except:
		print "FTP error!"
EOF
endfunction


function! FTP_start()
  if !exists('g:ftp_config')
    echoerr "g:ftp_configがセットされていません！"
  endif
python << EOF
import os
import sys
import vim
from ftplib import FTP

try:
	#ftp = FTP('www.betatechnology.jp', 'apache', 'beta')
	ftp_host       = vim.eval('g:ftp_config["host"]')
	ftp_user       = vim.eval('g:ftp_config["user"]')
	ftp_pass       = vim.eval('g:ftp_config["pass"]')
	ftp_localbase  = vim.eval('g:ftp_config["localbase"]')
	ftp_serverbase = vim.eval('g:ftp_config["serverbase"]')
	if not ftp_localbase.endswith('/'):
		ftp_localbase += '/'
	if not ftp_serverbase.endswith('/'):
		ftp_serverbase += '/'
	ftp = FTP(ftp_host, ftp_user, ftp_pass)
	print "FTP start: %s@%s" % (ftp_user, ftp_host)
	vim.command('let g:is_ftp_start = 1')

except:
	print "FTP connection error! %s@%s" % (ftp_user, ftp_host)

def handleDownload(block):
	f.write(block)
EOF
endfunction

function! FTP_ls(...)
	if !g:is_ftp_start | call FTP_start() | endif
	if a:0 == 0 || a:1 == ""
		python << EOF
try:
	serverpath = os.getcwd().replace(ftp_localbase, ftp_serverbase)
	ftp.sendcmd('CWD ' + serverpath)
	ftp.retrlines('NLST -Fal')
except:
	print "FTP error " + str(sys.exc_info()[0])
EOF
	else
		let arg = a:1
		py ftp.retrlines('NLST ' + vim.eval("arg") + ' -Fal')
	end
endfunction

function! FTP_ls2(...)
	"new | setl buftype=nofile bufhidden=delete
	call SingletonBuffer('ftp', 'split')
	setl buftype=nofile
	%d
	nnoremap <buffer> <CR> :FTPCD2 <C-r><C-f><CR>
	redir @f
	sil! call FTP_sendcmd("PWD")
	sil! call FTP_ls()
	redir END
	sil! put f
	1
	sil! 1,2d
endfunction

function! FTP_put()
	if !g:is_ftp_start | call FTP_start() | endif
python << EOF
try:
	filepath = vim.current.buffer.name
	serverpath = filepath.replace(ftp_localbase, ftp_serverbase)
	f = open(filepath, 'r')
	ftp.storbinary('STOR ' + serverpath, f)
	f.close()
	print "FTP_put: success     [FTPAUTOPUT command allows auto-uploading]"
except:
	print "FTP error!"
EOF
endfunction

function! FTP_get()
	if !g:is_ftp_start | call FTP_start() | endif
if &modified
	echo "STOP. Buffer is modified!"
	return
end
python << EOF
try:
	filepath = vim.current.buffer.name
	serverpath = filepath.replace(ftp_localbase, ftp_serverbase)
	print serverpath

	f = open(filepath, 'wb')
	ftp.retrbinary('RETR ' + serverpath, handleDownload)
	f.close()
	print "FTP_get: success"
except:
	print "FTP error!"
EOF
e!
endfunction

function! FTP_cd(...)
	if !g:is_ftp_start | call FTP_start() | endif
	if a:0 > 0
		let dir = a:1
python << EOF
try:
	print ftp.sendcmd('CWD ' + vim.eval('dir'))
except:
	print "FTP error!"
EOF
	else
	endif
endfunction

function! FTP_chmod(...)
	if !g:is_ftp_start | call FTP_start() | endif
	python << EOF
filepath = vim.current.buffer.name
serverpath = filepath.replace(ftp_localbase, ftp_serverbase)
print ftp.sendcmd('SITE CHMOD 755 ' + serverpath)
EOF
endfunction

function! FTP_autoput()
	if exists('b:ftp_auto_put') && b:ftp_auto_put
		FTPPUT
	end
endfunction


command! -nargs=0 FTPSTART call FTP_start()
command! -nargs=? FTPLS call FTP_ls("<args>")
command! -nargs=? FTPLS2 call FTP_ls2("<args>")
command! -nargs=0 FTPPUT call FTP_put()
command! -nargs=0 FTPGET call FTP_get()
command! -nargs=? FTPCD call FTP_cd("<args>")
command! -nargs=? FTPCD2 call FTP_cd("<args>") | call FTP_ls2()
command! -nargs=? FTPCHMOD call FTP_chmod("<args>")
command! -nargs=0 Lftp exe printf("!lftp -u %s,%s %s", g:ftp_config['user'], g:ftp_config['pass'], g:ftp_config['host'])
command! -nargs=0 FTPAUTOPUT let b:ftp_auto_put = 1

augroup Ftp
  au BufWritePost * call FTP_BufWritePost()
augroup END

function! FTP_BufWritePost()
  if exists('b:ftp_auto_put') && b:ftp_auto_put == 1
    redraw
    FTPPUT
  endif
endfunction

endif	" has('python')

let path = expand("%:p:h")
if stridx(path, "/virtual") >= 0
	let g:ftp_config = {
				\ 'host' : 'www.e-hankoya.com',
				\ 'user' : 's-aoyama',
				\ 'pass' : 'no78pro',
				\ 'localbase' : '/virtual/',
				\ 'serverbase' : '/',
				\}
elseif stridx(path, "/nakahama") >= 0
	let g:ftp_config = {
				\ 'host' : 'nakahama-c-s.sakura.ne.jp',
				\ 'user' : 'nakahama-c-s',
				\ 'pass' : 'ns4av3uw6u',
				\ 'localbase' : '/www/',
				\ 'serverbase' : '/home/ao/nakahama-c-s/www/',
				\}
elseif stridx(path, "/kyuyo") >= 0
	let g:ftp_config = {
				\ 'host' : 'k-meister.jp',
				\ 'user' : 's-aoyama',
				\ 'pass' : 'no78pro',
				\ 'localbase' : '/var/www/html/kyuyo/system/manage/',
				\ 'serverbase' : '/ssl/system/manage/',
				\}
elseif stridx(path, "/k-meister") >= 0
	let g:ftp_config = {
				\ 'host' : 'www.hanko-direct.sakura.ne.jp',
				\ 'user' : 'hanko-direct',
				\ 'pass' : 'direct_5757',
				\ 'localbase' : '/home/ao/public_html/k-meister/www',
				\ 'serverbase' : '/www/k-meister.jp/',
				\}
elseif stridx(path, "/taiyo") >= 0
	let g:ftp_config = {
				\ 'host' : 'trace.sakura.ne.jp',
				\ 'user' : 'trace',
				\ 'pass' : 'sonata26',
				\ 'localbase' : '/home/ao/public_html/taiyo/',
				\ 'serverbase' : '/www/',
				\}
endif
nnoremap <silent> <C-d><C-f><c-p> :<C-u>FTPPUT<CR>
nnoremap <silent> <c-d><C-f><c-g> :<C-u>FTPGET<CR>
nnoremap <silent> <c-d><C-f><c-s> :<C-u>FTPSTART<CR>
nnoremap <silent> <c-d><C-f><c-a> :let b:ftp_auto_put = 1<CR>:au BufWritePost <buffer> :call FTP_autoput():echo "FTP auto put enabled"<CR>
nnoremap <silent> <c-d><C-f><c-l> :FTPLS<CR>
cabbrev ftpstart FTPSTART
cabbrev ftpls FTPLS
cabbrev ftpls2 FTPLS2
cabbrev ftpget FTPGET
cabbrev ftpput FTPPUT
