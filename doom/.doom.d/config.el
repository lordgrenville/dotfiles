;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

; Place your private configuration here! Remember, you do not need to run 'doom
; sync' after modifying this file!


; Some functionality uses this to identify you, e.g. GPG configuration, email
; clients, file templates and snippets.
(setq user-full-name "Josh Friedlander"
      user-mail-address "joshuatfriedlander@gmail.com")

; Doom exposes five (optional) variables for controlling fonts in Doom. Here
; are the three important ones:
;
; + `doom-font'
; + `doom-variable-pitch-font'
; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;   presentations or streaming.
;
; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
; font string. You generally only need these two:

(setq doom-font (font-spec :family "Fira Mono for Powerline" :size 16)
      doom-variable-pitch-font (font-spec :family "ETBembo" :size 24))

; There are two ways to load a theme. Both assume the theme is installed and
; available. You can either set `doom-theme' or manually load a theme with the
; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

; my `org-directory' has to be in Documents so that iCloud will back it up 🙄
(setq org-directory "~/Documents/org/")
;; (setq org-roam-directory "~/Documents/org/roam/")

; lines should be the screen length of my MBP, not 80 (emacs default) or 70 (org-mode default!)
(after! org (add-hook 'org-mode-hook
	  (lambda () (setq fill-column 145))))

(add-hook 'org-mode-hook 'org-fragtog-mode)

; This determines the style of line numbers in effect. If set to `nil', line
; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type 'fixed)
(setq display-line-numbers-type 'relative)

; pylsp formatter doesn't work, overrride it manually
(setq-hook! 'python-mode-hook +format-with 'black)

;; display time, and don't show me the system load, which makes no sense to me
(setq display-time-default-load-average 'nil)
(display-time)

; repetitive modeline diagnostics not needed
(setq lsp-modeline-diagnostics-enable nil)

(map!
     :n "]s"      #'evil-next-flyspell-error
     :n "[s"      #'evil-prev-flyspell-error
 )

(map!
     :n  "z="     #'flyspell-correct-word-before-point
 )

; don't autolaunch spell-fu
(remove-hook 'text-mode-hook #'spell-fu-mode)
(add-hook 'text-mode-hook #'flyspell-mode)

(setq +ivy-buffer-preview t)

; in org-mode, TAB key cycles headings even inside text block, rather than emulating real tab
; (matching the behaviour in Magit)
(setq org-cycle-emulate-tab 'nil)

(setq comint-scroll-to-bottom-on-output t)

(defun add-pcomplete-to-capf ()
  (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))

(add-hook 'org-mode-hook #'add-pcomplete-to-capf)

;; keybind to disable search highlighting (like :set noh)
;; ok I don't need this but keeping it here for reference
;; (map! :leader
;;       :desc "SPC k kil buffer like in my Vim"
;;       "k"
;;       #'kill-buffer)

;; keybind to disable search highlighting (like :set noh)
(map! :leader
      :desc "Clear search highlight"
      "s c"
      #'evil-ex-nohighlight)

; show battery status in bottom right
(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))

; start in fullscreen
(if (eq initial-window-system 'x) ; if started by emacs command or desktop file
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))
(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

;; (setq gnus-select-method '(nntp "news.eternal-september.org"))
;; (setq gnus-read-active-file nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom")

;; hide wrapping punctuation in org mode
(setq org-hide-emphasis-markers t)

;; (setq frame-title-format
;;     '(""
;;       (:eval
;;        (if (buffer-file-name "")
;;            (replace-regexp-in-string ".*/[0-9]*-?" "🢔 " buffer-file-name)
;;          "%b"))
;;       (:eval
;;        (let ((project-name (projectile-project-name)))
;;          (unless (string= "-" project-name)
;;            (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

;; (conda-env-autoactivate-mode t)

; ignore org-mode and others in flycheck (syntax checker)
(setq flycheck-global-modes '(not gfm-mode forge-post-mode gitlab-ci-mode dockerfile-mode Org-mode org-mode))

; does this work? check next time you restart, otherwise use M-x ispell-change-dict
(setq ispell-dictionary "en_GB")

; Here are some additional functions/macros that could help you configure Doom:
;
; - `load!' for loading external *.el files relative to this one
; - `use-package' for configuring packages
; - `after!' for running code after a package has loaded
; - `add-load-path!' for adding directories to the `load-path', relative to
;   this file. Emacs searches the `load-path' when you load packages with
;   `require' or `use-package'.
; - `map!' for binding new keys
;
; To get information about any of these functions/macros, move the cursor over
; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
; This will open documentation for it, including demos of how they are used.

; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
; they are implemented.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files '("/josh/org/kbase.org"))
 '(package-selected-packages '(aggressive-indent)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(evil-set-initial-state 'term-mode 'emacs)
(evil-set-initial-state 'help-mode 'emacs)
(evil-set-initial-state 'shell-mode 'emacs)
(evil-set-initial-state 'dired-mode 'emacs)
(evil-set-initial-state 'wdired-mode 'normal)
(evil-set-initial-state 'git-commit-mode 'emacs)
(evil-set-initial-state 'git-rebase-mode 'emacs)
