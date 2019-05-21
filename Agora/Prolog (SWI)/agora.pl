reverse(Xs, Ys) :-
        reverse_worker(Xs, [], Ys).

reverse_worker([], R, R).
reverse_worker([X | Xs], T, R) :-
        reverse_worker(Xs, [X | T], R).

read_input(File, N, Cities):-
	open(File, read, Stream),
	read_line_to_codes(Stream, Line),
	atom_codes(Atom, Line),
	atom_number(Atom, N),
	read_line(Stream, Cities).

read_line(Stream, Cities):-
	read_line_to_codes(Stream, Line),
	(Line =[] ->
		Cities = []
	;	atom_codes(Atom, Line),
		atomic_list_concat(Atoms, ' ',Atom),
		maplist(atom_number, Atoms, Cities)).

gcd(X, 0, X).
gcd(0, Y, Y).
gcd(X, Y, G) :- X = Y, G is X, !. 
gcd(X, Y, G) :- X < Y, Y1 is Y mod X, gcd(X, Y1, G), !. 
gcd(X, Y, G) :- X > Y, X1 is X mod Y, gcd(X1, Y, G), !.

lcm(X,Y,LCM):-gcd(X,Y,GCD), LCM is (X//GCD)*Y.

running_sum([], _, []) :- !.
running_sum([X | T], Lcm, [New | N]) :-
	lcm(X, Lcm, New),
	running_sum(T, New, N).

solve(_, [], Min, ThatDay, _, ThatDay, Min):- ! .
solve([X | Xs], [Y | Ys], When, Missing, 0, 0, _) :-
	solve([X | Xs], Ys, When, Missing, 1, 0, Y), !.
solve([X | Xs], [Y | Ys], When, Missing, 1, _, Min) :-
	( Y < Min -> 
		solve([X | Xs], Ys, When, Missing, 2, 1, Y)
	;
	  solve([X | Xs], Ys, When, Missing, 2, 0, Min)
	), ! .
solve([X | Xs], [Y | Ys], When, Missing, Today, ThatDay, Min) :-
	lcm(X, Y, Lcm),
	( Lcm < Min ->
		NewThatDay is Today,
		NewToday is Today + 1,
		solve(Xs, Ys, When, Missing, NewToday, NewThatDay, Lcm)
	;
	  NewToday is Today + 1,
	  solve(Xs, Ys, When, Missing, NewToday, ThatDay, Min)
	), !. 


agora(File, When, Missing):-
	read_input(File, _, Cities),
	running_sum(Cities, 1, L1),
	reverse(Cities, Ls1),
	running_sum(Ls1, 1, Ls2),
	reverse(Ls2, L2),
	solve(L1, L2, When, Missing, 0, _, _).



