---
name: scheme-dev
description: Use for one function, one test file, or one review in the Racket Scheme problems S1 and S2.
---

## Environment and workflow

Use Racket 8.x. The first line of each submitted file must be `#lang racket/base`. Put S1 in `code/21_q3.rkt` and S2 in `code/21_q4.rkt`.

Handle one unit per prompt. Copy the prompt word for word into `prompts/S1.md` or `prompts/S2.md`. Keep commits aligned with the units completed.

## Coding conventions

- Preserve the function names and argument order given in the question. For new names, use lowercase words separated by hyphens, such as `count-leaves`. End Boolean predicate names with `?`.
- Above each function, write a short `;` comment explaining what it returns or prints. For recursion, explain the base case, what the recursive call computes, and how its result is used. For example, `; The empty list has length zero. For a pair, count its first element and add the length of its tail.`
- Pass state through arguments. Prefer tail recursion where it fits naturally.
- Keep only definitions after the language line. Put example calls in tests. Loading a submitted file must produce no output.

## Allowed built-ins

For both problems, use only the following:

- Forms: `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` with `else`, `and`, `or`, `not`, `begin`, and `quote` or `'`.
- Lists and symbols: `cons`, `car`, `cdr`, `list`, compositions of `car` and `cdr` up to four levels, `null?`, `pair?`, `eq?`, `assq`, and `assoc`.
- Arithmetic and comparisons: `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, and `max`.
- Output: `display` and `newline`. S2 also permits `read`.

Do not use mutation, vectors, hash tables, strings, `do`, or `for`. Built-ins such as `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, and `list-tail` are forbidden. Write a helper using the allowed forms when needed.

## Problem-specific checks

- S1: The empty tree has height 0 and no leaves. A single node has height 1 and one leaf. Visit the left subtree before the right subtree. Each requested output line ends with `newline`.
- S2: Measure each list's original top-level length, including for the outer list and empty sublists. Read `x`, `lst`, and `n` in that order without printing a prompt. Keep `my-length` and `my-map`. The final file must contain one definition of `insert-if-short` using `make-inserter`. Account for nesting depth 100 and lists of 10,000 elements.

## Running and testing

From the `21/` directory, run:

```sh
racket --version
racket code/21_q3.rkt
racket code/21_q4.rkt
```

Both submitted files should load silently. The grader appends calls to each file. To reproduce that behavior locally, append a call to a temporary copy:

```sh
test_file=$(mktemp)
cp code/21_q3.rkt "$test_file"
printf '\n%s\n' "(print-height-and-leaves '())" >> "$test_file"
racket "$test_file"
rm "$test_file"
```

The expected output is `(0 0)` followed by a newline. For S2, use a temporary copy of `21_q4.rkt`, append `(print-insert-result)`, and run it with `7 () 3` on standard input. The expected output is `(7)` followed by a newline.

Keep one test file per problem in `tests/`. Include the handout examples and your own edge cases. Use an asymmetric tree to expose traversal-order mistakes. For S2, test an empty nested list and a list whose length is exactly `n`.

## Common AI mistakes

- Using a familiar Racket built-in such as `map`, `length`, or `displayln` without checking the allowlist.
- Calling `car` or `cdr` on the empty list, or treating `'()` as false. Only `#f` is false in a conditional.
- Confusing `cons` with `list` and accidentally adding a level of nesting.
- Measuring an S2 list after insertion, skipping the outer list, or overlooking an empty sublist because `pair?` returns false for it.
- Printing from a helper that should return a value, or leaving a demonstration call at the end of the submitted file.

## Self-review before answering

- [ ] Did I handle exactly the requested unit and preserve its signature?
- [ ] Is every built-in permitted for this problem?
- [ ] Can I explain the base case, the smaller recursive input, and how the current result is formed?
- [ ] Did I check the result's type, list shape, order, and output formatting where relevant?
- [ ] Does loading the file produce no output?
- [ ] Did I distinguish tests I actually ran from cases I checked by hand?