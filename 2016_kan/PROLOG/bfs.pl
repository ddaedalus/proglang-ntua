bsf_level([X | Children], X, 1) .
bfs_level([X | Children], Y, D) :-
	member(Child, Children),
	bfs_level(Child, Y, DD),
	D is DD + 1.
