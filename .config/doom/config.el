                                        ; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; >> Load all config files
(load! "calendar.el")
(load! "bibtex.el")
(load! "calibredb.el")
(load! "copilot.el")
(load! "custom_func.el")
(load! "dev.el")
(load! "keymap.el")
(load! "org.el")

;; >> USER
(setq user-full-name "luk3rr"
      user-mail-address "araujolucas@dcc.ufmg.br")

;; >> EDITOR CONFIG
(setq doom-font (font-spec :family "Fira Code" :size 16 :weight 'medium)) ;; normal
(setq doom-theme 'doom-dracula)
(setq display-line-numbers-type 'relative)

(after! editorconfig
  (setq tab-width 4))

;; Opacity
(add-to-list 'default-frame-alist '(alpha . 90))

;; column width
(add-hook 'doom-first-buffer-hook
          #'global-display-fill-column-indicator-mode)

(setq-default fill-column 87)
(setq dap-auto-configure-mode t)

(use-package company
  :defer 0.1
  :config
  (global-company-mode t)
  (setq-default
   company-idle-delay 0.05
   company-require-match nil
   company-minimum-prefix-length 0

   ;; get only preview
   company-frontends '(company-preview-frontend)
   ;; also get a drop down
   ;; company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
   ))

(add-hook! conf-mode 'rainbow-mode)

(use-package flycheck
  :config
  (setq-default flycheck-disabled-checkers '(python-pylint)))

;; emojify
(setq emojify-display-style 'unicode)

;; Neotree config
(doom-themes-neotree-config)

;; Treemacs project follow mode
(with-eval-after-load 'treemacs
  (treemacs-follow-mode)
  (treemacs-project-follow-mode)
  (setq treemacs--project-follow-delay 0.1)
  (setq treemacs-file-follow-delay 0.1)
  (setq treemacs-project-follow-cleanup t)
  (setq treemacs-follow-after-init t)
  (setq treemacs-width 30)
  )

;; Deft uses same org folder
(after! deft
  (setq deft-directory "~/Org/")
  (setq deft-recursive t)
  )

;; Spell-check and grammar (need to install hunspell... pt-br only AUR)
(after! ispell
  (setq ispell-program-name "hunspell"
        ispell-dictionary "pt_BR,en_US")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "pt_BR,en_US")
  )

;; Check previous wrong word
(global-set-key [f12] 'flyspell-check-previous-highlighted-word)

;; Set default dic
(setq-default flyspell-default-dictionary "pt_BR")

(use-package! ox-extra
  :after org
  :config
  (ox-extras-activate '(ignore-headlines))
  )

;; >> OPENWITH AND ELFEED
(use-package openwith
  :after-call pre-command-hook
  :config
  (openwith-mode t)
  (setq openwith-associations '(("\\.pdf\\'" "zathura" (file))
                                ("\\.epub\\'" "zathura" (file))
                                ("\\.\\(?:mp4\\|avi\\|mkv\\)\\'" "mpv" (file))
                                ))
  )

;; Configure Elfeed with org mode
(after! elfeed
  (setq rmh-elfeed-org-files '("~/path/to/Elfeed/elfeed.org"))
  (setq elfeed-search-filter "@1-month-ago +unread"))

;; Automatic update elfeed when opening
(add-hook! 'elfeed-search-mode-hook 'elfeed-update)

;; enable term-cursor
(global-term-cursor-mode)
