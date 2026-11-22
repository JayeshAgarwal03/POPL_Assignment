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

% operator_precedence(Operator, Precedence) holds when Precedence is
% the operator's formatting rank. A higher rank means tighter binding.
operator_precedence('+', 1).
operator_precedence('-', 1).
operator_precedence('*', 2).
operator_precedence('/', 2).

% format_operand(Side, ParentOperator, ChildTree, ChildText, Text) holds
% when Text preserves the child tree by adding parentheses where needed.
% Numbers keep their text. Equal precedence needs parentheses on the right.
format_operand(_, _, num(_), Text, Text).
format_operand(Side, ParentOperator, bin(ChildOperator, _, _), ChildText, Text) :-
    operator_precedence(ParentOperator, ParentRank),
    operator_precedence(ChildOperator, ChildRank),
    (   (   ChildRank < ParentRank
        ;   Side == right,
            ChildRank =:= ParentRank
        )
    ->  format(string(Text), '(~s)', [ChildText])
    ;   Text = ChildText
    ).

% expression_string(Tree, Text) holds when Text is the decimal or infix
% rendering of Tree with its grouping preserved.
% A number is a leaf. For a binary node, render the two smaller trees
% and format them as operands before joining them with the operator.
expression_string(num(Number), Text) :-
    format(string(Text), '~d', [Number]).
expression_string(bin(Operator, LeftTree, RightTree), Text) :-
    expression_string(LeftTree, LeftText),
    expression_string(RightTree, RightText),
    format_operand(left, Operator, LeftTree, LeftText, FormattedLeft),
    format_operand(right, Operator, RightTree, RightText, FormattedRight),
    format(string(Text), '~s~a~s', [FormattedLeft, Operator, FormattedRight]).

% generate_equation(List, Equation) holds when Equation joins two ordered
% expressions that use all of List and have the same integer value.
generate_equation(List, Equation) :-
    split_nonempty(List, LeftNumbers, RightNumbers),
    expression(LeftNumbers, LeftTree, LeftValue),
    expression(RightNumbers, RightTree, RightValue),
    LeftValue =:= RightValue,
    expression_string(LeftTree, LeftText),
    expression_string(RightTree, RightText),
    format(string(Equation), '~s=~s', [LeftText, RightText]).

% all_equations(List, Equations) holds when Equations is the sorted list
% of distinct equation strings generated from List.
all_equations(List, Equations) :-
    findall(Equation, generate_equation(List, Equation), UnsortedEquations),
    sort(UnsortedEquations, Equations).
