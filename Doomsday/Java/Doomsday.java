import java .io .*;

public class Doomsday {

	public static void main (String [] args) {
		try {
			BufferedReader reader = new BufferedReader (new FileReader (args[0]));
			String line = null;
			int N, M, i, j, k, s, check;
			boolean done;
			done = false;
			N = 1000;
			M = 1000;
			char d;
			char[][] a = new char [1000][1000];
			int[][] b = new int [3][1000001];
			char[] c = new char [1000001];


			// initialization
			for (i = 0; i < N * M + 1; i++) {
				b[0][i] = -1;
				b[1][i] = -1;
				b[2][i] = -1;
				c[i] = 'o';
			}
			k = 0;
			N = 0;
			M = 0;
			check = 1;
			i = 1;
			try {
				line = reader.readLine();
				// find x_chars
				M = (Integer) line.length();
			} catch (Exception e) { 
				System .out . println (" Something went wrong " + e);
			}

			k = 0;
			while (line != null) {
				++N;                    // find y_chars 
				char [] temp = line.toCharArray();

				// set a,b and c arrays 
				for (i = 0; i < M; ++i) {
					a[N-1][i] = temp [i];
					if((temp[i] =='+')) {
						b[0][k] = N - 1;
						b[1][k] = i;
						b[2][k] = 0;
						c[k] = '+';
						k++;
					}

					else if ((temp[i] == '-')) {
						b[0][k] = N - 1;
						b[1][k] = i;
						b[2][k] = 0;
						c[k] = '-';
						k++;                          // kappa
					}
				}
				try {
					line = reader.readLine();               // read next line
				} catch ( Exception e) { 
					System .out . println (" Something went wrong : " + e);
				}
			}
			s = 0;
			check = 1;
			int day = 0;
			while ((b[0][s] != -1) && (check == 1)) {
				if (c[s] == '+') {
					if (b[1][s] > 0) {
						if (a[b[0][s]][b[1][s] - 1] == '.') {
							a[b[0][s]][b[1][s] - 1] = '+';
							b[0][k] = b[0][s];
							b[1][k] = b[1][s]-1;
							b[2][k] = b[2][s]+1;
							c[k] = '+';
							k++;
						}
						else if (a[b[0][s]][b[1][s] - 1] == '-') {
							a[b[0][s]][b[1][s] -1 ] = '*';
							done = true;
							day = b[2][s] + 1;
						}
					}
					if (b[1][s] < M - 1) {
						if (a[b[0][s]][b[1][s] + 1] == '.') {
							a[b[0][s]][b[1][s] + 1] = '+';
							b[0][k] = b[0][s];
							b[1][k] = b[1][s] + 1;
							b[2][k] = b[2][s] + 1;
							c[k] = '+';
							k++;
						}
						else if (a[b[0][s]][b[1][s] + 1] == '-') {
							a[b[0][s]][b[1][s] + 1] = '*';
							done = true;
							day = b[2][s] + 1;
						}
					}
					if (b[0][s] > 0) {
						if (a[b[0][s] - 1][b[1][s]]== '.') {
							a[b[0][s] - 1][b[1][s]] = '+';
							b[0][k] = b[0][s] - 1;
							b[1][k] = b[1][s];
							b[2][k] = b[2][s] + 1;
							c[k] = '+';
							k++;
						}
						else if (a[b[0][s] - 1][b[1][s]] == '-') {
							a[b[0][s] - 1][b[1][s]] = '*';
							done = true;
							day = b[2][s] + 1;
						}
					}
					if (b[0][s] < N - 1) {
						if (a[b[0][s] + 1][b[1][s]] == '.') {
							a[b[0][s] + 1][b[1][s]] = '+';
							b[0][k] = b[0][s] + 1;
							b[1][k] = b[1][s];
							b[2][k] = b[2][s] + 1;
							c[k] = '+';
							k++;
						}
						else if (a[b[0][s] + 1][b[1][s]] == '-') {
							a[b[0][s] + 1][b[1][s]] = '*';
							done = true;
							day = b[2][s] + 1;
						}
					}
				}
				else if (c[s] == '-') {
					if (b[1][s] > 0) {
						if (a[b[0][s]][b[1][s] - 1]== '.') {
							a[b[0][s]][b[1][s] - 1] = '-';
							b[0][k] = b[0][s];
							b[1][k] = b[1][s] - 1;
							b[2][k] = b[2][s] + 1;
							c[k] = '-';
							k++;
						}
						else if (a[b[0][s]][b[1][s] - 1] == '+') {
							a[b[0][s]][b[1][s] - 1] = '*';
							done = true;
							day = b[2][s] + 1;
						}
					}   
					if (b[1][s] < M - 1) {
						if (a[b[0][s]][b[1][s] + 1] == '.') {
							a[b[0][s]][b[1][s] + 1] ='-';
							b[0][k] = b[0][s];
							b[1][k] = b[1][s] + 1;
							b[2][k] = b[2][s] + 1;
							c[k] = '-';
							k++;
						}
						else if (a[b[0][s]][b[1][s] + 1] == '+') {
							a[b[0][s]][b[1][s] + 1] = '*';
							done = true;
							day = b[2][s] + 1;
						}
					}
					if (b[0][s] > 0) {
						if (a[b[0][s] - 1][b[1][s]] == '.') {
							a[b[0][s] - 1][b[1][s]] = '-';
							b[0][k] = b[0][s] - 1;
							b[1][k] = b[1][s];
							b[2][k] = b[2][s] + 1;
							c[k] = '-';
							k++;
						}
						else if (a[b[0][s] - 1][b[1][s]] == '+') {
							a[b[0][s] - 1][b[1][s]] = '*';
							done = true;
							day = b[2][s] + 1;
						}
					}
					if (b[0][s] < N - 1) {
						if (a[b[0][s] + 1][b[1][s]] =='.') {
							a[b[0][s] + 1][b[1][s]] = '-';
							b[0][k] = b[0][s] + 1;
							b[1][k] = b[1][s];
							b[2][k] = b[2][s] + 1;
							c[k] = '-';
							k++;
						}
						else if (a[b[0][s] + 1][b[1][s]] == '+') {
							a[b[0][s] + 1][b[1][s]] = '*';
							done = true;
							day = b[2][s] + 1;
						}
					}
				}
				if ((b[2][s] != b[2][s + 1]) && (done)) 
					check = 0;
				s++;
			}
			if(!done) 
				System.out.println("the world is saved");
			else
				System.out.println(day);
			for(i = 0; i < N; i++) {
				for(j = 0; j < M; j++) {
					System.out.print(a[i][j]);
				}
				System.out.println();
			}
			System.out.println();

		} catch (IOException e2) {
			e2.printStackTrace();
		}
	}
}
