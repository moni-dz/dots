;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "shadow"
      user-mail-address "shadow@shadowraze.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "FantasqueSansMono Nerd Font" :weight 'Regular :size 14)
      doom-big-font (font-spec :family "FantasqueSansMono Nerd Font" :weight 'Regular :size 16)
      doom-variable-pitch-font (font-spec :family "Inter"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Don't read PDFs in light mode
(add-hook 'pdf-tools-enabled-hook #'pdf-view-midnight-minor-mode)

;; Autocompletion and syntax checking tweaks
(after! flycheck
  (setq flycheck-check-syntax-automatically '(save idle-change new-line mode-enabled)))

(after! company
  (setq company-idle-delay 0
        company-minimum-prefix-length 1
        company-selection-wrap-around t))

;; Discord Rich Presence (the flex and the bling bling)
(use-package! elcord
  :config (elcord-mode 1)
  :custom (elcord-use-major-mode-as-main-icon t))

;; Note taking directory
(setq deft-directory "~/Notes"
      deft-extensions '("org")
      deft-recursive t)

;; If we're on an X11 session, run maximized and fullscreen since we're on spectrwm
;(if (eq initial-window-system 'x)
;    (toggle-frame-maximized)
;  (toggle-frame-fullscreen))
(after! centaur-tabs
  (setq centaur-tabs-set-bar 'under)
  ;; Note: If you're not using Spacmeacs, in order for the underline to display
  ;; correctly you must add the following line:
  (setq x-underline-at-descent-line t)
  (setq centaur-tabs-close-button "x"))

;; Auto tangle spectrwm config file
(setq user-dotfiles-directory "/home/fortuneteller2k/.config")

(defun f2k--tangle-spectrwm-config ()
  (if (string= buffer-file-name (concat user-dotfiles-directory "/spectrwm/spectrwm.org"))
      (org-babel-tangle)
    (ignore)))

(add-hook 'after-save-hook #'f2k-tangle-spectrwm-config)
