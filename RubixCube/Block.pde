class Block {

  PVector pos;
  color[] colors = new color[6]; //left right up down back front
  boolean showBlack = false;
  int numberOfCols = 0;
  int id;
  Block(PVector pos) {
    this.pos = pos;
    id = (int)(pos.x*100*n*n + pos.y*10*n + pos.z*1) + floor(random(100000));
    setColors();
  }
  Block() {
  }

  Block clone() {

    Block clone = new Block(); 
    clone.colors = colors.clone();
    clone.pos = new PVector(pos.x, pos.y, pos.z);
    clone.numberOfCols = numberOfCols;
    clone.id = id;
    return clone;
  }
  void turn(int axisNo, boolean clockwise) {
    //assume always clockwise
    color[] newColors = colors.clone();
    if (clockwise) {
      turn(axisNo, false); 
      turn(axisNo, false); 
      turn(axisNo, false);
      return;
    }
    switch(axisNo) {
    case 0://x axis
      //front becomes up
      //up becomes back
      //back becomes down
      //down becomes font

      newColors[2] = colors[5];
      newColors[3] = colors[4];
      newColors[4] = colors[2];
      newColors[5] = colors[3];
      break;
    case 1://yaxis
      newColors[0] = colors[4];//left = back
      newColors[1] = colors[5];//right = fron
      newColors[4] = colors[1];//back = right
      newColors[5] = colors[0];//front = left
      break;
    case 2://zaxis
      newColors[0] = colors[3];
      newColors[1] = colors[2];
      newColors[2] = colors[0];
      newColors[3] = colors[1];
      break;
    }
    colors = newColors.clone();
  }
  void setColors() {
    //position 0 0 0 is the top left back which is the blue, white orange corner (respectively)
    for (int i = 0; i< colors.length; i++) { 
      colors[i] = color(0);
    }
    if (pos.x==0) {
      colors[0] = color(255);
      numberOfCols++;
    }
    if (pos.x == numberOfSides-1) {
      colors[1] = color(255, 255, 0);
      numberOfCols++;
    }
    if (pos.y ==0) {
      colors[2] = color(0, 0, 255);
      numberOfCols++;
    }
    if (pos.y ==numberOfSides-1) {
      colors[3] = color(0, 255, 0);
      numberOfCols++;
    }
    if (pos.z ==0) {
      colors[4] = color(255, 140, 0);//orange
      numberOfCols++;
    }
    if (pos.z ==numberOfSides-1) {
      colors[5] = color(255, 0, 0);
      numberOfCols++;
    }
  }


  void show() {

    for (int i = 0; i< colors.length; i++) { 
      drawFace(i, colors[i]);
    }
  }


  //left right up down back front
  void drawFace(int faceNo, color col) {

    //if (!showBlack && col == color(0)) {
    //  return;
    //}
    if (col == color(0)) {
      return;
    }
    

    fill(col);
    stroke(0);
    float weightSize = max(1, blockWidth/20.0);
    strokeWeight(weightSize);
    //strokeWeight(2);
    //noStroke();
    switch(faceNo) {
    case 0:
      //left
      beginShape();
      addVertex(0, 0, 1);
      addVertex(0, 0, 0);
      addVertex(0, 1, 0);
      addVertex(0, 1, 1);
      endShape(CLOSE);
      break;
    case 1:
      //right
      beginShape();
      addVertex(1, 0, 1);
      addVertex(1, 0, 0);
      addVertex(1, 1, 0);
      addVertex(1, 1, 1);
      endShape(CLOSE);
      break;
    case 2:
      //top
      beginShape();
      addVertex(0, 0, 1);
      addVertex(0, 0, 0);
      addVertex(1, 0, 0);
      addVertex(1, 0, 1);
      endShape(CLOSE);
      break;
    case 3:
      //bottom
      beginShape();
      addVertex(0, 1, 1);
      addVertex(0, 1, 0);
      addVertex(1, 1, 0);
      addVertex(1, 1, 1);
      endShape(CLOSE);
      break;
    case 4:
      //back
      beginShape();
      addVertex(0, 0, 0);
      addVertex(1, 0, 0);
      addVertex(1, 1, 0);
      addVertex(0, 1, 0);
      endShape(CLOSE);
      break;
    case 5:
      //front
      beginShape();
      addVertex(0, 0, 1);
      addVertex(1, 0, 1);
      addVertex(1, 1, 1);
      addVertex(0, 1, 1);
      endShape(CLOSE);
      break;
    }
  }


  //todo gonna need more info for larger problems
  boolean matchesColors(color[] cols) {
    if (numberOfCols != cols.length) {
      return false;
    }

    for (int i = 0; i< cols.length; i++) {
      boolean foundMatch = false;
      for (int j = 0; j < colors.length; j++) {
        if (colors[j] == cols[i]) {
          foundMatch = true;
          break;
        }
      }
      if (!foundMatch) {
        return false;
      }
    }


    return true;
  }

  boolean matchesColors(color col) {
    if (numberOfCols != 1) {
      return false;
    }
    for (int j = 0; j < colors.length; j++) {
      if (colors[j] == col) {
        return true;
      }
    }
    return false;
  }

  color[] getColors() {
    color[] cols = new color[numberOfCols];
    int counter =0;
    for (int i = 0; i<6; i++) {
      if (colors[i]!= color(0)) {
        cols[counter] = colors[i];
        counter++;
      }
    } 
    return cols;
  }

  color getColorFromFace(char face) {
    String faces = "LRUDBF";
    return colors[faces.indexOf(face)];
  }


  char getFace(color col) { //left right up down back front
    for (int j = 0; j < colors.length; j++) {
      if (colors[j] == col) {
        String faces = "LRUDBF";
        return faces.charAt(j);
      }
    }
    return  ' ';
  }

  String getFaces() {
    String faces = "";
    String faceOrder = "LRUDBF";
    for (int j = 0; j < colors.length; j++) {
      if (colors[j] != color(0)) {
        faces += faceOrder.charAt(j);
      }
    }
    return  faces;
  }


  void addVertex(int x, int y, int z) {
    vertex((x-0.5)*faceWidth, (y-0.5)*faceWidth, (z-0.5)*faceWidth);
  }
}
