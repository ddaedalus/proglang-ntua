(* :set ts=4 sw=4 *)

(* Pistes Standard ML Of New Jersey *)

(* Useful functions used *)  


fun find_list_max [] max = max
  | find_list_max (xs:int list) max = 
	if (hd xs) > max then find_list_max (tl xs) (hd xs)
	else find_list_max (tl xs) max; 

fun print_list [] = print ("Empty  ")
  | print_list (xs:int list) =
	let
		val x = print (Int.toString (hd xs) ^ "  ")
	in
		print_list (tl xs)
	end;


fun get_num (round:(int * int * int list * int list * int * int)) =
	#1 (round);

fun lock (round:(int * int * int list * int list * int * int)) =
    #3 (round);

fun unlock (round:(int * int * int list * int list * int * int)) =
    #4 (round);

fun n_lock (round:(int * int * int list * int list * int * int)) =
    #5 (round);

fun n_unlock (round:(int * int * int list * int list * int * int)) = 
    #6 (round);

fun head_lock (round:(int * int * int list * int list * int * int)) =
	hd (#3 (round));

fun head_unlock (round:(int * int * int list * int list * int * int)) =
    hd (#4 (round));

fun get_stars (round:(int * int * int list * int list * int * int)) =
	#2 (round);

fun find_max (a, b) =
	if (a >= b) then a
	else b;



(* Deletes element from list l one time if exists and returns the new list *)
(* Yes, I want the polyequal type ''a *)
fun delete (element, l) = 	
	case l of
	[] => []
		| xs :: ys => if element = xs then ys
					else xs :: delete (element, ys);


(* Give (Element, List, 0, Size) --> Select Prolog *)
(* Yes, I want the polyequal type ''a *)
fun select (x, xs, i, max) = if i = max then (false, xs)
					    	 else if (x <> (List.nth (xs, i))) then select (x, xs, (i+1), max)
				             else (
							 	    if i = 0 then (true, tl xs)
									else if i = max-1 then (true, (List.take(xs, i)))
									else (true, (List.take(xs, i) @ List.drop(xs, i+1)))
							 );


(* Reverse a' list -> a' list *)
fun reverse xc =
 	let
		fun rev (nil, z) = z
		  | rev (y :: yc, z) = rev (yc, y :: z)
	
	in 
       	       	rev (xc, nil)

	end;

(* Type: string -> (int * int * int list * int list) list *)
fun pistes file =
	let
		(* Reads an integer from input *)
		fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input);

		(* Opens input *)
		val inStream = TextIO.openIn file

		(* Reads an integer and consume newline -- number is the number of rounds *)
		val n = readInt inStream
		val number = n + 1
		val _ = TextIO.inputLine inStream		

		(* Reads N integers from the open file and put them in acc *)
		fun readInts 0 acc = acc
	  	  | readInts i acc = readInts (i - 1) ((readInt inStream) :: acc);

		(* Makes a list of rounds that needs to be reversed *)
		fun readRounds 0 acc n = acc
		  | readRounds i acc n = 
			let
				val num = n + 1 - i 
				val n_lock = readInt inStream
				val n_unlock  = readInt inStream
				val stars = readInt inStream
				val lock = readInts n_lock []
				val unlock = readInts n_unlock []
				
				(* Consume new line *)
				val _ = TextIO.inputLine inStream	
	
				(* round(int * int * int list * int list * int * int) *)
				val round = (num, stars, lock, unlock, n_lock, n_unlock)

			in 
				readRounds (i - 1) (round :: acc) n
			end;

		(* list of all rounds, order by num *)
		val pistes =  reverse (readRounds number [] number)

		(* Checks if one round can unlock another *)
		(* Type:
		 * int list -> int list -> int -> int -> int -> int -> int -> int -----  -> int list * int * int  
		 * Returns a tuple consisted of --- (New Unlock Keys, New Stars, Num)
		 *)
		fun unlock_round (unlock:int list) [] (his:int list) (unlock_keys:int) (stars:int) (stars2:int) (old_keys:int list) (num:int) (num2:int) =
			let
				val new_stars = stars + stars2
			in
				((List.concat [unlock, his]), new_stars, num2, true)
			end
	 	  | unlock_round (unlock:int list) (lock:int list) (his:int list) (unlock_keys:int) (stars:int) (stars2:int) (old_keys:int list) (num:int) (num2:int) =
			let 
				val (flag, new) = select(hd lock, unlock, 0, unlock_keys)

			in 
				if (flag = false) then (old_keys, stars, num, false)
				else unlock_round new (tl lock) his (unlock_keys-1)  stars stars2 old_keys num num2
			end					

		(* Pistes minus First Round  --  rest_rounds  *)
		val rest_rounds = tl pistes 

		(* Find the size of rest_rounds *)
		val size = number - 1

		(* Find the first round *)
	    val first = hd pistes

		(* Find the stars of first round *)
		val first_stars = get_stars first


		fun play (fathers:(((int * int * int list * int list * int * int) list)list)) (acc:(int * int * int list * int list * int * int) list) (round:(int * int * int list * int list * int * int)) (racc:(((int * int * int list * int list * int * int) list)list)) [] (final:int list) (counter:int) = 			  
		
			if ((((hd racc)) = []) andalso (get_num (hd acc) = 1)) then final
	     	else play (tl fathers) (tl acc) (hd (tl acc)) (tl racc) (hd (tl racc)) (final:int list) 0

		  | play (fathers:(((int * int * int list * int list * int * int) list)list)) (acc:(int * int * int list * int list * int * int) list) (round:(int * int * int list * int list * int * int)) (racc:(((int * int * int list * int list * int * int) list) list)) (rounds:(int * int * int list * int list * int * int) list) (final:int list) (counter:int) =

			let 			
				(* Checks for unlock_round *)		
				val (keys:int list, new_stars, num, flag) = unlock_round (unlock round) (lock (hd rounds)) (unlock (hd rounds)) (n_unlock round) (get_stars round) (get_stars (hd rounds)) (unlock round) (get_num round) (get_num (hd rounds))
				
				val new_round = (num, new_stars, (lock (hd rounds)), keys, (n_lock (hd rounds)), (length keys))			
				val checked = (hd rounds)   
				val new_pistes = delete (checked, (hd fathers))

				val new_prev = delete (checked, (hd racc))
			in	
				if flag = true then play (new_pistes::fathers) (new_round::acc) new_round (new_pistes::new_prev::(tl racc)) new_pistes (new_stars :: final) 0
				else (
					if counter > (length (hd fathers)) then 
						play fathers acc round ((delete (checked, (hd fathers))) :: racc) (delete (checked, (hd fathers))) final 0
					else play fathers acc round ((delete (checked, (hd racc))) :: (tl racc)) (delete (checked, (hd racc))) (new_stars :: final) (counter + 1)
				)

			end;
	
			val the_game = play [rest_rounds] [first] first [rest_rounds] rest_rounds [first_stars] 0
	in 
		print (Int.toString (find_list_max the_game 0) ^ "\n")

	end




















