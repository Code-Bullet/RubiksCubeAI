class TurnO {
  int axis = 0;
  int index = 0;
  boolean clockwise = true;

  TurnO(int a, int i, boolean c) {
    axis =a;
    index = i;
    clockwise = c;
  }
  TurnO() {
    axis =floor(random(3));
    index = floor(random(n));
    if (random(1) <0.5) {
      clockwise =false;
    }
  }

  boolean matches(TurnO t) {
    return t.axis ==axis && t.index == index && clockwise == t.clockwise;
  }
  
  
  void printTurn(){
    println("axis: " + axis +", index " + index + ", isclockwise " +clockwise);  
    
  }
  
  TurnO getReverse(){
    TurnO reverse = new TurnO(axis,index,!clockwise);
    return reverse;
  }
}
