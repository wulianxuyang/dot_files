(defun binding-pry-filter (text)
  (if (string-match "^ => [0-9]+:" text) (pop-to-buffer (current-buffer))))

(defun enh-ruby-toggle-block ()
  (interactive)
  (let ((start (point)) beg end)
    (end-of-line)
    (unless
        (if (and (re-search-backward "\\(?:[^#]\\)\\({\\)\\|\\(\\_<do\\_>\\)")
                 (progn
                   (goto-char (or (match-beginning 1) (match-beginning 2)))
                   (setq beg (point))
                   (save-match-data (enh-ruby-forward-sexp))
                   (setq end (point))
                   (> end start)))
            (if (match-beginning 1)
                (ruby-brace-to-do-end beg end)
              (ruby-do-end-to-brace beg end)))
      (goto-char start))))

(defun current-line-has-pry-breakpoint-p ()
  (string-match-p "binding\\.pry" (buffer-substring-no-properties (line-beginning-position) (line-end-position))))

(defun delete-pry-breakpoints ()
  (save-excursion
    (goto-char (point-min))
    (while (/= (point) (point-max))
      (if (current-line-has-pry-breakpoint-p) (kill-whole-line) (forward-line)))))

(defun toggle-pry-breakpoint ()
  (interactive)
  (let ((buf-changed (buffer-modified-p)) (saved-evil-state evil-state))
    (if (current-line-has-pry-breakpoint-p)
        (kill-whole-line)
      (evil-open-above 0)
      (insert "require 'pry'; binding.pry;"))

    (unless buf-changed (save-buffer))
    (call-interactively (intern (concat "evil-" (symbol-name saved-evil-state) "-state")))))

(defun cleanup-pry-breakpoints ()
  (interactive)
  (let ((buf-changed (buffer-modified-p)) (saved-evil-state evil-state))
    (delete-pry-breakpoints)
    (unless buf-changed (save-buffer))
    (call-interactively (intern (concat "evil-" (symbol-name saved-evil-state) "-state")))))