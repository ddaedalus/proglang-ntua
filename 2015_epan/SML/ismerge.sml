fun merge [] [] [] = true
  | merge [] xs ys = false
  | merge lst xs ys =
	let
		fun foo [] [] [] = true
		  | foo (z::zs) (x::xs) [] = if x <> z then false else foo zs xs []
          | foo (z::zs) [] (y::ys) = if y <> z then false else foo zs [] ys
		  | foo (z::zs) (x::xs) (y::ys) = if (z = x) then foo zs xs (y::ys) else (
										  if (z = y) then foo zs (x::xs) ys else false);
	in
		foo lst xs ys
	end;
