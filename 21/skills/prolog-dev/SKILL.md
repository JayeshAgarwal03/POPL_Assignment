---
name: prolog-dev
description: Use for one predicate, one test file, or one review in the SWI-Prolog problems P1 and P2.
---

## Environment and workflow

Use SWI-Prolog 9.x. Put P1 in `code/id_q1.pl` and P2 in `code/id_q2.pl`, replacing `id` with the group ID.

Handle one unit per prompt. Copy the prompt word for word into `prompts/P1.md` or `prompts/P2.md`. Keep commits aligned with the units completed.

## Coding conventions

- Preserve the predicate names, arities, and argument order given in the question.
- Use `lower_snake_case` for new predicate names and descriptive capitalized names for variables, such as `ActiveClues`. Use `_` for an argument whose value is ignored.
- Give each predicate a short declarative reading in a `%` comment. For example, `% count_solutions(Active, N) holds when N is the number of assignments satisfying the clues in Active.`
- For a recursive predicate, explain when the base case holds and which argument gets smaller in the recursive clause.
- Use only the permitted libraries: `lists`, `apply`, `yall`, and `aggregate`. Do not use `assert`, `retract`, or global variables.
- A submitted file must load silently. Do not add sample queries, an `initialization` directive, or a call to `halt/0`.

## Problem-specific checks

- P1: Preserve the order Alex, Ben, Carla, Dana. Use the exact atoms from the question, including `'Alex'`, `'AI'`, and `'c++'`. Apply only the clues listed in `Active` when counting. Put the English text of clue 9 directly above its clause in a comment beginning `% CLUE 9:`. Only `main/0` should print the requested four lines.
- P2: Preserve the input order and use every number exactly once. Check every division for a nonzero divisor and an exact integer result. Return equations as SWI-Prolog strings with the specified parentheses. Do not parse a generated string to evaluate it. P2 predicates must produce no printed output.

## Running and testing

Run these commands from the repository root after replacing `id` with the group ID:

```sh
swipl --version
swipl -q -f code/id_q1.pl -g main -t halt
swipl -q -f code/id_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8,9],1)" -t halt
swipl -q -f code/id_q2.pl -g 'all_equations([2,4,8],["2*4=8"])' -t halt
```

For the last two commands, exit status 0 means the query succeeded. Keep one test file per problem in `tests/`. Include the handout examples and your own edge cases. For P2, check both a query that should fail and a query that should succeed with an empty result list. For P1, test different active-clue lists.

## Common AI mistakes

- Using `=` to calculate a number. `X = 1+2` binds `X` to a term. `X is 1+2` binds `X` to `3`.
- Adding a cut that discards valid solutions or overlapping clauses that count the same solution twice.
- Treating omitted P1 clues as clues that must be false. Omitted clues impose no condition.
- Returning a P2 atom instead of a string, or dropping parentheses that distinguish two expression trees.

## Self-review before answering

- [ ] Did I handle exactly the requested unit?
- [ ] Does the predicate match the required name, arity, argument order, and supported inputs?
- [ ] Does the comment accurately state when the predicate succeeds?
- [ ] For recursion or backtracking, did I check termination, missing answers, and duplicates?
- [ ] Does the file load silently, and is any required output exact?
- [ ] Did I distinguish tests I actually ran from cases I checked by hand?