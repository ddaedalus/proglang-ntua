next(M,N) :-
	next_to(M, N, 0, Answer),
	N = Answer.

next_to([], N, _, Answer) :-
	Answer = N.
next_to([MH | MT], [NH | NT], T, Answer) :-
	( T =:= 0 -> 
		append([1, MH], [], N),
		next_to(MT, N, 1, Answer)
	;
	  reverse([NH | NT], N),
	  nth0(0, N, X),
	  ( MH =:= X -> 
		nth0(1, N, Y),
		NewY is Y + 1,
		once(select(Y, N, NN)),
		once(select(X, NN, NNN)),
		append([MH, NewY], NNN, NNNN),
		reverse(NNNN,NNNNN),
		NewT is T + 1,
		next_to(MT, NNNNN, NewT, Answer)
	  ;
	    append([MH, 1], N, NN),
	    reverse(NN, NNN),
	    NewT is T + 1,
	    next_to(MT, NNN, NewT, Answer)
	  )
	).
			
