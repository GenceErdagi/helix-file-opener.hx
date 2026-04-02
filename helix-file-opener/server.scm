(require-builtin helix/core/typable as hx-typable.)
(require "helix/ext.scm")
(require "notify/notify.scm")
(require "helix/misc.scm")

(provide open-file-handler)

(define (notify-safe msg #:severity [severity 'info] #:title [title ""])
  (enqueue-thread-local-callback
    (lambda ()
      (notify msg #:severity severity #:title title))))

(define (open-file-handler path)
  (with-handler
      (lambda (err)
        (notify-safe (string-append "Failed to open file: " (error-object-message err)) #:severity 'error #:title "helix-file-opener"))
    (when (not (equal? path ""))
      (hx.block-on-task 
        (lambda () 
          (hx-typable.open (list path)))))))
