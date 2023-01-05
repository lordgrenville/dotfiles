;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq
  user-full-name "Josh Friedlander"
  user-mail-address "joshuatfriedlander@gmail.com"
  doom-font (font-spec :family "Fira Mono for Powerline" :size 16)
  ;; doom-variable-pitch-font (font-spec :family "Liberation Mono" :size 15)
  ;; doom-variable-pitch-font (font-spec :family "Meslo LG M DZ for Powerline" :size 15)
  doom-variable-pitch-font (font-spec :family "Noto Sans" :size 13)
  doom-theme-treemacs-theme "doom-colors"
  delete-by-moving-to-trash t
  undo-limit 9999999
  evil-want-fine-undo t
  ;; I think I want autosave-visited-mode here? but might be on by default?
  auto-save-default t
  scroll-margin 2
  lsp-pylsp-server-command "/home/josh/.local/bin/pylsp"
  org-directory "~/Dropbox/org/"
  ;; org-hugo-base-dir "~/Documents/dev/blog/athena/"
  projectile-project-search-path '("~/Documents/")
  ; This determines the style of line numbers in effect. If set to `nil', line
  ; numbers are disabled. For relative line numbers, set this to `relative'.
  display-line-numbers-type 'visual
  lsp-modeline-diagnostics-enable nil
  ;; display time, and don't show me the system load, which makes no sense to me
  display-time-default-load-average 'nil
  dired-kill-when-opening-new-dired-buffer t
  +ivy-buffer-preview t
  ; in org-mode, TAB key cycles headings even inside text block, rather than emulating real tab
  ; (matching the behaviour in Magit)
  org-cycle-emulate-tab 'nil
  comint-scroll-to-bottom-on-output t
  ob-mermaid-cli-path "/opt/homebrew/bin/mmdc"
  ;; hide wrapping punctuation in org mode
  org-hide-emphasis-markers t
  ; ignore org-mode and others in flycheck (syntax checker)
  flycheck-global-modes '(not gfm-mode forge-post-mode gitlab-ci-mode dockerfile-mode Org-mode org-mode)
  ; does this work? if not use M-x ispell-change-dict
  ispell-dictionary "en_ZA"
  ;; ispell-local-dictionary "en_ZA"
  ;; ispell-program-name "aspell"
  ;; ispell-extra-args '("--sug-mode=ultra" "--run-together")
  org-todo-keywords '((sequence "TODO" "DONE"))
  ; for mac with external keyboard: https://github.com/hlissner/doom-emacs/issues/3952#issuecomment-716608614
  ns-right-option-modifier 'left
  ;; hides top menu bar on Gnome
  default-frame-alist '((undecorated . t))
  )

(display-time)

(defun apply-to-region (func)
  (unless (use-region-p)
    (error "need an active region"))
  (let ((res (funcall func (buffer-substring (mark) (point)))))
    (delete-region (region-beginning) (region-end))
    (insert res))
  )

(defun text-to-wikipedia-link (string)
  "Convert a string to a link to English Wikipedia"
        (concat "[[https://en.wikipedia.org/wiki/" (subst-char-in-string ?  ?_ string) "][" string "]]"))

(defun my/org-insert-wikipedia-link ()
  (interactive)
  (apply-to-region 'text-to-wikipedia-link))

(defun number-to-whatsapp-link (string)
  "Phone number to whatsapp link"
        (concat "https://web.whatsapp.com/send/?phone=972" (string-remove-prefix "0" string) ))

(defun my/make-whatsapp-link ()
  (interactive)
  (apply-to-region 'number-to-whatsapp-link))

; in doom instead of define-key you have a  macro map!
; you can prepend :leader, or :en for emacs, normal mode etc
; more at :h map!
(map!
 :n "]s"   #'evil-next-flyspell-error
 :n "[s"   #'evil-prev-flyspell-error
 :leader :desc "Clear search highlight" "s c" #'evil-ex-nohighlight
 :leader "j" #'evilem-motion-next-line
 :leader "k" #'evilem-motion-previous-line
 )

(map!
 (:after evil
  :n "z=" #'flyspell-correct-word-before-point
  :n "n"  #'next-search-and-centre)
  :n "C-t" nil
 ;; overrides the default of "correct before point", which has a nice
 ;; GUI popup but crashes Emacs. Use C-o to get option to add/accept
 ;; :map evil-normal-state-map "z=" #'flyspell-correct-wrapper
 )

(defun next-search-and-centre ()
  "Run `evil-ex-search-next` and `evil-scroll-line-to-center` in sequence."
  (interactive)
  (evil-ex-search-next 1)
  (evil-scroll-line-to-center nil))

(evil-define-command evil-goto-mark-line (char &optional noerror)
  "Go to the line of the marker specified by CHAR."
  :keep-visual t
  :repeat nil
  :type line
  :jump t
  (interactive (list (read-char)))
  (evil-goto-mark char noerror)
  (evil-first-non-blank)
  (evil-scroll-line-to-center nil))

(after! org
  (setq org-startup-folded t)
  (map! :localleader
        :map org-mode-map
        (:desc "Insert source code block" "i" 'org-insert-structure-template))
  (map! :localleader
        :map org-mode-map
        (:desc "Make Wikipedia link" "w" #'my/org-insert-wikipedia-link))
  (map!
   (
    :n "<down>"   #'evil-next-visual-line
    :n "<up>"   #'evil-previous-visual-line
    :n "j"   #'evil-next-visual-line
    :n "k"   #'evil-previous-visual-line
    )
   ))

(after! treemacs
  (setq treemacs-git-mode nil))

(add-hook! 'org-mode-hook
           #'turn-off-smartparens-mode
           'org-fragtog-mode)

; lines should be the screen length of my MBP, not 80 (emacs default) or 70 (org-mode default!)
;; (setq-hook! '(text-mode-hook) fill-column 145)

;; (after! treemacs
;;   (setq evil-treemacs-state-cursor nil
;;         treemacs-show-cursor nil
;;         treemacs-width 30))

(add-hook! python-mode
  (conda-env-activate "myenv")
  (lambda () (+fold/close-all))
)

(setq-hook! 'python-mode-hook
  +format-with 'black
; pylsp formatter doesn't work, overrride it manually
  lsp-pylsp-plugins-pydocstyle-enabled nil
  lsp-pylsp-plugins-flake8-config "/Users/josh/.flake8"
  )

; don't autolaunch spell-fu
(remove-hook 'text-mode-hook #'spell-fu-mode)
(add-hook 'text-mode-hook #'flyspell-mode)

(dolist (mode '(
                   ;; term-mode
                   ;; vterm-mode
                   ;; help-mode
                   ;; shell-mode
                   ;; dired-mode
                   ;; wdired-mode
                   ;; git-commit-mode
                   ;; git-rebase-mode
                   ))
  (evil-set-initial-state mode 'emacs))

;; stuff from Tecosaur, not major
; show battery status in bottom right
(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))

; start in fullscreen
(if (eq initial-window-system 'x) ; if started by emacs command or desktop file
    (toggle-frame-maximized)
  (toggle-frame-fullscreen))

(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is
   not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))
(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(defalias 'yes-or-no-p 'y-or-n-p)

(with-eval-after-load 'ox
  (require 'ox-hugo))

(evil-define-key 'normal peep-dired-mode-map (kbd "<SPC>") 'peep-dired-scroll-page-down
                                             (kbd "C-<SPC>") 'peep-dired-scroll-page-up
                                             (kbd "<backspace>") 'peep-dired-scroll-page-up
                                             (kbd "j") 'peep-dired-next-file
                                             (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(with-eval-after-load 'treemacs
  (defun treemacs-ignore-pycache (file _)
    (string= file "__pycache__"))
  (push #'treemacs-ignore-pycache treemacs-ignored-file-predicates))

(setq counsel-find-file-ignore-regexp
        (concat
         ;; File names beginning with # or .
         "\\(?:^[#.]\\)\\|\\(?:[#~]$\\)\\|\\(?:^Icon?\\)"
         ;; File names ending with # or ~
         "__pycache__"))

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
