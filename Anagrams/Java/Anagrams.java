public class Anagrams {

  public static void main(String args[]) {
    Solver solver = new BFSolver();
    State initial = new AnagramsState(args[0], "", "", args[1], null, "");
    State result = solver.solve(initial);
    if (result == null) {
      System.out.println("No solution found.");
    } 
    else {
      printSolution(result);
    }
  }

  private static void printSolution(State state) {
    if (state.getPrevious() != null) {
      printSolution(state.getPrevious());
    }
    System.out.println(state);
  }
}
