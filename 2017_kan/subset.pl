sumall([], Sum, Sum).     /* same to sum_list */
sumall([H|T], Sum, Total) :-
	NewSum is Sum + H,
	sumall(T, NewSum, Total).

subset([], []).
subset([H|T1], [H|T2]) :-
	subset(T1, T2).	
subset(L, [_|S]) :-
	subset(L, S).

setsum(L, Sum, Subset) :-
	subset(Subset, L),
	sumall(Subset, 0, Sum).
	
	
	
