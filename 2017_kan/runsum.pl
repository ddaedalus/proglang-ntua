runsum([], []).
runsum(Lst, S) :-
	(var(S) -> runsum(Lst, 0, [], S)
	 ;
	 var(Lst) -> runsum(Lst, 0, S)
	).

runsum([], _, []).
runsum([H|T], Current, [K|R]) :-
	H is K - Current,
	runsum(T, K, R). 

runsum([], _, Temp, S) :-
	reverse(Temp, S).
runsum([H|T], Current, Temp, S) :-
	New is H + Current,
	runsum(T, New, [New|Temp], S).
