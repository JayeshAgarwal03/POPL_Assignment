:- use_module(library(plunit)).
:- use_module(library(lists), [member/2, nth1/4]).
:- ensure_loaded('../code/21_q1.pl').

:- begin_tests(p1_a).

% The three assignments that satisfy clues 1 through 8.
expected_solution([
    p('Alex',  design,      java,       'AI'),
    p('Ben',   development, javascript, web),
    p('Carla', research,    'c++',      data),
    p('Dana',  testing,     python,     embedded)
]).
expected_solution([
    p('Alex',  design,      java,       embedded),
    p('Ben',   development, javascript, web),
    p('Carla', testing,     python,     'AI'),
    p('Dana',  research,    'c++',      data)
]).
expected_solution([
    p('Alex',  testing,     python,     embedded),
    p('Ben',   development, javascript, web),
    p('Carla', design,      java,       'AI'),
    p('Dana',  research,    'c++',      data)
]).

test(candidate_count_and_uniqueness) :-
    findall(Solution, candidate_solution(Solution), Candidates),
    sort(Candidates, UniqueCandidates),
    length(Candidates, Total),
    length(UniqueCandidates, Distinct),
    assertion(Total == 13824),
    assertion(Distinct == 13824).

test(each_clue_succeeds_once,
     [forall((expected_solution(Solution), between(1, 8, Number)))]) :-
    findall(ok, clue(Number, Solution), Results),
    assertion(Results == [ok]).

% Each case changes one attribute in the first expected solution.
% Friend positions are Alex=1, Ben=2, Carla=3, Dana=4.
% Field positions in the list [Name, Dept, Lang, Project] are 2, 3, and 4.
violating_swap(1, 4, 1, 3).  % The AI project is in research.
violating_swap(1, 4, 1, 4).  % Dana prefers the AI project.
violating_swap(2, 2, 1, 2).  % Alex works in development.
violating_swap(2, 3, 1, 3).  % Alex prefers C++.
violating_swap(3, 3, 4, 2).  % The testing friend prefers JavaScript.
violating_swap(4, 4, 2, 4).  % Ben prefers embedded projects.
violating_swap(4, 2, 2, 4).  % Ben works in testing.
violating_swap(5, 3, 1, 2).  % The Java user works in development.
violating_swap(6, 4, 3, 4).  % Carla prefers embedded projects.
violating_swap(6, 2, 3, 2).  % Carla works in development.
violating_swap(7, 3, 4, 1).  % Dana prefers Java.
violating_swap(7, 2, 4, 2).  % Dana works in development.
violating_swap(8, 4, 3, 2).  % The data project is in development.
violating_swap(8, 3, 3, 2).  % The data project uses JavaScript.

% Exchange one attribute between two friends, preserving a complete assignment.
swap_attribute(Before, Field, First, Second, After) :-
    nth1(First, Before, FirstPerson, WithoutFirst),
    nth1(Second, Before, SecondPerson, _),
    FirstPerson =.. [p | FirstFields],
    SecondPerson =.. [p | SecondFields],
    nth1(Field, FirstFields, FirstValue, FirstRest),
    nth1(Field, SecondFields, SecondValue, SecondRest),
    nth1(Field, NewFirstFields, SecondValue, FirstRest),
    nth1(Field, NewSecondFields, FirstValue, SecondRest),
    NewFirstPerson =.. [p | NewFirstFields],
    NewSecondPerson =.. [p | NewSecondFields],
    nth1(First, Intermediate, NewFirstPerson, WithoutFirst),
    nth1(Second, Intermediate, SecondPerson, WithoutSecond),
    nth1(Second, After, NewSecondPerson, WithoutSecond).

test(each_clue_rejects_violations,
     [forall(violating_swap(Number, Field, First, Second))]) :-
    once(expected_solution(Baseline)),
    swap_attribute(Baseline, Field, First, Second, Invalid),
    assertion(\+ clue(Number, Invalid)).

test(main_prints_exactly_one_valid_assignment) :-
    with_output_to(string(Actual), findall(ok, main, Results)),
    assertion(Results == [ok]),
    findall(Output, expected_output(Output), AllowedOutputs),
    assertion(member(Actual, AllowedOutputs)).

% Expected output strings include the spaces and the final newline.
expected_output("Alex = [design, java, AI]\nBen = [development, javascript, web]\nCarla = [research, c++, data]\nDana = [testing, python, embedded]\n").
expected_output("Alex = [design, java, embedded]\nBen = [development, javascript, web]\nCarla = [testing, python, AI]\nDana = [research, c++, data]\n").
expected_output("Alex = [testing, python, embedded]\nBen = [development, javascript, web]\nCarla = [design, java, AI]\nDana = [research, c++, data]\n").

:- end_tests(p1_a).