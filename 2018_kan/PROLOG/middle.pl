middle([], []).
middle([X], [X]) :- !.
middle([X, Y], [X, Y]) :- !.
middle([X, [Head|Tail], Y], [X, K, Y]) :-
        middle([Head|Tail], K), !.

middle([X, Y, Z], [X, [Y], Z]) :- !.
middle([X, Y, Z, S], [X, [Y, Z], S]) :- !.
middle([X, Y | Rest], M) :-
        append(Ys, [Last], Rest), !,
        middle([X, [Y|Ys], Last], M).



	
