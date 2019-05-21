import java.util.*;

public class BFSolver implements Solver {

  @Override
  public State solve(State initial) {
    Set<State> seen = new HashSet<>();
    Queue<State> remaining = new ArrayDeque<>();

    // Add the initial state to the queue.
    seen.add(initial);
    remaining.add(initial);

    // While the queue contains states to be examined.
    while (!remaining.isEmpty()) {
      // Remove the first remaining state from the queue.
      State s = remaining.remove();
      // If s is final, then just return it.
      if (s.isFinal())
        return s;
      // Find the states that can be reached from this one.
      for (State n : s.next())
        // If n has not been seen before, add it to the queue.
        if (!seen.contains(n)) {
          seen.add(n);
          remaining.add(n);
        }
    }
    // If the queue is empty and no solution was found, return null.
    return null;
  }
}
