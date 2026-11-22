#lang racket/base

; Tests for S1.a: print-inorder.
(require rackunit
         racket/runtime-path)

; Locate the solution file without modifying it.
(define-runtime-path solution-path "../code/21_q3.rkt")

; Load the solution and access its definitions.
(dynamic-require solution-path #f)
(define solution-namespace (module->namespace solution-path))

; Capture the exact printed output, including the newline.
(define (inorder-output tree)
  (define output (open-output-string))
  (parameterize ([current-namespace solution-namespace]
                 [current-output-port output])
    (eval (list 'print-inorder (list 'quote tree))))
  (get-output-string output))

; Trees given in the assignment.
(define t1
  '(4 (2 (1 () ()) (3 () ()))
      (6 (5 () ()) (7 () ()))))

(define t2
  '(1 () (2 () (3 () ()))))

(define t3
  '(a (b () ()) (c () ())))

; Test 1: Balanced tree.
(check-equal?
 (inorder-output t1)
 "(1 2 3 4 5 6 7)\n"
 "Balanced tree")

; Test 2: Right-skewed tree.
(check-equal?
 (inorder-output t2)
 "(1 2 3)\n"
 "Right-skewed tree")

; Test 3: Symbol-valued tree.
(check-equal?
 (inorder-output t3)
 "(b a c)\n"
 "Symbol tree")

; Test 4: Empty tree.
(check-equal?
 (inorder-output '())
 "()\n"
 "Empty tree")

; Test 5: Single-node tree.
(check-equal?
 (inorder-output '(42 () ()))
 "(42)\n"
 "Single-node tree")

; Test 6: Left-skewed tree.
(check-equal?
 (inorder-output '(3 (2 (1 () ()) ()) ()))
 "(1 2 3)\n"
 "Left-skewed tree")

; Test 7: Asymmetric tree.
(check-equal?
 (inorder-output
  '(8 (3 () (6 (4 () ()) ()))
      (10 () (14 (13 () ()) ()))))
 "(3 4 6 8 10 13 14)\n"
 "Asymmetric tree")

(display "S1.a: all 7 tests passed\n")
