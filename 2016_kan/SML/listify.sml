fun reverse (xs : int list list) =
	let
	 	fun rev ([], z) = z
		  | rev (y :: ys, z) = rev (ys, y :: z)
	in
		rev (xs, [])
	end;

fun listify (list : int list) =
	let
		fun listing [] (acc : int list list) temp = acc
		  | listing l [] 0 = listing (tl l) [[hd l]] (hd l)
		  | listing l (acc : int list list) temp =
			if (hd l) >= temp then listing (tl l) (((hd acc) @ [hd l]) :: (tl acc)) (hd l)
			else listing (tl l) ([hd l] :: acc) (hd l);
	in
		reverse (listing list [] 0)
	end;
