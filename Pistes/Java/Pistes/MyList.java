import java.util.ArrayList;

class MyList<T> extends ArrayList<T> {
	
	// Copy Constructor for MyList<Int>
	public MyList<T> ListConstructor(MyList<T> l) {
		int length = l.size();
		for (int i=0; i<length; ++i) {
			super.add(l.get(i));
		}
		return this;
	}

	// Copy Constructor for MyList<Round>
	public MyList<Round> RoundConstructor(MyList<Round> l) {
		int length = l.size();
		MyList<Round> lista = new MyList<>();
		for (int i=0; i<length; ++i) {
			Round item = new Round();
			item.CopyConstructor(l.get(i));
			lista.add(item);
		}
		return lista;
	}
}
				
