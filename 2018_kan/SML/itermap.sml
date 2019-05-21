fun itermap f lst =
	let
		fun foo f [] position counter acc = acc
		  | foo f (y::ys) position 0 acc = 
				foo f ys (position + 1) (position + 1) (y::acc)
		  | foo f (y::ys) position counter acc = 
				foo f ((f y)::ys) position (counter - 1) acc
	in
		rev (foo f lst 0 0 [])
	end
				
