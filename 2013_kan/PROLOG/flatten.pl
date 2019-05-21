flatten([], []) .
flatten([[] | Rest], FL) :-
	flatten(Rest, FL).
flatten([[X|T] | Rest], [X|FL]) :-
	flatten([T | Rest], FL).
flatten(T, T).

check([]).	
check([H|T]):-
	H \= [_|_],
	check(T).

flat(FL, FL).
flat(FILE, FL) :-
	once(flatten(FILE, F)),
	( \+check(F) -> 
		flat(F, FL)
	;
	  FL = F
	).
flatt(FILE, FL) :-
	findall(A, flat(FILE,A), L),
	reverse(L, B),
	[FL | _] = B.
