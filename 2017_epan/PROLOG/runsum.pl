runsum([], []).
runsum(Lst, S) :-
	runsum(Lst, 0, [], S).

runsum([], _, Temp, S) :-
	reverse(Temp, S).
runsum([H|T], Current, Temp, S) :-
	New is H + Current,
	runsum(T, New, [New|Temp], S).
