magic(L) :-
	X = [_, _, _, _, _, _, _, _, _],
	legal(X),
	be_magic(X, L).

be_different([], _) .
be_different([Head | Rest], X) :-
	List = [Head | Rest],
	\+select(X, List, _).
	



legal([]) .
legal([Head | Rest]) :-
	legal(Rest),
	member(Head, [1, 2, 3, 4, 5, 6, 7, 8, 9]),
	be_different(Rest, Head).
	
be_magic(List, L) :-
	nth0(0,	List, A1),
	nth0(1, List, A2),
	nth0(2, List, A3),
	nth0(3, List, A4),
	nth0(4, List, A5),
	nth0(5, List, A6),
	nth0(6, List, A7),
	nth0(7, List, A8),
	nth0(8, List, A9),
	S1 = A1 + A2 + A3,
	S2 = A4 + A5 + A6,
	S3 = A7 + A8 + A9,
	S4 = A1 + A4 + A7,
	S5 = A2 + A5 + A8,
	S6 = A3 + A6 + A9,
	S7 = A1 + A5 + A9,
	S8 = A3 + A5 + A7,
	S1 =:= S2,
	S2 =:= S3,
	S3 =:= S4,
	S4 =:= S5,
	S5 =:= S6,
	S6 =:= S7,
	S7 =:= S8,
	L = List.


	






