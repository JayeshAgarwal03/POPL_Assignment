:- use_module(library(lists), [permutation/2]).

% candidate_solution(Solution) holds when each friend has a department,
% a language, and a project, with each attribute value used exactly once.
candidate_solution([
    p('Alex',  AlexDept,  AlexLang,  AlexProject),
    p('Ben',   BenDept,   BenLang,   BenProject),
    p('Carla', CarlaDept, CarlaLang, CarlaProject),
    p('Dana',  DanaDept,  DanaLang,  DanaProject)
]) :-
    permutation([research, development, design, testing],
                [AlexDept, BenDept, CarlaDept, DanaDept]),
    permutation([python, java, 'c++', javascript],
                [AlexLang, BenLang, CarlaLang, DanaLang]),
    permutation(['AI', web, embedded, data],
                [AlexProject, BenProject, CarlaProject, DanaProject]).

% 1. The friend who prefers AI works outside research and is someone other than Dana.
clue(1, Solution) :-
    memberchk(p(Name, Dept, _, 'AI'), Solution),
    Dept \== research,
    Name \== 'Dana'.

% 2. Alex works outside development and prefers a language other than C++.
clue(2, Solution) :-
    memberchk(p('Alex', Dept, Lang, _), Solution),
    Dept \== development,
    Lang \== 'c++'.

% 3. The friend in testing prefers Python.
clue(3, Solution) :-
    memberchk(p(_, testing, python, _), Solution).

% 4. Ben prefers web projects and works outside testing.
clue(4, Solution) :-
    memberchk(p('Ben', Dept, _, web), Solution),
    Dept \== testing.

% 5. The friend who prefers Java works in design.
clue(5, Solution) :-
    memberchk(p(_, design, java, _), Solution).

% 6. Carla works outside development and prefers a project other than embedded.
clue(6, Solution) :-
    memberchk(p('Carla', Dept, _, Project), Solution),
    Dept \== development,
    Project \== embedded.

% 7. Dana works in research or testing and prefers a language other than Java.
clue(7, Solution) :-
    memberchk(p('Dana', Dept, Lang, _), Solution),
    Lang \== java,
    memberchk(Dept, [research, testing]).

% 8. The friend who prefers data projects works in research and prefers a language other than JavaScript.
clue(8, Solution) :-
    memberchk(p(_, research, Lang, data), Solution),
    Lang \== javascript.

% solve_p1(Solution) holds when a complete assignment satisfies clues 1 through 8.
solve_p1(Solution) :-
    candidate_solution(Solution),
    forall(between(1, 8, Number), clue(Number, Solution)).

% main prints the first valid assignment, one line per friend.
main :-
    once(solve_p1(Solution)),
    forall(
        member(p(Name, Dept, Lang, Project), Solution),
        format('~a = [~a, ~a, ~a]~n', [Name, Dept, Lang, Project])
    ).

% count_solutions(Active, N) holds when N is the number of complete
% assignments that satisfy every clue number in the given list Active.
count_solutions(Active, N) :-
    findall(
        Solution,
        ( candidate_solution(Solution),
          forall(member(Number, Active), clue(Number, Solution))
        ),
        Solutions
    ),
    length(Solutions, N).