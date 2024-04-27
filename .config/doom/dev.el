;;; dev.el -*- lexical-binding: t; -*-


(setenv "JAVA_HOME" "/usr/lib/jvm/default")
(setq lsp-java-java-path "/usr/lib/jvm/default/bin/java")

;; c++ mode in .h files
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . c++-mode))

(after! python
  :config
  (setq lsp-pyright-python-executable-cmd "python3"))

(add-hook! prog-mode 'rainbow-mode)
