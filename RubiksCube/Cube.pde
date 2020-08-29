class Cube {
  Block[][][] blocks;
  int rotationAxis = 0;
  int rotatingIndex = 0;
  float rotationAngle = 0;
  ArrayList<Block> rotatingBlocks = new ArrayList();
  ArrayList<Block> showingBlack = new ArrayList();
  int counter = 0;
  ArrayList<ArrayList<Block>> cycleLists = new ArrayList();
  Block centerBlock = new Block(new PVector(0, 0, 0));
  boolean turning = false;
  boolean turningClockwise = true;
  boolean turningWholeCube = false;
  boolean scrambling = true;
  float rotationSpeed = PI/20.0;

  CubeAlgorithms algos;
  Cube() {
    blocks = new Block[numberOfSides][numberOfSides][numberOfSides];
    for (int i = 0; i< numberOfSides; i++) { 
      for (int j = 0; j< numberOfSides; j++) { 
        for (int k = 0; k< numberOfSides; k++) { 
          blocks[i][j][k] = new Block(new PVector(i, j, k));
        }
      }
    }
    algos = new CubeAlgorithms(this);
  }

  //-----------------------------------------------------------------------------------------------------------------------------------------------------------
  void show() {

    showBlacks();
    int angleMultiplier = 1; 
    if (turningClockwise) {
      angleMultiplier = -1;
    }
    //int otherCounter =0;
    //Block[][] face = getFace('D');
    //for (int i = 0; i< numberOfSides; i++) { 
    //  for (int j = 0; j< numberOfSides; j++) {
    //    pushMatrix();
    //    float x = face[i][j].pos.x;
    //    float y = face[i][j].pos.y;
    //    float z = face[i][j].pos.z;

    //    float m =(numberOfSides-1)/2.0;
    //    translate((x-m)*blockWidth, (y-m)*blockWidth, (z-m)*blockWidth);
    //    face[i][j].show();
    //    popMatrix();
    //    otherCounter++;
    //    if (otherCounter > counter) {
    //      counter ++;
    //      return;
    //    }
    //  }
    //}

    //counter =0;

    for (int i = 0; i< numberOfSides; i++) { 
      for (int j = 0; j< numberOfSides; j++) { 
        for (int k = 0; k< numberOfSides; k++) { 
          pushMatrix();
          if (turning && (turningWholeCube || rotatingBlocks.contains(blocks[i][j][k]) )) {
            switch(rotationAxis) {
            case 0:
              rotateX(angleMultiplier*rotationAngle);
              break;
            case 1:
              rotateY(angleMultiplier*rotationAngle);
              break;
            case 2:
              rotateZ(angleMultiplier*rotationAngle);
              break;
            }
          }
          float m =(numberOfSides-1)/2.0;
          translate((i-m)*blockWidth, (j-m)*blockWidth, (k-m)*blockWidth);
          blocks[i][j][k].show();
          popMatrix();
        }
      }
    }
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------
  void update() {
    if (turning) {
      if (rotationAngle < PI/2) {
        float scramblingMultiplier = 1;
        if (scrambling) {
          scramblingMultiplier = 5;
        } 
        int turningEaseCoeff = 2;
        if (rotationAngle<PI/8) {
          rotationAngle += scramblingMultiplier*rotationSpeed/map(rotationAngle, 0, PI/8, turningEaseCoeff, 1);
        } else if (rotationAngle > PI/2-PI/8) {
          rotationAngle += scramblingMultiplier*rotationSpeed/map(rotationAngle, PI/2-PI/8, PI/2, 1, turningEaseCoeff);
        } else {
          rotationAngle += scramblingMultiplier* rotationSpeed;
        }
      }
      if (rotationAngle >=PI/2) {
        rotationAngle = 0;
        turning= false;
        if (turningWholeCube) {
          finishTurningWholeCube(rotationAxis, turningClockwise);
        } else {
          finaliseTurn(rotatingIndex, rotationAxis, turningClockwise);
        }
      }
    }
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------

  void finaliseTurn(int index, int xOrYOrZ, boolean turnClockwise) {
    turning = false;

    ////to turn once clockwise take 2 from the back of the list and chuck em on the front
    
    for (int i = 0; i< rotatingBlocks.size(); i++) { 
      rotatingBlocks.get(i).turn(xOrYOrZ, turnClockwise);
    }

    for (int j = 0; j < cycleLists.size(); j++) {
      ArrayList<Block> temp = cycleLists.get(j);
      for (int i = 0; i< numberOfSides-1-j*2; i++) { 
        if (!turnClockwise) {
          //remove from end and add to start
          temp.add(0, temp.remove(temp.size()-1));
        } else {
          //remove from front and add to the end
          temp.add(temp.remove(0));
        }
      }
      returnListToCube(temp, index, xOrYOrZ, j);
    }
  }

  void finishTurningWholeCube(int axis, boolean clockwise) {
    turning = false;
    turningWholeCube = false;

    for (int i = 0; i< numberOfSides; i++) { 
      for (int j = 0; j< numberOfSides; j++) { 
        for (int k = 0; k< numberOfSides; k++) { 
          blocks[i][j][k].turn(axis, clockwise);
        }
      }
    }

    for (int k = 0; k< numberOfSides; k++) {
      cycleLists = getAllBlocksToRotate(k, axis);
      for (int j = 0; j < cycleLists.size(); j++) {
        ArrayList<Block> temp = cycleLists.get(j);
        for (int i = 0; i< numberOfSides-1-j*2; i++) { 
          if (!clockwise) {
            //remove from end and add to start
            temp.add(0, temp.remove(temp.size()-1));
          } else {
            //remove from front and add to the end
            temp.add(temp.remove(0));
          }
        }
        returnListToCube(temp, k, axis, j);
      }
    }
  }

  void turnWholeCube(int axis, boolean clockwise) {
    if (turning) {
      return;
    }
    turning = true;
    turningClockwise = clockwise;
    turningWholeCube = true;
    rotationAxis = axis;
    if (fixCubeRotation) {
      rotationAngle = 0;
      turning= false;
      finishTurningWholeCube(axis, clockwise);
    }
  }


  //-----------------------------------------------------------------------------------------------------------------------------------------------------------
  void turnCubeFromObj(TurnO t) {
    turnCube(t.index, t.axis, t.clockwise);
  }


  void turnCube(int index, int xOrYOrZ, boolean turnClockwise) {
    if (turning) {//finish the turn
      rotationAngle = 0;
      turning= false;
      finaliseTurn(rotatingIndex, rotationAxis, turningClockwise);
    }
    turning = true;
    this.turningClockwise = turnClockwise;
    cycleLists = getAllBlocksToRotate(index, xOrYOrZ);
    rotatingBlocks = new ArrayList();
    for (int i = 0; i < cycleLists.size(); i++) {
      rotatingBlocks.addAll(cycleLists.get(i));
    }
    rotationAxis = xOrYOrZ;
    rotatingIndex = index;
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------
  ArrayList<ArrayList<Block>> getAllBlocksToRotate(int index, int xOrYOrZ) {
    ArrayList<ArrayList<Block>>  temp = new ArrayList();   
    if (index ==0 || index ==n-1) {
      for (int i  = 0; i < floor((numberOfSides+1)/2); i++) {
        temp.add(getList(index, xOrYOrZ, i));
      }
    } else {
      temp.add(getList(index, xOrYOrZ, 0));
    }
    return temp;
  }

  //-----------------------------------------------------------------------------------------------------------------------------------------------------------
  //takes in an arraylist and adds it to the cube
  void returnListToCube(ArrayList<Block> list, int index, int xOrYOrZ, int listNumber) {
    int i = 0;
    int j = 0;
    int k = 0;
    int size = numberOfSides-2*listNumber;

    switch(xOrYOrZ) {
    case 0:
      //return all blocks with the x index of "index"
      i = index;

      //add all on top row
      k = 0;
      for (j = 0; j< size; j++) { 
        blocks[i][j+listNumber][k+listNumber] = list.remove(0).clone();
      }

      //add right row
      j=size-1;
      for (k = 1; k< size; k++) { 
        blocks[i][j+listNumber][k+listNumber] = list.remove(0).clone();
      }

      //add bottom
      k=size-1;
      for (j = size-2; j>=0; j--) {
        blocks[i][j+listNumber][k+listNumber] = list.remove(0).clone();
      }

      //add left
      j=0;
      for (k = size-2; k>0; k--) {
        blocks[i][j+listNumber][k+listNumber] = list.remove(0).clone();
      }
      break;
    case 1:
      //return all blocks with the y index of "index"
      j = index;

      //add all on top row
      i = 0;
      for (k = 0; k< size; k++) { 
        blocks[i+listNumber][j][k+listNumber] = list.remove(0).clone();
      }

      //add right row
      k=size -1;
      for (i = 1; i< size; i++) { 
        blocks[i+listNumber][j][k+listNumber] = list.remove(0).clone();
      }

      //add bottom
      i=size-1;
      for (k = size-2; k>=0; k--) {
        blocks[i+listNumber][j][k+listNumber] = list.remove(0).clone();
      }

      //add left
      k=0;
      for (i = size-2; i>=1; i--) {
        blocks[i+listNumber][j][k+listNumber] = list.remove(0).clone();
      }
      break;

    case 2:
      //return all blocks with the y index of "index"
      k = index;

      //add all on top row
      j = 0;
      for (i = 0; i< size; i++) { 
        blocks[i+listNumber][j+listNumber][k] = list.remove(0).clone();
      }

      //add right row
      i=size-1;
      for (j = 1; j< size; j++) { 
        blocks[i+listNumber][j+listNumber][k] = list.remove(0).clone();
      }

      //add bottom
      j=size-1;
      for (i = size-2; i>=0; i--) {
        blocks[i+listNumber][j+listNumber][k] = list.remove(0).clone();
      }

      //add left
      i=0;
      for (j = size-2; j>=1; j--) {
        blocks[i+listNumber][j+listNumber][k] = list.remove(0).clone();
      }
      break;
    }
    for ( i = 0; i< numberOfSides; i++) { 
      for ( j = 0; j< numberOfSides; j++) { 
        for ( k = 0; k< numberOfSides; k++) { 
          blocks[i][j][k].pos = new PVector(i, j, k);
        }
      }
    }
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------
  //returns a list of all the blocks in that row/column thing
  //returns them in an order going clockwise around the center
  //todo only works for 3 length rubix cube
  ArrayList<Block> getList(int index, int xOrYOrZ, int listNumber) {
    ArrayList<Block> list = new ArrayList();
    int i = 0;
    int j = 0;
    int k = 0;
    int size = numberOfSides-listNumber*2;

    switch(xOrYOrZ) {
    case 0:
      //return all blocks with the x index of "index"
      i = index;

      //add all on top row
      k = 0;
      for (j = 0; j< size; j++) { 
        list.add(blocks[i][j+listNumber][k+listNumber]);
      }

      //add right row
      j=size-1;
      for (k = 1; k< size; k++) { 
        list.add(blocks[i][j+listNumber][k+listNumber]);
      }

      //add bottom
      k=size-1;
      for (j = size-2; j>=0; j--) {
        list.add(blocks[i][j+listNumber][k+listNumber]);
      }

      //add left
      j=0;
      for (k = size-2; k>=1; k--) {
        list.add(blocks[i][j+listNumber][k+listNumber]);
      }
      break;
    case 1:
      //return all blocks with the y index of "index"
      j = index;

      //add all on top row
      i = 0;
      for (k = 0; k< size; k++) { 
        list.add(blocks[i+listNumber][j][k+listNumber]);
      }

      //add right row
      k=size -1;
      for (i = 1; i< size; i++) { 
        list.add(blocks[i+listNumber][j][k+listNumber]);
      }

      //add bottom
      i=size-1;
      for (k = size-2; k>=0; k--) {
        list.add(blocks[i+listNumber][j][k+listNumber]);
      }

      //add left
      k=0;
      for (i = size-2; i>=1; i--) {
        list.add(blocks[i+listNumber][j][k+listNumber]);
      }
      break;

    case 2:
      //return all blocks with the y index of "index"
      k = index;

      //add all on top row
      j = 0;
      for (i = 0; i< size; i++) { 
        list.add(blocks[i+listNumber][j+listNumber][k]);
      }

      //add right row
      i=size -1;
      for (j = 1; j< size; j++) { 
        list.add(blocks[i+listNumber][j+listNumber][k]);
      }

      //add bottom
      j=size-1;
      for (i = size-2; i>=0; i--) {
        list.add(blocks[i+listNumber][j+listNumber][k]);
      }

      //add left
      i=0;
      for (j = size-2; j>=1; j--) {
        list.add(blocks[i+listNumber][j+listNumber][k]);
      }
      break;
    }
    return list;
  }

  void showBlacks() {
    if (turning && !turningWholeCube) {
      pushMatrix();
      translate((-numberOfSides*blockWidth)/2.0, (-numberOfSides*blockWidth)/2.0, (-numberOfSides*blockWidth)/2.0); 
      //now we are at 0,0,0
      fill(0);
      noStroke();

      switch(rotationAxis) {
      case 0:
        break;

      case 1: //yaxis
        translate((numberOfSides*blockWidth)/2.0, (numberOfSides*blockWidth)/2.0, (numberOfSides*blockWidth)/2.0);
        rotateZ(PI/2);
        translate((-numberOfSides*blockWidth)/2.0, (-numberOfSides*blockWidth)/2.0, (-numberOfSides*blockWidth)/2.0); 
        break;
      case 2://zaxis
        translate((numberOfSides*blockWidth)/2.0, (numberOfSides*blockWidth)/2.0, (numberOfSides*blockWidth)/2.0);
        rotateY(-PI/2);
        translate((-numberOfSides*blockWidth)/2.0, (-numberOfSides*blockWidth)/2.0, (-numberOfSides*blockWidth)/2.0); 
        break;
      }


      if (rotatingIndex !=0) {
        beginShape();
        vertex(blockWidth*rotatingIndex, 0, 0);
        vertex(blockWidth*rotatingIndex, numberOfSides*blockWidth, 0);
        vertex(blockWidth*rotatingIndex, numberOfSides*blockWidth, numberOfSides*blockWidth);
        vertex(blockWidth*rotatingIndex, 0, numberOfSides*blockWidth);
        endShape(CLOSE);
      }
      if (rotatingIndex !=numberOfSides-1) {
        beginShape();
        vertex(blockWidth*(rotatingIndex+1), 0, 0);
        vertex(blockWidth*(rotatingIndex+1), numberOfSides*blockWidth, 0);
        vertex(blockWidth*(rotatingIndex+1), numberOfSides*blockWidth, numberOfSides*blockWidth);
        vertex(blockWidth*(rotatingIndex+1), 0, numberOfSides*blockWidth);
        endShape(CLOSE);
      }
      pushMatrix();
      translate((numberOfSides*blockWidth)/2.0, (numberOfSides*blockWidth)/2.0, (numberOfSides*blockWidth)/2.0);
      if (turningClockwise) {
        rotateX(-rotationAngle);
      } else {
        rotateX(rotationAngle);
      }
      translate((-numberOfSides*blockWidth)/2.0, (-numberOfSides*blockWidth)/2.0, (-numberOfSides*blockWidth)/2.0); 
      if (rotatingIndex !=0) {
        beginShape();
        vertex(blockWidth*rotatingIndex, 0, 0);
        vertex(blockWidth*rotatingIndex, numberOfSides*blockWidth, 0);
        vertex(blockWidth*rotatingIndex, numberOfSides*blockWidth, numberOfSides*blockWidth);
        vertex(blockWidth*rotatingIndex, 0, numberOfSides*blockWidth);
        endShape(CLOSE);
      }
      if (rotatingIndex !=numberOfSides-1) {
        beginShape();
        vertex(blockWidth*(rotatingIndex+1), 0, 0);
        vertex(blockWidth*(rotatingIndex+1), numberOfSides*blockWidth, 0);
        vertex(blockWidth*(rotatingIndex+1), numberOfSides*blockWidth, numberOfSides*blockWidth);
        vertex(blockWidth*(rotatingIndex+1), 0, numberOfSides*blockWidth);
        endShape(CLOSE);
      }

      popMatrix();
      popMatrix();
    }
  }


  //Block[][] getFace(char face) {
  //  int minI =0;
  //  int maxI = n-1;
  //  int minJ = 0;
  //  int maxJ = n-1;
  //  int minK =0;
  //  int maxK = n-1;
  //  switch(face) {
  //  case 'F':
  //    minK = n-1;
  //    break;
  //  case 'B':
  //    minI = n-1;
  //    maxI = 0;
  //    maxK = 0;
  //    break;
  //  case 'L':
  //    maxI = 0;
  //    break;
  //  case 'R':
  //    minI = n-1;
  //    minK = n-1;
  //    maxK = 0;
  //    break;
  //  case 'U':
  //    maxJ = 0;
  //    break;
  //  case 'D':
  //    minJ = n-1;
  //    maxK = 0;
  //    minK = n-1;
  //    break;
  //  }

  //  Block[][] faceArr = new Block[n][n];
  //  int xCounter = 0;
  //  int yCounter =0;
  //  int negationI = 1;
  //  if (maxI!=minI) {
  //    negationI = (maxI-minI)/(abs(maxI-minI));
  //  }

  //  for (int i = minI; i!=maxI+negationI; i+= negationI) {
  //    int negationJ = 1;
  //    if (maxJ!=minJ) {
  //      negationJ = (maxJ-minJ)/(abs(maxJ-minJ));
  //    }

  //    for (int j = minJ; j!=maxJ+negationJ; j+= negationJ) {
  //      int negationK = 1;
  //      if (maxK!=minK) {
  //        negationK = (maxK-minK)/(abs(maxK-minK));
  //      }
  //      for (int k = minK; k!=maxK+negationK; k+= negationK) {
  //        faceArr[xCounter][yCounter] = blocks[i][j][k];
  //        xCounter++;
  //        if (xCounter ==n) {
  //          xCounter = 0;
  //          yCounter++;
  //          if (yCounter == n) {
  //            return faceArr;
  //          }
  //        }
  //      }
  //    }
  //  }
  //  println("Fuck");
  //  return null;
  //}



  Block[][] getFace(char face) {

    Block[][] faceArr = new Block[n][n];

    switch(face) {
    case 'F':
      for (int i = 0; i< n; i++) { 
        for (int j = 0; j<n; j++) {
          faceArr[i][j] = blocks[i][j][n-1];
        }
      }
      return faceArr;
    case 'B':
      for (int i = 0; i< n; i++) { 
        for (int j = 0; j<n; j++) {
          faceArr[i][j] = blocks[n-1-i][j][0];
        }
      }
      return faceArr;

    case 'L':
      for (int k = 0; k< n; k++) { 
        for (int j = 0; j<n; j++) {
          faceArr[k][j] = blocks[0][j][k];
        }
      }
      return faceArr;      
    case 'R':
      for (int i = 0; i< n; i++) { 
        for (int j = 0; j<n; j++) {
          faceArr[i][j] = blocks[n-1][j][n-1-i];
        }
      }
      return faceArr;
    case 'U':
      for (int i = 0; i< n; i++) { 
        for (int j = 0; j<n; j++) {
          faceArr[i][j] = blocks[i][0][j];
        }
      }
      return faceArr;
    case 'D':
      for (int i = 0; i< n; i++) { 
        for (int j = 0; j<n; j++) {
          faceArr[i][j] = blocks[i][n-1][n-1-j];
        }
      }
      return faceArr;
    }

    println("Fuck");
    return null;
  }
}
