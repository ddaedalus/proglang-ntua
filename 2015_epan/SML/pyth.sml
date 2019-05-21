fun power (x, 0) = 1
  | power (x, n) = x * power (x, n - 1);


fun pyth (l : int list) = 
	let
		fun sq [] acc = acc
		  | sq (l : int list) acc =
			sq (tl l) ((power ((hd l), 2)) :: acc);
	
		val squ = sq l []
		
			
	in squ
		 		
	end;
