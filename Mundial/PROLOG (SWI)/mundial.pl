mundial(File, Matches) :-
	read_input(File, Countries),
	length(Countries, Size),
	Agones is Size - 1,
	Games = [match(_, _, _, _) | _],
	Matches = [match(_, _, _, _) | _],
	length(Matches, Agones),
	length(Games, Agones),
	once(unify_result(Games, Countries, Matches)).


unify_result(Matches, Countries, Answer) :-
	solve(Matches, Countries, [], Answer).
	

solve([], _, [], Answer) :-
	Answer = []. 
solve(LeftMatches, [], Qualified, Answer) :-
	solve(LeftMatches, Qualified, [], Answer).
solve([match(Name1, Name2, Goals1, Goals2) | LeftMatches], [First | Rest], Qualified, [Head | Answer]) :-
	Agonas = match(Name1, Name2, Goals1, Goals2),
	First = country(Country1, Matches1, Scored1, Conceded1),
	Rival = country(Country2, Matches2, Scored2, Conceded2),
	select(Rival, Rest, Remainders),
	( Matches2 =:= 1, Matches1 =:= 1->
                Goals2 is Scored2,
                Goals2 =:= Conceded1,
                Goals1 is Scored1,
                Goals1 =:= Conceded2
 	; Matches1 =:= 1 ->
                Goals1 is Scored1,
                Goals2 is Conceded1
        ; Matches2 =:= 1 ->
                Goals2 is Scored2,
                Goals1 is Conceded2
        ; between(0, Scored1, Goals1),
          between(0, Conceded1, Goals2)
        ),
	is_valid(Agonas, First, Rival),
	/* If is valid then proceed */
        LeftScored1 is Scored1 - Goals1,
        LeftConceded1 is Conceded1 - Goals2,
	LeftScored2 is Scored2 - Goals2,
        LeftConceded2 is Conceded2 - Goals1,
	LeftMatches1 is Matches1 - 1,
        LeftMatches2 is Matches2 - 1,
	/* Unify Answer */
	Head = Agonas,
	( LeftMatches2 = 0 ->  
		solve(LeftMatches, Remainders, [country(Country1, LeftMatches1, LeftScored1, LeftConceded1) | Qualified], Answer) 
	; LeftMatches1 = 0 -> 
		solve(LeftMatches, Remainders, [country(Country2, LeftMatches2, LeftScored2, LeftConceded2) | Qualified], Answer)
	).
		

is_valid(match(Name1,Name2,Goals1,Goals2),country(Country1,Matches1,Scored1,Conceded1),country(Country2,Matches2,Scored2,Conceded2)) :-
        Name1 = Country1,
        Name2 = Country2,
	Temp1 = Goals2 - Goals1,
	Temp2 = Goals1 - Goals2,
	(Temp1 > 0 ; Temp2 > 0),
        Scored2 >= Goals2,
        Conceded2 >= Goals1,
        LeftScored1 is Scored1 - Goals1,
        LeftConceded1 is Conceded1 - Goals2,
	LeftScored2 is Scored2 - Goals2,
        LeftConceded2 is Conceded2 - Goals1,
	LeftScored1 >= 0,
	LeftScored2 >= 0,
	LeftConceded1 >= 0,
	LeftConceded2 >= 0,
	LeftMatches1 is Matches1 - 1,
        LeftMatches2 is Matches2 - 1,
        LeftMatches1 >= 0,
        LeftMatches2 >= 0.	

read_input(File, Countries) :-
	open(File, read, Stream),
    	read_line_to_codes(Stream, Line),
    	atom_codes(Atom, Line),
    	atom_number(Atom, N),
    	read_lines(Stream, N, Countries) .


read_lines(_, 0, []) :- !.   
read_lines(Stream, N, Countries) :-
	read_line(Stream, Country),
        N1 is N-1,
        read_lines(Stream, N1, Rest),
        Countries = [Country | Rest].


read_line(Stream, country(Country, Matches, Scored, Conceded)) :-
    	read_line_to_codes(Stream, Line),
    	atom_codes(Atom, Line),
	atomic_list_concat(Atoms, ' ', Atom),
	[Country | Rest] = Atoms,
	maplist(atom_number, Rest, [Matches | Tail]),
	[Scored | NewTail] = Tail,
	[Conceded | _ ] = NewTail.





