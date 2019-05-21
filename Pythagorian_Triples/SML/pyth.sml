fun pyth [] = []
  | pyth lst = 
	let
		fun comb [] xs = []
		  | comb (y::k::ks) [] = comb (k::ks) ks
		  | comb (y::ys) [] = comb [] []
		  | comb (y::ys) (x::xs) = ((y, x) :: (comb (y::ys) xs));

		val tuples = comb lst []
		
		fun foo (k::init) [] initcomb = foo init initcomb initcomb
		  | foo [] combin initcomb = []
		  | foo (k::init) ((x, y)::combin) initcomb = 
			if (k*k) = (x*x + y*y) then ((x, y, k) :: (foo (k::init) combin initcomb))
			else foo  (k::init) combin initcomb
	in
		foo lst tuples tuples
	end;

