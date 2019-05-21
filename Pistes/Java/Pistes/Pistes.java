import java.io.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.*;



class MyList<T> extends ArrayList<T> {
	
	// Copy Constructor for MyList<Int>
	public MyList<T> ListConstructor(MyList<T> l) {
		int length = l.size();
		for (int i=0; i<length; ++i) {
			super.add(l.get(i));
		}
		return this;
	}

	// Copy Constructor for MyList<Round>
	public MyList<Round> RoundConstructor(MyList<Round> l) {
		int length = l.size();
		MyList<Round> lista = new MyList<>();
		for (int i=0; i<length; ++i) {
			Round item = new Round();
			item.CopyConstructor(l.get(i));
			lista.add(item);
		}
		return lista;
	}
}

class Round {
		    
    	private int num;
	private int stars;
	private MyList<Integer> lock = new MyList<>();     // requirement keys
	private MyList<Integer> unlock = new MyList<>();   // unlock keys	

	public Round() {
	;
	}

	public Round(int num, int stars, MyList<Integer> require, MyList<Integer> newkeys) {
		this.num = num;
		this.stars = stars;
		this.lock.ListConstructor(require);
		this.unlock.ListConstructor(newkeys);
	}

	public Round CopyConstructor(Round r) {
		this.num = r.getNum();
		this.stars = r.getStars();
		this.lock.ListConstructor(r.getLock());
		this.unlock.ListConstructor(r.getUnlock());
		return this;
	}	

	public int getNum() {
		return num;
	}

	public void setStars(int a) {
		stars = a;
	}	

	public int getStars() {
		return stars;
	}

	public MyList<Integer> getLock() {
		return lock;
	}

	public MyList<Integer> getUnlock() {
		return unlock;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || this.getClass() != o.getClass()) return false;
	
		Round r = (Round) o;
		
		if (r.getNum() == this.getNum()) return true;
		return false;
	}

}

interface Solver {

	// Returns max number of stars 
	int solve(State initial);
}

			
interface State {
		
   	public boolean isFinal();
   	public Collection<State> next();
	public MyList<Integer> remaining();     // remaining keys
	public Round getRound();
	public State CopyConstructor(State s);
	public int getRealStars();		
}   

class RoundSolver implements Solver {
	
	@Override
	public int solve(State initial) {

		int count = initial.getRound().getStars();
		int tempcount;
		Set<State> seen = new HashSet<>();

		// List of states that the game begins
		MyList<State> remaining = new MyList<>();     

		// Add initial state to list.
		seen.add(initial);
		remaining.add(0, initial);

		// While the list contains states to be examined.
		while (!remaining.isEmpty()) {
			State s = remaining.remove(0);

			// Find Count aka Result
			count = (s.getRealStars() > count) ? s.getRealStars() : count;

			seen.add(s);			
	
			// Check if is final
			if (s.isFinal()) {

				continue;
			}
			

			// Find all next cases that can be examined
			for (State n : s.next()) {
				
				// Check if n has been seen before in current path
				if (!seen.contains(n)) {
					remaining.add(0, n);
				}
			}
		}

		// Return the max sum of stars examined in a past State
		return count;
	}
}

class RoundState implements State {

	private int realStars;
	private Round current = new Round();
	private	MyList<Integer> keys = new MyList<>();	
	private MyList<State> next = new MyList<>();
	private MyList<Round> left = new MyList<>();

	public RoundState (Round round, MyList<Integer> mykeys, MyList<Round> left, int stars) {
		current.CopyConstructor(round);                
		keys.ListConstructor(mykeys);		
		this.left = this.left.RoundConstructor(left);
		realStars = stars;
	}	

	@Override
	public int getRealStars() {
		return realStars;
	}

	@Override
	public Round getRound() {
		return current;
	}	
	
	@Override
	public MyList<Integer> remaining() {
		return keys;
	}

	@Override
	public State CopyConstructor(State s) {
		this.realStars = s.getRealStars();
		this.current.CopyConstructor(s.getRound());
		this.keys.ListConstructor(s.remaining());
		return this;
	}
	
	@Override
	public boolean isFinal() {
		if (keys.isEmpty()) {
			return true;
		}

		// Check if next exists 
		boolean flag = true;
		MyList<Integer> temp = new MyList<>();
		temp.ListConstructor(keys);
		for (Round n : left) {
			flag = true;
			temp = new MyList<>();
	        	temp.ListConstructor(keys);						
			for (int k : n.getLock()) {

				// Key Found
				if (temp.contains(k)) {
					flag = false;
					//break;
				}

				// Key Not Found 
				else {flag = true; break;}
			}
			
			// Check if round n is valid for next
			if (!flag) {
				break;
			}
			else continue;   
		}	
		return flag;
	}

	@Override
	public MyList<State> next() {
		boolean flag;
		MyList<Integer> temp = new MyList<>();     // keys
		temp.ListConstructor(keys);
		MyList<Round> templeft = new MyList<>();   // left
		for (Round n : left) {
			flag = true;

			// Initialize temp to keys at the beginning of each loop
			temp = new MyList<>();
	        	temp.ListConstructor(keys);

			// Initialize templeft to left at the beginning of each loop
			templeft = new MyList<>();
			templeft = templeft.RoundConstructor(left);

			int len = temp.size();

			for (int k : n.getLock()) {

				// Key not found 
				if (!temp.contains(k)) {
					flag = false;
					break;
				}

				// Key found
				else {   
					len = temp.size();

					// i index for remove()
					for (int i=0; i<len; ++i) {   		
						if (temp.get(i).equals(k)) {
							temp.remove(i);
							break;
						}
					}
				}
			}
			
			// Check if round n is valid for next
			if (flag) {

				// Delete current next round from next left
				boolean t = templeft.remove(n);

				// Add keys to next state
				temp.addAll(n.getUnlock());

				// Create next state
				next.add(new RoundState(n, temp, templeft, this.getRealStars() + n.getStars()));
			}				
			else continue;
		}
		
		// Returns the next states
		return next;
	}

	@Override
 	public boolean equals(Object o) {
    	
		if (this == o) return true;
    		if (o == null || getClass() != o.getClass()) return false;

    		RoundState that = (RoundState) o;

    		if (!this.getRound().equals(that.getRound()) || this.getRealStars() != (that.getRealStars())) return false;
		
		return true;		

        }

	@Override
	public int hashCode() {
		int code = 0;
		
		// Just a simple hash function ^.^
		for (int i=0; i<getRound().getNum(); ++i) {
			code = code * 2 + 32;
		}
		return code;
	}
}

public class Pistes {
	public static void main(String[] args) {
		try {
			BufferedReader reader = new BufferedReader (new FileReader (args[0]));
			
			// Find the number of rounds + 1 (in)
			String line = reader.readLine();
			int in = Integer.parseInt(line) + 1;
			MyList<Round> left = new MyList<>();
			int stars = 0;
			MyList<Integer> require = null, unlock = null;
			Round init = null;
			for (int i=0; i<in; ++i) {
		
				line = reader.readLine();	
				int length = line.length();
				String [] arr = line.split(" ");
				
				for (int j=0; j<length; ++j) {
					int len1 = Integer.parseInt(arr[0]);
					int len2 = Integer.parseInt(arr[1]);
					stars = Integer.parseInt(arr[2]);

					// Full the requirement keys
					require = new MyList<>();
					for (int k=0; k<len1; ++k) {
						require.add(Integer.parseInt(arr[3 + k]));			
					} 

					// Full the unlock keys
					unlock = new MyList<>();
					for (int r=0; r<len2; ++r) {
						unlock.add(Integer.parseInt(arr[3 + len1 + r]));
					}
				}

				// Call constructors to start the game
				if (i == 0) {
					init = new Round(0, stars, require, unlock);
				}
				else {
					Round current = new Round(i, stars, require, unlock);
					left.add(current);
				}
			}

			// Start the game
			State initial = new RoundState (init, init.getUnlock(), left, init.getStars()); 
			Solver solver = new RoundSolver();
			int result = solver.solve(initial);
			System.out.println(result);
		}

		catch(IOException e) {
			e.printStackTrace();
		}
	}
}

	

				

			



										



			
