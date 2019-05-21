fun isMerge xs ys zs = 
	let
		
		fun merge [] [] [] 1 = true
		  | merge [] _ _ 0 = false	
		  | merge (x :: xs) (y :: ys) zs 0 =
			if (x = y andalso ys <> []) then merge xs ys zs 0
			else if (x = y andalso null ys) then merge xs [] zs 1
			else false
		  | merge (x :: xs) [] (z :: zs) 1 = 
			if (x = z andalso zs <> []) then merge xs [] zs 1
			else if (x = z andalso zs = [] andalso xs = []) then true
			else false
	in
		merge xs ys zs 0
	end; 
