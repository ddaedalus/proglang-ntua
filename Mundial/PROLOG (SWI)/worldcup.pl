/**
 * FIFA WORLD CUP RUSSIA 2018 ?? ------ MUNDIAL SWIPL PROLOG
 * 
 * 
 */


mundial(File, Matches) :-
	read_input(File, Teams),
	/* Len is the number of teams participated in Mundial */
	length(Teams, NumTeams),
	/* Fixtures is the number of matches arranged */
	Fixtures is NumTeams - 1,
	Matches = [match(_, _, _, _) | _],
	/* Fixture Matches Arranged -- Matches a list of fixtures match(_, _, _, _) elements */
	length(Matches, Fixtures),
	(play(Matches, Teams, [])).

/* Begins, Proceeds and Ceases the World Cup */
play([], _, []) . 
play(M, [], Next) :-
	play(M, Next, []).
play([match(Home, Away, Goals1, Goals2) | M], [H | T], Next) :-
	H = team(Name, Matches, For, Against),
	X = team(Name2, Matches2, For2, Against2),

	/* Unify X with the teams qualified in current round */
	member(X, T),
	
	/* Arrange a match */
        ( /* Final Round */
	  Matches =:= 1, Matches2 =:= 1->
                Goals1 is For,
                Goals1 =:= Against2,
                Goals2 is For2,
                Goals2 =:= Against
 	;
	  Matches =:= 1 ->
                Goals1 is For,
                Goals2 is Against
        ; Matches2 =:= 1 ->
                Goals2 is For2,
                Goals1 is Against2
        ;
          between(0, For, Goals1),
          between(0, Against, Goals2)
        ),

	/* Check if this match is valid */	
        Goals1 >= 0,
        Goals2 >= 0,
	/* Not A Draw */
	(Goals1 > Goals2 ; Goals2 > Goals1),
        For2 >= Goals2,
        Against2 >= Goals1,
        Home = Name,
        Away = Name2,
        NG1 is For - Goals1,
        NA1 is Against - Goals2,
        NA2 is Against2 - Goals1,
        NG2 is For2 - Goals2,
	NG1 >= 0,
	NG2 >= 0,
	NA1 >= 0,
	NA2 >= 0,
        NM2 is Matches2 - 1,
        NM1 is Matches - 1,
        NM1 >= 0,
        NM2 >= 0,
	
	select(X, T, NewT),   
	
	( NM1 = 0 -> 
		AwayTeam = team(Name2, NM2, NG2, NA2),
		play(M, NewT, [AwayTeam | Next])
	;
	  NM2 = 0 ->  
		HomeTeam = team(Name, NM1, NG1, NA1),
		play(M, NewT, [HomeTeam | Next])
	).
		

/* Reads from an input text file */
read_input(File, Teams) :-
	open(File, read, Stream),
    	read_line_to_codes(Stream, Line),
    	atom_codes(Atom, Line),
    	atom_number(Atom, N),
    	read_lines(Stream, N, Teams) .


read_lines(_, 0, []) :- ! .   /* cut -- stop backtracking in order to avoid end-of-file error */
read_lines(Stream, N, Teams) :-
	read_line(Stream, Team),
        Nm1 is N-1,
        read_lines(Stream, Nm1, RestTeams),
        Teams = [Team | RestTeams] .


read_line(Stream, team(Name, Matches, For, Against)) :-
    	read_line_to_codes(Stream, Line),
    	atom_codes(Atom, Line),
	atomic_list_concat(Atoms, ' ', Atom),
	[Name | TREST] = Atoms,
	maplist(atom_number, TREST, [Matches | TS]),
	[For | TL] = TS,
	[Against | _ ] = TL .





