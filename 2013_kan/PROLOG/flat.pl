flatten([],[]).
flatten([[X|R]|T],[X|F]) :-
	flatten(T, F).
