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


; S1.b Phase 1: Return the preorder traversal of a binary tree.
; Base case: An empty tree has no values, so return '().
; Recursive step: Visit the root first, then recursively traverse
; the left subtree followed by the right subtree.

(define (my-preorder tree)
  (if (null? tree)
      '()
      (cons (car tree)
            (my-append
             (my-preorder (cadr tree))
             (my-preorder (caddr tree))))))


; S1.b Phase 2: Return the postorder traversal of a binary tree.
; Base case: An empty tree has no values, so return '().
; Recursive step: Recursively traverse the left subtree, then
; the right subtree, and finally visit the root.

(define (my-postorder tree)
  (if (null? tree)
      '()
      (my-append
       (my-postorder (cadr tree))
       (my-append
        (my-postorder (caddr tree))
        (list (car tree))))))


; S1.b Phase 3: Print all three binary tree traversals.
; Print inorder, preorder and postorder in that order.
; Each traversal is displayed on its own line.

(define (print-all-traversals tree)
  (display (my-inorder tree))
  (newline)
  (display (my-preorder tree))
  (newline)
  (display (my-postorder tree))
  (newline))


; S1.c Phase 1: Calculate the height of a binary tree.
; Base case: An empty tree has height 0.
; Recursive step: The height of a nonempty tree is 1 plus
; the maximum height of its left and right subtrees.

(define (my-height tree)
  (if (null? tree)
      0
      (+ 1
         (max (my-height (cadr tree))
              (my-height (caddr tree))))))


; S1.c Phase 2: Count the leaf nodes of a binary tree.
; Empty-tree case: An empty tree has 0 leaves.
; Leaf-node case: A node with both subtrees empty has 1 leaf.
; Recursive step: Add the leaf counts of the left and right subtrees.

(define (my-leaf-count tree)
  (if (null? tree)
      0
      (if (and (null? (cadr tree))
               (null? (caddr tree)))
          1
          (+ (my-leaf-count (cadr tree))
             (my-leaf-count (caddr tree))))))


; S1.c Phase 3: Print the height and leaf count of a binary tree.
; Combine the height and leaf count into a two-element list.
; Display the list followed by exactly one newline.

(define (print-height-and-leaves tree)
  (display (list (my-height tree)
                 (my-leaf-count tree)))
  (newline))
