import java.util.ArrayList;
import java.util.Collection;

public class RoundState implements State {

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
