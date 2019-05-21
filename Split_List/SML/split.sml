fun split [] index = ([], [])
    |  split lst index =
	let 
		fun foo [] data acc = (rev acc, [])
		  | foo (x::xs) data acc = if x = data then (rev acc, (data::xs)) else foo xs data (x::acc)
	in 
		foo lst index []
	end;
