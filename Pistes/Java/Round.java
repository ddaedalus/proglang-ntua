import java.util.*;

public class Round {
		    
    	private int num;
	private int stars;
	private MyList<Integer> lock = new MyList<>();     // requirement keys
	private MyList<Integer> unlock = new MyList<>();   // unlock keys	

	public Round() {
	;
	}

	public Round(int num, int stars, MyList<Integer> require, MyList<Integer> newkeys) {
		this.num = num;
		this.stars = stars;
		this.lock.ListConstructor(require);
		this.unlock.ListConstructor(newkeys);
	}

	public Round CopyConstructor(Round r) {
		this.num = r.getNum();
		this.stars = r.getStars();
		this.lock.ListConstructor(r.getLock());
		this.unlock.ListConstructor(r.getUnlock());
		return this;
	}	

	public int getNum() {
		return num;
	}

	public void setStars(int a) {
		stars = a;
	}	

	public int getStars() {
		return stars;
	}

	public MyList<Integer> getLock() {
		return lock;
	}

	public MyList<Integer> getUnlock() {
		return unlock;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || this.getClass() != o.getClass()) return false;
	
		Round r = (Round) o;
		
		if (r.getNum() == this.getNum()) return true;
		return false;
	}

}
		
