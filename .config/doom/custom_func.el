;;; custom_func.el -*- lexical-binding: t; -*-

(defun my/insert-header ()
  "Inserts a header with filename, creation date, and author."
  (interactive)
  (goto-char (point-min))
  (unless (search-forward "Created on:" nil t)
    (let* ((filename (file-name-nondirectory (buffer-file-name)))
           (creation-date (format-time-string "%B %e, %Y"))
           (author "Lucas Araújo <araujolucas@dcc.ufmg.br>")
           (file-extension (file-name-extension filename))
           (comment-style
            (cond ((member file-extension '("c" "cpp" "h" "hpp" "java")) '("/*" " */" " * "))
                  ((member file-extension '("js")) '("/*" " */" " * "))
                  ((member file-extension '("py")) '("# " "" "# "))
                  (t '("/*" " */" " * "))))) ; Estilo padrão

      (insert (concat (car comment-style) "\n"
                      (caddr comment-style) "Filename: " filename "\n"
                      (caddr comment-style) "Created on: " creation-date "\n"
                      (caddr comment-style) "Author: " author "\n"
                      (cadr comment-style) "\n\n")))))


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

(defun my/org-find-month-in-datetree()
  (org-datetree-find-date-create (calendar-current-date))
  (kill-line))

(defun my/org-diff-to-now (time-str)
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
         (tex-file (concat "~/path/to/Outputs/" base-name ".tex"))
         (bash-script "/home/luk3rr/.config/scripts/compile_tex.sh")) ; Update with the actual path

    (shell-command (format "%s \"%s\" >/dev/null 2>&1"
                           bash-script (expand-file-name tex-file)))

    (message "Processed %s" base-name)))

(defun my/remove-newlines-in-region ()
  "Removes all newlines in the region."
  (interactive)
  (save-restriction
    (narrow-to-region (point) (mark))
    (goto-char (point-min))
    (while (search-forward "\n" nil t) (replace-match "" nil t))))

;;;; Call the remove newlines function
(global-set-key [f8] 'remove-newlines-in-region)

(defun my/find-most-recent-file (dir)
  ;;Retorna o nome do arquivo mais recente em um diretório (excluindo subdiretórios).
  ;;Retorna nil se nenhum arquivo for encontrado.
  ;;Se os diretórios não forem removidos da lista, essa função não funcionará corretamente, pois
  ;;eles não têm datas de modificações válidas como os arquivos
  (let ((files (remove-if #'file-directory-p (directory-files dir t nil 'nosort))))
    (when files
      (car (sort files #'file-newer-than-file-p))))
  )

(defun my/insert-org-image ()
  "Moves image from screenshots folder to ~/path/to/Contents, inserting org-mode link"
  (interactive)
  (let* ((infile (my/find-most-recent-file "/home/luk3rr/Pictures/Screenshots"))
         (screenshots-dir (file-name-directory infile))
         (outdir (expand-file-name "Contents" "~/path/to"))
         (buffer-name (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
    (unless (and infile (file-exists-p infile) (member (file-name-extension infile) '("jpg" "jpeg" "png" "gif")))
      (error "Nenhum arquivo de imagem encontrado em %s" screenshots-dir))
    (unless (file-directory-p outdir)
      (make-directory outdir t))
    (let* ((new-filename (read-string "Contexto da imagem: "))
           (outfile (expand-file-name (concat buffer-name "_" new-filename "." (file-name-extension infile)) outdir)))
      (rename-file infile outfile)
      (insert (concat (concat "#+ATTR_LATEX: :width 300px :float nil \n#+name:\n#+caption:\n[[file:" outfile) "]]")))
    (newline)
    (newline)))

;; Function to open pdf associated with current org file
(defun my/run-script-to-open-pdf ()
  ;;Runs a Python script to open pdf
  (interactive)
  (call-process-shell-command (format "python3 ~/.config/scripts/open_pdf_emacs.py \"%s\"" buffer-file-name))
  )
