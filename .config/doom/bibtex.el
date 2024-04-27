;;; bibtex.el -*- lexical-binding: t; -*-

(after! citar
  (setq citar-bibliography '("~/path/to/Bibliography/articles.bib"
                             "~/path/to/Bibliography/alexandria.bib")))

(setq bibtex-completion-bibliography '("~/path/to/Bibliography/articles.bib"
                                       "~/path/to/Bibliography/alexandria.bib")

      bibtex-completion-library-path "~/path/to/Bibliography/"
      bibtex-completion-notes-path "~/path/to/Literature Notes/")

;; Config for +biblio
(setq! +biblio-pdf-library-dir '("~/path/to/Bibliography/")
       +biblio-default-bibliography-files '("~/path/to/Bibliography/articles.bib"
                                            "~/path/to/Bibliography/alexandria.bib"))

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
