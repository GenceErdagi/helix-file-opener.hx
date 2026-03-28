(require-builtin helix/core/typable as hx-typable.)
(require "helix/ext.scm")

(provide open-file-handler)

(define (open-file-handler path)
  (when (not (equal? path ""))
    (hx.block-on-task 
      (lambda () 
        (hx-typable.open (list path))))))
