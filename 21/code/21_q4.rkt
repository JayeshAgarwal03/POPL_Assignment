#lang racket/base

; S2.a Phase 1: Read the three inputs for nested list insertion.
; Read x, lst and n from standard input in that exact order.
; Return all three values together as a list without printing anything.

(define (read-insert-input)
  (let ((x (read))
        (lst (read))
        (n (read)))
    (list x lst n)))


; S2.a Phase 2: Read input and print the insertion result.
; Obtain x, lst and n using read-insert-input.
; Apply insert-if-short and display the resulting list
; followed by exactly one newline.

(define (print-insert-result)
  (let ((inputs (read-insert-input)))
    (display
     (insert-if-short
      (car inputs)
      (cadr inputs)
      (caddr inputs)))
    (newline)))
