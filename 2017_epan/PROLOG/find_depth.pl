find_depth([H|Children], H, 1).
find_depth([H|Children], X, L) :-
	member(Child, Children),
	find_depth(Child, X, LL),
	LL is L + 1. 
