running_sum(L, S):-
	help(L, [], 0, S).
	
help([], X, _, S) :- 
	S = X.
help(L, [], 0, S) :-
	L = [FirstL | RestL],
	Sum = FirstL,
	help(RestL, [FirstL], Sum, S).
help(L, X, Sum, S) :-
	L = [FirstL | RestL],
	NewSum is Sum + FirstL,
	append(X, [NewSum], Y),
	help(RestL, Y, NewSum, S).
	
	
