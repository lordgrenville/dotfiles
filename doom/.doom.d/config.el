;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq
   user-full-name "Josh Friedlander"
   user-mail-address "joshuatfriedlander@gmail.com"
   ;; doom-font (font-spec :family "Fira Mono for Powerline" :size 16)
   doom-font (font-spec :family "Fira Mono for Powerline" :size 16 :weight 'light)
   doom-variable-pitch-font (font-spec :family "Noto Sans" :size 13)
   doom-theme 'doom-dracula
   ;; doom-theme-treemacs-theme "doom-atom"
   doom-theme-treemacs-theme "doom-colors"
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
   doom-fallback-buffer-name "► Doom"
   +doom-dashboard-name "► Doom"
;; hide wrapping punctuation in org mode
   org-hide-emphasis-markers t
; ignore org-mode and others in flycheck (syntax checker)
   flycheck-global-modes '(not gfm-mode forge-post-mode gitlab-ci-mode dockerfile-mode Org-mode org-mode)
   conda-anaconda-home "~/miniforge3/"
; does this work? if not use M-x ispell-change-dict
   ;; ispell-dictionary "en_ZA"
   ;; ispell-program-name "aspell"
   ;; ispell-extra-args '("--sug-mode=ultra" "--run-together")
   org-todo-keywords '((sequence "TODO" "DONE"))
   ; for mac with external keyboard: https://github.com/hlissner/doom-emacs/issues/3952#issuecomment-716608614
   ns-right-option-modifier 'left
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
 )

(defun next-search-and-centre ()
  "Run `evil-ex-search-next` and `evil-scroll-line-to-center` in sequence."
  (interactive)
  (evil-ex-search-next 1)
  (evil-scroll-line-to-center nil))

(map!
 (:after evil
   :n "z=" #'flyspell-correct-word-before-point
   :n "n"  #'next-search-and-centre
   )
 )

;; keybind to disable search highlighting (like :set noh)
(map! :leader
      :desc "Clear search highlight"
      "s c"
      #'evil-ex-nohighlight)

;; (map! :n
;;       "C-a" #'evil-numbers/inc-at-pt
;;       "C-x" #'evil-numbers/dec-at-pt
;; )

; (map!
  ; :after company
  ; :map company-active-map
  ;; "RET" nil
  ;; "<return>" nil
  ;; [tab] nil
  ; "TAB" nil
  ; )

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

(defun add-pcomplete-to-capf ()
  (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))

(add-hook! 'org-mode-hook
           #'turn-off-smartparens-mode
           ;; #'add-pcomplete-to-capf
           'org-fragtog-mode)
;; (define-key global-map (kbd "C-c x")
;;   (lambda () (interactive) (org-capture nil "t")))

; lines should be the screen length of my MBP, not 80 (emacs default) or 70 (org-mode default!)
;
;; (setq-hook! '(text-mode-hook) fill-column 145)

;; (after! treemacs
;;   (setq evil-treemacs-state-cursor nil
;;         treemacs-show-cursor nil
;;         treemacs-width 30))

(add-hook! python-mode (conda-env-activate "myenv"))
; pylsp formatter doesn't work, overrride it manually
(setq-hook! 'python-mode-hook
  +format-with 'black
  lsp-pylsp-plugins-pydocstyle-enabled nil
  lsp-pylsp-plugins-flake8-config "/Users/josh/.flake8"
  )

; don't autolaunch spell-fu
(remove-hook 'text-mode-hook #'spell-fu-mode)
(add-hook 'text-mode-hook #'flyspell-mode)

;; (evil-set-initial-state 'term-mode 'emacs)
;; (evil-set-initial-state 'vterm-mode 'emacs)
;; (evil-set-initial-state 'help-mode 'emacs)
;; (evil-set-initial-state 'shell-mode 'emacs)
;; (evil-set-initial-state 'dired-mode 'emacs)
;; (evil-set-initial-state 'wdired-mode 'normal)
;; (evil-set-initial-state 'git-commit-mode 'emacs)
;; (evil-set-initial-state 'git-rebase-mode 'emacs)

;; the above was rewritten into a loop using the dolist macro!
(dolist (mode '(
                   ;; term-mode
                   ;; vterm-mode
                   ;; help-mode
                   ;; shell-mode
                   ;; dired-mode
                   ;; wdired-mode
                   git-commit-mode
                   git-rebase-mode
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

(map! :after evil
      ;; overrides the default of "correct before point", which has a nice
      ;; GUI popup but crashes Emacs. Use C-o to get option to add/accept
      :map evil-normal-state-map
      "z=" #'flyspell-correct-wrapper
      )
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

;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
;; (add-hook 'org-mode-hook 'turn-off-auto-fill)

;; (after! treemacs
;;   (setq treemacs-default-visit-action 'treemacs-visit-node-close-treemacs))

;; (after! org-capture

;;   (defun +doct-icon-declaration-to-icon (declaration)
;;     "Convert :icon declaration to icon"
;;     (let ((name (pop declaration))
;;           (set  (intern (concat "all-the-icons-" (plist-get declaration :set))))
;;           (face (intern (concat "all-the-icons-" (plist-get declaration :color))))
;;           (v-adjust (or (plist-get declaration :v-adjust) 0.01)))
;;       (apply set `(,name :face ,face :v-adjust ,v-adjust))))

;;   (defun +doct-iconify-capture-templates (groups)
;;     "Add declaration's :icon to each template group in GROUPS."
;;     (let ((templates (doct-flatten-lists-in groups)))
;;       (setq doct-templates (mapcar (lambda (template)
;;                                      (when-let* ((props (nthcdr (if (= (length template) 4) 2 5) template))
;;                                                  (spec (plist-get (plist-get props :doct) :icon)))
;;                                        (setf (nth 1 template) (concat (+doct-icon-declaration-to-icon spec)
;;                                                                       "\t"
;;                                                                       (nth 1 template))))
;;                                      template)
;;                                    templates))))

;;   (setq doct-after-conversion-functions '(+doct-iconify-capture-templates))

;;   (defun set-org-capture-template ()
;;     (setq org-capture-templates
;;           (doct `(("Personal todo" :keys "t"
;;                    :icon ("checklist" :set "octicon" :color "green")
;;                    :file +org-capture-todo-file
;;                    :prepend t
;;                    :headline "Inbox"
;;                    :type entry
;;                    :template ("* TODO %?"
;;                               "%i"))
;;                   ("Personal note" :keys "n"
;;                    :icon ("sticky-note-o" :set "faicon" :color "green")
;;                    :file +org-capture-todo-file
;;                    :prepend t
;;                    :headline "Inbox"
;;                    :type entry
;;                    :template ("* %?"
;;                               "%i %a"))
;;                   ("Tasks" :keys "k"
;;                    :icon ("inbox" :set "octicon" :color "yellow")
;;                    :file +org-capture-todo-file
;;                    :prepend t
;;                    :headline "Tasks"
;;                    :type entry
;;                    :template ("* TODO %? %^G%{extra}"
;;                               "%i %a")
;;                    :children (("General Task" :keys "k"
;;                                :icon ("inbox" :set "octicon" :color "yellow")
;;                                :extra "")
;;                               ("Task with deadline" :keys "d"
;;                                :icon ("timer" :set "material" :color "orange" :v-adjust -0.1)
;;                                :extra "\nDEADLINE: %^{Deadline:}t")
;;                               ("Scheduled Task" :keys "s"
;;                                :icon ("calendar" :set "octicon" :color "orange")
;;                                :extra "\nSCHEDULED: %^{Start time:}t")))
;;                   ))))
;;   (set-org-capture-template)
;;   (unless (display-graphic-p)
;;     (add-hook 'server-after-make-frame-hook
;;               (defun org-capture-reinitialise-hook ()
;;                 (when (display-graphic-p)
;;                   (set-org-capture-templates)
;;                   (remove-hook 'server-after-make-frame-hook
;;                                #'org-capture-reinitialise-hook))))))

;; (defun org-capture-select-template-prettier (&optional keys)
;;   "Select a capture template, in a prettier way than default
;; Lisp programs can force the template by setting KEYS to a string."
;;   (let ((org-capture-templates
;;          (or (org-contextualize-keys
;;               (org-capture-upgrade-templates org-capture-templates)
;;               org-capture-templates-contexts)
;;              '(("t" "Task" entry (file+headline "" "Tasks")
;;                 "* TODO %?\n  %u\n  %a")))))
;;     (if keys
;;         (or (assoc keys org-capture-templates)
;;             (error "No capture template referred to by \"%s\" keys" keys))
;;       (org-mks org-capture-templates
;;                "Select a capture template\n━━━━━━━━━━━━━━━━━━━━━━━━━"
;;                "Template key: "
;;                `(("q" ,(concat (all-the-icons-octicon "stop" :face 'all-the-icons-red :v-adjust 0.01) "\tAbort")))))))
;; (advice-add 'org-capture-select-template :override #'org-capture-select-template-prettier)

;; (add-hook 'tuareg-mode-hook #'(lambda() (setq mode-name "🐫")))

;; (add-to-list 'load-path "/Users/josh/.opam/default/share/emacs/site-lisp")
;; (require 'ocp-indent)

; visual line numbers that work with folds
;; (defun josh/toggle-relative-line-numbers ()
;;   (interactive)
;;   (if display-line-numbers
;;       (setq display-line-numbers nil)
;;     (progn (setq display-line-numbers 'visual)
;;            )))
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
