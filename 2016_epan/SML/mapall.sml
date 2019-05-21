fun kart init [] _ = []
  | kart init (y::ys) [] = kart init ys init
  | kart init (y::ys) (x::xs) = ((y, x) :: (kart init (y::ys) xs))

fun mapall f [] = []
  | mapall f lst =
	let 
		val cart = kart lst lst lst 
		fun foo f [] = []
		  | foo f ((x, y)::xs) = ((f (x, y)) :: (foo f xs))
	in
		foo f cart
	end
