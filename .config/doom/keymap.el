;;; keymap.el -*- lexical-binding: t; -*-

(load! "custom_func.el")

;; Keybind to export
(map! :map (pdf-view-mode)
      :leader
      (:prefix-map ("e" . "export")
       :desc "Export to pdf"                    "p" #'my/export-org-to-tex-and-process
       :desc "Open export dispath"              "o" #'org-export-dispatch
       :desc "Run associated pdf"               "r" #'my/run-script-to-open-pdf
       :desc "Insert Image"                     "i" #'my/insert-org-image
       :desc "Export beamer slide"              "s" #'org-beamer-export-to-pdf
       ))

;;(define-key org-mode-map (kbd "C-c C-e p") #'my/org-latex-export-to-pdf-with-bibtex)
;; Notes keybinds
(map! :leader
      (:prefix-map ("n" . "notes")
       :desc "Bibliographic notes"              "b" #'helm-bibtex
       :desc "Cite insert"                      "i" #'org-ref-insert-cite-link
       :desc "Calibre"                          "c" #'calibredb
       ))

(map! :leader
      :desc "graph roam-ui"
      "n r g" #'org-roam-ui-mode
      )

(map! :leader
      :desc "insert header"
      "c h" #'my/insert-header
      :desc "insert ifndef"
      "c n" #'my/insert-ifndef
      )

(map! :leader
      (:prefix-map ("l" . "latex")
       :desc "Preview fragment"                          "p" #'org-latex-preview
       :desc "Enable fragtog"                            "f" #'org-fragtog-mode
       ))

(map! :leader
      (:prefix-map ("a" . "agenda-tasks")
       :desc "New task"                          "n" #'helm-org-capture-templates
       ))

(map! :leader
      :desc "Toggle neotree file viewer" "t n" #'treemacs
      :desc "Open directory in neotree" "d n" #'treemacs)

(define-key evil-visual-state-map (kbd "C-;") 'evil-multiedit-match-all)
(define-key evil-normal-state-map (kbd "C-;") 'evil-multiedit-match-all)
