import java.util.Collection;

public interface State {

  public boolean isFinal();
  public boolean isBad();
  public State getPrevious();
  public Collection<State> next();
}
