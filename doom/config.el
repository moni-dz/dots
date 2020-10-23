;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "fortuneteller2k"
      user-mail-address "lythe1107@gmail.com")

(setq doom-font (font-spec :family "JetBrains Mono" :weight 'Regular :size 14)
      doom-big-font (font-spec :family "JetBrains Mono" :weight 'Regular :size 16)
      doom-variable-pitch-font (font-spec :family "Inter" :weight 'Bold :size 20)
      doom-unicode-font (font-spec :family "Symbola"))

(setq doom-theme 'doom-horizon)
(delq! t custom-theme-load-path)

(setq fancy-splash-image (concat doom-private-dir "icons/cacodemon.svg"))

(setq display-line-numbers-type 'relative)

(after! centaur-tabs
  (setq centaur-tabs-height 25
        centaur-tabs-set-bar 'under
        x-underline-at-descent-line t
        centaur-tabs-close-button "x")
  (centaur-tabs-change-fonts "Fantasque Sans Mono" 110))

(use-package! elcord
  :config (elcord-mode 1)
  :custom (elcord-use-major-mode-as-main-icon t))

(after! doom-modeline
  (setq doom-modeline-bar-width 3))

(use-package! keycast
  :commands keycast-mode
  :config
  (define-minor-mode keycast-mode
    "Show current command and its keybinding in the mode line."
    :global t
    (if keycast-mode
        (progn
          (add-hook 'pre-command-hook 'keycast-mode-line-update t)
          (add-to-list 'global-mode-string '("" mode-line-keycast " ")))
      (remove-hook 'pre-command-hook 'keycast-mode-line-update)
      (setq global-mode-string (remove '("" mode-line-keycast " ") global-mode-string))))
  (custom-set-faces!
    '(keycast-command :inherit doom-modeline-debug
                      :height 0.9)
    '(keycast-key :inherit custom-modified
                  :height 1.1
                  :weight bold)))

(add-hook 'pdf-view-mode-hook #'pdf-view-midnight-minor-mode)

(after! writeroom-mode
  (add-hook 'writeroom-mode-hook
            (defun +zen-cleaner-org ()
              (when (and (eq major-mode 'org-mode) writeroom-mode)
                (setq-local -display-line-numbers display-line-numbers
                            display-line-numbers nil))))
  (add-hook 'writeroom-mode-disable-hook
            (defun +zen-dirty-org ()
              (when (eq major-mode 'org-mode)
                (setq-local display-line-numbers -display-line-numbers)))))

(use-package! info-colors
  :commands (info-colors-fontify-node))

(add-hook 'Info-selection-hook 'info-colors-fontify-node)
(add-hook 'Info-mode-hook #'mixed-pitch-mode)

(after! company
  (setq company-idle-delay 0.4
        company-minimum-prefix-length 1
        company-selection-wrap-around t))

(after! flycheck
  (setq flycheck-check-syntax-automatically '(save idle-change new-line mode-enabled)))

(setq org-directory "~/org/")

(add-hook! 'org-mode-hook #'+org-pretty-mode #'mixed-pitch-mode)

(after! org
  (custom-set-faces!
    '(org-document-title :height 1.2)))

(custom-set-faces!
  '(outline-1 :weight extra-bold :height 1.25)
  '(outline-2 :weight bold :height 1.15)
  '(outline-3 :weight bold :height 1.12)
  '(outline-4 :weight semi-bold :height 1.09)
  '(outline-5 :weight semi-bold :height 1.06)
  '(outline-6 :weight semi-bold :height 1.03)
  '(outline-8 :weight semi-bold)
  '(outline-9 :weight semi-bold))

(use-package! org-superstar
  :custom (org-superstar-item-bullet-alist '((42 . 8226) (43 . 10148) (45 . 8211))))

(add-hook! 'org-mode-hook #'org-superstar-mode #'org-pretty-tags-mode)

(setq deft-directory "~/Notes"
      deft-extensions '("org")
      deft-recursive t)

(setq user-dotfiles-directory "/home/fortuneteller2k/.config")

(defun f2k--tangle-spectrwm-config ()
  (if (string= buffer-file-name (concat user-dotfiles-directory "/spectrwm/spectrwm.org"))
      (org-babel-tangle)
    (ignore)))

(add-hook 'after-save-hook #'f2k--tangle-spectrwm-config)
