;; $Id: .emacs,v 1.7 2007/01/06 16:57:42 ao Exp $

;-----------------------------------------------------------------------------
;;;; キーマップ
(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\C-x\C-r" (lambda (arg) (interactive "p") (load-file "~/.emacs")))
;; 行頭の非空白文字へ
(global-set-key "\C-a" 'back-to-indentation)
(global-set-key "\M-f" 'next-word)
(define-key mode-specific-map "c" 'compile)
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key [f6] 'copy-with-line-number)
(global-set-key "\C-t"  'other-window)
(define-key esc-map "\C-t" '(lambda (N) (interactive "p") (other-window (- N))))
;(define-key esc-map ":" 'execute-extended-command)
;(define-key esc-map "x" 'eval-expression)
(global-set-key "%" 'match-paren)
;;; ファンクションキー
(global-set-key [f1] 'toggle-input-method)
(global-set-key [f3] (lambda () (interactive) (find-file "~/etc/.emacs")))
(global-set-key [f4] (lambda () (interactive) (switch-to-buffer "*scratch*")))
(global-set-key [f5] 'shell)
(global-set-key [f6] (lambda () (interactive) (find-file "~/memo")))
(global-set-key "\C-k" 'my-kill-line)
(global-set-key "\C-o" 'iswitchb-buffer)
(define-key esc-map "#" 'toggle-comment-line)
(global-set-key "\M-n" 'lisp-complete-symbol)
(global-set-key "\C-a" 'my-beginning-of-line)

;-----------------------------------------------------------------------------
;;;; 全般:general

;; load-path
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "/usr/local/share/emacs/21.3/site-lisp/navi2ch/")

;;;; 日本語関連
(load "migemo" t)

;; 文字コード
(set-default-coding-systems 'euc-jp)

(add-hook 'mw32-ime-on-hook
	  (function (lambda () (set-cursor-color "red"))))
(add-hook 'mw32-ime-off-hook
	  (function (lambda () (set-cursor-color "black"))))

;;;; 表示:view ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq tab-width 4)
;; 起動時メッセージを表示しない
(setq inhibit-startup-message t)
;;括弧にカーソルをもってくと相方に色がつく
(show-paren-mode 1)
;;桁番号を表示する
(setq column-number-mode t)
;; 折り返さない
(setq truncate-lines t)
(setq truncate-partial-width-windows t)

;-----------------------------------------------------------------------------
;;;; カーソル移動:cursor-move
;-----------------------------------------------------------------------------

(defun next-word (&optional n)
  (interactive "p")
  (and (forward-word (1+ n)) (backward-word 1)))

;;;; 編集:edit ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq kill-whole-line t)
;;;; プログラミング支援:programming
(which-function-mode)
;;; c-mode
(add-hook 'c-mode-common-hook
	  (function (lambda ()
		      (setq comment-column 48)
		      (setq c-tab-always-indent t)
		      (define-key c-mode-map "\C-c\C-a" 'ff-find-other-file)
		      (modify-syntax-entry ?_ "w")
		      (setq c-basic-offset 4 indent-tabs-mode t)
                      ;(require 'cpp-complt)
                      ;(define-key c-mode-map "#"
                       ; 'cpp-complt-instruction-completing)
                      ;(define-key c-mode-map "\C-c#"
                       ; 'cpp-complt-ifdef-region)
                      ;(cpp-complt-init)
		      )))
;; If you want the *Macroexpansion* window to be not higher than
;; necessary:
(setq c-macro-shrink-window-flag t)
(setq c-macro-preprocessor "/usr/bin/cpp -C")
(setq c-macro-cppflags "-I /usr/include/local -I./proto -DDEBUG")
;; If you want the "Preprocessor arguments: " prompt:
(setq c-macro-prompt-flag t)
;; M-x compile
(setq compile-command "make")
(setq compile-history (list "make" "make clean"))
;; 自動で色を付ける設定
(global-font-lock-mode t)
;; (add-hook 'c-mode-common-hook
;;           '(Lambda ()
;;              ;; センテンスの終了である ';' を入力したら、自動改行+インデント
;;              (c-toggle-auto-hungry-state 1)
;;              ;; RET キーで    *  ファイルの先頭に #! で始まる行が含まれている
;;     * ファイル名の先頭がピリオド以外 
;; の場合，実行用のスクリプトファイルであると見なして，保存時に実行許可属性を自動的に設定します．
    (defun make-file-executable ()
      "Make the file of this buffer executable, when it is a script source."
      (save-restriction
        (widen)
        (if (string= "#!" (buffer-substring-no-properties 1 (min 3 (point-max))))
            (let ((name (buffer-file-name)))
              (or (equal ?. (string-to-char (file-name-nondirectory name)))
                  (let ((mode (file-modes name)))
                    (set-file-modes name (logior mode (logand (/ mode 4) 73)))
                    (message (concat "Wrote " name " (+x)"))))))))
    (add-hook 'after-save-hook 'make-file-executable)
;; M-! で complete filename by tsuchiya
;(require 'shell-command)
;(shell-command-completion-mode)
;;;; GUI and mouse:GUI
(if window-system
     (global-unset-key "\C-z"))
;; 行間スペースを指定
(setq line-spacing 2)
;; よそのウィンドウにはカーソルを表示しない
(setq cursor-in-non-selected-windows nil)
;; カーソルの点滅をやめる
(blink-cursor-mode 0)
;; ツールバーを表示しない
(tool-bar-mode nil)
;; 画像ファイルを表示
(auto-image-file-mode)
;; ホイールマウスを使う
(mouse-wheel-mode)
;; カーソル位置に貼り付け
(setq mouse-yank-at-point t)
;; always end with newline
(setq require-final-newline t)
    ;;;
    ;;; for canna
    ;;;
    (if (and (boundp 'CANNA) CANNA) ; 『かんな/emacs』であることを確認
        ;;かんな/emacsの場合のみ以下を実行する
        (progn
        ;;;      (setq canna-underline t)   ;アンダーラインスタイル
        (setq default-input-method 'japanese-canna)
        (load-library "canna")
        (setq canna-do-keybind-for-functionkeys nil)
        (setq canna-server "localhost")
        (canna)
        
        ;;; かんなでのリージョンの単語登録を C-tで行う
        (global-set-key "\C-t" 'canna-touroku-region)
        
        ;;; アンドゥの設定
        (global-set-key "\C-_" 'canna-undo)
        
        ;;;      (setq canna-use-color t)
        
        ;;; アンドゥの設定
        (global-set-key "\C-_" 'canna-undo)
        
        ;;;      (setq canna-use-color t)
        
        ;;;かんなの変換中に BS & DEL を使う
        ;;;(define-key canna-mode-map [backspace] [?\C-h])
        ;;;(define-key canna-mode-map [delete] [?\C-h])
        
        ;;;かんなの変換中に C-h を使う (with term/keyswap)
        ;;;(define-key canna-mode-map [?\177] [?\C-h])
        
        (global-set-key [f1] 'canna-toggle-japanese-mode)
        (global-unset-key [kanji])
        (global-set-key "\C-o" 'open-line)
    ))

;-----------------------------------------------------------------------------
;;;; バッファ／ウィンドウ :buffer/window
;-----------------------------------------------------------------------------

(defun sp ()
  (interactive)
  (split-window))
(defun vs ()
  (interactive)
  (split-window-horizontally))
(defun cl ()
  (interactive)
  (delete-window))
(defun q ()
  (interactive)
  (delete-window))

;;; revert-buffer で yes/no を尋ねないようにする。
(defvar force-revert-buffer t)

(defadvice yes-or-no-p
  (around force-yes)
  (setq ad-return-value t))

(defadvice revert-buffer
  (around force-revert-buffer activate)
  (if force-revert-buffer
      (progn
	(ad-activate-regexp "force-yes")
	ad-do-it
	(ad-deactivate-regexp "force-yes"))
    ad-do-it))

(setq global-auto-revert-mode t)

;;   ;; 日本語の設定
;;   (set-language-environment "Japanese")
;;   (set-default-coding-systems 'euc-jp)
;;   (set-keyboard-coding-system 'japanese-iso-8bit-unix)
;;   ;; Canna を使うための設定
;;   (load-library "canna")
;;   (canna)
;;   ;; キーバインドを "Ctrl + o' にする。
;;   (global-set-key "\C-o" 'canna-toggle-japanese-mode)
;;   ;; フェンスモード中のバックスペースを有効にする
;;   (define-key canna-mode-map "\C-?" "\C-h")
;;   ;; キーバインドのカスタマイズ
;;   ;; C-t でテキストモード
;;   (global-set-key "\C-t" 'text-mode)
;;   ;; C-c C-u で auto-fill-mode の切替え
;;   (global-set-key "\C-c\C-u" 'auto-fill-mode)
;;   ;; C-c C-f で fill
;;   (global-set-key "\C-c\C-f" 'fill-region-as-paragraph)
;;   ;; フォントの設定
;;   (cond (window-system 
;;          (setq initial-frame-alist
;;   	     (append
;;   	      '((width . 80) (height . 54) (top . 0) (left . 600))
;;   	      initial-frame-alist))
;;          (setq default-frame-alist
;;   	     (append
;;   	      '((width . 80) (height . 54) (top . 0) (left . 600)
;;   		(font . "-misc-fixed-medium-r-normal--14-*"))
;;   	      default-frame-alist))))
;;   ;; 時刻の表示
;;   (setq display-time-24hr-format t)  ;; 24 時間表記
;;   (setq display-time-day-and-date t) ;; 日付も
;;   ;; 出力フォーマット
;;   (setq display-time-string-forms
;;         '(month "/" day "(" dayname ") " 24-hours ":" minutes))
;;   (display-time)
;;;; viper
;;(setq viper-mode t)
(setq viper-ex-style-motion nil)
(setq viper-ex-style-editing nil)
;;(require 'viper)
(require 'advice)
(defadvice viper-undo (around viper-undo-more-maybe activate)
  "Have `viper-undo' behave more like Vim."
  (if (eq last-command 'viper-undo)
      (viper-undo-more)
    ad-do-it))
;; do not adjust undo, so that inserting something, then moving around                              
;; and then inserting again generates 2 undo commands instead of one.                               
(defun viper-adjust-undo ()
  "Redefined to empty function so that movement commands with cursor break the undo list"
  )
;; vi の % をまねる
;; http://flex.ee.uec.ac.jp/texi/faq-jp/faq-jp_130.html
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))
;; XEmacs like / in minibuffer
(defun minibuffer-electric-separator ()
  (interactive)
  (let ((c last-command-char))
    (and (eq c directory-sep-char)
	 (eq c (char-before (point)))
	 (not (save-excursion
		(goto-char (point-at-bol))
		(and (looking-at "/.+:~?[^/]*/.+")
		     (re-search-forward "^/.+:~?[^/]*" nil t)
		     (progn
		       (delete-region (point) (point-max))
p		       t))))
	 (not (save-excursion
		(goto-char (point-at-bol))
		(and (looking-at ".+://[^/]*/.+")
		     (re-search-forward "^.+:/" nil t)
		     (progn
		       (delete-region (point) (point-max))
		       t))))
	 (not (eq (point) (1+ (point-at-bol))))
	 (or (not (eq ?: (char-after (- (point) 2))))
	     (eq ?/ (char-after (point-at-bol))))
	 (delete-region (point-at-bol) (point)))
    (insert c)))
(define-key minibuffer-local-completion-map
  (vector directory-sep-char) 'minibuffer-electric-separator)
;; scroll amount when cursor goes out of screen
(setq scroll-step 1)
(defun occur-at-point()
  "point のある位置の単語を occur にかける"
  (interactive)
  (occur (thing-at-point 'word)))
(defun trim-region (start end)
  "リージョン中の行末の無駄な空白を消去"
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char start)
      (replace-regexp "[ \t]+$" ""))))
(defun trim-eob ()
  "バッファの最後に溜った空行を消去"
  (interactive)
  (save-excursion
    (progn
      (goto-char (point-max))
      (delete-blank-lines)
      nil)))
(defun trim-buffer ()
  "バッファ中の行末の無駄な空白を消去"
  (interactive)
  (save-excursion
    (mark-whole-buffer)
    (trim-region (region-beginning) (region-end))))
;; _ を単語の一部とみなす
(modify-syntax-entry ?_ "w")
;; コンパイル画面はあんまりとらない
(setq compilation-window-height 10)
(defun display-ruby-on-minibuffer ()						  (interactive)
  (shell-command (concat "echo \"" (current-word) "\" | kakasi -JH"))
  )
;;;; バッファ／ウィンドウ:buffer/window
(require 'iswitchb)
(iswitchb-default-keybindings)
;;ファイルの先頭に #! が含まれているとき、自動的に chmod +x を行ってくれます。
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)
;; vim C-a/C-x
(defun integer-edit (add-num)
  (interactive)
  (save-excursion
    (skip-syntax-forward "-")
    (condition-case nil
	(let* ((p (point))
	       (i (read (current-buffer))))
	  (when (numberp i)
	    (delete-region p (point))
	    (insert (number-to-string (+ i add-num)))))
      (error nil))))
;; 全角空白／タブに色をつける
(defface my-face-b-1 '((t (:background "medium aquamarine"))) nil) ;全角スペース
;(defface my-face-b-2 '((t (:background "beige"))) nil) ;タブ
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ("　" 0 my-face-b-1 append)
     ("\t" 0 my-face-b-2 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
(add-hook 'find-file-hooks '(lambda ()
			      (if font-lock-mode
				  nil
				(font-lock-mode t))) t)
;;;; 補完
(setq completion-ignore-case t)	    ; C-xC-fで大文字小文字を区別しない
(setq read-file-name-completion-ignore-case t)
(defun line-beginning-to-point ()
  "行頭からポイントまでの文字列を返す。"
  (buffer-substring (line-beginning-position) (point)))

(defun kill-whole-line (arg)
  "vi の dd。"
  (interactive "p")
  (beginning-of-line)
  (let ((begin (point)) (killed 0))
    (end-of-line)
    (if (eobp)
	(progn
	  (end-of-line)
	  (setq killed 1))
      (setq killed (- arg (forward-line arg)))
      (beginning-of-line))
    (kill-region (point) begin)
    (message "Killed %d lines." killed)))

(defun my-kill-line (arg)
  "1. 引数が与えられたときは arg 行全体をキルする。
   2. ポイントが行頭から最初の非空白文字の間ならば行全体をキルする。
   3. そうでないなら行末までをキルする。"
  (interactive "P")
  (if arg
      (kill-whole-line arg)
    (if (string-match "^[ \t]*$" (line-beginning-to-point))
	  (kill-whole-line 1)
	(kill-region (point) (line-end-position)))))
    
  


;;;; 色
;(load-file "~/.emacs.d/face.el")
;;; スクロールバー
;(scroll-bar-mode t)
(setq scroll-bar-mode 'right)
;; カーソル位置のフェースを調べる関数
(defun describe-face-at-point ()
  "Return face used at point."
  (interactive)
  (message "%s" (get-char-property (point) 'face)))
(setq cpp-complt-standard-header-path
      '(
        "/usr/include/"
        ))
(defun mark-line ()
  "カレント行をマークする。"
  (interactive)
  (push-mark (line-beginning-position))
  (push-mark (line-end-position) t t)
  (goto-char (line-beginning-position)))
(defun toggle-comment-line (arg)
  "カレント行のコメントをトグルする。"
  (interactive "p")
  (let ((i 0))
    (while (< i arg)
      (back-to-indentation)
      (if (looking-at "//")
	  (delete-char 2)
	(insert "//"))
      (next-line 1)
      (setq i (1+ i)))))
(defun line-number (pos)
  "指定した位置の行番号を返す。"
  (+ (if (bolp)
	 1
       0)
     (count-lines (point-min) pos)))
(defun copy-with-line-number (beginning end)
  "行番号つきで行をコピーする。"
  (interactive "r")
  (setq lnum (count-lines beginning end))
  (save-excursion
    (goto-char beginning)
    (let ((i 0) (s ""))
      (while (< i lnum)
	(setq s
	      (concat s (number-to-string (line-number (point)))
		      "    "
		      (buffer-substring (line-beginning-position) (line-end-position))
		      "\n"
		      ))
	(next-line 1)
	(setq i (1+ i)))
      (message "Copied %d lines." lnum)
      (kill-new s))))
(defun my-beginning-of-line ()
  "スマートホーム。"
  (interactive)
  (let ((oldpos (point)))
    (back-to-indentation)
    (if (= (point) oldpos)
	(beginning-of-line))))
(setq default-frame-alist
      (append
       '((line-space . "5"))
       default-frame-alist))
(defun include-guard ()
  "インクルードガードをバッファに挿入する。"
  (interactive)
  (let ((macro
	 (concat (upcase (buffer-name))
		 "_H_INCLUDED")))
    (save-excursion
      (beginning-of-buffer)
      (insert (concat "#ifndef " macro "\n"
		      "#define " macro "\n\n\n"))
      (end-of-buffer)
      (insert (concat "#endif // " macro "\n"))))
  (goto-line 4))

;; M-x time-stamp でタイムスタンプ挿入
(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S")
(setq time-stamp-line-limit 10)

(defun my-insert-time ()
  (interactive)
  (insert (concat
	   (format-time-string "%Y-%m-%d %H:%M:%S"))))



;;;; メモ
;; ウィンドウ左上からの行数を取得する。
;(count-lines (window-start) (point))
(defun char-code-at-point ()
  "ポイント位置の文字のコードを16進数表記で返す。"
  (interactive)
  (if (eolp)
      "--"
    (format "%02X"
	    (string-to-char (buffer-substring (point) (+ 1 (point)))))))

;; color-mateよりcolor-themeのほうがいいらしい

;; Emacsのコンパイルオプション
;system-configuration-options

;; タブ2回目からはmenu-completeにする方法
;; ( ) のこと
;; {をいれたら改行して}をいれる方法

;; which-function の実体は:
;; add-log.el の add-log-current-defub


;; xyzzy の which-function-mode by 亀井さん
;; (or (boundp 'which-function-mode)
;;     (setq which-function-mode nil))
;; (or (boundp 'which-function-mode-name)
;;     (setq which-function-mode-name nil))
;; (or (boundp 'which-function-mode-last-point)
;;     (setq which-function-mode-last-point nil))

;; (defun which-function-find-defun ()
;;   (save-excursion
;;     (forward-char 1)
;;     (beginning-of-defun)
;;     (unless (eql which-function-mode-last-point (point))
;;       (setq which-function-mode-last-point (point))
;;       (forward-line -1)
;;       (setq which-function-mode-name
;; 	    (buffer-substring (point) (progn (goto-eol) (point))))
;;       (update-mode-line))))

;; (defun which-function-mode ()
;;   (interactive)
;;   (make-local-variable 'which-function-mode)
;;   (setq which-function-mode t)
;;   (make-local-variable 'which-function-mode-name)
;;   (make-local-variable 'which-function-mode-last-point)
;;   (make-local-variable '*post-command-hook*)
;;   (add-hook '*post-command-hook* 'which-function-find-defun))

;; (pushnew '(which-function-mode . which-function-mode-name)
;; 	 *minor-mode-alist* :key #'car)

;; man を見るには
;; M-x man

(setq auto-mode-alist
      (cons '("\\.py$" . python-mode) auto-mode-alist))

(autoload 'python-mode "python-mode" "Python editing mode." t)

(add-hook 'lisp-mode-hook (lambda ()
			    (slime-mode t)
			    (show-paren-mode)))

(add-hook 'scheme-mode-hook
	  (lambda ()
	    (find-file "~/w/scm/hoge.scm")))
(setq common-lisp-hyperspec-root
    (concat "file://" "/usr/local/share/HyperSpec/")
    common-lisp-hyperspec-symbol-table
    (expand-file-name "/usr/local/share/HyperSpec/Data/Map_Sym.txt"))
"/usr/local/share/HyperSpec/Data/Map_Sym.txt"
(global-set-key "\C-cH" 'hyperspec-lookup)


;;; SLIME
(require 'slime)
(setq slime-net-coding-system 'utf-8-unix)
(add-hook 'lisp-mode-hook (lambda ()
                            (slime-mode t)
                            (show-paren-mode)))
(add-hook 'slime-mode-hook
          (lambda ()
            (setq lisp-indent-function 'common-lisp-indent-function)))
(add-hook 'inferior-lisp-mode-hook
          (lambda ()
            (slime-mode t)
            (show-paren-mode)))
(setq inferior-lisp-program "/usr/bin/sbcl")

;; Additional definitions by Pierpaolo Bernardi.
(defun cl-indent (sym indent)
  (put sym 'common-lisp-indent-function
       (if (symbolp indent)
           (get indent 'common-lisp-indent-function)
         indent)))

(cl-indent 'if '1)
(cl-indent 'generic-flet 'flet)
(cl-indent 'generic-labels 'labels)
(cl-indent 'with-accessors 'multiple-value-bind)
(cl-indent 'with-added-methods '((1 4 ((&whole 1))) (2 &body)))
(cl-indent 'with-condition-restarts '((1 4 ((&whole 1))) (2 &body)))
(cl-indent 'with-simple-restart '((1 4 ((&whole 1))) (2 &body)))

(setq slme-lisp-implementations
      '((sbcl ("sbcl") :coding-system utf-8-unix)
        (cmucl ("cmucl") :coding-system iso-latin-1-unix)))

;; CMUCL
;(defun cmucl-start ()
;  (interactive)
;  (shell-command ""))

;; SBCL
(defun sbcl-start ()
  (interactive)
  (shell-command "sbcl --load $HOME/.slime.l &"))

;; GNU CLISP
(defun clisp-start ()
  (interactive)
  (shell-command (format "clisp -K full -q -ansi -i %s/.slime.l &" (getenv "HOME"))))

(modify-coding-system-alist 'process "gosh" '(utf-8 . utf-8))
(setq scheme-program-name "gosh -i")
(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process." t)

(defun scheme-other-window ()
  "Run scheme on other window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))

(define-key global-map
  "\C-cs" 'scheme-other-window)


