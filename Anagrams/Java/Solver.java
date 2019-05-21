public interface Solver {
  // Returns the solution, or null if there is none.
  State solve(State initial);
}
