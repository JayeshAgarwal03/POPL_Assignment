#lang racket/base

; Phase 1: Concatenate two lists while preserving their order.
; Base case: If the first list is empty, return the second list.
; Recursive step: Place the first element of the first list
; before the concatenation of its remaining elements and the second list.

(define (my-append lst1 lst2)
  (if (null? lst1)
      lst2
      (cons (car lst1)
            (my-append (cdr lst1) lst2))))


; Phase 2: Return the inorder traversal of a binary tree.
; Base case: An empty tree has no values, so return '().
; Recursive step: Traverse the left subtree, then the root,
; followed by the right subtree.

(define (my-inorder tree)
  (if (null? tree)
      '()
      (my-append
       (my-inorder (cadr tree))
       (cons (car tree)
             (my-inorder (caddr tree))))))


; Phase 3: Print the inorder traversal of a binary tree.
; Display the traversal as a Scheme list, followed by one newline.

(define (print-inorder tree)
  (display (my-inorder tree))
  (newline))
