import java.util.Collection;
import java.util.ArrayList;

public interface State {
		
   	public boolean isFinal();
   	public Collection<State> next();
	public MyList<Integer> remaining();     // remaining keys
	public Round getRound();
	public State CopyConstructor(State s);
	public int getRealStars();		
}   
