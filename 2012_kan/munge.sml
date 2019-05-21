fun munge f g [] = []
  | munge f g lst =
	let
		fun foo f g [] [] = []
		  | foo f g (x::xs) (y::ys) = ((f x)::(g y)::(foo f g xs ys));
	
	in
		foo f g lst (rev lst)
	end;


