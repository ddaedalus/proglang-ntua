fun mangle (f, g, []) = []
  | mangle (f, g, lst) =
	let
		fun foo f g [] position counter acc = rev acc
		  | foo f g (x::xs) position 0 acc = 
				foo f g xs (position + 1) (position + 1) (x::acc)
		  | foo f g (x::xs) position counter acc =
				if (position mod 2 = 1) then foo f g ((f x)::xs) position (counter - 1) acc
				else foo f g ((g x)::xs) position (counter - 1) acc
	in
		foo f g lst 1 1 []
	end
