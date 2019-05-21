fun gcd (a:IntInf.int) (b:IntInf.int) =
	if a > 0 andalso b > 0 then
		if a > b then gcd (#2 (IntInf.divMod (a, b))) b
		else gcd a (#2 (IntInf.divMod (b, a)))
	else ((a + b) : IntInf.int);
			
fun lcm (a:IntInf.int) (b:IntInf.int) =
	(#1 (IntInf.divMod (a, gcd a b))) *  b;


fun reverse xc =
 	let
		fun rev (nil, z) = z
		  | rev (y :: yc, z) = rev (yc, y :: z)
	
	in 
       	       	rev (xc, nil)

	end;
	

fun agora file =
	let
		(* read an integer from input *)
		fun readInt input =
				Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input);

		(* open input *)
		val inStream = TextIO.openIn file
	
		(* read an integer and consume newline *)
		val size = readInt inStream
		val _ = TextIO.inputLine inStream

		(* read size integers from the open file *)
		fun readInts 0 acc = acc
	  	  | readInts i acc = readInts (i - 1) ((readInt inStream) :: acc);

		(* int list -> IntInf.int list -> IntInf.int list *)
		fun toInf [] acc = acc 
	          | toInf l acc  =  toInf (tl l) (Int.toLarge (hd l) :: acc)

		(* in order to avoid Uncaught Exception Option, when using market *)
		val user = readInts size [];  
                val inf = toInf user [];

		(* find left - find right using reverse left reverse *)
		fun left l 1 acc = (lcm (hd l) (hd acc)) :: acc
		  | left l n acc = if length l = size 
					then left (tl l) (n - 1) (hd l :: acc)
				   else 
					left (tl l) (n - 1) (lcm (hd l) (hd acc) :: acc);

		fun market (xs:IntInf.int list) (ys:IntInf.int list) 1 acc = (hd xs) :: acc
		  | market (xs:IntInf.int list) (ys:IntInf.int list) n acc = if n = size 
								             	   then market xs (tl ys) (n - 1) ((hd (tl ys)) :: acc)
					 			             else
										   market (tl xs) (tl ys) (n - 1) ((lcm (hd (tl ys)) (hd xs)) :: acc);  
		
		fun find [] acc start  = ()			
		  | find [x:IntInf.int] acc start = if length acc = 1 
						    	then print (IntInf.toString x ^ " " ^ Int.toString 0 ^ "\n") 
				         	    else
				                        print (IntInf.toString x ^ " " ^ Int.toString (hd acc) ^ "\n")
		  | find ((x:IntInf.int) :: (y:IntInf.int) :: (xs:IntInf.int list)) acc start = if x < y
					            							then find (x :: xs) (acc) (start + 1) 
			                       	   						else if x > y  
						    							then find (y :: xs) ((start + 1) :: acc) (start + 1)  		   
				                   					        else		 
				               	  						  	find (x :: xs) acc (start + 1) 

	in
		(*left (user) size [] 
		reverse (left (reverse (user)) size []) *)
		(*market (reverse (left (reverse (user)) size [])) (left (user) size []) size [] *)
		find (market (reverse (left (reverse inf) size [])) (left inf size []) size []) [1] 1 
	
	end;