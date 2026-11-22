% split_nonempty(List, Left, Right) holds when Left is a nonempty prefix
% of List and Right is the remaining nonempty suffix.
% The base case puts only the first element in Left. The recursive case
% splits the shorter tail and prepends the first element to its prefix.
split_nonempty([First, Next | Rest], [First], [Next | Rest]).
split_nonempty([First | Rest], [First | Left], Right) :-
    split_nonempty(Rest, Left, Right).

% apply_operator(Operator, LeftValue, RightValue, Value) holds when
% Operator gives the integer Value for the two input integers.
% Division requires a nonzero divisor and a zero remainder.
apply_operator('+', LeftValue, RightValue, Value) :-
    Value is LeftValue + RightValue.
apply_operator('-', LeftValue, RightValue, Value) :-
    Value is LeftValue - RightValue.
apply_operator('*', LeftValue, RightValue, Value) :-
    Value is LeftValue * RightValue.
apply_operator('/', LeftValue, RightValue, Value) :-
    RightValue =\= 0,
    LeftValue rem RightValue =:= 0,
    Value is LeftValue // RightValue.

% expression(Numbers, Tree, Value) holds when Tree uses Numbers in order
% and evaluates to the integer Value.
% A singleton list gives a leaf. For a longer list, recursively build trees
% for the two shorter lists from an ordered split and apply an operator.
expression([Number], num(Number), Number).
expression(Numbers, bin(Operator, LeftTree, RightTree), Value) :-
    split_nonempty(Numbers, LeftNumbers, RightNumbers),
    expression(LeftNumbers, LeftTree, LeftValue),
    expression(RightNumbers, RightTree, RightValue),
    apply_operator(Operator, LeftValue, RightValue, Value).
