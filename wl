;;; -*- emacs-lisp -*-
;;;
;;; Wanderlust
;;;

;;(setq wl-local-domain "is.akita-u.ac.jp")
(setq wl-smtp-posting-server "mailer.is.akita-u.ac.jp")
(setq wl-nntp-posting-server "news.akita-u.ac.jp")

(setq elmo-imap4-default-server "mailer.is.akita-u.ac.jp")
(setq elmo-imap4-default-authenticate-type 'auth) ; or "login", "cram-md5"
(setq elmo-nntp-default-server "news.akita-u.ac.jp")
(setq elmo-nntp-default-user nil)

(setq elmo-pop3-default-server "mailer.ed.akita-u.ac.jp")
(setq elmo-pop3-default-authenticate-type 'apop)


(setq wl-default-folder "+primary")
(setq wl-default-spec "+")

(setq wl-draft-reply-buffer-style 'full)
(setq wl-interactive-exit nil)

(setq wl-temporary-file-directory "/tmp/")


(autoload 'wl-user-agent-compose "wl-draft" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'wl-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'wl-user-agent
      'wl-user-agent-compose
      'wl-draft-send
      'wl-draft-kill
      'mail-send-hook))

(setq wl-draft-reply-without-argument-list
      '(("Mail-Followup-To" . (("Mail-Followup-To") nil ("Newsgroups")))
	("Followup-To" . (nil nil ("Followup-To")))
	(("X-ML-Name" "Reply-To") . (("Reply-To") nil nil))
	("From" . (("From") ("To" "Cc") ("Newsgroups")))))

(setq mime-view-ignored-field-list
      '("^X-.*" ".*Received:" ".*Path:" ".*Id:" "^References:"
	"^Replied:" "^Errors-To:" "^Lines:" "^Sender:" ".*Host:" "^Xref:"
	"^Content-Type:" "^Precedence:" "^Status:"
	"^Content-Transfer-Encoding:"
	"^Mime-Version:" "^Delivered-To:" "^In-Reply-To:"))

(setq mime-edit-split-message nil)

(setq wl-from "sig@is.akita-u.ac.jp (SASAKI Shigeo)")
;;(setq wl-envelope-from "sig@is.akita-u.ac.jp")
(setq wl-draft-always-delete-myself t)

(setq wl-expire-alist
      '(("^\\+trash$"	(date 5) remove)
	("^\\+junky$"	(date 14) remove)
	("^\\+primary$"	(date 14) "+old")
	("^\\+daemon$"	(date 7) remove)
	("^\\+cron"	(date 14) remove)
	("^\\+FreeBSD"	(date 10) remove)
	("^\\+memo"     (date 30) remove)
	("^\\+ruby/list" (date 14) remove)
	("^\\+wl"	(date 14) remove)
	("^\\+postfix"  (date 14) remove)
	("^\\+imap4"    (date 14) remove)
	("^\\+test"     (date 14) remove)))

; (setq wl-subscribed-mailing-list
;       '("ningen-kankyo-profs@ed.akita-u.ac.jp"
; 	"kankyo-oyo-senshu-profs@ed.akita-u.ac.jp"
; 	"kankyo-joho-koza-profs@ed.akita-u.ac.jp"
; 	"profs@is.akita-u.ac.jp"
; 	"staff@is.akita-u.ac.jp"
; 	"net-comm@ed.akita-u.ac.jp"
; 	"net-staff@ed.akita-u.ac.jp"
; 	"drinker"
; 	"shinse-kanji"
; 	"scl-douki"
; 	"FreeBSD-users-jp"))


;; (setq wl-plugged nil)			; off-line
(add-hook 'wl-make-plugged-hook
	  '(lambda ()
	     (elmo-set-plugged nil "mailer.is.akita-u.ac.jp" "imap4")
	     (elmo-set-plugged nil "mailer.ed.akita-u.ac.jp" 110)))

(define-key wl-summary-mode-map "n" 'wl-summary-down)
(define-key wl-summary-mode-map "N" 'wl-summary-next)
(define-key wl-summary-mode-map "p" 'wl-summary-up)
(define-key wl-summary-mode-map "P" 'wl-summary-prev)
(define-key wl-summary-mode-map "t " 'wl-thread-mark-as-read)
(define-key wl-summary-mode-map "k"
  '(lambda ()
     (interactive)
     (wl-thread-mark-as-read)
     (wl-summary-down)))
;(define-key wl-summary-mode-map "g" 'wl-summary-incorporate)
(define-key wl-summary-mode-map "v" 'wl-summary-goto-folder)
(define-key wl-summary-mode-map "r" 'wl-summary-reply)
(define-key wl-summary-mode-map "R" 'wl-summary-reply-with-citation)
(define-key wl-summary-mode-map "\M-p" 'wl-summary-pack-number)
