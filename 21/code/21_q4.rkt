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


; S2.b Phase 1: Count the top-level elements of a list.
; Base case: An empty list has length 0.
; Recursive step: Count the first element as 1, then
; recursively count the remaining elements.

(define (my-length lst)
  (if (null? lst)
      0
      (+ 1 (my-length (cdr lst)))))


; S2.b Phase 2: Apply a function to each top-level element of a list.
; Base case: An empty list returns '().
; Recursive step: Apply f to the first element, then recursively
; process the remaining elements while preserving their order.

(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))


; S2.b Phase 3: Recursively insert x into lists shorter than n.
; Atoms remain unchanged, while nested lists are processed recursively.
; Check each list's original length before inserting x, so new
; insertions do not affect the decision for that list.

(define (insert-short-helper x lst n)
  (let ((original-length (my-length lst)))
    (let ((processed
           (my-map
            (lambda (item)
              (if (pair? item)
                  (insert-short-helper x item n)
                  (if (null? item)
                      (insert-short-helper x item n)
                      item)))
            lst)))
      (if (< original-length n)
          (cons x processed)
          processed))))


; S2.b Phase 4: Insert x into every list shorter than n.
; Reuse insert-short-helper to process the top-level list
; and all nested lists without duplicating the recursion.

(define (insert-if-short x lst n)
  (insert-short-helper x lst n))
