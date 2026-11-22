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
