#lang racket/base

(provide define+test
         +test)

(require (for-syntax racket/base
                     racket/syntax
                     syntax/parse
                     racket/contract))
(require rackunit
         racket/contract)

;;; Macro for defining tests as a part of defines
;; Do note that the macro does not currently work inside
;; function definitions as it needs to work in the
;; top level scope to be able to (module+ test)
(define-syntax (define+test stx)
  (syntax-parse
   stx
    [(dt (func-name:id parameters:id ...)
         (((test-input:expr ...) desired-result:expr) ...)
        body:expr ...)
     #'(begin
         (define (func-name parameters ...)
           body ...)
         (module+ test
           (check-equal? (func-name test-input ...)
                         desired-result) ...))]))

;;; Macro for expanding tests, separate of definitions
(define-syntax (+test stx)
  (syntax-parse
   stx
    [(t func:id ((test-input:expr ...) desired-result:expr) ...)
     #'(begin
         (module+ test
           (check-equal? (func test-input ...) desired-result) ...))]
    [(t func:id (test-input:expr desired-result:expr) ...)
     #'(begin
         (module+ test
           (check-equal? (func test-input) desired-result) ...))]))

(define-syntax (define/tc stx)
  (syntax-parse stx
    [(tc (func-name:id arg:id ...)
         contract-spec
         ([(test-input:expr ...) desired-result:expr] ...)
         body:expr ...)
     #'(begin
         (define/contract (func-name arg ...)
           contract-spec
           body ...)
           (check-equal? (func-name test-input ...) desired-result)
           ...)]
    [(tc (func-name:id arg:id ...)
         contract-spec
         ([test-input:expr desired-result:expr] ...)
         body:expr ...)
     #'(begin
         (define/contract (func-name arg ...)
           contract-spec
           body ...)
           (check-equal? (func-name test-input) desired-result)
           ...)]))
           

;;; Usage examples
(define+test (cubic x)
  (((2) 8)
   ((3) 27))
  (expt x 3))

(define+test (add-x&y x y)
  (((5 4) 9)
   ((5 5) 10)
   ((1 2) 3))
  (+ x y))

(define+test (insert-rambo input-list)
  ((('(jungle now contains)) '(jungle now contains rambo))
   (('(nothing is impossible for)) '(nothing is impossible for rambo))
   (('(john)) '(john rambo)))
  (append input-list '(rambo)))

(define (times-x&y x y)
  (* x y))

(+test times-x&y
       ((4 2) 8)
       ((12 3) 36)
       ((8 8) 64))

(define/tc (square x)
  (integer? . -> . integer?)
  
  ([2 4]
   [3 9]
   [5 25])

  (expt x 2))

(define/tc (square2&add x y)
  (integer? integer? . -> . integer?)

  ([(2 3) 13]
   [(1 2) 5])

  (+ (expt x 2) (expt y 2)))