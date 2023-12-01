                                        ; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; ---------------------------------------------------------------------------------------------------------------------
;; >> USER
(setq user-full-name "luk3rr"
      user-mail-address "araujolucas@dcc.ufmg.br")

;; ---------------------------------------------------------------------------------------------------------------------
;; >> EDITOR CONFIG
(setq doom-font (font-spec :family "Fira Code" :size 16 :weight 'medium)) ;; normal
(setq doom-theme 'doom-dracula)
(setq display-line-numbers-type 'relative)

(after! editorconfig
  (setq tab-width 4))

(setq dap-auto-configure-mode t)

(after! company
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0) ;; default is 0.2
  )

(add-hook! prog-mode 'rainbow-mode)
(add-hook! conf-mode 'rainbow-mode)

;; Opacity
(add-to-list 'default-frame-alist '(alpha . 90))

;; c++ mode in .h files
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-mode))

(after! python
  :config
  (setq lsp-pyright-python-executable-cmd "python3"))

;; column width
(add-hook 'doom-first-buffer-hook
          #'global-display-fill-column-indicator-mode)

(setq-default fill-column 87)

;; emojify
(setq emojify-display-style 'unicode)

;; Neotree config
(doom-themes-neotree-config)

;;(after! neotree
;;  (setq neo-smart-open t
;;        neo-window-fixed-size nil))
;;
;;(after! doom-themes
;;  (setq doom-neotree-enable-variable-pitch t))
;;doom-themes-neotree-file-icons t

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

;; ---------------------------------------------------------------------------------------------------------------------
;; >> BIBTEX
(after! citar
  (setq citar-bibliography '("~/Org/Roam/Bibliography/articles.bib"
                             "~/Org/Roam/Bibliography/alexandria.bib")))

(setq bibtex-completion-bibliography '("~/Org/Roam/Bibliography/articles.bib"
                                       "~/Org/Roam/Bibliography/alexandria.bib")

      bibtex-completion-library-path "~/Org/Roam/Bibliography/"
      bibtex-completion-notes-path "~/Org/Roam/Literature Notes/")

;; Config for +biblio
(setq! +biblio-pdf-library-dir '("~/Org/Roam/Bibliography/")
       +biblio-default-bibliography-files '("~/Org/Roam/Bibliography/articles.bib"
                                            "~/Org/Roam/Bibliography/alexandria.bib"))

(after! helm-bibtex
  (setq helm-bibtex-pdf-open-function
        (lambda (fpath)
          (call-process "zathura" nil 0 nil fpath)))

  (setq bibtex-completion-notes-template-multiple-files
        (concat
         ":PROPERTIES:\n"
         ":ID: ${=key=}\n"
         ":END:\n"
         "#+TITLE: ${title}\n"
         "#+AUTHOR: ${author}\n"
         "#+YEAR: ${year}\n"
         "#+note_created: %<%A, %Y-%m-%d - %H:%M:%S>\n"
         "#+filetags:\n"
         "#+ROAM_KEY: ${=key=}\n"
         "#+LATEX_HEADER: \\usepackage[backend=bibtex,sorting=none]{biblatex}\n"
         "#+LaTeX_HEADER: \\usepackage[portuguese]{babel}\n"
         "#+LaTeX_HEADER: \\usepackage[ruled, longend]{algorithm2e}\n"
         "#+LATEX_HEADER: \\usepackage{mdframed}\n"
         "#+LATEX_HEADER: \\usepackage{amssymb}\n"
         "#+LATEX_HEADER: \\usepackage{amsthm}\n"
         "#+LATEX_HEADER: \\bibliography{\jobname}\n"
         "#+LaTeX_HEADER: \\hyphenation{to-po-ló-gi-ca}\n"
         "#+LANGUAGE:  en\n"
         "#+OPTIONS:   toc:nil H:3 num:t \\ n:nil @:t ::t |:t ^:t -:t f:t *:t <:t ^:nil _:nil\n"
         "#+STARTUP:   align\n"
         "#+latex_class: article\n"
         "#+latex_class_options: [a4paper,11pt]\n"
         "#+LATEX_HEADER: \\usepackage[table]{xcolor}\n"
         "#+LATEX_HEADER: \\usepackage[margin=0.9in,bmargin=1.0in,tmargin=1.0in]{geometry}\n"
         "#+LaTeX_HEADER: \\setlength\\parskip{.5\\baselineskip}\n"
         "#+LaTeX_HEADER: \\usepackage{tikz}\n"
         "#+LaTeX_HEADER: \\usetikzlibrary{arrows,automata, quotes}\n"
         "#+LaTeX_HEADER: \\parindent = 0em\n"
         "#+TOC: headlines 3\n"
         "#+export_file_name: ../Outputs/${=key=}\n"
         "------\n"
         "* Siglas\n"
         "* Objetivo deste trabalho\n"
         "\n"
         "* Referências citadas pelo autor\n"
         "* Questões\n"
         "* Percepções sobre este artigo\n"
         "* References :ignore:\n"
         "[[nocite:&${=key=}]]\n"
         "#+print_bibliography:\n"
         "\begin{filecontents}{\jobname.bib}\n"
         "\end{filecontents}\n"
         "\nocite{}\n")
        ))

(setq org-citation-numeric-mode t) ; Ativa a numeração de citações

;; ---------------------------------------------------------------------------------------------------------------------
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

;;(use-package! openwith
;;  :after-call pre-command-hook
;;  :config
;;  (openwith-mode t)
;;  (add-to-list 'openwith-associations '("\\.pdf\\'" "zathura" (file)))
;;  (add-to-list 'openwith-associations '("\\.epub\\'" "zathura" (file)))
;;  (add-to-list 'openwith-associations '("\\.png\\'" calibredb-search (file)))
;;  (add-to-list 'openwith-associations '("\\.jpg\\'" calibredb-search (file)))
;;  )

;; Configure Elfeed with org mode
(after! elfeed
  (setq rmh-elfeed-org-files '("~/Org/Roam/Elfeed/elfeed.org"))
  (setq elfeed-search-filter "@1-month-ago +unread"))

;; Automatic update elfeed when opening
(add-hook! 'elfeed-search-mode-hook 'elfeed-update)


;; ---------------------------------------------------------------------------------------------------------------------
;; >> ORG CONFIG
(setq org-directory "~/Org/")

(add-hook! org-mode 'rainbow-mode)

;; TODO Priorities
(after! org-fancy-priorities
  (setq org-fancy-priorities-list '("📌" "🔸" "🔹")
        org-priority-faces '((?A :foreground "#ff6c6b" :weight bold)
                             (?B :foreground "#98be65" :weight bold)
                             (?C :foreground "#c678dd" :weight bold))))

(after! org
  (setq org-agenda-files '("~/Org/Agenda/"
                           "~/Org/Roam/Class Notes/"
                           "~/Org/Roam/School Planner/")
        org-agenda-block-separator 8411)

  (setq org-agenda-custom-commands
        '(
          ("b" "bdays"
           ((agenda ""
                    ((org-agenda-span 'year)
                     (org-agenda-show-all-dates nil)
                     (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp ":bdays:"))
                     (org-agenda-prefix-format
                      '((agenda . " %i %-12:c in %(my-org-diff-to-now (org-entry-get (point) \"SCHEDULED\"))d at %?-12t% s")))
                     ))))

          ("m" "month"
           ((agenda ""
                    ((org-agenda-span 30)
                     (org-agenda-overriding-header "My month")
                     (org-agenda-start-on-weekday nil)
                     (org-agenda-start-day "-3d")
                     (org-agenda-show-all-dates nil)
                     ))))

          ("y" "Year agenda"
           ((agenda ""
                    ((org-agenda-span 'year)
                     (org-agenda-show-all-dates nil)
                     (org-agenda-skip-function '(org-agenda-skip-entry-if 'regexp "+"
                                                 'todo 'done))
                     (org-agenda-prefix-format
                      '((agenda . " %i %-12:c in %(my-org-diff-to-now (org-entry-get (point) \"SCHEDULED\"))d at %?-12t% s")))
                     ))))

          ("v" "A better agenda view"
           ((tags "PRIORITY=\"B\""
                  ((org-agenda-skip-function '(org-agenda-skip-entry-if 'notscheduled
                                               'regexp "+"
                                               'todo 'done))
                   (org-agenda-overriding-header "Next tasks:")))

            (tags "@cycle"
                  ((org-agenda-skip-function '(org-agenda-skip-entry-if 'notscheduled))
                   (org-agenda-overriding-header "Repeated tasks:")))
            (agenda "")))
          ))

  ;;org-roam
  :init
  (setq org-roam-v2-ack t)
  (setq org-roam-directory "~/Org/Roam/"
        org-roam-graph-viewer "/usr/bin/brave")

  :custom
  (setq org-roam-capture-templates
        '(
          ("l" "Literature notes" plain "%?"
           :target (file+head "~/Org/Roam/Literature Notes/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}
#+author: ${AUTHOR}
#+year: ${YEAR}
#+edition: ${EDITION}
#+note_created: %<%A, %Y-%m-%d - %H:%M:%S>
#+filetags: ${TAGS}
#+LATEX_HEADER: \\usepackage[backend=bibtex,sorting=none]{biblatex}
#+LaTeX_HEADER: \\usepackage[portuguese]{babel}
#+LaTeX_HEADER: \\usepackage[ruled, longend]{algorithm2e}
#+LATEX_HEADER: \\usepackage{mdframed}
#+LATEX_HEADER: \\usepackage{amssymb}
#+LATEX_HEADER: \\usepackage{amsthm}
#+LATEX_HEADER: \\bibliography{\\jobname}
#+LaTeX_HEADER: \\hyphenation{to-po-ló-gi-ca}
#+LANGUAGE:  en
#+OPTIONS:   toc:nil H:3 num:t \\n:nil @:t ::t |:t ^:t -:t f:t *:t <:t ^:nil _:nil
#+STARTUP:   align
#+latex_class: article
#+latex_class_options: [a4paper,11pt]
#+LATEX_HEADER: \\usepackage[table]{xcolor}
#+LATEX_HEADER: \\usepackage[margin=0.9in,bmargin=1.0in,tmargin=1.0in]{geometry}
#+LaTeX_HEADER: \\setlength\\parskip{.5\\baselineskip}
#+LaTeX_HEADER: \\usepackage{tikz}
#+LaTeX_HEADER: \\usetikzlibrary{arrows,automata, quotes}
#+LaTeX_HEADER: \\parindent = 0em
#+TOC: headlines 3
#+export_file_name: ../Outputs/${slug}
------
* Introdução

* References :ignore:
#+print_bibliography:
\\begin{filecontents}{\\jobname.bib}
\\end{filecontents}
\\nocite{}
")
           :unnarrowed t
           :empty-lines 1)

          ("f" "Fleeting notes" plain "%?"
           :target (file+head "~/Org/Roam/Fleeting Notes/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}
#+note_created: %<%A, %Y-%m-%d - %H:%M:%S>
#+filetags: ${TAGS}
#+export_file_name: ../Outputs/${slug}
------
* ?

* References :ignore:
#+print_bibliography:
")
           :unnarrowed t
           :empty-lines 1)

          ("p" "Permanent notes" plain "%?"
           :target (file+head "~/Org/Roam/Permanent Notes/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}
#+note_created: %<%A, %Y-%m-%d - %H:%M:%S>
#+filetags: ${TAGS}
#+LATEX_HEADER: \\usepackage[backend=bibtex,sorting=none]{biblatex}
#+LaTeX_HEADER: \\usepackage[portuguese]{babel}
#+LaTeX_HEADER: \\usepackage[ruled, longend]{algorithm2e}
#+LATEX_HEADER: \\usepackage{mdframed}
#+LATEX_HEADER: \\usepackage{amssymb}
#+LATEX_HEADER: \\usepackage{amsthm}
#+LATEX_HEADER: \\bibliography{\\jobname}
#+LaTeX_HEADER: \\hyphenation{to-po-ló-gi-ca}
#+LANGUAGE:  en
#+OPTIONS:   toc:nil H:3 num:t \\n:nil @:t ::t |:t ^:t -:t f:t *:t <:t ^:nil _:nil
#+STARTUP:   align
#+latex_class: article
#+latex_class_options: [a4paper,11pt]
#+LATEX_HEADER: \\usepackage[table]{xcolor}
#+LATEX_HEADER: \\usepackage[margin=0.9in,bmargin=1.0in,tmargin=1.0in]{geometry}
#+LaTeX_HEADER: \\setlength\\parskip{.5\\baselineskip}
#+LaTeX_HEADER: \\usepackage{tikz}
#+LaTeX_HEADER: \\usetikzlibrary{arrows,automata, quotes}
#+LaTeX_HEADER: \\parindent = 0em
#+TOC: headlines 3
#+export_file_name: ../Outputs/${slug}
------
* Introdução

* References :ignore:
#+print_bibliography:
\\begin{filecontents}{\\jobname.bib}
\\end{filecontents}
\\nocite{}
")
           :unnarrowed t
           :empty-lines 1)

          ("s" "School Planner" plain "%?"
           :target (file+head "~/Org/Roam/School Planner/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}
#+note_created: %<%A, %Y-%m-%d - %H:%M:%S>
#+LATEX_HEADER: \\usepackage[backend=bibtex,sorting=none]{biblatex}
#+LaTeX_HEADER: \\usepackage[portuguese]{babel}
#+LaTeX_HEADER: \\hyphenation{to-po-ló-gi-ca}
#+LANGUAGE:  en
#+OPTIONS:   toc:nil H:3 num:t \\n:nil @:t ::t |:t ^:t -:t f:t *:t <:t ^:nil _:nil
#+STARTUP:   align
#+latex_class: article
#+latex_class_options: [a4paper,11pt]
#+LATEX_HEADER: \\usepackage[table]{xcolor}
#+LATEX_HEADER: \\usepackage[margin=0.9in,bmargin=1.0in,tmargin=1.0in]{geometry}
#+LaTeX_HEADER: \\setlength\\parskip{.5\\baselineskip}
#+LaTeX_HEADER: \\usepackage{tikz}
#+LaTeX_HEADER: \\usetikzlibrary{arrows,automata, quotes}
#+LaTeX_HEADER: \\parindent = 0em
#+TOC: headlines 3
#+export_file_name: ../Outputs/${slug}
------
* ?

")
           :append t
           :unnarrowed t)

          ("c" "Class notes" plain
           "%(if (file-exists-p (file-truename \"%F\"))
               \"\n* %<%Y-%m-%d %H:%M> - \")%?"
           :target (file+head "~/Org/Roam/Class Notes/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}
#+teacher: ${teacher}
#+class: ${class}
#+note_created: %<%A, %Y-%m-%d - %H:%M:%S>
#+filetags: ${TAGS}
#+LATEX_HEADER: \\usepackage[backend=bibtex,sorting=none]{biblatex}
#+LaTeX_HEADER: \\usepackage[portuguese]{babel}
#+LaTeX_HEADER: \\usepackage[ruled, longend]{algorithm2e}
#+LATEX_HEADER: \\usepackage{mdframed}
#+LATEX_HEADER: \\usepackage{amssymb}
#+LATEX_HEADER: \\usepackage{amsthm}
#+LaTeX_HEADER: \\hyphenation{to-po-ló-gi-ca}
#+LANGUAGE:  en
#+OPTIONS:   toc:nil H:3 num:t \\n:nil @:t ::t |:t ^:t -:t f:t *:t <:t ^:nil _:nil
#+STARTUP:   align
#+latex_class: article
#+latex_class_options: [a4paper,11pt]
#+LATEX_HEADER: \\usepackage[table]{xcolor}
#+LATEX_HEADER: \\usepackage[margin=0.9in,bmargin=1.0in,tmargin=1.0in]{geometry}
#+LaTeX_HEADER: \\setlength\\parskip{.5\\baselineskip}
#+LaTeX_HEADER: \\usepackage{tikz}
#+LaTeX_HEADER: \\usetikzlibrary{arrows,automata, quotes}
#+LaTeX_HEADER: \\parindent = 0em
#+TOC: headlines 3
#+export_file_name: ../Outputs/${slug}
------
* ?
")
           :append t
           :unnarrowed t)

          ("t" "Thoughts" plain "%?"
           :target (file+head "~/Org/Roam/Thoughts/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}
#+date: %<%A, %Y-%m-%d - %H:%M:%S>
#+author: luk3rr
#+filetags: ${TAGS}
#+LATEX_HEADER: \\usepackage[backend=bibtex,sorting=none]{biblatex}
#+LaTeX_HEADER: \\usepackage[portuguese]{babel}
#+LaTeX_HEADER: \\usepackage[ruled, longend]{algorithm2e}
#+LATEX_HEADER: \\usepackage{mdframed}
#+LATEX_HEADER: \\usepackage{amssymb}
#+LATEX_HEADER: \\usepackage{amsthm}
#+LATEX_HEADER: \\bibliography{\\jobname}
#+LaTeX_HEADER: \\hyphenation{to-po-ló-gi-ca}
#+LANGUAGE:  en
#+OPTIONS:   toc:nil H:3 num:t \\n:nil @:t ::t |:t ^:t -:t f:t *:t <:t ^:nil _:nil
#+STARTUP:   align
#+latex_class: article
#+latex_class_options: [a4paper,11pt]
#+LATEX_HEADER: \\usepackage[table]{xcolor}
#+LATEX_HEADER: \\usepackage[margin=0.9in,bmargin=1.0in,tmargin=1.0in]{geometry}
#+LaTeX_HEADER: \\setlength\\parskip{.5\\baselineskip}
#+LaTeX_HEADER: \\usepackage{tikz}
#+LaTeX_HEADER: \\usetikzlibrary{arrows,automata, quotes}
#+LaTeX_HEADER: \\parindent = 0em
#+TOC: headlines 3
#+export_file_name: ../Outputs/${slug}
------
* Introdução


* References :ignore:
#+print_bibliography:
\\begin{filecontents}{\\jobname.bib}
\\end{filecontents}
\\nocite{}
")
           :unnarrowed t
           :empty-lines 1)
          )
        )

  (setq org-roam-dailies-directory "~/Org/Journal/"
        org-roam-dailies-capture-templates
        '(
          ("d" "Diary" entry "* %<%Y-%m-%d, %H:%M> - %?"
           :empty-lines 1
           :target (file+head "~/Org/Journal/%<%Y-%m-%d>.org"
                              "#+title: %<%A, %Y-%m-%d>\n------\n")
           :unnarrowed t
           :empty-lines 1)
          )
        )
  (setq org-capture-templates '(("i" "inbox" entry
                                 (file+headline "~/Org/Agenda/inbox.org" "Tasks")
                                 "*** TODO %i%?")
                                ("t" "toDo" plain
                                 (file+function "~/Org/Agenda/toDo.org" org-find-month-in-datetree)
                                 "*** TODO %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t) t)")
                                ("a" "agenda" plain
                                 (file+function "~/Org/Agenda/agenda-23.org" org-find-month-in-datetree)
                                 "*** TODO %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t) t)")))

  (setq org-refile-targets '(("~/Org/Agenda/someday.org" :level . 1)
                             ("~/Org/Agenda/toDo.org" :maxlevel . 2)))

  (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-log-into-drawer "LOGBOOK")
  :setup
  (org-roam-db-autosync-enable)
  )

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :hook (org-roam . org-roam-ui-mode))

(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;                 normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;                 a hookable mode anymore, you're advised to pick something yourself
  ;;                 if you don't care about startup time, use
  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(setq org-id-link-to-org-use-id t)

;;(use-package! org-pdftools
;;  :hook (org-load . org-pdftools-setup-link))
;;
;;(use-package! org-noter-pdftools
;;  :after org-noter
;;  :config
;;  (with-eval-after-load 'pdf-annot
;;    (add-hook 'pdf-annot-activate-handler-functions #'org-noter-pdftools-jump-to-note)))

;;(setq org-noter-pdftools-markup-pointer-color "yellow"
;;      org-noter-notes-search-path '("~/Org/Roam/Literature Notes/")
;;      org-noter-doc-split-fraction '(0.6 . 0.4)
;;      org-noter-always-create-frame nil
;;      org-noter-hide-other nil
;;      org-noter-pdftools-free-pointer-icon "Note"
;;      org-noter-pdftools-free-pointer-color "red"
;;      org-noter-kill-frame-at-session-end nil
;;      )

;; ---------------------------------------------------------------------------------------------------------------------
;; >> CUSTOM FUNCTIONS
(defun my/insert-header ()
  "Inserts a header with filename, creation date, and author."
  (interactive)
  (goto-char (point-min))
  (unless (search-forward "Created on:" nil t)
    (let ((filename (file-name-nondirectory (buffer-file-name)))
          (creation-date (format-time-string "%B %e, %Y"))
          (author "Lucas Araújo <araujolucas@dcc.ufmg.br>"))
      (insert (concat "/*\n"
                      "* Filename: " filename "\n"
                      "* Created on: " creation-date "\n"
                      "* Author: " author "\n"
                      "*/\n\n"))))
  )

(defun my/insert-ifndef ()
  "Inserts ifndef template"
  (interactive)
  (goto-char (point-min))
  (unless (search-forward "#ifndef" nil t)
    (let ((header-name (file-name-nondirectory (buffer-file-name))))
      (setq header-name (replace-regexp-in-string "\\." "_" header-name))
      (insert (concat
               "#ifndef " (upcase header-name) "_\n"
               "#define " (upcase header-name) "_\n\n\n"
               "#endif // " (upcase header-name) "_\n"))))
  )

(defun my/insert-header-on-file-creation ()
  "Inserts a header with filename, creation date, and author."
  (when (and (buffer-file-name)
             (string-match-p "\\.[h]\\{1,2\\}\\(?:pp\\)?\\'" (buffer-file-name))
             (not (file-exists-p (buffer-file-name))))
    (my/insert-ifndef))
  (when (and (buffer-file-name)
             (string-match-p "\\.[hc]\\{1,2\\}\\(?:pp\\)?\\'" (buffer-file-name))
             (not (file-exists-p (buffer-file-name))))
    (my/insert-header))
  )

(add-hook 'find-file-hook 'my/insert-header-on-file-creation)

(defun org-find-month-in-datetree()
  (org-datetree-find-date-create (calendar-current-date))
  (kill-line))

;;(defun my-org-diff-to-now (time-str)
;;  "Calculate the number of days between TIME-STR and today."
;;  (let* ((time (apply #'encode-time (org-parse-time-string time-str)))
;;         (now (org-current-time))
;;         (diff (time-subtract time now)))
;;    (round (/ (float-time diff) 86400.0))))

;;(defun my-org-diff-to-now (time-str)
;;  "Calculate the number of days between TIME-STR and today."
;;  (let* ((time (apply #'encode-time (org-parse-time-string time-str)))
;;         (now (org-current-time)))
;;    (message "time: %s, now: %s" (format-time-string "%Y-%m-%d" time) (format-time-string "%Y-%m-%d" now))
;;    (if (equal (format-time-string "%Y-%m-%d" time) (format-time-string "%Y-%m-%d" now))
;;        0
;;      (let* ((diff (time-subtract time now)))
;;        (round (/ (float-time diff) 86400.0))))))

(defun my-org-diff-to-now (time-str)
  "Calculate the number of days between TIME-STR and today."
  (if (or (null time-str) (string-empty-p time-str))
      nil ;; return nil if time-str is null or empty
    (let* ((time (apply #'encode-time (org-parse-time-string time-str)))
           (now (org-current-time)))

      ;;(message "time: %s, now: %s" (format-time-string "%Y-%m-%d" time) (format-time-string "%Y-%m-%d" now))
      (if (equal (format-time-string "%Y-%m-%d" time) (format-time-string "%Y-%m-%d" now))
          0
        (let* ((diff (time-subtract time now)))
          (round (/ (float-time diff) 86400.0)))))))

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

(after! org
  (setq org-latex-pdf-process
        '("pdflatex -interaction nonstopmode -output-directory %o %f"
          "bibtex %b"
          "pdflatex -interaction nonstopmode -output-directory %o %f")))

(defun my/export-org-to-tex-and-process ()
  "Export the current Org mode file to LaTeX and process using external script."
  (interactive)
  (org-latex-export-to-latex)

  (let* ((org-file (buffer-file-name))
         (org-content (with-temp-buffer
                        (insert-file-contents org-file)
                        (buffer-string)))
         (base-name (if (string-match "#\\+export_file_name:[[:space:]]*../Outputs/\\(.*\\)"
                                      org-content)
                        (match-string 1 org-content)
                      (file-name-base org-file)))
         (tex-file (concat "~/Org/Roam/Outputs/" base-name ".tex"))
         (bash-script "/home/luk3rr/.config/scripts/compile_tex.sh")) ; Update with the actual path

    (shell-command (format "%s \"%s\" >/dev/null 2>&1"
                           bash-script (expand-file-name tex-file)))

    (message "Processed %s" base-name)))

(defun remove-newlines-in-region ()
  "Removes all newlines in the region."
  (interactive)
  (save-restriction
    (narrow-to-region (point) (mark))
    (goto-char (point-min))
    (while (search-forward "\n" nil t) (replace-match "" nil t))))

;;;; Call the remove newlines function
(global-set-key [f8] 'remove-newlines-in-region)

(defun find-most-recent-file (dir)
  ;;Retorna o nome do arquivo mais recente em um diretório (excluindo subdiretórios).
  ;;Retorna nil se nenhum arquivo for encontrado.
  ;;Se os diretórios não forem removidos da lista, essa função não funcionará corretamente, pois
  ;;eles não têm datas de modificações válidas como os arquivos
  (let ((files (remove-if #'file-directory-p (directory-files dir t nil 'nosort))))
    (when files
      (car (sort files #'file-newer-than-file-p))))
  )

(defun insert-org-image ()
  "Moves image from screenshots folder to ~/Org/Roam/Contents, inserting org-mode link"
  (interactive)
  (let* ((infile (find-most-recent-file "/home/luk3rr/Pictures/995.SCREENSHOTS"))
         (screenshots-dir (file-name-directory infile))
         (outdir (expand-file-name "Contents" "~/Org/Roam"))
         (buffer-name (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
    (unless (and infile (file-exists-p infile) (member (file-name-extension infile) '("jpg" "jpeg" "png" "gif")))
      (error "Nenhum arquivo de imagem encontrado em %s" screenshots-dir))
    (unless (file-directory-p outdir)
      (make-directory outdir t))
    (let* ((new-filename (read-string "Contexto da imagem: "))
           (outfile (expand-file-name (concat buffer-name "_" new-filename "." (file-name-extension infile)) outdir)))
      (rename-file infile outfile)
      (insert (concat (concat "#+ATTR_LATEX: :width 200px :float nil \n#+caption:\n[[file:" outfile) "]]")))
    (newline)
    (newline)))

;; Function to open pdf associated with current org file
(defun run-script-to-open-pdf ()
  ;;Runs a Python script to open pdf
  (interactive)
  (call-process-shell-command (format "python3 ~/.config/scripts/open_pdf_emacs.py \"%s\"" buffer-file-name))
  )

;; ---------------------------------------------------------------------------------------------------------------------
;; >> KEYBINDINGS
;; Keybind to export
(map! :map (pdf-view-mode)
      :leader
      (:prefix-map ("e" . "export")
       :desc "Export to pdf"                    "p" #'my/export-org-to-tex-and-process
       :desc "Open export dispath"              "o" #'org-export-dispatch
       :desc "Run associated pdf"               "r" #'run-script-to-open-pdf
       :desc "Insert Image"                     "i" #'insert-org-image
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


;; ---------------------------------------------------------------------------------------------------------------------
;; >> DEPENDS ON DIR
;; /home/luk3rr/data/000.DOCUMENTS/000.ALEXANDRIA/001.CALIBRE_LIBRARY
(setq calibredb-root-dir "~/Documents/000.ALEXANDRIA/001.CALIBRE_LIBRARY/")
(setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
(setq calibredb-library-alist '("~/Documents/000.ALEXANDRIA/001.CALIBRE_LIBRARY/"))

;;(use-package! python-mode
;;  :ensure t
;;  :hook (python-mode . lsp-deferred)
;;  :config
;;  (set-ligatures! 'python-mode
;;    ;; Functional
;;    :def "def"
;;    :lambda "lambda"
;;    ;; Types
;;    :null "None"
;;    :true "True" :false "False"
;;    :int "int" :str "str"
;;    :float "float"
;;    :bool "bool"
;;    :tuple "tuple"
;;    ;; Flow
;;    :not "not"
;;    :in "in" :not-in "not in"
;;    :and "and" :or "or"
;;    :for "for"
;;    :return "return" :yield "yield")
;;
;;  (setq python-indent-guess-indent-offset-verbose nil)
;;
;;  ;; Default to Python 3. Prefer the versioned Python binaries since some
;;  ;; systems stupidly make the unversioned one point at Python 2.
;;  (when (and (executable-find "python3")
;;             (string= python-shell-interpreter "python"))
;;    (setq python-shell-interpreter "python3"))
;;
;;  (add-hook! 'python-mode-hook
;;    (defun +python-use-correct-flycheck-executables-h ()
;;      "Use the correct Python executables for Flycheck."
;;      (let ((executable python-shell-interpreter))
;;        (save-excursion
;;          (goto-char (point-min))
;;          (save-match-data
;;            (when (or (looking-at "#!/usr/bin/env \\(python[^ \n]+\\)")
;;                      (looking-at "#!\\([^ \n]+/python[^ \n]+\\)"))
;;              (setq executable (substring-no-properties (match-string 1))))))
;;        ;; Try to compile using the appropriate version of Python for
;;        ;; the file.
;;        (setq-local flycheck-python-pycompile-executable executable)
;;        ;; We might be running inside a virtualenv, in which case the
;;        ;; modules won't be available. But calling the executables
;;        ;; directly will work.
;;        (setq-local flycheck-python-pylint-executable "pylint")
;;        (setq-local flycheck-python-flake8-executable "flake8"))))
;;
;;  (define-key python-mode-map (kbd "DEL") nil) ; interferes with smartparens
;;  (sp-local-pair 'python-mode "'" nil
;;                 :unless '(sp-point-before-word-p
;;                           sp-point-after-word-p
;;                           sp-point-before-same-p))
;;
;;  (setq-hook! 'python-mode-hook tab-width python-indent-offset))
;;;; Set Path To pylsp and pyls otherwise it doesn't work
;;(setq lsp-pyls-server-command "/home/luk3rr/.local/bin/pyls")
;;(setq lsp-pylsp-server-command "/home/luk3rr/.local/bin/pylsp")
;;;; Set Flake8 Ignore Codes
;;(setq lsp-pylsp-plugins-flake8-ignore ["E231","226"])
