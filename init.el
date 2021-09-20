;;; init.el --- Emacs Startup Program                -*- lexical-binding: t; -*-

;;; Code:

(add-to-list 'load-path
	     (expand-file-name "~/elisp"))

(setq grep-command "egrep -n ")

(when window-system
  (setq ring-bell-function 'ignore)
  (setq visible-bell t))


(add-to-list 'auto-mode-alist '("[mM]akefile~?" . text-mode))

(provide 'init)
;;; init.el ends here
