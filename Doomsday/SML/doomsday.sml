fun doomsday file =
    let
        fun next_String input = (TextIO.inputAll input) ;
        val stream = TextIO.openIn file
    
        (* user is list using explode *)
        val a = next_String stream   
        val user = explode (a);
        
        (* " #1 (r, c) -> r, #2 (r, c) / r -> c " *)
        fun search [] r c = (42, 17)                               (* exhaustive *)       
	      | search [#"\n"] (r:int) (c:int) = (r, c)
	    (* at least 3 elements *)	 
          | search ((x:char) :: (y:char) :: (ys:char list)) (r:int) (c:int) =
	        if (x = (#"\n")) then search (y :: ys) (r + 1) c
            else search (y :: ys) r (c + 1)
	    (* 2 elements *)
	      | search ((y:char) :: (ys:char list)) r c = search [#"\n"] r (c + 1) ;
      
	    val seek = search user 1 0  
        
        (* define and initialize array *)
        val arr = Array2.array ((#1 seek ), floor (real ((#2 seek)) / (real (#1 seek ))), (#"V"))
        
        (* update and finalize starting grid *)
        fun readList [] i j () = ()                       (* exhaustive *) 
          | readList [#"\n"] i j () = ()          (* print (Char.toString (Array2.sub (arr, 0, 4))) *)
	    (* at least 3 elements *)
	      | readList ((x:char) :: (y:char) :: (ys:char list)) i j () = 
	        if x = (#"\n") then readList (y :: ys) (i + 1) 0 ()
	        else readList (y :: ys) i (j + 1) (Array2.update (arr, i, j, x))
	    (* 2 elements *)
          | readList ((x:char) :: (xs:char list)) i j () = readList [#"\n"] (i + 1) 0 (Array2.update (arr, i, j, x)) ; 
        
        val n = #1 (Array2.dimensions (arr))
        val m = #2 (Array2.dimensions (arr))
        
        (* make a new queue, empty for the time being *)
        val qu = Queue.mkQueue () : (int * int * int * char) Queue.queue
        val tmp = Queue.mkQueue () : (int * int * int * char) Queue.queue
        
        (* set correctly the initial tuples of qu *)
	    fun browse i j 1 () = browse i j 0 (readList user 0 0 ())
	      | browse i j 0 () = 
	        if j = m then browse (i + 1) 0 0 ()
	        else if i = n then
			(if ((Queue.isEmpty qu) = true) then (42, 42, 42, (#"+"))
			 else Queue.head qu) 
	        else if Array2.sub (arr, i, j) = (#"+") then browse i (j + 1) 0 (Queue.enqueue (qu, (i, j, 0, (#"+"))))
            else if Array2.sub (arr, i, j) = (#"-") then browse i (j + 1) 0 (Queue.enqueue (qu, (i, j, 0, (#"-"))))
            else browse i (j + 1) 0 () 
          | browse _ _ _ () = Queue.head qu ;
        
	(* fun oura () (tmp : int * int * int * char) = 
	    if (Queue.isEmpty qu) = true then ()
	    else oura (print (Char.toString(#4 (Queue.head qu)))) (Queue.dequeue qu); *)
	
   
        (* init = head of qu *)  
        val init = browse 0 0 1 (readList user 0 0 ())
	(* val check = oura () init *)
        
        (* Print all elements of a 2D Array *)
        fun toPrint 4217 4217 () = print ("\n")
          | toPrint i j () = 
            if ((j < m - 1) andalso (i < n - 1)) then toPrint i (j + 1) (print (Char.toString (Array2.sub (arr, i, j))))
            else if ((j = m - 1) andalso (i < n - 1)) then toPrint (i + 1) 0 (print (Char.toString (Array2.sub (arr, i, j)) ^ "\n"))
            else if ((j < m - 1) andalso (i = n - 1)) then toPrint i (j + 1) (print (Char.toString (Array2.sub (arr, i, j))))
            else toPrint 4217 4217 (print (Char.toString (Array2.sub (arr, i, j)))) ;
        
        fun game 42 0 2 (pre : int * int * int * char) () (tmp : int * int * int * char) () = game 0 0 0 init () (42, 42, 42, (#"k")) ()
          | game 42 t 42 (pre : int * int * int * char) () (tmp : int * int * int * char) () = toPrint 0 0 (print (Int.toString (t) ^ "\n"))
          | game 0 t 0 (pre : int * int * int * char) () (tmp : int * int * int * char) () = 
            if ((Queue.isEmpty qu = false) andalso ((#4 (Queue.head qu)) = (#"+"))) then 
                (if (#2 (Queue.head qu)) < (m - 1) then 
                    (if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1) = (#".")) then 
                     game 1 t 0 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu) + 1), (#"+"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1, (t + 1), (#"+"))))
                     else if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1) = (#"-")) then 
                     game 1 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu) + 1), (#"*"))) (Queue.head qu) () 
                     else game 1 t 0 (Queue.head qu) () (Queue.head qu) () )
                else
                    game 1 t 0 (Queue.head qu) () (Queue.head qu) () )
            else if((Queue.isEmpty qu = false) andalso ((#4 (Queue.head qu)) = (#"-"))) then
                (if (#2 (Queue.head qu)) < (m - 1) then 
                    (if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1) = (#".")) then
                     game 1 t 0 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu) + 1), (#"-"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1, (t + 1), (#"-"))))
                     else if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1) = (#"+")) then
                     game 1 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu) + 1), (#"*"))) (Queue.head qu) () 
                     else game 1 t 0 (Queue.head qu) () (Queue.head qu) () )
                 else
                     game 1 t 0 (Queue.head qu) () (Queue.head qu) () )
            else toPrint 0 0 (print ("the world is saved" ^ "\n"))
          | game 1 t 0 (pre : int * int * int * char) () (tmp : int * int * int * char) () = 
            if (#4 (Queue.head qu)) = (#"+") then
                (if (#2 (Queue.head qu)) > 0 then
                    (if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1) = (#".")) then   
                     game 2 t 0 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu) - 1), (#"+"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1, (t + 1), (#"+")))) 
                     else if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1) = (#"-")) then
                     game 2 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu) - 1), (#"*"))) (Queue.head qu) ()
                     else game 2 t 0 (Queue.head qu) () (Queue.head qu) () )
                else
                    game 2 t 0 (Queue.head qu) () (Queue.head qu) () )
            else if (#4 (Queue.head qu)) = (#"-") then
                (if (#2 (Queue.head qu)) > 0 then 
                    (if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1) = (#".")) then
                     game 2 t 0 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu) - 1), (#"-"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1, (t + 1), (#"-"))))
                     else if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1) = (#"+")) then
                     game 2 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu) - 1), (#"*"))) (Queue.head qu) ()
                     else game 2 t 0 (Queue.head qu) () (Queue.head qu) () )
                 else
                     game 2 t 0 (Queue.head qu) () (Queue.head qu) () )
            else game 42 42 42 (42, 42, 42, (#"a")) () (Queue.head qu) ()
          | game 2 t 0 (pre : int * int * int * char) () (tmp : int * int * int * char) () =
            if (#4 (Queue.head qu)) = (#"+") then
                (if (#1 (Queue.head qu)) > 0 then
                    (if (Array2.sub (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu))) = (#".")) then
                     game 3 t 0 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu)), (#"+"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (Queue.head qu)) - 1, (#2 (Queue.head qu)), (t + 1), (#"+"))))
                     else if (Array2.sub (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu))) = (#"-")) then
                     game 3 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu)), (#"*"))) (Queue.head qu) ()
                     else game 3 t 0 (Queue.head qu) () (Queue.head qu) () )
                else
                    game 3 t 0 (Queue.head qu) () (Queue.head qu) () )
            else if (#4 (Queue.head qu)) = (#"-") then
                (if (#1 (Queue.head qu)) > 0 then
                    (if (Array2.sub (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu))) = (#".")) then
                     game 3 t 0 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu)), (#"-"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (Queue.head qu)) - 1, (#2 (Queue.head qu)), (t + 1), (#"-"))))
                     else if (Array2.sub (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu))) = (#"+")) then
                     game 3 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu)), (#"*"))) (Queue.head qu) ()
                     else game 3 t 0 (Queue.head qu) () (Queue.head qu) () )
                else
                    game 3 t 0 (Queue.head qu) () (Queue.head qu) () )
            else game 42 42 42 (42, 42, 42, (#"a")) () (Queue.head qu) ()
          | game 3 t 0 (pre : int * int * int * char) () (tmp : int * int * int * char) () = 
            if (#4 (Queue.head qu)) = (#"+") then
                (if (#1 (Queue.head qu)) < (n - 1) then
                    (if (Array2.sub (arr, (#1 (Queue.head qu)) + 1, (#2 (Queue.head qu))) = (#".")) then
                        (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then (*sas gamaei o pipo *)
                         game 0 t 0 (Queue.head qu) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"+"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (pre)) + 1, (#2 (pre)), (t + 1), (#"+"))))
                        else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 0 (t + 1) 0 (Queue.head qu) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"+"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (pre)) + 1, (#2 (pre)), (t + 1), (#"+"))))
                        else toPrint 0 0 (print ("the world is saved" ^ "\n")))
                    else if (Array2.sub (arr, (#1 (Queue.head qu)) + 1, (#2 (Queue.head qu))) = (#"-")) then
                        (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                         game 0 t 1 (Queue.head qu) (Array2.update (arr, (#1 (pre)) + 1, (#2 (pre)), (#"*"))) (Queue.head qu) ()
                        else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 0 (t + 1) 1 (Queue.head qu) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"*"))) (Queue.head qu) ()
                        else toPrint 0 0 (print ("the world is saved" ^ "\n")))
                    else 
                        (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                         game 0 t 0 (Queue.head qu) () (Queue.head qu) ()
                        else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 0 (t + 1) 0 (Queue.head qu) () (Queue.head qu) ()
                        else toPrint 0 0 (print ("the world is saved" ^ "\n")) ) )
                else 
                    (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                        game 0 t 0 (Queue.head qu) () (Queue.head qu) ()
                    else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 0 (t + 1) 0 (Queue.head qu) () (Queue.head qu) ()
                    else toPrint 0 0 (print ("the world is saved" ^ "\n")) ) )
            else if ((#4 (Queue.head qu)) = (#"-")) then   
                (if (#1 (Queue.head qu)) < (n - 1) then
                    (if (Array2.sub (arr, (#1 (Queue.head qu)) + 1, (#2 (Queue.head qu))) = (#".")) then
                        (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                         game 0 t 0 (Queue.head qu) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"-"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (pre)) + 1, (#2 (pre)), (t + 1), (#"-"))))
                        else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 0 (t + 1) 0 (Queue.head qu) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"-"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (pre)) + 1, (#2 (pre)), (t + 1), (#"-"))))
                        else toPrint 0 0 (print ("the world is saved" ^ "\n")) )
                    else if (Array2.sub (arr, (#1 (Queue.head qu)) + 1, (#2 (Queue.head qu))) = (#"+")) then
                        (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                         game 0 t 1 (Queue.head qu) (Array2.update (arr, (#1 (pre)) + 1, (#2 (pre)), (#"*"))) (Queue.head qu) ()
                        else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 0 (t + 1) 1 (Queue.head qu) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"*"))) (Queue.head qu) ()
                        else toPrint 0 0 (print ("the world is saved" ^ "\n")) )
                    else
                        (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                         game 0 t 0 (Queue.head qu) () (Queue.head qu) ()
                        else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 0 (t + 1) 0 (Queue.head qu) () (Queue.head qu) ()
                        else toPrint 0 0 (print ("the world is saved" ^ "\n")) ) )
                else 
                    (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                        game 0 t 0 (Queue.head qu) () (Queue.head qu) ()
                    else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 0 (t + 1) 0 (Queue.head qu) () (Queue.head qu) ()
                    else toPrint 0 0 (print ("the world is saved" ^ "\n")) ) )
            else game 42 42 42 (42, 42, 42, (#"a")) () (Queue.head qu) ()
          | game 0 t 1 (pre : int * int * int * char) () (tmp : int * int * int * char) () = 
            if (((#4 (Queue.head qu)) = (#"+"))) then 
                (if (#2 (Queue.head qu)) < (m - 1) then
                    (if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1) = (#".")) then
                     game 1 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1, (#"+"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (Queue.head qu)), (#2 ((Queue.head qu))) + 1, (t + 1), (#"+"))))
                     else if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1) = (#"-")) then 
                     game 1 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu) + 1), (#"*"))) (Queue.head qu) () 
                     else game 1 t 1 (Queue.head qu) () (Queue.head qu) () )
                else
                    game 1 t 1 (Queue.head qu) () (Queue.head qu) () )
            else if(((#4 (Queue.head qu)) = (#"-"))) then
                (if (#2 (Queue.head qu)) < (m - 1) then 
                    (if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1) = (#".")) then
                     game 1 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1, (#"-"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1, (t + 1), (#"-"))))
                     else if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) + 1) = (#"+")) then
                     game 1 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu) + 1), (#"*"))) (Queue.head qu) () 
                     else game 1 t 1 (Queue.head qu) () (Queue.head qu) () )
                 else
                     game 1 t 1 (Queue.head qu) () (Queue.head qu) () )
            else toPrint 0 0 (print ("the world is saved" ^ "\n"))                                        (* sas agapaw ma den pantreuomai *)
          | game 1 t 1 (pre : int * int * int * char) () (tmp : int * int * int * char) () = 
            if (#4 (Queue.head qu)) = (#"+") then
                (if (#2 (Queue.head qu)) > 0 then
                    (if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1) = (#".")) then   
                     game 2 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1, (#"+"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1, (t + 1), (#"+"))))  
                     else if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1) = (#"-")) then
                     game 2 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu) - 1), (#"*"))) (Queue.head qu) ()
                     else game 2 t 1 (Queue.head qu) () (Queue.head qu) () )
                else
                    game 2 t 1 (Queue.head qu) () (Queue.head qu) () )
            else if (#4 (Queue.head qu)) = (#"-") then
                (if (#2 (Queue.head qu)) > 0 then 
                    (if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1) = (#".")) then
                     game 2 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1, (#"-"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1, (t + 1), (#"-"))))
                     else if (Array2.sub (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu)) - 1) = (#"+")) then
                     game 2 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)), (#2 (Queue.head qu) - 1), (#"*"))) (Queue.head qu) ()
                     else game 2 t 1 (Queue.head qu) () (Queue.head qu) () )
                 else
                     game 2 t 1 (Queue.head qu) () (Queue.head qu) () )
            else game 42 42 42 (42, 42, 42, (#"a")) () (Queue.head qu) ()    
          | game 2 t 1 (pre : int * int * int * char) () (tmp : int * int * int * char) () =
            if (#4 (Queue.head qu)) = (#"+") then
                (if (#1 (Queue.head qu)) > 0 then
                    (if (Array2.sub (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu))) = (#".")) then
                     game 3 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu)), (#"+"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (Queue.head qu)) - 1, (#2 (Queue.head qu)), (t + 1), (#"+"))))
                     else if (Array2.sub (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu))) = (#"-")) then
                     game 3 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu)), (#"*"))) (Queue.head qu) ()
                     else game 3 t 1 (Queue.head qu) () (Queue.head qu) () )
                else
                    game 3 t 1 (Queue.head qu) () (Queue.head qu) () )
            else if (#4 (Queue.head qu)) = (#"-") then
                (if (#1 (Queue.head qu)) > 0 then
                    (if (Array2.sub (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu))) = (#".")) then
                     game 3 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu)), (#"-"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (Queue.head qu)) - 1, (#2 (Queue.head qu)), (t + 1), (#"-"))))
                     else if (Array2.sub (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu))) = (#"+")) then
                     game 3 t 1 (Queue.head qu) (Array2.update (arr, (#1 (Queue.head qu)) - 1, (#2 (Queue.head qu)), (#"*"))) (Queue.head qu) ()
                     else game 3 t 1 (Queue.head qu) () (Queue.head qu) () )
                else
                    game 3 t 1 (Queue.head qu) () (Queue.head qu) () )
            else game 42 42 42 (42, 42, 42, (#"a")) () (Queue.head qu) ()
          | game 3 t 1 (pre : int * int * int * char) () (tmp : int * int * int * char) () = 
            if (#4 (Queue.head qu)) = (#"+") then
                (if (#1 (Queue.head qu)) < (n - 1) then
                    (if (Array2.sub (arr, (#1 (Queue.head qu)) + 1, (#2 (Queue.head qu))) = (#".")) then
                        (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then 
                         game 0 t 1 (Queue.head qu) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"+"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (pre)) + 1, (#2 (pre)), (t + 1), (#"+"))))
                        else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 42 (t + 1) 42 (Queue.head qu) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"+"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (pre)) + 1, (#2 (pre)), (t + 1), (#"+"))))
                        else game 42 t 42 (42, 42, 42, (#"a")) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"+"))) (42, 42, 42, (#"a")) () )
                    else if (Array2.sub (arr, (#1 (Queue.head qu)) + 1, (#2 (Queue.head qu))) = (#"-")) then
                        (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                         game 0 t 1 (Queue.head qu) (Array2.update (arr, (#1 (pre)) + 1, (#2 (pre)), (#"*"))) (Queue.head qu) ()
                        else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 42 (t + 1) 42 (Queue.head qu) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"*"))) (Queue.head qu) ()
                        else game 42 t 42 (42, 42, 42, (#"a")) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"*"))) (42, 42, 42, (#"a")) () )
                    else 
                        (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                         game 0 t 1 (Queue.head qu) () (Queue.head qu) ()
                        else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 42 (t + 1) 42 (Queue.head qu) () (Queue.head qu) ()
                        else game 42 t 42 (42, 42, 42, (#"a")) () (42, 42, 42, (#"a")) () ) )
                else 
                    (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                        game 0 t 1 (Queue.head qu) () (Queue.head qu) ()
                    else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 42 (t + 1) 42 (Queue.head qu) () (Queue.head qu) ()
                    else game 42 t 42 (42, 42, 42, (#"a")) () (42, 42, 42, (#"a")) () ) )
            else if (#4 (Queue.head qu)) = (#"-") then   
                (if (#1 (Queue.head qu)) < (n - 1) then
                    (if (Array2.sub (arr, (#1 (Queue.head qu)) + 1, (#2 (Queue.head qu))) = (#".")) then
                        (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                         game 0 t 1 (Queue.head qu) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"-"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (pre)) + 1, (#2 (pre)), (t + 1), (#"-"))))
                        else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 42 (t + 1) 42 (Queue.head qu) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"-"))) (Queue.head qu) (Queue.enqueue (qu, ((#1 (pre)) + 1, (#2 (pre)), (t + 1), (#"-"))))
                        else game 42 t 42 (42, 42, 42, (#"a")) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"-"))) (42, 42, 42, (#"a")) () )
                    else if (Array2.sub (arr, (#1 (Queue.head qu)) + 1, (#2 (Queue.head qu))) = (#"+")) then
                        (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                         game 0 t 1 (Queue.head qu) (Array2.update (arr, (#1 (pre)) + 1, (#2 (pre)), (#"*"))) (Queue.head qu) ()
                        else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 42 (t + 1) 42 (Queue.head qu) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"*"))) (Queue.head qu) ()
                        else game 42 t 42 (42, 42, 42, (#"a")) (Array2.update (arr, (#1 pre) + 1, (#2 pre), (#"*"))) (42, 42, 42, (#"a")) () )
                    else
                        (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                         game 0 t 1 (Queue.head qu) () (Queue.head qu) ()
                        else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 42 (t + 1) 42 (Queue.head qu) () (Queue.head qu) ()
                        else game 42 t 42 (42, 42, 42, (#"a")) () (42, 42, 42, (#"a")) () ) )
                else 
                    (if (((Queue.dequeue qu) = pre) andalso ((Queue.peek qu) <> NONE) andalso ((#3 pre) = (#3 (Queue.head qu)))) then
                        game 0 t 1 (Queue.head qu) () (Queue.head qu) ()
                    else if (((Queue.peek qu) <> NONE) andalso ((#3 pre) <> (#3 (Queue.head qu)))) then
                        game 42 (t + 1) 42 (Queue.head qu) () (Queue.head qu) ()
                    else game 42 (t + 1) 42 (42, 42, 42, (#"a")) () (42, 42, 42, (#"a")) () ) ) 
            else game 42 42 42 (42, 42, 42, (#"a")) () (Queue.head qu) ()                             (* never got in *)
          | game _ _ _ (pre : int * int * int * char) () (tmp : int * int * int * char) () =      (* never got in *)
            game 42 17 42 (42, 42, 42, (#"a")) () (42, 42, 42, (#"a")) ()  ;                       (* never got in *)
          
        
    in
	    (* check *)
	    (* seek *)
 	    (* readList user 0 0 () *)
 	    (* init *)
 	    game 42 0 2 init () (42, 42, 42, (#"k")) ()
    end ;