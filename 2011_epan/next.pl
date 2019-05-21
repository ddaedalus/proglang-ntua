next([], []).
next([X], [1, X]).
next([H|T], Next) :-
	append([1, H], Tail, Next), 	
	next(T, Tail), !.
