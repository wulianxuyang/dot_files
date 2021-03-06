(defun projectile-shell-pop ()
  (interactive)
  (if (string= "term-mode" major-mode)
      (shell-pop-out)
    (if (not (projectile-project-p))
        (spacemacs/shell-pop-ansi-term 0)
      (if (not (boundp 'projectile-term-index-hash-table)) (setq projectile-term-index-hash-table (make-hash-table :test 'equal)))
      (let* ((projectile-project-root (projectile-project-root))
             (index (or (gethash projectile-project-root projectile-term-index-hash-table)
                        (1+ (apply 'max 99 (hash-table-values projectile-term-index-hash-table))))))
        (puthash projectile-project-root index projectile-term-index-hash-table)
        (spacemacs/shell-pop-ansi-term index)))))

