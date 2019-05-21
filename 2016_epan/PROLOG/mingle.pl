mingle([], [], []).
mingle([], Lst, Lst).
mingle(Lst, [], Lst).
mingle([X|Xs], [Y|Ys], M) :-
	( append([X], NewM, M),
	  mingle(Xs, [Y|Ys], NewM) 
	; 
	  append([Y], NewM, M),
	  mingle([X|Xs], Ys, NewM)
	) .
