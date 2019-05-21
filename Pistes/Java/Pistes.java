import java.io.*;
import java.util.ArrayList;

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
	
				

			



										



			
