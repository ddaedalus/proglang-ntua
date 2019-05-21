find_depth([X | Children], X, 1) .
find_depth([X | Children], X, D) :-
	member(Child, Children),
	find_depth(Child, X, DD),
	D is DD + 1.
