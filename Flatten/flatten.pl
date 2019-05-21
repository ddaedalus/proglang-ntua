flatten([], []).
flatten([[X|R]|T], FL) :-
	flatten([X|R], Find), !,
	append(Find, NewFL, FL),
	flatten(T, NewFL).
flatten([X|T], [X|FL]):-
	flatten(T, FL).

