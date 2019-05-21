is_heap(empty).
is_heap(node(Data, Left, Right) :-
	is_heap(Data, Left),
	is_heap(Data, Right).
is_heap(_, empty).
is_heap(Data, node(K, Left, Right)) :-
	Data <= K,
	is_heap(K, Left),
	is_heap(K, Right).
