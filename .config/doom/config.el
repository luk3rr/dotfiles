; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "luk3rr"
      user-mail-address "araujolucas@dcc.ufmg.br")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 16 :weight 'normal))
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Org/")

;; Opacity
(add-to-list 'default-frame-alist '(alpha . 95))

;; column width
(add-hook 'doom-first-buffer-hook
          #'global-display-fill-column-indicator-mode)
(setq-default fill-column 120)

;; emojify
(setq emojify-display-style 'unicode)

;; Neotree config
(doom-themes-neotree-config)

(after! neotree
  (setq neo-smart-open t
        neo-window-fixed-size nil))

(after! doom-themes
  (setq doom-neotree-enable-variable-pitch t
        doom-themes-neotree-file-icons t))

(map! :leader
      :desc "Toggle neotree file viewer" "t n" #'neotree-toggle
      :desc "Open directory in neotree" "d n" #'neotree-dir)

;; ivy in center screen
;;(after! ivy-posframe
;;  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
;;  )

;; helm in center screen
;;(helm-posframe-enable) ; For the posframe goodness
;;(setq helm-echo-input-in-header-line t
;;      helm-posframe-border-width 0)

;; Deft uses same org folder
(after! deft
    (setq deft-directory "~/Org/")
    (setq deft-recursive t)
)

;;(setq emojify-display-style "unicode")

(add-hook! org-mode 'rainbow-mode)
(add-hook! prog-mode 'rainbow-mode)
(add-hook! conf-mode 'rainbow-mode)


(after! org-fancy-priorities
  (setq org-fancy-priorities-list '("📌" "🔸" "🔹")
        org-priority-faces '((?A :foreground "#ff6c6b" :weight bold)
                             (?B :foreground "#98be65" :weight bold)
                             (?C :foreground "#c678dd" :weight bold))))

(after! org
    (setq org-agenda-files '("~/Org/Agenda/")
          org-agenda-block-separator 8411)

  (setq org-agenda-custom-commands
        '(("v" "A better agenda view"

           ((tags "PRIORITY=\"A\""
                  ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                   (org-agenda-overriding-header "High-priority unfinished tasks:")))

            (tags "PRIORITY=\"B\""
                  ((org-agenda-skip-function '(org-agenda-skip-entry-if 'notscheduled
                                                                        'todo 'done))
                   (org-agenda-overriding-header "Medium-priority unfinished tasks:")))
            (tags "PRIORITY=\"C\""
                  ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                   (org-agenda-overriding-header "Low-priority unfinished tasks:")))

            (agenda "")
            (alltodo "")))))

  ;;org-roam
  :init
  (setq org-roam-v2-ack t)
  (setq org-roam-directory "~/Org/Roam/"
        org-roam-graph-viewer "/usr/bin/brave")

  :custom
  (setq org-roam-capture-templates
        '(
          ("l" "Literature note" plain "%?"
           :target (file+head "~/Org/Roam/Literature Notes/${slug}.org"
                              "#+title: ${TITLE}
#+author: ${AUTHOR}
#+year: ${YEAR}
#+edition: ${EDITION}
#+note_created: %<%A, %Y-%m-%d - %H:%M:%S>
#+roam_tags: ${TAGS}
#+export_file_name: ../Outputs/${slug}
---

* ${slug} :ignore:
:PROPERTIES:
:NOTER_DOCUMENT: ../Bibliography/${slug}.pdf
:NOTER_PAGE: 1
:END:
")
           :unnarrowed t
           :empty-lines 1)

          ("f" "Fleeting note" plain "%?"
           :target (file+head "~/Org/Roam/Fleeting Notes/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}
#+note_created: %<%A, %Y-%m-%d - %H:%M:%S>
#+roam_tags: ${TAGS}
#+export_file_name: ../Outputs/${slug}
------
")
           :unnarrowed t
           :empty-lines 1)

          ("p" "Permanent note" plain "%?"
           :target (file+head "~/Org/Roam/Permanent Notes/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}
#+note_created: %<%A, %Y-%m-%d - %H:%M:%S>
#+roam_tags: ${TAGS}
#+export_file_name: ../Outputs/${slug}
------

*

* Referências
")
           :unnarrowed t
           :empty-lines 1)

          ("t" "Thoughts" plain "%?"
           :target (file+head "~/Org/Roam/Thoughts/${slug}.org"
                              "#+title: ${title}
#+date: %<%A, %Y-%m-%d - %H:%M:%S>
#+author: luk3rr
#+roam_tags: pensamentos
#+export_file_name: ../Outputs/${slug}
------
")
           :unnarrowed t
           :empty-lines 1)
          )
        )

  (setq org-roam-dailies-directory "~/Org/Journal/"
        org-roam-dailies-capture-templates
        '(
          ("d" "Diary" entry "* %<%Y-%m-%d, %H:%M> %?"
           :empty-lines 1
           :target (file+head "~/Org/Journal/%<%Y-%m-%d>.org"
                              "#+title: %<%A, %Y-%m-%d>\n------\n")
           :unnarrowed t
           :empty-lines 1)
          )
        )
  :setup
  (org-roam-db-autosync-enable)

  )

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
   :hook (org-roam . org-roam-ui-mode))

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
    :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(setq org-id-link-to-org-use-id t)

(setq citar-bibliography "~/Org/Roam/Bibliography/bibliography.bib")

(setq bibtex-completion-bibliography "~/Org/Roam/Bibliography/bibliography.bib"
      bibtex-completion-library-path "~/Org/Roam/Bibliography/"
      bibtex-completion-notes-path "~/Org/Roam/Literature Notes/")

;; Config for +biblio
;;(setq! +biblio-pdf-library-dir '("~/Org/Roam/Bibliography/")
;;       +biblio-default-bibliography-files '("~/Org/Roam/Bibliography/bibliography.bib"))

;;(setq org-noter-pdftools-markup-pointer-color "yellow"
;;      org-noter-notes-search-path '("~/Org/Roam/Literature Notes/")
;;      org-noter-doc-split-fraction '(0.6 . 0.4)
;;      org-noter-always-create-frame nil
;;      org-noter-hide-other nil
;;      org-noter-pdftools-free-pointer-icon "Note"
;;      org-noter-pdftools-free-pointer-color "red"
;;      org-noter-kill-frame-at-session-end nil
;;      )

;;(use-package! org-pdftools
;;  :hook (org-load . org-pdftools-setup-link))
;;
;;(use-package! org-noter-pdftools
;;  :after org-noter
;;  :config
;;  (with-eval-after-load 'pdf-annot
;;    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))

;; Spell-check and grammar (need to install hunspell... pt-br only AUR)
(after! ispell
  (setq ispell-program-name "hunspell"
        ispell-dictionary "pt_BR,en_US")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "pt_BR,en_US")
  )

;;(let ((langs '("pt_BR" "american" "fr_FR")))
;;      (setq lang-ring (make-ring (length langs)))
;;      (dolist (elem langs) (ring-insert lang-ring elem)))
;;(let ((dics '("portuguese" "american-english" "french")))
;;      (setq dic-ring (make-ring (length dics)))
;;     (dolist (elem dics) (ring-insert dic-ring elem)))
;;
;;(defun cycle-ispell-languages ()
;;  (interactive)
;;  (let (
;;        (lang (ring-ref lang-ring -1))
;;        (dic (ring-ref dic-ring -1))
;;        )
;;    (ring-insert lang-ring lang)
;;    (ring-insert dic-ring dic)
;;    (ispell-change-dictionary lang)
;;    (setq ispell-complete-word-dict (concat "/usr/share/dict/" dic))
;;    )
;;  )
;;
;;;; Call the cycle ispell func
;;(global-set-key [f6] 'cycle-ispell-languages)

;; Check previous wrong word
(global-set-key [f12] 'flyspell-check-previous-highlighted-word)

(defun remove-newlines-in-region ()
  "Removes all newlines in the region."
  (interactive)
  (save-restriction
    (narrow-to-region (point) (mark))
    (goto-char (point-min))
    (while (search-forward "\n" nil t) (replace-match "" nil t))))

(global-set-key [f8] 'remove-newlines-in-region)

;; Set default dic
(setq-default flyspell-default-dictionary "pt_BR")

;; Keybind to export
(map! :map (pdf-view-mode)
      :leader
      (:prefix-map ("e" . "export")
       :desc "Export to pdf"                    "p" #'org-latex-export-to-pdf
       :desc "Open export dispath"              "o" #'org-export-dispatch
       ))

;; Notes keybinds
(map! :leader
      (:prefix-map ("n" . "notes")
       :desc "Bibliographic notes"              "b" #'helm-bibtex
       :desc "Cite insert"                      "i" #'org-ref-insert-cite-link
       ))


(map! :leader
       :desc "graph roam-ui"
       "n r g" #'org-roam-ui-mode
       )

(use-package! ox-extra
  :after org
  :config
  (ox-extras-activate '(ignore-headlines))
  )

(setq calibredb-root-dir "~/data/001.ALEXANDRIA/001.CALIBRE_LIBRARY/")
(setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
(setq calibredb-library-alist '("~/data/001.ALEXANDRIA/001.CALIBRE_LIBRARY/"))

(setq elfeed-feeds '(
                     ("http://g1.globo.com/dynamo/rss2.xml" Tudo)
                     ("http://g1.globo.com/dynamo/economia/rss2.xml" Economia)
                     ("http://g1.globo.com/dynamo/educacao/rss2.xml" Educação)
                     ("http://g1.globo.com/dynamo/tecnologia/rss2.xml" Tecnologia)
                     ("http://g1.globo.com/dynamo/minas-gerais/rss2.xml" MinasGerais)
                     )
      )

;;(define-key calibredb-search-mode-ma "V" #'calibredb-open-file-with-default-tool)
;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
