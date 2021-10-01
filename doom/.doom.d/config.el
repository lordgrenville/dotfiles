;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq
   user-full-name "Josh Friedlander"
   user-mail-address "joshuatfriedlander@gmail.com"
   doom-font (font-spec :family "Fira Mono for Powerline" :size 16)
   ;; doom-variable-pitch-font (font-spec :family "ETBembo" :size 24)
   ;; doom-variable-pitch-font (font-spec :family "Vollkorn")
   ;; doom-variable-pitch-font (font-spec :family "Noto Sans" :size 19)
   doom-theme 'doom-snazzy
   ;; doom-theme 'doom-vibrant
   org-directory "~/Dropbox/org/"
   projectile-project-search-path '("~/Documents/")
; This determines the style of line numbers in effect. If set to `nil', line
; numbers are disabled. For relative line numbers, set this to `relative'.
   display-line-numbers-type 'relative
   org-startup-folded 'overview
; repetitive modeline diagnostics not needed
   lsp-modeline-diagnostics-enable nil
;; display time, and don't show me the system load, which makes no sense to me
   display-time-default-load-average 'nil
   +ivy-buffer-preview t
; in org-mode, TAB key cycles headings even inside text block, rather than emulating real tab
; (matching the behaviour in Magit)
   org-cycle-emulate-tab 'nil
   comint-scroll-to-bottom-on-output t
   ob-mermaid-cli-path "/usr/local/bin/mmdc"
   doom-fallback-buffer-name "► Doom"
   +doom-dashboard-name "► Doom"
;; hide wrapping punctuation in org mode
   org-hide-emphasis-markers t
; ignore org-mode and others in flycheck (syntax checker)
   flycheck-global-modes '(not gfm-mode forge-post-mode gitlab-ci-mode dockerfile-mode Org-mode org-mode)
   conda-anaconda-home "~/miniforge3/"
; does this work? if not use M-x ispell-change-dict
   ispell-dictionary "en_GB"
)

(display-time)

(with-eval-after-load 'doom-themes
  (doom-themes-treemacs-config))

; lines should be the screen length of my MBP, not 80 (emacs default) or 70 (org-mode default!)
(after! org (add-hook 'org-mode-hook
                      (lambda () (setq fill-column 145))))

(add-hook 'org-mode-hook 'org-fragtog-mode)
;
; don't autolaunch spell-fu
(remove-hook 'text-mode-hook #'spell-fu-mode)
(add-hook 'text-mode-hook #'flyspell-mode)

; pylsp formatter doesn't work, overrride it manually
(setq-hook! 'python-mode-hook +format-with 'black)

; in doom instead of define-key you have a convenience macro map!
; you can prepend :leader, or :en for emacs, normal mode etc
; more at :h map!
(map!
   :n "]s"   #'evil-next-flyspell-error
   :n "[s"   #'evil-prev-flyspell-error
 )
(map!
 (:after evil
   :n "z="   #'flyspell-correct-word-before-point)
 )

(defun add-pcomplete-to-capf ()
  (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))

(add-hook 'org-mode-hook #'add-pcomplete-to-capf)

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

(defalias 'yes-or-no-p 'y-or-n-p)
(add-hook 'python-mode-hook 'anaconda-mode)

(evil-set-initial-state 'term-mode 'emacs)
(evil-set-initial-state 'help-mode 'emacs)
(evil-set-initial-state 'shell-mode 'emacs)
(evil-set-initial-state 'dired-mode 'emacs)
(evil-set-initial-state 'wdired-mode 'normal)
(evil-set-initial-state 'git-commit-mode 'emacs)
(evil-set-initial-state 'git-rebase-mode 'emacs)

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
