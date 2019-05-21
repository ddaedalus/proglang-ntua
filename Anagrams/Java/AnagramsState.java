import java.util.ArrayList;
import java.util.Collection;

public class AnagramsState implements State {

  private String q1;
  private String q2;
  private String a0;
  private String goal;
  private State previous;
  private String move;

  @Override
  public State getPrevious() {
    return previous;
  }

  public AnagramsState(String q1, String q2, String a0, String goal,
                       State previous, String move) {
    this.q1 = q1;
    this.q2 = q2;
    this.a0 = a0;
    this.goal = goal;
    this.previous = previous;
    this.move = move;
  }
    
  @Override
  public boolean isFinal() {
    return q2.equals(goal) && q1.length() == 0 && a0.length() == 0;
  }

  private Pair<String> moveLetter(String s1, String s2) {
    String s1n = s1.substring(0, s1.length() - 1);
    String s2n = s2.concat(s1.substring(s1.length() - 1));
    return new Pair<>(s1n, s2n);
  }

  private void addState(State state, Collection<State> states) {
    if (!state.isBad()) {
      states.add(state);
    }
  }

  @Override
  public Collection<State> next() {
    Collection<State> states = new ArrayList<>();
    Pair<String> pair;

    if (q1.length() > 0) {
      // 1 -> 0
      pair = moveLetter(q1, a0);
      addState(new AnagramsState(pair.getA(), q2, pair.getB(), goal,
                                 this, "10"), states);
      // 1 -> 2
      pair = moveLetter(q1, q2);
      addState(new AnagramsState(pair.getA(), pair.getB(), a0, goal,
                                 this, "12"), states);
    }

    if (q2.length() > 0) {
      // 2 -> 0
      pair = moveLetter(q2, a0);
      addState(new AnagramsState(q1, pair.getA(), pair.getB(), goal,
                                 this, "20"), states);
      // 2 -> 1
      pair = moveLetter(q2, q1);
      addState(new AnagramsState(pair.getB(), pair.getA(), a0, goal,
                                 this, "21"), states);
    }

    if (a0.length() > 0) {
      // 0 -> 1
      pair = moveLetter(a0, q1);
      addState(new AnagramsState(pair.getB(), q2, "", goal,
                                 this, "01"), states);
      // 0 -> 2
      pair = moveLetter(a0, q2);
      addState(new AnagramsState(q1, pair.getB(), "", goal,
                                 this, "02"), states);
    }

    return states;
  }
    
  @Override
  public boolean isBad() {
    return a0.length() > 1;
  }

  @Override
  public String toString() {
    final StringBuilder sb = new StringBuilder("AnagramsState{");
    sb.append("q1='").append(q1).append('\'');
    sb.append(", q2='").append(q2).append('\'');
    sb.append(", a0='").append(a0).append('\'');
    sb.append(", move='").append(move).append('\'');
    sb.append('}');
    return sb.toString();
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;

    AnagramsState that = (AnagramsState) o;

    if (q1 != null ? !q1.equals(that.q1) : that.q1 != null) return false;
    if (q2 != null ? !q2.equals(that.q2) : that.q2 != null) return false;
    return !(a0 != null ? !a0.equals(that.a0) : that.a0 != null);

  }
					
  @Override
  public int hashCode() {
    int result = q1 != null ? q1.hashCode() : 0;
    result = 31 * result + (q2 != null ? q2.hashCode() : 0);
    result = 31 * result + (a0 != null ? a0.hashCode() : 0);
    return result;
  }
}
