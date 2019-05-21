fun prefix [] = []
  | prefix lst =
	let
		fun foo [] sum = []
		  | foo (x::xs) sum = ((x+sum)::(foo xs (x+sum)))
	in
		foo lst 0
	end;
