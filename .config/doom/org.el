;;; org.el -*- lexical-binding: t; -*-

(setq org-directory "~/path/to/")

(add-hook! org-mode 'rainbow-mode)

;; TODO Priorities
(after! org-fancy-priorities
  (setq org-fancy-priorities-list '("📌" "🔸" "🔹")
        org-priority-faces '((?A :foreground "#ff6c6b" :weight bold)
                             (?B :foreground "#98be65" :weight bold)
                             (?C :foreground "#c678dd" :weight bold))))

(after! org
  (setq org-agenda-files '("~/path/to/Agenda/"
                           "~/path/to/Class Notes/"
                           "~/path/to/School Planner/")
        org-agenda-block-separator 8411)

  (setq org-agenda-custom-commands
        '(
          ("b" "bdays"
           ((agenda ""
                    ((org-agenda-span 'year)
                     (org-agenda-show-all-dates nil)
                     (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp "bday"))
                     (org-agenda-prefix-format
                      '((agenda . " %i %-12:c in %(my/org-diff-to-now (org-entry-get (point) \"SCHEDULED\"))d at %?-12t% s")))
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
                      '((agenda . " %i %-12:c in %(my/org-diff-to-now (org-entry-get (point) \"SCHEDULED\"))d at %?-12t% s")))
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
  (setq org-roam-directory "~/path/to/"
        org-roam-graph-viewer "/usr/bin/firefox")

  :custom
  (setq org-roam-capture-templates
        '(
          ("l" "Literature notes" plain "%?"
           :target (file+head "~/path/to/Literature Notes/%<%Y%m%d%H%M%S>-${slug}.org"
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
           :target (file+head "~/path/to/Fleeting Notes/%<%Y%m%d%H%M%S>-${slug}.org"
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
           :target (file+head "~/path/to/Permanent Notes/%<%Y%m%d%H%M%S>-${slug}.org"
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

          ;;          ("s" "School Planner" plain "%?"
          ;;           :target (file+head "~/path/to/School Planner/%<%Y%m%d%H%M%S>-${slug}.org"
          ;;                              "#+title: ${title}
          ;;#+note_created: %<%A, %Y-%m-%d - %H:%M:%S>
          ;;#+LATEX_HEADER: \\usepackage[backend=bibtex,sorting=none]{biblatex}
          ;;#+LaTeX_HEADER: \\usepackage[portuguese]{babel}
          ;;#+LaTeX_HEADER: \\hyphenation{to-po-ló-gi-ca}
          ;;#+LANGUAGE:  en
          ;;#+OPTIONS:   toc:nil H:3 num:t \\n:nil @:t ::t |:t ^:t -:t f:t *:t <:t ^:nil _:nil
          ;;#+STARTUP:   align
          ;;#+latex_class: article
          ;;#+latex_class_options: [a4paper,11pt]
          ;;#+LATEX_HEADER: \\usepackage[table]{xcolor}
          ;;#+LATEX_HEADER: \\usepackage[margin=0.9in,bmargin=1.0in,tmargin=1.0in]{geometry}
          ;;#+LaTeX_HEADER: \\setlength\\parskip{.5\\baselineskip}
          ;;#+LaTeX_HEADER: \\usepackage{tikz}
          ;;#+LaTeX_HEADER: \\usetikzlibrary{arrows,automata, quotes}
          ;;#+LaTeX_HEADER: \\parindent = 0em
          ;;#+TOC: headlines 3
          ;;#+export_file_name: ../Outputs/${slug}
          ;;------
          ;;* ?
          ;;
          ;;")
          ;;           :append t
          ;;           :unnarrowed t)

          ("c" "Class notes" plain
           "%(if (file-exists-p (file-truename \"%F\"))
               \"\n* %<%Y-%m-%d %H:%M> - \")%?"
           :target (file+head "~/path/to/Class Notes/%<%Y%m%d%H%M%S>-${slug}.org"
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
           :target (file+head "~/path/to/Thoughts/%<%Y%m%d%H%M%S>-${slug}.org"
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

  (setq org-roam-dailies-directory "~//path/to/Journal/"
        org-roam-dailies-capture-templates
        '(
          ("d" "Diary" entry "* %<%Y-%m-%d, %H:%M> - %?"
           :empty-lines 1
           :target (file+head "~//path/to/Journal/%<%Y-%m-%d>.org"
                              "#+title: %<%A, %Y-%m-%d>\n------\n")
           :unnarrowed t
           :empty-lines 1)
          )
        )
  (setq org-capture-templates '(("i" "inbox" entry
                                 (file+headline "~//path/to/Agenda/inbox.org" "Tasks")
                                 "*** TODO %i%?")
                                ("t" "toDo" plain
                                 (file+function "~//path/to/Agenda/toDo.org" my/org-find-month-in-datetree)
                                 "*** TODO %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t) t)")
                                ("a" "agenda" entry
                                 (file "~//path/to/Agenda/agenda-24.org")
                                 "* %?\n:PROPERTIES:\n:calendar-id:\tMY_ID\n:END:\n:org-gcal:\n%^T\n\n%i%\n:END:\n\n" :jump-to-captured t)))


  (setq org-refile-targets '(("~//path/to/Agenda/someday.org" :level . 1)
                             ("~//path/to/Agenda/toDo.org" :maxlevel . 2)))

  (setq org-todo-keywords '((sequence "TODO(t)" "PROG(p)" "|" "DONE(d)" "CANCELLED(c)")))

  (setq org-todo-keyword-faces
        '(("PROG" . (:foreground "yellow" :weight bold))))

  ;; Hide the deadline prewarning prior to scheduled date.
  (setq org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)


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
;;      org-noter-notes-search-path '("~/path/to/Literature Notes/")
;;      org-noter-doc-split-fraction '(0.6 . 0.4)
;;      org-noter-always-create-frame nil
;;      org-noter-hide-other nil
;;      org-noter-pdftools-free-pointer-icon "Note"
;;      org-noter-pdftools-free-pointer-color "red"
;;      org-noter-kill-frame-at-session-end nil
;;      )

(after! org
  (setq org-latex-pdf-process
        '("pdflatex -interaction nonstopmode -output-directory %o %f"
          "bibtex %b"
          "pdflatex -interaction nonstopmode -output-directory %o %f")))

(setq company-global-modes '(not org-mode))

(after! org-roam
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t)
  )
