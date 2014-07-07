#lang racket/base

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse
                     racket/contract))

(define-syntax (while stx)
  (syntax-parse stx
    [(w condition-spec:expr body:expr ...)
     (with-syntax ([while-id (format-id stx
                                        "~a"
                                        'while-def)])
       #'(begin
           (require racket/contract)
           (define/contract (while-id condition-var)
             (boolean? . -> . any/c)

             (when condition-spec
               body ...
               (while-id condition-spec)))
           (while-id condition-spec)))]))

(module+ main
  (define k 0)
  (while (< k 3)
    (printf "k: ~a~n" k)
    (set! k (add1 k))))