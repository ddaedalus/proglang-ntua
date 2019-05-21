datatype 'a tree = node of 'a * 'a tree * 'a tree | empty

fun size empty = 0
  | size (node (_, left, right))  =
	  size left + size right + 1;


fun unBal empty = 0
  | unBal (node (_ : int, left, right)) =
	let
		val lsize = size left 
		val rsize = size right
		val index = if rsize = lsize then 0 else 1
		val r = unBal right 
		val l = unBal left
	in
		index + r + l
	end; 	


