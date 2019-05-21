datatype heap = empty | node of int * heap * heap


fun isHeap empty = true
  | isHeap (node (index, empty, empty)) = true
  | isHeap (node (index, empty, node (k, left, right))) =
	if (k <= index) then false else isHeap left andalso isHeap right
  | isHeap (node (index, node (k, left, right), empty)) =
	if (k <= index) then false else isHeap left andalso isHeap right
  | isHeap (node (index, node (m, l1, r1), node (n, l2, r2))) =
	if (m <= index orelse n <= index) then false
	else isHeap l1 andalso isHeap r1 andalso isHeap l2 andalso isHeap r2;
