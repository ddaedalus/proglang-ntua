import java.util.*;

public class RoundSolver implements Solver {
	
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
