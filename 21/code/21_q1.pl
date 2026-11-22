:- use_module(library(lists), [permutation/2]).

% candidate_solution(Solution) holds when Solution assigns every friend
% one department, one language, and one project, using each value once.
% The friends appear in the order Alex, Ben, Carla, Dana.
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