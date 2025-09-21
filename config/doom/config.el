;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq
 user-full-name "Josh Friedlander"
 user-mail-address "joshuatfriedlander@gmail.com"
 doom-font (font-spec :family "Fira Mono for Powerline" :size 14)
 doom-variable-pitch-font (font-spec :family "Liberation Mono for Powerline" :size 15)
 doom-variable-pitch-font (font-spec :family "Meslo LG M DZ for Powerline" :size 15)
 doom-symbol-font (font-spec :family "Apple Color Emoji")
 doom-theme-treemacs-theme "doom-colors"
 delete-by-moving-to-trash t
 undo-limit 9999999
 evil-want-fine-undo t
 auto-save-visited-mode t
 scroll-margin 2
 org-directory "~/Documents/org/"
 ;; org-hugo-base-dir "~/Documents/dev/blog/athena/"
 projectile-project-search-path '("~/Documents/")
                                        ; This determines the style of line numbers in effect. If set to `nil', line
                                        ; numbers are disabled. For relative line numbers, set this to `relative'.
 display-line-numbers-type 'visual
 lsp-modeline-diagnostics-enable nil
 ;; display time, and don't show me the system load, which makes no sense to me
 display-time-default-load-average 'nil
 ;; doom-modeline-hud t
 ;; doom-modeline-battery t
 ;; doom-modeline-time-icon t
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
 ispell-dictionary "en_ZA"
 ispell-hunspell-dict-paths-alist '(("en_ZA" . ("/Users/joshf/Library/Spelling/en_ZA.aff")))
                                        ; for mac with external keyboard: https://github.com/hlissner/doom-emacs/issues/3952#issuecomment-716608614
 ns-right-option-modifier 'left
 )

(display-time)
(defun my/keyboard-layout ()
  (if (string-match-p "Hebrew"
                      (shell-command-to-string "defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep \"KeyboardLayout Name\" ")
                      ) "ℷℶℵ" "ABC"
                        )
  )

(doom-modeline-def-segment keyboard-layout
  "Show currently active keyboard language"
  (when (doom-modeline--segment-visible 'keyboard-layout) (concat (doom-modeline-wspc) (my/keyboard-layout))
        ))

;; Define your custom doom-modeline
(doom-modeline-def-modeline 'my-simple-line
  '(bar window-state workspace-name window-number modals matches follow buffer-info buffer-position word-count selection-info)
  '(keyboard-layout misc-info project-name persp-name battery minor-modes input-method indent-info buffer-encoding major-mode process check time))

;; Set default mode-line
(add-hook 'doom-modeline-mode-hook
          (lambda ()
            (doom-modeline-set-modeline 'my-simple-line 'default)))

;; Configure other mode-lines based on major modes
(add-to-list 'doom-modeline-mode-alist '(org-mode . my-simple-line))

;; ...in addition to this (see https://github.com/doomemacs/doomemacs/issues/6478)
(evil-select-search-module 'evil-search-module 'evil-search)

(defun apply-to-region (func)
  (unless (use-region-p)
    (error "need an active region"))
  (let ((res (funcall func (buffer-substring (mark) (point)))))
    (delete-region (region-beginning) (region-end))
    (insert res))
  )

(defun select-around-word ()
  "If there is no active region, define the region as the word nearest to the point"
  (unless (use-region-p)
    (push-mark (point))
    (backward-sexp)
    (mark-sexp)
    (exchange-point-and-mark)))

(defun text-to-wikipedia-link (string)
  "Convert a string to a link to English Wikipedia"
  (concat "[[https://en.wikipedia.org/wiki/" (capitalize (subst-char-in-string ?  ?_ string)) "][" string "]]"))

(defun my/org-insert-wikipedia-link ()
  (interactive)
  (select-around-word)
  (apply-to-region 'text-to-wikipedia-link))

(defun my/move-and-fold-toggle ()
  (interactive)
  (evil-first-non-blank)
  (+fold/toggle))

(defun number-to-whatsapp-link (string)
  "Phone number to whatsapp link"
  (concat "https://web.whatsapp.com/send/?phone=972" (string-remove-prefix "0" string) ))

(defun my/make-whatsapp-link ()
  (interactive)
  (apply-to-region 'number-to-whatsapp-link))

(defun my/fix-mac-quotes ()
  ;;Replace those badly named 'smart quotes' Apple loves with something simpler
  (interactive)
  (replace-string-in-region "“" "\"" (point-min))
  (replace-string-in-region "”" "\"" (point-min))
  )

(defun jump-down-to-non-whitespace-char-in-same-column ()
  (interactive)
  (evil-next-line)
  (while (or (= (char-after (point)) 32)
             (= (char-after (point)) 10))
    (evil-next-line)))

(defun jump-up-to-non-whitespace-char-in-same-column ()
  (interactive)
  (evil-previous-line)
  (while (or (= (char-after (point)) 32)
             (= (char-after (point)) 10))
    (evil-previous-line)))

                                        ; in doom instead of define-key you have a  macro map!
                                        ; you can prepend :leader, or :en for emacs, normal mode etc
                                        ; more at :h map!
(map!
 :n "]s"   #'evil-next-flyspell-error
 :n "[s"   #'evil-prev-flyspell-error
 :n "ze"   #'hs-hide-level
 :n "zi" #'my/move-and-fold-toggle
 :leader :desc "Clear search highlight" "s c" #'evil-ex-nohighlight
 :leader "j" #'evilem-motion-next-line
 :leader "k" #'evilem-motion-previous-line
 :leader "fw" #'find-file-other-window
 )

(map!
 (:after evil
  :n "z=" #'flyspell-correct-at-point
  :n "n"  #'next-search-and-centre)
 :n "C-t" nil
 ;; overrides the default of "correct before point", which has a nice
 ;; GUI popup but crashes Emacs. Use C-o to get option to add/accept
 ;; :map evil-normal-state-map "z=" #'flyspell-correct-wrapper
 )

(defun my/find-and-fix-spelling ()
  "Go to next flyspell error and suggest fixes"
  (interactive)
  (evil-next-flyspell-error)
  (flyspell-correct-at-point))

(defun my/empty-sql-buffer ()
  "Pop up an empty SQL mode buffer and dump clipboard in it"
  (interactive)
  (let ((buf (generate-new-buffer "sql-buffer")))
    (switch-to-buffer buf)
    (sql-mode)
    (yank))
  )

(defun my/scroll-all-buffers-to-fill-screen ()
  (interactive)
  (if (eq (length (window-list)) 1) (evil-window-vsplit)
    ;; (evil-window-up 1)
    )
  (find-file "/Users/joshf/Documents/work_kbase.org")
  (+org/open-all-folds)
  (evil-scroll-line-to-bottom (line-number-at-pos))
  (evil-window-right 1)
  (find-file "/Users/joshf/Documents/org/journal.org")
  (+org/open-all-folds)
  (evil-scroll-line-to-bottom (line-number-at-pos))
  (evil-scroll-line-down 20)
  )

(defun my/org-capture ()
  (interactive)
  (org-capture nil "k"))

(defun my/edit-downloads ()
  "Open Downloads folder in dired"
  (interactive)
  (dired "/Users/joshf/Downloads"))

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
  (setq
   org-startup-folded t
   ;; old style org folding to fix search bug...
   org-fold-core-style 'overlays
   org-modern-fold-stars '(("►" . "▼") ("▷" . "▽") ("⏵" . "⏷") ("▹" . "▿") ("▸" . "▾"))
   org-capture-templates '(
                           ("k" "Work Log Entry"
                            entry (file+datetree +org-capture-journal-file)
                            "* %?"
                            ;; :empty-lines-before 1
                            ))
   )


  (map! :localleader
        :map org-mode-map
        (:desc "Insert source code block" "i" 'org-insert-structure-template))
  (map! :localleader
        :map org-mode-map
        (:desc "Make Wikipedia link" "w" #'my/org-insert-wikipedia-link))
  ;; (setq company-backends '(:separate company-dabbrev company-yasnippet company-ispell))
  (map!
   (
    :n "<down>"   #'evil-next-visual-line
    :n "<up>"   #'evil-previous-visual-line
    :n "j"   #'evil-next-visual-line
    :n "k"   #'evil-previous-visual-line
    :leader :desc "Fix next typo" "r" #'my/find-and-fix-spelling
    :leader :desc "downloads folder" "oD" #'my/edit-downloads
    :leader :desc "empty SQL buffer" "nb" #'my/empty-sql-buffer
    :leader :desc "Org capture work thought" "x" #'my/org-capture
    :leader :desc "Set things up the way I like" "d" #'my/scroll-all-buffers-to-fill-screen
    )
   ))

(global-unset-key (kbd "s-t"))          ;; don't open a new project with Cmd-t

(after! treemacs
  (setq treemacs-git-mode nil))

;; (add-hook! 'org-mode-hook
;;            ;; #'turn-off-smartparens-mode
;;            'org-fragtog-mode)

;; (defun my/query-fixup-tool (&optional project)
;;   ;;Replace in either the region or the buffer and copy to clipboard.
;;   ;;Defaults to migration or production, can also give a project name
;;   (interactive)
;;   (let (
;;         (begin (if (use-region-p) (point) (point-min)))
;;         (end   (if (use-region-p) (mark) (point-max)))
;;         )
;;     (kill-ring-save begin end))
;;   (with-temp-buffer
;;     (yank)
;;     (replace-string-in-region "PROJECTID_REPLACE" "anzu-179515" (point-min))
;;     (let (
;;           ;; if project is null (the default, so can mean it was not supplied) then use y-or-n-p
;;           (replacement (if project project (if (y-or-n-p "Replace with migration?") "migration" "production")))
;;           )
;;       (replace-string-in-region "DATASET_REPLACE" replacement (point-min)))
;;     (kill-region (point-min) (point-max)))
;;   )

                                        ; lines should be the screen length of my MBP, not 80 (emacs default) or 70 (org-mode default!)
;; (setq-hook! '(text-mode-hook) fill-column 145)

;; (after! treemacs
;;   (setq evil-treemacs-state-cursor nil
;;         treemacs-show-cursor nil
;;         treemacs-width 30))

;; if long file, fold it
(if (< 50 (count-lines (point-min) (point-max))) (+fold/close-all))

(add-hook! python-mode
                                        ; (+fold/close-all)         ; like in VS Code (does this work tho?)
           (set-fill-column 120)
           (display-fill-column-indicator-mode)
           (python-ts-mode)
           ;; (eglot-ensure)
           )


(setq-hook! 'python-mode-hook
  ;; pylsp formatter doesnt work, override it manually
  ;; +format-with 'black
  lsp-pylsp-plugins-pylint-enabled t
  lsp-pylsp-plugins-pydocstyle-enabled nil
  python-shell-virtualenv-root "my_env312"
                                        ; lsp-pylsp-plugins-flake8-config "/Users/josh/.flake8"
  )

                                        ; don't autolaunch spell-fu
(remove-hook 'text-mode-hook #'spell-fu-mode)
(add-hook 'text-mode-hook #'flyspell-mode)

;; (dolist (mode '(
;; term-mode
;; vterm-mode
;; help-mode
;; shell-mode
;; dired-mode
;; wdired-mode
;; git-commit-mode
;; git-rebase-mode
;; ))
;; (evil-set-initial-state mode 'emacs))

;; stuff from Tecosaur, not major
                                        ;; show battery status in bottom right
(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))

;; start in fullscreen
;; (if (eq initial-window-system 'x) ; if started by emacs command or desktop file
;;     (toggle-frame-maximized)
;;   (toggle-frame-fullscreen))

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

;; (emms-all)
;; (setq emms-player-list '(emms-player-mpv)
;;       emms-info-functions '(emms-info-native))
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
