fun inc [] = []
  | inc lst = 
	let
		fun foo [] ys = ys
		  | foo (x::xs) [] = foo xs [[x]]
		  | foo (x::xs) (y::ys) = 
				if (x = (hd y + 1)) then foo xs ((x::y)::ys)
				else foo xs ([x]::y::ys);
		
		val mylist = foo lst []
	in
		rev (map rev mylist)
	end;
