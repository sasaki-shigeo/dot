;;;
;;; ~/.emacs.d/init.el
;;;

(setq load-path (cons (expand-file-name "~/elisp") load-path))
(setq-default fill-column 64)		; text-mode
(setq require-final-newline nil)	; default
(setq make-backup-files t)		; default
(setq version-control nil)		; default
(setq backup-by-copying-when-linked t)
(setq visible-bell t)
(setq grep-command "egrep -n ")
(setq next-line-add-newlines t)

;;; key-maps
(define-key global-map	"\r"	'newline-and-indent)
(define-key global-map	"\n"	'newline)
(define-key global-map	"\M-`"	'goto-line)
(define-key global-map  "\M- "  'set-mark)
(define-key ctl-x-map	"%"	'blink-matching-open)
(define-key ctl-x-map	"\C-v"	'view-file)
(define-key ctl-x-map	"B"	'bury-buffer)
(define-key esc-map	"\C-x"	'compile)
;;; Disable
(put 'set-fill-prefix 'disabled t)	; C-x .
(put 'set-fill-column 'disabled t)	; C-x f
(put 'set-goal-column 'disabled t)	; C-x C-n
;;; Enable
(put 'eval-expression 'disabled nil)	; ESC ESC or M-:

(when (and tty-erase-char
	   (= tty-erase-char ?\b))
  (define-key global-map (string tty-erase-char) 'backward-delete-char-untabify)
  (define-key minibuffer-local-map (string tty-erase-char) 'backward-delete-char)
  (setq search-delete-char tty-erase-char))

;;; text-mode
(add-hook 'text-mode-hook
	  '(lambda ()
	     (auto-fill-mode 1)
	     (if (string-match "[mM]akefile~?" (buffer-name))
		 (auto-fill-mode 0))))


;;; TeX mode (for emacs 19 or later)
;; (setq tex-shell-file-name "/bin/sh")
(setq tex-run-command "ptex")
(setq latex-run-command "platex")
(setq tex-bibtex-command "jbibtex")
;;(setq tex-dvi-view-command "xdvi -s 8")
(setq tex-dvi-view-command "dvipdfmx")
;;(setq tex-dvi-print-command "dvips -f * | lpr -Pddc")
;;(setq tex-dvi-print-command "dvips -f * |psfilter -d| lpr -Plp")
(setq tex-default-mode 'latex-mode)
(setq latex-block-names '("Def" "example" "question" "exercise" "alltt"))
(defun tex-insert-item ()
  (interactive)
  (insert "\\item "))
(add-hook 'latex-mode-hook
	  '(lambda ()
	     ;; (outline-minor-mode 1)
	     ;; (make-local-variable 'outline-regexp)
	     ;; (setq outline-regexp "\\\\\\(chap\\|\\(sub\\)*sect\\)")
	     (set-variable tex-run-command "ptex")
	     (set-variable latex-run-command "platex")
	     (set-variable tex-dvi-view-command "dvipdfmx")
	     (define-key tex-mode-map "\""       'self-insert-command)
	     (define-key tex-mode-map "\C-c\C-i" 'tex-insert-item)
	     (define-key tex-mode-map "\C-co"    'tex-latex-block)
	     (define-key tex-mode-map "\C-c\C-b" 'tex-latex-block)
	     (define-key tex-mode-map "\C-cb"    'tex-latex-block)
	     (define-key tex-mode-map "\C-cc"    'tex-close-latex-block)))


;;;
;;; MacOS
;;;
(when (eq system-type 'darwin)
  (setq ns-command-modifier 'meta)
  (let ((path (shell-command-to-string "eval `/usr/libexec/path_helper`; echo $PATH")))
    (setenv "PATH" path t)))

(when (eq window-system 'ns)
  (setq default-directory "~/")
  (setq command-line-default-directory "~/"))

;;;
;;; Emacs 28 Official Binary for MacOS or Home Brew Distribuion has
;;; a bug that cause an error at the start time.
;;;
;;; Emacs 28 for MacOS can handle
(when (and (eq window-system 'ns)
	   (string>= emacs-version "28"))
  (add-to-list 'image-types 'svg))

;;;
;;; MacOS font settings
;;;
(when (memq window-system '(mac ns))
  (global-set-key [s-mouse-1] 'browse-url-at-mouse)
  (let* ((size 14)
	 (jpfont "Hiragino Maru Gothic ProN")
	 (asciifont "Courier")
	 (h (* size 10)))
    (set-face-attribute 'default nil :family asciifont :height h)
    (set-fontset-font t 'katakana-jisx0201 jpfont)
    (set-fontset-font t 'japanese-jisx0208 jpfont)
    (set-fontset-font t 'japanese-jisx0212 jpfont)
    (set-fontset-font t 'japanese-jisx0213-1 jpfont)
    (set-fontset-font t 'japanese-jisx0213-2 jpfont)
    (set-fontset-font t '(#x0080 . #x024F) asciifont))
  (setq face-font-rescale-alist
	'(("^-apple-hiragino.*" . 1.2)
	  (".*-Hiragino Maru Gothic ProN-.*" . 1.2)
	  (".*osaka-bold.*" . 1.2)
	  (".*osaka-medium.*" . 1.2)
	  (".*courier-bold-.*-mac-roman" . 1.0)
	  (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
	  (".*monaco-bold-.*-mac-roman" . 0.9)
	  ("-cdac$" . 1.3)))
  ;; C-x 5 2 で新しいフレームを作ったときに同じフォントを使う
  (setq frame-inherited-parameters '(font tool-bar-lines)))

;; 以下の設定はお好みで
(setq resize-mini-windows nil)
(setq mouse-drag-copy-region t)
