fun add42 x = x + 42;

fun comp F G = let fun C x = G (F x) in C end;

fun compA42 x = comp add42 x;

val foo = compA42 add42;

fun compCompA42 x = comp compA42 x;
