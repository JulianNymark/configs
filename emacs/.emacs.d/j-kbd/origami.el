(progn
  (define-key origami-mode-map (kbd "C-c C-h") 'origami-close-node)
  (define-key origami-mode-map (kbd "C-c C-s") 'origami-open-node)
  (define-key origami-mode-map (kbd "C-c C-M-h") 'origami-close-all-nodes)
  (define-key origami-mode-map (kbd "C-c C-M-s") 'origami-open-all-nodes))
