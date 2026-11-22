#lang racket/base

; S2.a tests: verify input order and exact printed output.
(require rackunit
         racket/runtime-path)

; Access the solution module without changing or exporting its definitions.
(define-runtime-path solution-path "../code/21_q4.rkt")
(dynamic-require solution-path #f)
(define solution-namespace (module->namespace solution-path))

; Supply the three inputs on standard input and capture every printed character.
(define (insert-output input-text)
  (define output (open-output-string))
  (parameterize ([current-namespace solution-namespace]
                 [current-input-port (open-input-string input-text)]
                 [current-output-port output])
    (eval '(print-insert-result)))
  (get-output-string output))

; Test 1: Handout example - mixed nested-list lengths.
(check-equal?
 (insert-output "42 ((1 2) (3 4 5) (6) ()) 3")
 "((42 1 2) (3 4 5) (42 6) (42))\n"
 "S2.a handout example 1")

; Test 2: Handout example - nested lists at multiple depths.
(check-equal?
 (insert-output "0 (((1) 2) (3) ((4 5 6) ())) 3")
 "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n"
 "S2.a handout example 2")

; Test 3: Handout example - empty outer list is short.
(check-equal?
 (insert-output "7 () 3")
 "(7)\n"
 "S2.a handout example 3")

; Test 4: Handout example - n = 0 never inserts.
(check-equal?
 (insert-output "7 () 0")
 "()\n"
 "S2.a handout example 4")

; Test 5: A list with original length exactly n is not changed.
(check-equal?
 (insert-output "9 ((1 2) (3) ()) 3")
 "((9 1 2) (9 3) (9))\n"
 "S2.a strict less-than boundary")

; Test 6: n = 0 leaves both nonempty and empty nested lists unchanged.
(check-equal?
 (insert-output "8 ((1) ()) 0")
 "((1) ())\n"
 "S2.a n = 0 nested lists")

; Test 7: The outer list is processed as well as its nested lists.
(check-equal?
 (insert-output "5 (1 (2)) 3")
 "(5 1 (5 2))\n"
 "S2.a insertion into outer list")


; S2.b: Evaluate solution helpers in their defining module namespace.
; This keeps the restricted solution file unchanged and requires no exports.
(define (solution-eval expression)
  (parameterize ([current-namespace solution-namespace])
    (eval expression)))

; Tests 8-12: my-length counts top-level elements only.
(check-equal?
 (solution-eval '(my-length '()))
 0
 "S2.b my-length empty list")

(check-equal?
 (solution-eval '(my-length '(1 2 3 4)))
 4
 "S2.b my-length flat list")

(check-equal?
 (solution-eval '(my-length '((1 2) (3 4 5) (6) ())))
 4
 "S2.b my-length nested elements count once")

(check-equal?
 (solution-eval '(my-length '((()) ((1 2)))))
 2
 "S2.b my-length deeply nested elements count once")

(check-equal?
 (solution-eval '(my-length '(a (b c) d)))
 3
 "S2.b my-length mixed atoms and sublists")

; Tests 13-16: my-map preserves order and applies f to each element.
(check-equal?
 (solution-eval '(my-map (lambda (x) (* x 2)) '()))
 '()
 "S2.b my-map empty list")

(check-equal?
 (solution-eval '(my-map (lambda (x) (* x 2)) '(1 2 3)))
 '(2 4 6)
 "S2.b my-map arithmetic transformation")

(check-equal?
 (solution-eval '(my-map (lambda (x) x) '(a (b c) d)))
 '(a (b c) d)
 "S2.b my-map identity preserves nested elements")

(check-equal?
 (solution-eval '(my-map (lambda (x) (list x x)) '(1 2 3)))
 '((1 1) (2 2) (3 3))
 "S2.b my-map preserves input order")

; Tests 17-20: insert-if-short produces the four handout results.
(check-equal?
 (solution-eval '(insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3))
 '((42 1 2) (3 4 5) (42 6) (42))
 "S2.b insert-if-short handout example 1")

(check-equal?
 (solution-eval '(insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3))
 '((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
 "S2.b insert-if-short handout example 2")

(check-equal?
 (solution-eval '(insert-if-short 7 '() 3))
 '(7)
 "S2.b insert-if-short empty outer list")

(check-equal?
 (solution-eval '(insert-if-short 7 '() 0))
 '()
 "S2.b insert-if-short n = 0 on empty list")

; Tests 21-24: strict boundary, nesting, n = 0 and outer insertion.
(check-equal?
 (solution-eval '(insert-if-short 9 '((1 2) (3) ()) 3))
 '((9 1 2) (9 3) (9))
 "S2.b insert-if-short length exactly n stays unchanged")

(check-equal?
 (solution-eval '(insert-if-short 8 '((1) ()) 0))
 '((1) ())
 "S2.b insert-if-short n = 0 leaves all lists unchanged")

(check-equal?
 (solution-eval '(insert-if-short 5 '(1 (2)) 3))
 '(5 1 (5 2))
 "S2.b insert-if-short also processes the outer list")

(check-equal?
 (solution-eval '(insert-if-short 7 '((())) 2))
 '(7 (7 (7)))
 "S2.b insert-if-short nested empty lists")

(display "S2.b: 17 additional checks completed (inspect raco test for failures)\n")


; S2.c: Test make-inserter independently of insert-if-short.
; A predicate decides whether each list's original top-level length qualifies.

; Test 25: Length strictly less than 3; handle atoms and empty nested lists.
(check-equal?
 (solution-eval
  '((make-inserter 9 (lambda (len) (< len 3)))
    '((a) (b c d) () z)))
 '((9 a) (b c d) (9) z)
 "S2.c less-than predicate")

; Test 26: Length greater than 2; both outer and qualifying inner lists.
(check-equal?
 (solution-eval
  '((make-inserter 8 (lambda (len) (> len 2)))
    '((a b c) (d) () z)))
 '(8 (8 a b c) (d) () z)
 "S2.c greater-than predicate")

; Test 27: Length equal to 2; only the matching nested list qualifies.
(check-equal?
 (solution-eval
  '((make-inserter 7 (lambda (len) (= len 2)))
    '((a b) (c) () z)))
 '((7 a b) (c) () z)
 "S2.c equal-to predicate")

; Test 28: Predicate accepting every nonnegative length; all list levels.
(check-equal?
 (solution-eval
  '((make-inserter 5 (lambda (len) (>= len 0)))
    '(a (b) ())))
 '(5 a (5 b) (5))
 "S2.c accept-all predicate")

; Test 29: Empty top-level list is processed by the returned function.
(check-equal?
 (solution-eval
  '((make-inserter 4 (lambda (len) (= len 0))) '()))
 '(4)
 "S2.c empty top-level list")

; Test 30: Lengths are measured before insertion, even at nested levels.
; The outer list and its first child both originally have length 2.
(check-equal?
 (solution-eval
  '((make-inserter 6 (lambda (len) (= len 2)))
    '((a b) ())))
 '(6 (6 a b) ())
 "S2.c original lengths, not modified lengths")

; Test 31: Atoms and deeply nested empty lists are treated correctly.
(check-equal?
 (solution-eval
  '((make-inserter 'q (lambda (len) (< len 2)))
    '((()) a)))
 '((q (q)) a)
 "S2.c nested empty lists and symbol atoms")

(display "S2.c: 7 additional checks completed (inspect raco test for failures)\n")

; Stress test: a flat list containing 10,000 elements.
(define large-list (build-list 10000 (lambda (i) i)))

(check-equal?
 (solution-eval
  (list 'my-length (list 'quote large-list)))
 10000
 "S2 large-list length")
