/**
 * Here We Are Again
 *
 *
 */
pistes(File, Answer) :-
	read_input(File, _, Pistes),
	[First | Rest] = Pistes,
	First = round(_, FirstStars, _, _),
	findall(A, unlock(First, _, Rest, _, FirstStars, A), L),
	find_list_max(L, R),
	once(Answer = R).



/*
 * Checks if one round unlocks another and makes a new "union" round  -- Res
 */
unlock_round(round(_, Stars, _, Unlock), round(Num, Stars2, [], Unlock2), round(NewNum, NewStars, L, NewUnlock), Res, New, _, _) :-
	NewStars is Stars + Stars2,
	NewNum is Num,
	append(Unlock, Unlock2, NewUnlock),
	Res = round(Num, _, _, _),
	New = round(Num, NewStars, L, NewUnlock) . 

unlock_round(round(_, Stars, _, Unlock), round(Num, Stars2, [Lock | L], Unlock2), round(_, _, [], _), Res, New, Max, Answer) :-
	/* Check if you can unlock */	
	( select(Lock, Unlock, NUnlock),
		unlock_round(round(_, Stars, _, NUnlock), round(Num, Stars2, L, Unlock2), round(_, _, [], _), Res, New, Max, Answer)
	;
	  false
	) .



/*
 * Give a round and returns the rounds that unlock and the "new" rounds created with new stars and keys
 */        
unlock(round(_, _, _, _), _, [], _, Max, Answer) :- 
	Answer is Max.								

unlock(round(_, Stars, _, Unlock), [round(Num, Stars2, Locks, Unlock2) | _], Pistes, New, Max, Answer) :-
	member(round(Num, Stars2, Locks, Unlock2), Pistes),   % oi pistes na mhn periexoun thn num=1

	( unlock_round(round(_, Stars, _, Unlock), round(Num, Stars2, Locks, Unlock2), round(_, _, [], _), Res, New, Max, Answer) ->
	  	New = round(_, StarsC, _, _),
	  	find_max(StarsC, Max, Maximum),
	  	select(Res, Pistes, NewRest),
	  	unlock(New, _, NewRest, _, Maximum, Answer) 
	 ;
	   unlock(round(_, Stars, _, Unlock), _, [], New, Max, Answer)
	) .
	
	  


find_max(Number, Current, Max) :-
	( Current =< Number ->
		Max is Number
	;
	  Current > Number->
		Max is Current
	).



/*
 * By StackOverflow
 */
find_list_max([], R, R) .
find_list_max([X | Xs], WK, R) :-
	X > WK,
	find_list_max(Xs, X, R).
find_list_max([X | Xs], WK, R) :-
	X =< WK,
	find_list_max(Xs, WK, R).
find_list_max([X | Xs], R) :-
	find_list_max(Xs, X, R).



read_input(File, N, Pistes) :-
	open(File, read, Stream),
    	read_line_to_codes(Stream, Line),
    	atom_codes(Atom, Line),
    	atom_number(Atom, N),
    	NewN is N + 1,
    	read_lines(Stream, NewN, Pistes, 1).


read_lines(Stream, N, Pistes, Number) :-
    	( N =:= 0 -> Pistes = []
    	; 
      	  N > 0 -> Num is Number,
	       	   read_line(Stream, Num, Pista),
                   Nm1 is N-1,
	           NewNumber is Number + 1,
                   read_lines(Stream, Nm1, RestPistes, NewNumber),
                   Pistes = [Pista | RestPistes]
    	).


	
read_line(Stream, Num, round(Num, Stars, Lock, Unlock)) :-
    	read_line_to_codes(Stream, Line),
    	atom_codes(Atom, Line),
	atomic_list_concat(Atoms, ' ', Atom),
	maplist(atom_number, Atoms, [NumLock | Rest]),
	Rest = [NumUnlock | Rest1],
	Rest1 = [Stars | Rest2],
	get_list_from_list(Rest2, 1, NumLock, [], Lock, RemainingList),
	get_list_from_list(RemainingList, 1, NumUnlock, [], Unlock, _). 
	



get_list_from_list(List1, Counter, N, List2, Result, Remaining) :-
	( Counter =< N -> NewCounter is Counter + 1,
		    	  [Head | List] = List1, 
			  get_list_from_list(List, NewCounter, N, [Head | List2], Result, Remaining)
	;
	  reverse(List2, Result), 
	  Remaining = List1
	).

