;;; copilot.el -*- lexical-binding: t; -*-

;; Copilot config
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook ((prog-mode . copilot-mode)
         (org-mode . (lambda () (copilot-mode -1))))
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
