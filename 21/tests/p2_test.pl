% Run from the repository root.
% swipl -q -s 21/tests/p2_test.pl -g run_tests -t halt

:- use_module(library(plunit)).
:- ensure_loaded('../code/21_q2.pl').

:- begin_tests(p2).

% expected_equations(Numbers, Equations) holds for the handout examples.
expected_equations([4, 2, 5, 3], [
    "4*2-5=3",
    "4*2=5+3",
    "4-2=5-3",
    "4/2=5-3",
    "4=2*(5-3)",
    "4=2+(5-3)",
    "4=2+5-3"
]).
expected_equations([2, 4, 8], ["2*4=8"]).

test(all_equations_match_handout,
     [forall(expected_equations(Numbers, Expected)), true(Equations == Expected)]) :-
    all_equations(Numbers, Equations).

test(generator_matches_handout_on_backtracking,
     [forall(expected_equations(Numbers, Expected)), set(Equation == Expected)]) :-
    generate_equation(Numbers, Equation).

test(generator_fails_for_empty_list, [fail]) :-
    generate_equation([], _).

test(generator_fails_for_singleton, [fail]) :-
    generate_equation([7], _).

test(generator_fails_without_a_solution, [fail]) :-
    generate_equation([2, 3, 4], _).

test(all_equations_without_a_solution, true(Equations == [])) :-
    all_equations([2, 3, 4], Equations).

test(count_seven_equations, true(Count == 7)) :-
    count_equations([4, 2, 5, 3], Count).

test(count_zero_equations, true(Count == 0)) :-
    count_equations([2, 3, 4], Count).

test(two_zeros_yield_one_equation, true(Equations == ["0=0"])) :-
    all_equations([0, 0], Equations).

test(exact_division_returns_an_integer, true(Value == 4)) :-
    apply_operator('/', 8, 2, Value).

test(inexact_division_fails, [fail]) :-
    apply_operator('/', 7, 2, _).

test(zero_divisor_inside_expression_fails, [fail]) :-
    Tree = bin('/', num(8), bin('-', num(2), num(2))),
    expression([8, 2, 2], Tree, _).

test(negative_intermediate_value, all(Value == [-4])) :-
    Tree = bin('/', bin('-', num(2), num(10)), num(2)),
    expression([2, 10, 2], Tree, Value).

test(left_and_right_associated_trees_render_differently,
     all(LeftText-RightText == ["1-2-3"-"1-(2-3)"])) :-
    LeftTree = bin('-', bin('-', num(1), num(2)), num(3)),
    RightTree = bin('-', num(1), bin('-', num(2), num(3))),
    expression_string(LeftTree, LeftText),
    expression_string(RightTree, RightText).

:- end_tests(p2).
