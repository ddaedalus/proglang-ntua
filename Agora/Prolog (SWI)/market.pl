/*
 * Reverse by StackOverflow
 */
reverse(Xs, Ys) :-
        reverse_worker(Xs, [], Ys).

reverse_worker([], R, R).
reverse_worker([X | Xs], T, R) :-
        reverse_worker(Xs, [X | T], R).



/*
 * When is the time result
   Missing is the missing day result if it exists
   File is the argument file '_.txt'
 */
agora(File, When, Missing) :-

	/* Read from the argument file */
	read_input(File, N, Days),

	/* Make the right increasing list  -- Right */
	make_right(Days, [], Right, 1),

	/* In order to make left increasing list, we should reverse Days, use make_right and again reverse  -- Left */
	reverse(Days, ReverseDays),
	make_right(ReverseDays, [], Temp, 1),
	reverse(Temp, Left),
	
	/* Find total lcm of all days -- TotalLcm */
	[TotalLcm | _ ] = Left,

	find_best(Right, Left, TotalLcm, 0, When, Missing, 1, N).

	
/*
 * Finds the gcd of A, B and the result is Gcd
 */
gcd(A, B, Gcd) :-
	( A > 0, B > 0 -> 
		( A >= B ->
			NewA is A mod B,
			gcd(NewA, B, Gcd)
		; A < B ->
			NewB is B mod A,
			gcd(A, NewB, Gcd)
		)
	; A =:= 0 ->
		Gcd is B 
	;
	  B =:= 0 ->
		Gcd is A
	).


/*
 * Finds the lcm of A, B and the result is Lcm
 */			
lcm(A, B, Lcm) :-
	gcd(A, B, Gcd),
	Lcm is (A / Gcd) * B.



/* 
 * Reads from argument file given
 */
read_input(File, N, Days) :-
	open(File, read, Stream),
	read_line_to_codes(Stream, Line),
	atom_codes(Atom, Line),
	/* # Set N days */
	atom_number(Atom, N), 
	read_line(Stream, Days).


/* 
 * Reads a line and stores the numbers as elements in list Days
 */
read_line(Stream, List) :-
	read_line_to_codes(Stream, Line),
	( Line = [] -> 
		List = []
	;
	  atom_codes(A, Line),
	  atomic_list_concat(As, ' ', A),
	  maplist(atom_number, As, List)
	).


add_to_list([], _, Temp, L) :- 
	L = Temp.
add_to_list(List, Element, _, L) :-
	add_to_list([], Element, [Element | List], L).
	


/*
 * Make the right increasing list of elements that contain lcm
 */
make_right([], TempRight, Right, _) :-
	reverse(TempRight, TempR),
	Right = TempR.
make_right([Head | Rest], TempRight, Right, Lcm) :-
	lcm(Head, Lcm, NewLcm),
	( TempRight = [] -> 
		 make_right(Rest, [NewLcm], Right, NewLcm)
	;	
	  make_right(Rest, [NewLcm | TempRight], Right, NewLcm)
	).
	

/* 
 * Finds the solution -- When, Missing
 */
find_best([HeadR | R], [FirstL | L], CurrentLcm, DeleteDay, When, Missing, CurrentDay, N) :-
	( CurrentDay > N ->
		When = CurrentLcm,
		Missing is DeleteDay
	;
	  CurrentDay =:= 1 -> 
			[SecondL | Tail] = L,
	   		( CurrentLcm > SecondL ->
				find_best([HeadR | R], Tail, SecondL, 1, When, Missing, 2, N)
			;
			  find_best([HeadR | R], Tail, CurrentLcm, DeleteDay, When, Missing, 2, N)
			)
	;
	  CurrentDay =:= N ->
			( CurrentLcm > HeadR ->
				find_best([32, 32], [32, 32, 32], HeadR, N, When, Missing, N + 1, N)
			;
			   find_best([32,32], [32, 32, 32], CurrentLcm, DeleteDay, When, Missing, N + 1, N)
			)
	;
	  lcm(FirstL, HeadR, Lcm),
	  ( CurrentLcm > Lcm ->
		( CurrentDay < N-1 ->
			NewDay is CurrentDay + 1,
			NewDelete is CurrentDay,
			find_best(R, L, Lcm, NewDelete, When, Missing, NewDay, N)
		;
		   find_best(R, [32, 32, 32], Lcm, CurrentDay, When, Missing, N, N)
		)
	  ; 
	    ( CurrentDay < N-1 ->
		   NewDay is CurrentDay + 1, 
	      	   find_best(R, L, CurrentLcm, DeleteDay, When, Missing, NewDay, N) 
	    ;
	       find_best(R, [32, 32, 32], CurrentLcm, DeleteDay, When, Missing, N, N)
	    )
	  )
        ).
	











				
				







		



	
