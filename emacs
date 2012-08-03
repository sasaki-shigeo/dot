;;;;
;;;; Emacs start up program
;;;;
;;;; This file is designed for emacs19/emacs20/xemacs.
;;;; Emacs18 or earlier are not supported
;;;;

(if (= emacs-major-version 19)
    (require 'cl))			; common lisp package

;;; set variables
(setq load-path (cons (expand-file-name "~/elisp") load-path))
(setq Info-additional-directory-list '("/usr/share/info"))
(setq-default fill-column 64)		; text-mode
;;(setq-default fill-prefix "\t")
(setq require-final-newline nil)	; default
(setq make-backup-files t)		; default
(setq version-control nil)		; default
(setq backup-by-copying-when-linked t)
(setq visible-bell t)
(setq grep-command "egrep -n ")		; emacs 19 or later
(setq next-line-add-newlines t)		; emacs 21 or later

;;; file setting
(setq auto-mode-alist
      (nconc '(("[mM]akefile~?$" . text-mode)
	       ("\\.l~?$"	. c-mode)	;lex
	       ;; ("\\.[ch]~$"	. c-mode)
	       ("\\.cc~?$"	. c++-mode)
	       ;; ("\\.java~?$"	. java-mode)
	       ("\\.p~?$"	. pas-mode)
	       ("\\.hs~?$"      . haskell-mode)
	       ("\\.doc~?$"	. outline-mode)
	       ("\\.tex~?$"	. tex-mode)
	       ("\\.s?html?~?$"	. html-helper-mode)
	       ("\\.sdoc~?$"	. sdoc-mode)
	       ("\\.message$"	. text-mode)) ; vin
	      auto-mode-alist))

;;; key-maps
(define-key global-map  "\r"	'newline-and-indent)
(define-key global-map  "\n"	'newline)
(define-key global-map  "\M-`"  'goto-line)
(define-key ctl-x-map   "%"	'blink-matching-open)
(define-key esc-map	"#"	'ispell-word)

;;; *** Strongly Individual ***
;;; You should not copy this paragraph
;;(define-key ctl-x-map   "\t"	'toggle-tab-indent)
(define-key ctl-x-map   "\C-v"	'view-file)
;;(define-key ctl-x-map   "\C-e"  'compile)
(define-key ctl-x-map   "B"     'bury-buffer)
(define-key esc-map	"r"     'rename-buffer)
(define-key esc-map	"\C-x"  'compile)
;;; Enable
(put 'eval-expression 'disabled nil)	; ESC ESC or M-:
;;; Disable
(put 'set-fill-prefix 'disabled t)	; C-x .
(put 'set-fill-column 'disabled t)	; C-x f
(put 'set-goal-column 'disabled t)	; C-x C-n


;;; You may be confused about the position of BS key and DEL key.
;;; If you want to exchange the position between BS and DEL, eval following
;;    (load "term/bobcat")
;;; If you want to give BS key the function of deleting a backward char,
;;; eval following sexp's.
;; (define-key global-map "\b"	    'backward-delete-char-untabify);
;; (define-key minibuffer-local-map "\b" 'backward-delete-char)
;; (setq search-delete-char ?\b)

;;; text-mode
(add-hook 'text-mode-hook
	  '(lambda ()
	     (auto-fill-mode 1)
	     (if (string-match "[mM]akefile" (buffer-name))
		 (auto-fill-mode 0))))

;;; TeX mode (for emacs 19 or later)
;; (setq tex-shell-file-name "/bin/sh")
(setq tex-run-command "ptex")
(setq latex-run-command "platex")
(setq tex-bibtex-command "jbibtex")
(setq tex-dvi-view-command "xdvi")
(setq tex-dvi-print-command "dvips -f * | lpr -Plpress")
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
	     (define-key tex-mode-map "\""       'self-insert-command)
	     (define-key tex-mode-map "\C-c\C-i" 'tex-insert-item)
	     (define-key tex-mode-map "\C-co"    'tex-latex-block)
	     (define-key tex-mode-map "\C-c\C-b" 'tex-latex-block)
	     (define-key tex-mode-map "\C-cb"    'tex-latex-block)
	     (define-key tex-mode-map "\C-cc"    'tex-close-latex-block)))

(add-hook 'tex-shell-hook
	  '(lambda ()
	     (set-buffer-process-coding-system 'euc-jp 'euc-jp)))

(defun latex-insert-external-program (pathname)
  (interactive "F")
  (let ((filename (file-name-nondirectory pathname))
	p1 p2 p3)
    (insert "\\begin{program}")
    (setq p1 (point))
    (insert "\n\\begin{verbatim}\n")
    (setq p2 (point))
    (insert "\\end{verbatim}\n"
	    "\\end{program}\n")
    (save-excursion
      (set-mark (point))
      (if (not (file-exists-p pathname))
	  (goto-char p2)
	(save-excursion
	  (goto-char p2)
	  (set-mark (+ 1 p2))
	  (insert-file-contents pathname)
	  (untabify p2 (mark)))
	(goto-char p1)
	(insert " \\caption{" filename "} \\label{" filename "}")
	(goto-char (mark))))))

;;;
;;; C mode (C, C++, Java)
;;;

(add-hook 'c-mode-common-hook 'turn-on-font-lock)

(add-hook 'c-mode-common-hook
	  '(lambda ()
	     (setq c-basic-offset 4)
	     (setq c-offsets-alist
		   (nconc '((case-label . +)
			    (arglist-intro . 6)
			    (arglist-close . 6))
			  c-offsets-alist))))

(add-hook 'c-mode-hook
	  '(lambda ()
	     (setq c-basic-offset 4)
	     (setq c-comment-only-line-offset 0)
	     (setq c-hanging-braces-alist '((substatement-open before)))
	     (setq c-offsets-alist
		   (nconc '((substatement       . 4)
			    (substatement-open  . 0)
			    (case-label         . +)
			    (access-label       . 0)
			    (inher-intro        . +)
			    (inher-cont         . 4)
			    (inclass            . +)
			    (inline-open        . 0))
			  c-offsets-alist))))

(add-hook 'java-mode-hook
	  '(lambda ()
	     (make-local-variable 'compile-command)
             (setq compile-command
                   (concat "javac "
                           (file-name-nondirectory  buffer-file-name)))))

;(setq c-argdecl-indent 5)
;(setq c-indent-level 4)
;(setq c-continued-statement-offset 4)
;(setq c-label-offset -3)

;;; pascal mode
(setq pas-indent 4)

;;; shell mode
(setq shell-pushd-regexp "pd")
;; (setq explicit-shell-file-name "/usr/local/bin/zsh")
;; (autoload 'cmushell "cmushell" nil t)

;;; lisp mode
(put 'if 'lisp-indent-function 3)
(put 'defvar  'lisp-indent-function 2)
(put 'when    'lisp-indent-function 1)
(put 'unless  'lisp-indent-function 1)
(put 'dotimes 'lisp-indent-function 1)
(put 'dolist  'lisp-indent-function 1)
(put 'do      'lisp-indent-function 2)
(put 'do*     'lisp-indent-function 2)
(put 'case    'lisp-indent-function 1)
(put 'ecase    'lisp-indent-function 1)
(put 'typecase 'lisp-indent-function 1)
(put 'etypecase 'lisp-indent-function 1)
(put 'multiple-value-bind 'lisp-indent-function 2)
(put 'multiple-value-setq 'lisp-indent-function 1)
(put 'block   'lisp-indent-function 1)
(put 'with-open-file 'lisp-indent-function 1)
(add-hook 'emacs-lisp-mode-hook
	  '(lambda ()
	     (define-key ctl-x-map "\C-e" 'eval-last-sexp)))
(add-hook 'lisp-interaction-mode-hook
	  '(lambda ()
	     (define-key ctl-x-map "\C-e" 'eval-last-sexp)))

;(autoload 'find-doc "find-doc" nil t)
;(define-key help-map "d" 'find-doc)
;(visit-doc-file "/usr/local/lib/gcl/doc/DOC")


;;; scheme
;;(setq scheme-program-name "mzscheme")
(setq scheme-program-name "gosh")
;; (autoload 'run-scheme "cmuscheme" nil t)
(add-hook 'scheme-mode-hook
	  '(lambda ()
	     (autoload 'run-scheme "cmuscheme" nil t)
	     (if (zerop (buffer-size))
		 (insert ";;; -*- scheme -*-\n;;;\n;;;\n"))))

(put 'dolist 'scheme-indent-function 1)
(put 'dotimes 'scheme-indent-function 1)

;;; Ruby
(autoload 'ruby-mode "ruby-mode" nil t)
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process" t)
(setq auto-mode-alist (cons '("\\.rb~?$" . ruby-mode) auto-mode-alist))

;;; Python
(autoload 'python-mode  "python-mode" nil t)
(autoload 'jpython-mode "python-mode" nil t)
(autoload 'py-shell     "python-mode" nil t)

;;; Haskell
(autoload 'haskell-mode "haskell-mode" nil t)
(autoload 'run-haskell "inf-haskell" nil t)
(setq haskell-program-name "hugs \"+.\" -98")

;; E-Debug
(autoload 'edebug-defun 		"edebug" nil t)

;;; dired mode
(setq dired-listing-switches "-alg")
(add-hook 'dired-mode-hook
	  '(lambda ()
	     (define-key dired-mode-map " " 'scroll-up)
	     (define-key dired-mode-map "b" 'scroll-down)	 
	     (define-key dired-mode-map "j" 'dired-next-line)
	     (define-key dired-mode-map "k" 'dired-previous-line)
	     (define-key dired-mode-map "z" 'dired-find-compressed-file)))

;;;
;;; psgml-mode(an sgml mode) and sdoc-mode(an emacs mode for SmartDoc)
;;;
(autoload 'sdoc-mode "sdoc-mode" "Major mode to edit SmartDoc files." t)
(add-hook 'sdoc-mode-hook
	  '(lambda ()
	     (and (load "sgml-end-tag" t)
		  (define-key sdoc-mode-map "\C-c}" 'sgml-insert-end-tag)
		  (define-key sdoc-mode-map "\C-c)" 'sgml-insert-end-tag)
		  (define-key sdoc-mode-map "\C-c\C-]" 'sgml-insert-end-tag))))
(add-hook 'sdoc-mode-hook #'auto-fill-mode)

;; (autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
;; (autoload 'xml-mode "psgml" "Major mode to edit XML files." t)

;;;
;;; auto insert
;;;
;;(setq auto-insert t)

(defun java-insert-template ()
  (let ((classname (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
    (insert "public class " classname " {\n"
	    "    public static void main(String[] args) {\n\n"
	    "    }\n"
	    "}\n")))

(when (fboundp 'auto-insert-mode)
  (auto-insert-mode t)
  (setq auto-insert-directory (expand-file-name "~/.insert/"))
  (setq auto-insert-alist
	(nconc '(("\\.tex$" . "tex-insert.tex")
		 ("\\.html$" . "html-insert.html")
		 ("\\.shtml$" . "html-insert.html")
		 ("\\.sdoc$" . "sdoc-insert.sdoc")
		 ("\\.xml$" . "xml-insert.xml")
		 (java-mode . java-insert-template))
	       auto-insert-alist)))

;;;;
;;;; print
;;;;

(setq ps-multibyte-buffer 'non-latin-printer)
(setq ps-print-color-p nil)
(setq ps-bold-faces '(font-lock-keyword-face)
      ps-italic-faces '(font-lock-type-face)
      ps-underlined-faces 'nil)

;;;;
;;;; Hand-made functions
;;;;

;;; swap tab-to-tab-stop <=> indent-line-function
(defun toggle-tab-indent ()
  (interactive)
  (if (eq (local-key-binding "\t") 'tab-to-tab-stop)
      (progn
	(local-set-key "\t"   '(lambda () (interactive)
				 (funcall indent-line-function)))
	(local-set-key "\M-i" 'tab-to-tab-stop)
	(message "TAB is %s"  indent-line-function))
      (progn
	(local-set-key "\t"   'tab-to-tab-stop)
	(local-set-key "\M-i" '(lambda () (interactive)
				 (funcall indent-line-function)))
	(message "TAB is %s"  'tab-to-tab-stop))))

;;; display time
(setq display-time-day-and-date nil)

;;;;
;;;; Mail/News/W3 Interface
;;;;

;;;
;;; MIME (this feature is proveded by TM or SEMI)
;;;
(load "mime-setup" t)

;;;
;;; Common to almost Mail/News Interface
;;;
(setq mail-yank-prefix "> ")
(setq mail-aliases t)
(setq mail-self-blind t)		; BCC to myself
;; (setq mail-archive-file-name "~/Mail/FCC") ; mail record
;;(setq mail-default-headers "From: sasaki@is.akita-u.ac.jp (SASAKI Shigeo)\n")
(setq user-mail-address "sig@is.akita-u.ac.jp")
(setq belonging-mail-lists-regex nil)


;;;
;;; Mail (sending mail)
;;;
(defun mail-reply-to ()
  (interactive)
  (expand-abbrev)
  (or (mail-position-on-field "reply-to" t)
      (progn (mail-position-on-field "to")
	     (insert "\nReply-To: "))))
(add-hook 'mail-mode-hook
	  '(lambda ()
	     (define-key mail-mode-map "\C-c\C-f\C-r" 'mail-reply-to)))

;;; Rmail
(setq rmail-file-name "~/Mail/RMAIL")	; mail inbox
(setq rmail-mode-hook
      '(lambda ()
	 (setq rmail-delete-after-output t)
	 (setq rmail-output-directory "~/Mail")))

;;;
;;; wanderlust
;;;
(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-draft "wl" "Write draft with Wanderlust." t)

;;;
;;; Gnus
;;;
(setq gnus-default-subscribed-newsgroups t
      gnus-auto-subscribed-groups ".")

;;;
;;; JDE
;;;
(setq jde-jdk-doc-url
      "http://www.is.akita-u.ac.jp/local/java/jdk1.3/docs/ja/api/overview-summary.html")
(setq jde-help-docsets
      (list (list "JDK API"
		  (expand-file-name "~www/data/local/jdk5/docs/ja/api/")
		  nil)))

;;;
;;; w3m.el
;;; 

(require 'w3m-load nil t)
(require 'mime-w3m nil t)
(setq browse-url-browser-function 'w3m-browse-url)


;;;
;;; Navi2ch
;;;
(require 'navi2ch nil t)
(setq navi2ch-net-http-proxy "wproxy.is.akita-u.ac.jp:8080")
(setq navi2ch-article-auto-expunge t)
(setq navi2ch-list-bbstable-url "http://menu.2ch.net/bbstable.html")

;;;
;;; Emacs Wiki
;;;
(require 'emacs-wiki nil t)


;;;
;;; W3.el
;;;
(setq w3-default-homepage "http://www.is.akita-u.ac.jp/~sig/linklist.html")
(setq w3-do-incremental-display t)
;;(setq url-proxy-services '(("http" . "cache.is.akita-u.ac.jp:8080")))
;;(setq url-using-proxy "http://www.is.akita-u.ac.jp/")
(setq url-news-server "news://news.akita-u.ac.jp")
(setq url-global-history-file (expand-file-name "~/dot/w3-history"))

;;; Online Dictionary
(autoload 'online-dictionary "diclookup-mule" "Reference CD-ROM Dictionary" t)
;(autoload 'od:lookup-pattern-edit "diclookup" nil t)
(setq dserver-server-list '("symphony"))
(setq od-dictfile-list '("od-eiwa"))
;(define-key ctl-x-map "\C-d" 'od:lookup-pattern-edit)
;(setq od:*window-config* 5)
;(setq od:*default-jisyo* "eiwa")

;;;
;;; EGG/Wnn
;;;

(let ((jserver (getenv "JSERVER")))
  (or (and (boundp 'wnn-jserver) wnn-jserver)
      (if jserver
	  (setq wnn-jserver (list jserver)))))

(setq my-roma-kana-rule-alist
      (mapcar #'(lambda (x) (list x x))
	      '("thi" "twu" "thu" "dhi" "dwu" "dhu"
		"@" "#" "$" "%" "^" "&" "*" "(" ")" "+" "=" "_" "\\"
		"|" "`" "<" ">" "/" ":" ";" "\"" "'" "{" "}"
		"0" "1" "2" "3" "4" "5" "6" "7" "8" "9")))

;;;
;;; Paren Color Setting (by Satoru Takabayashi)
;;;
;;; The following codes possibly do not run on Emacs 19
;;;

(defvar paren-face 'paren-face)
(make-face 'paren-face)
(set-face-foreground 'paren-face "#88aaff")

(defvar brace-face 'brace-face)
(make-face 'brace-face)
(set-face-foreground 'brace-face "#ffaa88")

(defvar bracket-face 'bracket-face)
(make-face 'bracket-face)
(set-face-foreground 'bracket-face "#aaaa00")

; (setq lisp-font-lock-keywords-2
;       (append '(("(\\|)" . paren-face))
; 	      lisp-font-lock-keywords-2))

; (setq lisp-font-lock-keywords-2
;       (append '(("(\\|)" . paren-face))
; 	      lisp-font-lock-keywords-2))

; (add-hook 'scheme-mode-hook
; 	  '(lambda ()
; 	     (setq scheme-font-lock-keywords-2
; 		   (append '(("(\\|)" . paren-face))
; 			   scheme-font-lock-keywords-2))))

; (setq c-font-lock-keywords-3
;       (append '(("(\\|)" . paren-face))
; 	      '(("{\\|}" . brace-face))
; 	      '(("\\[\\|\\]" . bracket-face))
; 	      c-font-lock-keywords-3))


;;;;
;;;; Version Specific Customization
;;;;

;;;
;;; Japanese
;;;

(setq menu-coding-system 'euc-jp)

;;; Xemacs
(and (featurep 'xemacs)
     (setq custom-file "elisp/customize.el")
     window-system
     (fboundp 'set-face-font)
     (set-face-font 'default "-*-fixed-medium-r-normal--14-*"))

;;; roma->kana
(when (fboundp 'select-input-method)	; XEmacs
  (select-input-method "japanese-egg-wnn")
  (define-key global-map "\M- " 'toggle-input-method))

;;(when (featurep 'faces)
;;  (set-face-foreground))

;;; Emacs 20, 21
(when (and (or (= emacs-major-version 20)
	       (= emacs-major-version 21))
	   (not (featurep 'xemacs)))
  (set-language-environment "Japanese")
  (set-terminal-coding-system 'iso-2022-jp)
  (set-keyboard-coding-system 'iso-2022-jp-dos)
  ;; (set-terminal-coding-system 'sjis)
  ;; (set-keyboard-coding-system 'sjis-dos)
  (require 'egg "egg" t)
  (cond ((featurep 'its)		; EGG4
	 (define-key global-map "\M- " 'toggle-input-method)
	 ;;(custom-set-variables '(its-hira-enable-double-n nil))
	 (setq its-hira-enable-double-n nil)
	 (setq its-hira-enable-zenkaku-alphabet nil)
	 (setq its-hira-comma "，")
	 (define-its-state-machine-append its-hira-map
	   (its-defrule "Z,"  "、" nil t)
	   (its-defrule "wi"  "うぃ" nil t)
	   (its-defrule "we"  "うぇ" nil t)
	   (its-defrule "thi" "てぃ" nil t)
	   (its-defrule "twu" "とぅ" nil t)
	   (its-defrule "thu" "てゅ" nil t)
	   (its-defrule "dhi" "でぃ" nil t)
	   (its-defrule "dwu" "どぅ" nil t)
	   (its-defrule "dhu" "でゅ" nil t)))
	((featurep 'egg)
	 (let ((its:*defrule-verbose* nil))
	   (egg)				; EGG3
	   (define-key global-map "\M- " 'toggle-egg-mode)
	   (dolist (pair my-roma-kana-rule-alist)
	     (its-defrule (car pair) (cadr pair) nil nil "roma-kana")))))
      
  ;; EWnn (English Wnn)
  ;; (load "ewnn" t)
  (setq ewnn-server-list '("junsai" "lambda"))
  ;; (define-key global-map " " 'self-insert-command)

  (scroll-bar-mode -1)
  (autoload 'html-helper-mode "html" nil t)

  (setq default-frame-alist
	(nconc '((font . "fontset-14"))
	       default-frame-alist)))

(when (featurep 'tool-bar)
  (tool-bar-mode nil))

;;;
;;; HHK and Apple Keyboard have Erase keys printed as DELETE.
;;; If you use such a keyboard, let normal-erase-is-backspace be zero.
;;;
(when (= emacs-major-version 21)
  (normal-erase-is-backspace-mode 0))

;;;
;;; Emacs 19
;;;
(defun set-frame-attribute (key value)
  (let* ((config (current-frame-configuration))
	 (slot  (assoc key (car (cdr (car (cdr config)))))))
    (setcdr slot value)
    (set-frame-configuration config)))

(if (= emacs-major-version 19)
    (progn
      (fmakunbound 'c-mode)
      (makunbound  'c-mode-map)
      (fmakunbound 'c++-mode)
      (makunbound  'c++-mode-map)
      (makunbound  'c-style-alist)

      (autoload 'c-mode "cc-mode" nil t)
      (autoload 'c++-mode "cc-mode" nil t)
      (autoload 'java-mode "cc-mode" nil t)

      ;; autoloading
      (autoload 'pas-mode "pas-mode" nil t)
      (autoload 'html-helper-mode "html" nil t)

      (scroll-bar-mode -1)

      (if (featurep 'mule)
	  (let ((its:*defrule-verbose* nil))
	    (dolist (pair my-roma-kana-rule-alist)
	      (its-defrule (car pair) (cadr pair) nil nil "roma-kana"))
	    (define-key global-map  "\M- "  'toggle-egg-mode)))


      ;;(its-defrule "!"   "! "    nil nil "roma-kana")
      ;;(its-defrule ","   ", "    nil nil "roma-kana")
      ;;(its-defrule "."   ". "    nil nil "roma-kana")
      ;;(its-defrule "?"   "? "    nil nil "roma-kana")

      ;; EWnn (English Wnn)
      (load "ewnn" t)
      (setq ewnn-server-list '("junsai" "lambda"))))

;;;
;;; Eshell for emacs 20
;;;

(when (= emacs-major-version 20)
  ;; You can run eshell by M-x eshell
  (require 'eshell-auto)
  ;; Use pcomplete with shell-mode 
  (require 'pcmpl-auto))
(add-hook 'shell-mode-hook 'pcomplete-shell-setup)

;;;
;;; End of Personal Costomization.
;;;
;;; following lines are added by emacs
;;;

(put 'narrow-to-region 'disabled nil)
(custom-set-variables)
(custom-set-faces
 '(font-lock-comment-face ((((class color) (background light)) (:foreground "dark blue"))))
 '(font-lock-string-face ((((class color) (background light)) (:foreground "black"))))
 '(font-lock-keyword-face ((((class color) (background light)) (:bold t :foreground "navy blue"))))
 '(font-lock-constant-face ((((class color) (background light)) (:foreground "black"))))
 '(font-lock-type-face ((((class color) (background light)) (:foreground "dark green"))))
 '(font-lock-variable-name-face ((((class color) (background light)) (:foreground "black"))))
 '(font-lock-function-name-face ((((class color) (background light)) (:foreground "black"))))
 '(font-lock-builtin-face ((((class color) (background light)) (:foreground "black")))))
