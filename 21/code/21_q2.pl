% split_nonempty(List, Left, Right) holds when Left is a nonempty prefix
% of List and Right is the remaining nonempty suffix.
% The base case puts only the first element in Left. The recursive case
% splits the shorter tail and prepends the first element to its prefix.
split_nonempty([First, Next | Rest], [First], [Next | Rest]).
split_nonempty([First | Rest], [First | Left], Right) :-
    split_nonempty(Rest, Left, Right).
