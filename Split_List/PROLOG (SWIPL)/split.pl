split([], _, [], []). 
split(Lst, Data, X, Y) :-
	split(Lst, Data, [], X, Y).

split([], _, Acc, X, []) :-
	reverse(Acc, X), !.
split([Data|R], Data, Acc, X, [Data|R]) :-
	reverse(Acc, X), !.
split([H|R], Data, Acc, X, Y) :-
	split(R, Data, [H|Acc], X, Y).
