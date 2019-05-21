match([], []).
match([C], [C]).
match([C], [?]).
match([C], [+]).
match([C1, C2], [C1, C2]).
match([C1, C2], [?, ?]).
match([C1, C2], [+]).
match([C1, C2], [+, +]).
match([C|Tail], Res) :-
	(Res = [+]
	;
	 Res = [+|Rest],
	 match(Tail, Rest)
	;
	 Res = [C|Rest],
	 match(Tail, Rest)
	).	
