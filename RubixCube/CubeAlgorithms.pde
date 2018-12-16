class CubeAlgorithms { //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
  Cube cube;
  int stageNo = 0;
  int largeCubeStageNo =0;
  boolean part1 = true;
  int completedCorners = 0;
  int completedEdges = 0;
  int turnsDone = 0;
  int rowStage =0;
  int rowUpTo = 0;

  int rowCounter =1;
  Block target;
  boolean newTarget = true;
  int targetId =0;
  boolean doneRedCenterRow = false;
  CubeAlgorithms(Cube cube) {
    this.cube = cube;
    if (numberOfSides ==3) {
      part1=false;
      largeCubeStageNo = 10;
    }
  }

  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //called whenever the turn string is empty
  void continueSolve() {
    if (part1) {
      switch(largeCubeStageNo) {

      case -1:

        doEdges();
        break;
      case 0:      

        positionFace(green, 'D', 'X');
        largeCubeStageNo ++;
        return;
      case 1:
        FirstCenter();
        break;

      case 2:

        SecondCenter();
        break;
      case 3:
        positionFace(red, 'L', 'Y');
        largeCubeStageNo ++;
        break;
      case 4:

        ThirdCenter();
        break;
      case 5:
        positionFace(yellow, 'L', 'Y');
        largeCubeStageNo ++;
        break;
      case 6:
        FourthCenter();
        break;

      case 7:
        positionFace(yellow, 'D', 'Z');
        largeCubeStageNo ++;
        break;
      case 8:
        finalCenters();
        break;
      case 9:
        doEdges();
        break;
      default:
        //setup();
        //pause = true;
        part1 = false;
        return;
      }
    } else {

      switch(stageNo) {

      case 0://cross
        greenCross();    
        break;
      case 1:
        positionBottomCorners();    
        break;
      case 2:
        finishBottom2Rows();    
        break;
      case 3:
        positionTopCross();    
        break;
      case 4:
        finishTopCross();    
        break;
      case 5:
        getCornersInCorrectPositions();
        break;
      case 6:
        finalRotations();
        break;
      case 7:
        int globalTimer = millis()-startTime;

        if (repeatSolves) {
          if (globalTimer <4109) {


            resetCube();
            //pause = true;
            println("new cube", solveCounterThing, globalTimer);
            solveCounterThing++;
          } else {
            pause = true; 
            println("Solved " + solveCounterThing + " rubik's cubes in " +(globalTimer/1000.0)+ " seconds");
            println("averageTime = " + (float(globalTimer)/float(solveCounterThing)));
          }
        } else {
          pause = true; 

          println("Solved in " +(globalTimer/1000.0)+ " seconds");
        }
        return;
      }
    }
  }
  //edge stuff
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  void doEdges() {
    color[][] colorOrder = {{red, blue}, {red, white}, {red, green}, {red, yellow}, {orange, blue}, {orange, white}, {orange, green}, {orange, yellow}, {white, green}, {yellow, green}, {blue, yellow}, {blue, white}};
    for (int i = 0; i< colorOrder.length; i++) {
      if (!edgeFinished(colorOrder[i][0], colorOrder[i][1])) {
        solveEdge(colorOrder[i][0], colorOrder[i][1]);
      }
      if (moreTurns()) {
        return;
      }
    }



    //cube.rotationSpeed = PI/40.0;
    //setup();
    //return;

    for (int i = 0; i< colorOrder.length; i++) {
      if (!edgeFinishedWithRotation(colorOrder[i][0], colorOrder[i][1])) {
        parityFixer(colorOrder[i][0], colorOrder[i][1]);
        return;
      }
    }



    largeCubeStageNo++;
  }

  void parityFixer(color c1, color c2) {
    Block middlePiece = getEdgePiece(c1, c2, middle);
    char f1 = middlePiece.getFace(c1);
    char f2 = middlePiece.getFace(c2);
    if (f1 != 'F') {
      String temp =  getDirection(f1, 'F');
      //println(f1, "F", temp);

      turns+=temp;
      //println("temp1 " + temp);
      if (moreTurns()) {
        //println("Turnes" + turns);
        return;
      }
    }
    if (f2!='U') {
      if (f2 == 'L') {
        turns+="Z'";
      }
      if (f2 == 'D') {
        turns+="ZZ";
      }
      if (f2 =='R') {

        turns+="Z";
      }
      if (moreTurns()) {
        //println("Turnes" + turns);

        return;
      }
    }

    //so now its up and front
    Block[][] frontFace = cube.getFace('F');
    ArrayList<Integer> parityPositions = new ArrayList();
    //get all the positions which are shit
    for (int i = 1; i< n-1; i++) {
      if (frontFace[i][0].getFace(c1) != f1) {
        parityPositions.add(i);
      }
    } 

    //println("pairirir");
    for (int i = 0; i<parityPositions.size(); i++) {
      //println(parityPositions.get(i));
    } 
    //ok now lets fuck em up
    moveAllParities(parityPositions, 0, false, false);
    turnOs.add( charToTurnO('U', true));
    turnOs.add( charToTurnO('U', true));
    moveAllParities(parityPositions, 0, true, true);
    turnOs.add( charToTurnO('F', true));
    turnOs.add( charToTurnO('F', true));
    moveAllParities(parityPositions, 0, false, true);
    turnOs.add( charToTurnO('F', true));
    turnOs.add( charToTurnO('F', true));
    moveAllParities(parityPositions, 0, false, false);
    moveAllParities(parityPositions, 0, false, false);
    turnOs.add( charToTurnO('U', true));
    turnOs.add( charToTurnO('U', true));
    moveAllParities(parityPositions, 0, true, false);
    turnOs.add( charToTurnO('U', true));
    turnOs.add( charToTurnO('U', true));
    moveAllParities(parityPositions, 0, false, false);
    turnOs.add( charToTurnO('U', true));
    turnOs.add( charToTurnO('U', true));
    turnOs.add( charToTurnO('F', true));
    turnOs.add( charToTurnO('F', true));
    moveAllParities(parityPositions, 0, false, false);
    moveAllParities(parityPositions, 0, false, false);
    turnOs.add( charToTurnO('F', true));
    turnOs.add( charToTurnO('F', true));
    //printTurnos();
  }

  void moveAllParities(ArrayList<Integer> parities, int axis, boolean clockwise, boolean left) {
    for (int i = 0; i< parities.size(); i++) {
      if (left &&  parities.get(i)<middle) {
        //println("herherherherherher");
        turnOs.add(new TurnO(0, parities.get(i), clockwise));
      }
      if (!left &&  parities.get(i)>middle) {
        //println("herherherherherherRIGHT");

        turnOs.add(new TurnO(0, parities.get(i), !clockwise));
      }
    }
  }

  void solveEdge(color c1, color c2) {
    color[] cols = {c1, c2};
    Block edgeCenter = getEdgePiece(c1, c2, middle);

    if (!cube.blocks[n-1][middle][n-1].matchesColors(cols)) {
      //position front
      String edgeFaces = edgeCenter.getFaces();
      turnOs.addAll(moveEdgeToFrontRight(edgeFaces.charAt(0), edgeFaces.charAt(1)));
      return;
    }

    //now center is in front right
    for (int i = 1; i<n-1; i++) {
      if (!cube.blocks[n-1][i][n-1].matchesColors(cols)) {
        if (newTarget) {
          target = getEdgePieceNotFrontRight(c1, c2, i);
          targetId = target.id;
        } else {
          target = getEdgePieceNotFrontRight(c1, c2, i);
          if (target.id != targetId) {
            target = getEdgePieceNotFrontRight(c1, c2, i, target);
          }
        }
        String edgeFaces = target.getFaces();
        turnOs.addAll(moveEdgeToFrontLeft(edgeFaces.charAt(0), edgeFaces.charAt(1)));
        if (moreTurns()) {
          //println("ahh");
          newTarget = false;
          return;
        }

        //now target is in middle row

        //now we need to check if they are facing the same way
        String targetFaces = target.getFaces();
        String centerFaces = edgeCenter.getFaces();
        char rightMostTargetFace = getRightMostMiddleChar(targetFaces);
        char rightMostCenterFace = getRightMostMiddleChar(centerFaces);


        if (target.getColorFromFace(rightMostTargetFace) == edgeCenter.getColorFromFace(rightMostCenterFace)) {
          //println("this");
          //todo check if its already in position
          if (rightMostTargetFace == 'F') { 
            turnOs.add( charToTurnO('L', true));
            turnOs.add( charToTurnO('L', true));
          } else {
            turnOs.add( charToTurnO(rightMostTargetFace, true));
            turnOs.add( charToTurnO(rightMostTargetFace, true));
          }
          newTarget = false;

          return;
        }

        //println(targetFaces, centerFaces, rightMostTargetFace, rightMostCenterFace, "also im here");
        //now the target is facing the opposite direction to the thing
        turnOs.addAll(getTurnObjects(rightMostCenterFace, rightMostTargetFace, (int)(n-1-target.pos.y), 1));
        if (targetFaces.indexOf(rightMostTargetFace) ==0) {
          turnOs.addAll(getEdgeFlippingTurns(targetFaces.charAt(1), rightMostTargetFace));
        } else {
          turnOs.addAll(getEdgeFlippingTurns(targetFaces.charAt(0), rightMostTargetFace));
        }
        turnOs.addAll(getTurnObjects(rightMostTargetFace, rightMostCenterFace, (int)(n-1-target.pos.y), 1));
        newTarget = true;
        return;
      } else if (cube.blocks[n-1][i][n-1].getFace(c1) !=edgeCenter.getFace(c1)) {
        //println("fuck oh");
      }
      //newTarget = true;
    }
  }

  char getRightMostMiddleChar(String s) {
    return getRightMostMiddleChar(s.charAt(0), s.charAt(1));
  }
  char getRightMostMiddleChar(char c1, char c2) {
    String faceOrder= "FRBL";
    int f1 = faceOrder.indexOf(c1);
    int f2 = faceOrder.indexOf(c2);
    if (abs(f1-f2) ==1) {
      if (f1>f2) {
        return c1;
      } else {
        return c2 ;
      }
    } else {
      if (f1<f2) {
        return c1;
      } else {
        return c2 ;
      }
    }
  }
  Block getEdgePieceNotFrontRight(color c1, color c2, int edgePos) {
    String faces = "FBLRUD";
    color[] cols = {c1, c2};

    for (int i = 0; i<faces.length(); i++) {
      Block[][] face = cube.getFace(faces.charAt(i));
      if (face[edgePos][0].matchesColors(cols) && !face[edgePos][0].getFaces().equals("RF")) {
        return face[edgePos][0];
      }
      if (face[n-1-edgePos][0].matchesColors(cols) && !face[n-1-edgePos][0].getFaces().equals("RF")) {
        return face[n-1-edgePos][0];
      }
      if (face[n-1-edgePos][n-1].matchesColors(cols)&& !face[n-1-edgePos][n-1].getFaces().equals("RF")) {
        return face[n-1-edgePos][n-1];
      }
      if (face[edgePos][n-1].matchesColors(cols)&& !face[edgePos][n-1].getFaces().equals("RF")) {
        return face[edgePos][n-1];
      }
      if (face[0][edgePos].matchesColors(cols)&& !face[0][edgePos].getFaces().equals("RF")) {
        return face[0][edgePos];
      }
      if (face[n-1][edgePos].matchesColors(cols)&& !face[n-1][edgePos].getFaces().equals("RF")) {
        return face[n-1][edgePos];
      }
      if (face[n-1][n-1-edgePos].matchesColors(cols)&& !face[n-1][n-1-edgePos].getFaces().equals("RF")) {
        return face[n-1][n-1-edgePos];
      }
      if (face[0][n-1-edgePos].matchesColors(cols)&& !face[0][n-1-edgePos].getFaces().equals("RF")) {
        return face[0][n-1-edgePos];
      }
    }
    return null;
  }

  Block getEdgePieceNotFrontRight(color c1, color c2, int edgePos, Block notThisOne) {
    String faces = "FBLRUD";
    color[] cols = {c1, c2};

    for (int i = 0; i<faces.length(); i++) {
      Block[][] face = cube.getFace(faces.charAt(i));
      if (face[edgePos][0].matchesColors(cols) && !face[edgePos][0].getFaces().equals("RF") && face[edgePos][0] != notThisOne) {
        return face[edgePos][0];
      }
      if (face[n-1-edgePos][0].matchesColors(cols) && !face[n-1-edgePos][0].getFaces().equals("RF")&& face[n-1-edgePos][0] != notThisOne) {
        return face[n-1-edgePos][0];
      }
      if (face[n-1-edgePos][n-1].matchesColors(cols)&& !face[n-1-edgePos][n-1].getFaces().equals("RF")&& face[n-1-edgePos][n-1] != notThisOne) {
        return face[n-1-edgePos][n-1];
      }
      if (face[edgePos][n-1].matchesColors(cols)&& !face[edgePos][n-1].getFaces().equals("RF")&& face[edgePos][n-1] != notThisOne) {
        return face[edgePos][n-1];
      }
      if (face[0][edgePos].matchesColors(cols)&& !face[0][edgePos].getFaces().equals("RF")&& face[0][edgePos] != notThisOne) {
        return face[0][edgePos];
      }
      if (face[n-1][edgePos].matchesColors(cols)&& !face[n-1][edgePos].getFaces().equals("RF")&& face[n-1][edgePos] != notThisOne) {
        return face[n-1][edgePos];
      }
      if (face[n-1][n-1-edgePos].matchesColors(cols)&& !face[n-1][n-1-edgePos].getFaces().equals("RF")&& face[n-1][n-1-edgePos] != notThisOne) {
        return face[n-1][n-1-edgePos];
      }
      if (face[0][n-1-edgePos].matchesColors(cols)&& !face[0][n-1-edgePos].getFaces().equals("RF")&& face[0][n-1-edgePos] != notThisOne) {
        return face[0][n-1-edgePos];
      }
    }
    return null;
  }
  Block getEdgePiece(color c1, color c2, int edgePos) {
    String faces = "FBLRUD";
    color[] cols = {c1, c2};

    for (int i = 0; i<faces.length(); i++) {
      Block[][] face = cube.getFace(faces.charAt(i));
      if (face[edgePos][0].matchesColors(cols)) {
        return face[edgePos][0];
      }
      if (face[n-1-edgePos][0].matchesColors(cols)) {
        return face[n-1-edgePos][0];
      }
      if (face[n-1-edgePos][n-1].matchesColors(cols)) {
        return face[n-1-edgePos][n-1];
      }
      if (face[edgePos][n-1].matchesColors(cols)) {
        return face[edgePos][n-1];
      }
      if (face[0][edgePos].matchesColors(cols)) {
        return face[0][edgePos];
      }
      if (face[n-1][edgePos].matchesColors(cols)) {
        return face[n-1][edgePos];
      }
      if (face[n-1][n-1-edgePos].matchesColors(cols)) {
        return face[n-1][n-1-edgePos];
      }
      if (face[0][n-1-edgePos].matchesColors(cols)) {
        return face[0][n-1-edgePos];
      }
    }
    return null;
  }


  boolean edgeFinished(char f1, char f2) {
    Block[][] face1 = cube.getFace(f1);
    Block[][] face2 = cube.getFace(f2);
    ArrayList<Block> common = new ArrayList();
    for (int i = 0; i< n; i++) {
      for (int j = 0; j< n; j++) {
        if (i==0 || i==n-1 || j==0 || j==n-1 ) {
          for (int k = 0; k<n; k++) {
            for (int l = 0; l<n; l++) {
              if (face1[i][j] == face2[k][l] && face1[i][j].numberOfCols ==2) {
                common.add(face1[i][j]);
              }
            }
          }
        }
      }
    }

    color[] cols = common.get(0).getColors();
    for (int i = 1; i<common.size(); i++) {
      if (!common.get(i).matchesColors(cols)) {
        return false;
      }
    }

    return true;
  }

  boolean edgeFinishedWithRotation(char f1, char f2) {
    Block[][] face1 = cube.getFace(f1);
    Block[][] face2 = cube.getFace(f2);
    ArrayList<Block> common = new ArrayList();
    for (int i = 0; i< n; i++) {
      for (int j = 0; j< n; j++) {
        if (i==0 || i==n-1 || j==0 || j==n-1 ) {
          for (int k = 0; k<n; k++) {
            for (int l = 0; l<n; l++) {
              if (face1[i][j] == face2[k][l] && face1[i][j].numberOfCols ==2) {
                common.add(face1[i][j]);
              }
            }
          }
        }
      }
    }

    color[] cols = common.get(0).getColors();
    color f1Color = common.get(0).getColorFromFace(f1);
    for (int i = 1; i<common.size(); i++) {
      if (!common.get(i).matchesColors(cols) || common.get(i).getColorFromFace(f1) != f1Color) {
        return false;
      }
    }

    return true;
  }

  boolean edgeFinishedWithRotation(color c1, color c2) {
    String faces = getEdgePiece(c1, c2, middle).getFaces();
    return edgeFinishedWithRotation(faces.charAt(0), faces.charAt(1));
  }

  boolean edgeFinished(color c1, color c2) {
    String faces = getEdgePiece(c1, c2, middle).getFaces();
    return edgeFinished(faces.charAt(0), faces.charAt(1));
  }

  ArrayList<TurnO> getEdgeFlippingTurns(char leftFace, char rightFace) {
    ArrayList<TurnO> t = new ArrayList();
    //println(leftFace, rightFace);
    t.add(charToTurnO(rightFace, true));
    t.add(charToTurnO(leftFace, false));
    t.add(charToTurnO('U', true));
    t.add(charToTurnO(rightFace, false));
    t.add(charToTurnO(leftFace, true));
    return t;
  }
  ArrayList<TurnO> getEdgeFlippingTurns() {
    ArrayList<TurnO> t = new ArrayList();
    t.add(charToTurnO('R', true));
    t.add(charToTurnO('F', false));
    t.add(charToTurnO('U', true));
    t.add(charToTurnO('R', false));
    t.add(charToTurnO('F', true));
    return t;
  }


  //  STAGE 8L
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  void finalCenters() {
    //cube.rotationSpeed = PI/20.0;

    for (int i = 1; i<n-1; i++) {
      for (int j = 1; j< n-1; j++) {
        if (!cube.blocks[i][j][n-1].matchesColors(orange)) {
          finalCenterThing(i, j);
        }
        if (moreTurns()) {
          return;
        }
      }
    }
    largeCubeStageNo++;
  }

  void finalCenterThing(int x, int y) {
    char faceChar = 'U';
    boolean found = false;
    Block[][] face = cube.getFace(faceChar);

    int xRel = x-middle;
    int yRel = middle-y;
    int xMatrix = middle+xRel;
    int yMatrix = middle-yRel;

    for (int j = 0; j< 4; j++) {
      if (face[xMatrix][yMatrix].matchesColors(orange)) {
        for (int k = 0; k<j; k++) {
          turnOs.add(charToTurnO(faceChar, false));
        } 
        found = true;
        break;
      }
      int temp = xRel;
      xRel = yRel;
      yRel = -temp ;
      xMatrix = middle+xRel;
      yMatrix = middle-yRel;
    }
    if (found) {
      turnOs.add(new TurnO(0, x, false)); //bring it out
      turnOs.add(charToTurnO('U', true));
      int temp = x-middle;
      xRel = middle-y;
      yRel = -temp ;
      xMatrix = middle+xRel;
      yMatrix = middle-yRel;
      boolean tripleTurn = false;
      if (x == xMatrix) {
        tripleTurn = true;
        turnOs.add(charToTurnO('U', true));
        turnOs.add(charToTurnO('U', true));

        temp = xRel;
        xRel = yRel;
        yRel = -temp ;
        xMatrix = middle+xRel;
        yMatrix = middle-yRel;
        temp = xRel;
        xRel = yRel;
        yRel = -temp ;
        xMatrix = middle+xRel;
        yMatrix = middle-yRel;
      }
      turnOs.add(new TurnO(0, xMatrix, false)); 
      turnOs.add(charToTurnO('U', false));
      if (tripleTurn) {
        turnOs.add(charToTurnO('U', false));
        turnOs.add(charToTurnO('U', false));
      }
      turnOs.add(new TurnO(0, x, true)); //bring it out
      turnOs.add(charToTurnO('U', true));
      if (tripleTurn) {
        turnOs.add(charToTurnO('U', true));
        turnOs.add(charToTurnO('U', true));
      }
      turnOs.add(new TurnO(0, xMatrix, true)); 
      return;
    }
  }


  //  STAGE 5L
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void FourthCenter() {
    doYellowRow(rowCounter);
    if (moreTurns() || rowStage != 3) {
      return;
    }
    rowStage =0;
    rowCounter++;
    if (rowCounter>= n-1) {
      largeCubeStageNo++;
    }
  }

  void doYellowRow(int y) {
    switch(rowStage) {
    case 0:
      //println(0);
      turnOs.add(new TurnO(1, y, false)); //bring it out
      turnOs.add(charToTurnO('F', true));
      rowStage++;
      return;

    case 1:
      //println(1);
      for (int i = middle-1; i> -middle; i--) {
        int xPos = n-1-y;
        if (!cube.blocks[xPos][middle-i][n-1].matchesColors(yellow)) {
          fillFaceGap('F', yellow, (xPos) - middle, i, 1, xPos, 4);
        }
        if (turnOs.size() >0 || turns.length()>0) {
          return;
        }
      }
      rowStage++;
      return;
    case 2:
      //println(2);
      turnOs.add(charToTurnO('F', false));
      turnOs.add(new TurnO(1, y, true));
      rowStage++;
      return;
    }
  }
  //this only works for y axis at the moment
  void fillFaceGap(char targetFace, color pieceColor, int xIndex, int yIndex, int axis, int rowNo, int faceNo) {

    String faces = "LRB";
    if (faceNo ==3) {
      faces = "RB";//left is where we store shit
    }

    if (faceNo == 4) {
      faces = "R";//left is where we store shit
    }
    ArrayList<TurnO> adds = new ArrayList();
    char faceChar = 'N';
    boolean found = false;
    for (int i = 0; i< faces.length(); i++) { 

      Block[][] face = cube.getFace(faces.charAt(i));
      faceChar = faces.charAt(i); 

      int xRel = xIndex;
      int yRel = yIndex;
      int xMatrix = middle+xRel;
      int yMatrix = middle-yRel;

      for (int j = 0; j< 4; j++) {
        if (face[xMatrix][yMatrix].matchesColors(pieceColor)) {
          for (int k = 0; k<j; k++) {
            turnOs.add(charToTurnO(faceChar, false));
          } 
          found = true;
          break;
        }
        int temp = xRel;
        xRel = yRel;
        yRel = -temp ;
        xMatrix = middle+xRel;
        yMatrix = middle-yRel;
      }


      if (found) {
        //println("foundItcubt");
        adds.addAll(getTurnObjects(faceChar, targetFace, middle-yIndex, axis));
        turnOs.addAll(adds);

        if (faceNo ==3) {
          if (middle - yIndex < n-1-rowNo) { //if gonna fuck up previously done stuff
            //println(middle, yIndex, n, rowNo);
            turnOs.add(charToTurnO('F', false));//get the thing back into its row 
            while (adds.size() >0) {//reverse the movements
              turnOs.add(adds.remove(adds.size()-1).getReverse());
            }
            turnOs.add(charToTurnO('F', true));//get the thing back into its row
          }
        }

        if (faceNo ==4) {
          if (middle - yIndex == n-1-rowNo) { //need to turn other way
            turnOs.add(charToTurnO('F', true));//get the thing back into its row
          } else {
            turnOs.add(charToTurnO('F', false));//get the thing back into its row
          }
          while (adds.size() >0) {//reverse the movements
            turnOs.add(adds.remove(adds.size()-1).getReverse());
          }
          if (middle - yIndex == n-1-rowNo) { //need to turn other way
            turnOs.add(charToTurnO('F', false));//get the thing back into its row
          } else {
            turnOs.add(charToTurnO('F', true));//get the thing back into its row
          }
        }




        return;
      }
    }



    //checked faces and none found
    //println("oi mate its fuckede");
    //println(targetFace, pieceColor, xIndex, yIndex, axis, rowNo, faceNo);
    getToLRB(targetFace, pieceColor, xIndex, yIndex, axis, rowNo, faceNo);
  }


  //this only works for y axis at the moment
  void getToLRB(char targetFace, color pieceColor, int xIndex, int yIndex, int axis, int rowNo, int faceNo) {

    String faces = "DFU";
    if (faceNo ==3) {
      faces = "FL";
    }
    if (faceNo ==4) {
      faces = "FB";
    }
    ArrayList<TurnO> adds = new ArrayList();
    char faceChar = 'N';
    int x = 0;
    int y =0;
    boolean found = false;
    for (int i = 0; i< faces.length(); i++) { 
      Block[][] face = cube.getFace(faces.charAt(i));
      faceChar = faces.charAt(i); 

      int xRel = xIndex;
      int yRel = yIndex;
      int xMatrix = middle+xRel;
      int yMatrix = middle-yRel;

      for (int j = 0; j< 4; j++) {
        if (face[xMatrix][yMatrix].matchesColors(pieceColor)) {
          //println(faceChar, xMatrix, yMatrix);
          if (faceChar != 'L' || n-1-rowNo<= yMatrix) {
            if (faceChar == 'D') {
              if (!rowFinished('D', xMatrix, pieceColor)) {
                found = true;
                break;
              } else {
                int temp = xRel;
                xRel = yRel;
                yRel = -temp ;
                xMatrix = middle+xRel;
                yMatrix = middle-yRel;
                continue;
              }
            }
            if (faceChar != 'F' || xMatrix!=rowNo) {
              found = true;
              break;
            }
          } else {
            //println("here 782");
          }
        }
        int temp = xRel;
        xRel = yRel;
        yRel = -temp ;
        xMatrix = middle+xRel;
        yMatrix = middle-yRel;
      }
      if (faceNo ==4) {
        if (found) {
          switch(faceChar) {
          case 'F':
            adds.add(charToTurnO('F', true));
            int temp = xRel;
            xRel = yRel;
            yRel = -temp ;
            xMatrix = middle+xRel;
            yMatrix = middle-yRel;
            adds.add(new TurnO(1, yMatrix, false));
            adds.add(charToTurnO('R', false));
            if (yMatrix != middle) {
              adds.add(charToTurnO('R', false));
            }
            adds.add(new TurnO(1, yMatrix, true));
            adds.add(charToTurnO('F', false));
            turnOs.addAll(adds);
            return;

          case 'B':
            adds.add(new TurnO(1, yMatrix, true));
            adds.add(charToTurnO('R', false));
            if (yMatrix != middle) {
              adds.add(charToTurnO('R', false));
            }
            adds.add(new TurnO(1, yMatrix, false));
            turnOs.addAll(adds);

            return;
          }
        }
      }

      if (faceNo ==3) {
        if (found) {
          switch(faceChar) {
          case 'F':
            adds.add(charToTurnO('F', true));
            int temp = xRel;
            xRel = yRel;
            yRel = -temp ;
            xMatrix = middle+xRel;
            yMatrix = middle-yRel;
            adds.add(new TurnO(1, yMatrix, false));
            adds.add(charToTurnO('R', false));
            if (yMatrix != middle) {
              adds.add(charToTurnO('R', false));
            }
            adds.add(new TurnO(1, yMatrix, true));
            adds.add(charToTurnO('F', false));
            turnOs.addAll(adds);
            return;
          case 'L':

            if (yRel == yIndex && xRel == xIndex) {
              //println("get it out", yRel, xRel);
              adds.add(new TurnO(1, yMatrix, false));
            } else {
              adds.add(new TurnO(1, yMatrix, true));
              adds.add(charToTurnO('B', false));
              if (yMatrix!=middle) {
                adds.add(charToTurnO('B', false));
              }
              adds.add(new TurnO(1, yMatrix, false));
            }
            turnOs.addAll(adds);

            return;
          }
        } else {
          //println("not found and thats nor great");
        }
      } else if (found) {
        switch(faceChar) {
        case 'F':
          adds.add(charToTurnO('F', true));
          int temp = xRel;
          xRel = yRel;
          yRel = -temp ;
          xMatrix = middle+xRel;
          yMatrix = middle-yRel;
          adds.add(new TurnO(1, yMatrix, true));
          adds.add(charToTurnO('F', false));
          turnOs.addAll(adds);
          return;
        case 'U':
          if (faceNo ==2) {
            adds.add(charToTurnO('U', true));
            temp = xRel;
            xRel = yRel;
            yRel = -temp ;
            xMatrix = middle+xRel;
            yMatrix = middle-yRel;
          }
          adds.add(new TurnO(2, yMatrix, true));
          adds.add(charToTurnO('L', true));
          adds.add(charToTurnO('L', true));

          //adds.add(charToTurnO('L', true));
          adds.add(new TurnO(2, yMatrix, false));
          if (faceNo ==2) {
            adds.add(charToTurnO('U', false));
          }
          turnOs.addAll(adds);
          return;

        case 'D':
          //println("<--------------------------------------------its down boi");
          //cube.rotationSpeed = PI/50.0;
          adds.add(charToTurnO('D', true));
          //adds.add(charToTurnO('L', true));
          temp = xRel;
          xRel = yRel;
          yRel = -temp ;
          xMatrix = middle+xRel;
          yMatrix = middle-yRel;
          //adds.add(charToTurnO('L', true));
          adds.add(new TurnO(2, n-1- yMatrix, false));
          adds.add(charToTurnO('D', false));
          turnOs.addAll(adds);
          return;
        }
      }
    }
    //println("FUCKUCKCUCKCUKCUCKCUC<MCUKCUCKCKCKKCKCKK");
  }
  //  STAGE 3L
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void ThirdCenter() {
    //println("-------------------------------------------------");
    //cube.rotationSpeed = PI/20.0;
    //if (!doneRedCenterRow) {
    //  doRedRow(middle);
    //  if (moreTurns() || rowStage != 3) {
    //    return;
    //  }
    //  doneRedCenterRow = true;
    //}
    doRedRow(rowCounter);
    if (moreTurns() || rowStage != 3) {
      return;
    }
    rowStage =0;
    rowCounter++;

    if (rowCounter>= n-1) {
      rowCounter =0;
      largeCubeStageNo++;
    }
  }

  void doRedRow(int y) {
    switch(rowStage) {
    case 0:
      //println(0);
      turnOs.add(new TurnO(1, y, false)); //bring it out
      turnOs.add(charToTurnO('F', true));
      rowStage++;
      return;

    case 1:
      //println(1);
      for (int i = middle-1; i> -middle; i--) {
        int xPos = n-1-y;
        if (!cube.blocks[xPos][middle-i][n-1].matchesColors(red)) {
          fillFaceGap('F', red, (xPos) - middle, i, 1, xPos, 3);
        }
        if (turnOs.size() >0 || turns.length()>0) {
          return;
        }
      }
      rowStage++;
      return;
    case 2:
      //println(2);
      turnOs.add(charToTurnO('F', false));
      turnOs.add(new TurnO(1, y, true));
      rowStage++;
      return;
    }
  }




  //  STAGE 2L
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void SecondCenter() {
    //switch(rowUpTo) {
    //case 0:
    //if (!rowFinished('D', middle, green)) {
    //  doGreenRow(middle) ;
    //  if (turnOs.size()>0) {
    //    return;
    //  }
    //} else {
    //rowStage=0;



    if (!rowFinished('U', middle, blue)) {

      doMiddleBlueRow(); 
      return;
    }

    //cube.rotationSpeed = PI/30.0;

    for (int i = 1; i< n-1; i++) {
      if (i == middle) {
        continue;
      }
      if (!rowFinished('U', i, blue)) {
        doBlueRow(i); 
        return;
      } else if (rowStage ==2) {
        rowStage =0;
      }
    }
    //}

    largeCubeStageNo++;

    //DOES MIDDLE ROWQ HEWAPS OF TIMES

    //rowUpTo ++;
    //return;
    //case 1:

    //  doGreenRow(middle-1) ;
    //  if (turnOs.size()>0) {
    //    return;
    //  }
    //  //DOES MIDDLE ROWQ HEWAPS OF TIMES
    //  rowStage=0;
    //  rowUpTo ++;
    //  return;
  }
  //doGreenRow(middle-1) ;

  void doBlueRow(int x) {
    switch(rowStage) {

    case 0:
      //println("stage 0");
      for (int i = middle-1; i> -middle; i--) {
        if (!cube.blocks[x][middle-i][n-1].matchesColors(blue)) {
          fillFaceGap('F', blue, x-middle, i, 1, x, 2);
        }
        if (turnOs.size() >0 || turns.length()>0) {
          return;
        }
      }
      rowStage++;
      return;
    case 1:
      //println("stage 1");
      boolean uppyUppy = false;
      if (rowFinished('U', n-1-x, blue)) {
        uppyUppy = true;
        turnOs.add(charToTurnO('U', true));
        turnOs.add(charToTurnO('U', true));
      }

      turnOs.add(new TurnO(0, x, false));
      turnOs.add(charToTurnO('U', true));
      turnOs.add(charToTurnO('U', true));
      turnOs.add(new TurnO(0, x, true));

      if (!uppyUppy) {
        turnOs.add(charToTurnO('U', true));
        turnOs.add(charToTurnO('U', true));
      }
      rowStage++;
      return;
    }
  }

  //if (!cube.blocks[middle][middle-2][n-1].matchesColors(green)) {
  //  fillFaceGap('F', green, 0, 2, 1);
  //}
  //if (!cube.blocks[middle][middle-2][n-1].matchesColors(green)) {
  //  fillFaceGap('F', green, 0, 2, 1);
  //}
  //if (!cube.blocks[middle][middle-2][n-1].matchesColors(green)) {
  //  fillFaceGap('F', green, 0, 2, 1);
  //}
  //if (!cube.blocks[middle][middle-2][n-1].matchesColors(green)) {
  //  fillFaceGap('F', green, 0, 2, 1);
  //}
  //}  

  void doMiddleBlueRow() {
    for (int i = middle-1; i> -middle; i--) {
      if (i == middle) {
        continue;
      }
      if (!cube.blocks[middle][0][middle - i].matchesColors(blue)) {

        String faces = "LRBF";
        ArrayList<TurnO> adds = new ArrayList();
        char faceChar = 'N';
        boolean found = false;
        for (int k = 0; k< faces.length(); k++) { 

          Block[][] face = cube.getFace(faces.charAt(k));
          faceChar = faces.charAt(k); 

          int xRel = 0;
          int yRel = i;
          int xMatrix = middle+xRel;
          int yMatrix = middle-yRel;

          for (int j = 0; j< 4; j++) {
            if (face[xMatrix][yMatrix].matchesColors(blue)) {
              //println("found piece requires " + i + "face turns");
              ////println(f aceChar,);
              for (int l = 0; l<j; l++) {
                adds.add(charToTurnO(faceChar, false));
              } 
              found = true;
              break;
            }
            int temp = xRel;
            xRel = yRel;
            yRel = -temp ;
            xMatrix = middle+xRel;
            yMatrix = middle-yRel;
          }


          if (found) {
            adds.addAll(getTurnObjects(faceChar, 'R', middle-i, 1));
            adds.add(charToTurnO('R', true));
            xRel = 0;
            yRel = i;

            int temp = xRel;
            xRel = yRel;
            yRel = -temp ;
            xMatrix = middle+xRel;
            yMatrix = middle-yRel;

            adds.add(new TurnO(2, n-1-xMatrix, true));
            adds.add(charToTurnO('U', true));
            adds.add(new TurnO(2, n-1-xMatrix, false));
            adds.add(charToTurnO('U', false));


            turnOs.addAll(adds);
            return;
          }
        }



        //checked faces and none found
        //println("oi mate its fuckede");
        //getToLRB(targetFace, pieceColor, xIndex, yIndex, axis, rowNo);
      }
    }
  }


  //  STAGE 0L
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void FirstCenter() {

    //switch(rowUpTo) {
    //case 0:
    //if (!rowFinished('D', middle, green)) {
    //  doGreenRow(middle) ;
    //  if (turnOs.size()>0) {
    //    return;
    //  }
    //} else {
    //rowStage=0;


    if (!rowFinished('D', middle, green)) {
      doGreenRow(middle); 
      return;
    } else if (rowStage ==3) {
      rowStage =0;
    }
    for (int i = 1; i< n-1; i++) {
      if (i == middle) {
        continue;
      }
      if (!rowFinished('D', i, green)) {
        doGreenRow(i); 
        return;
      } else if (rowStage ==3) {
        rowStage =0;
      }
    }
    //}
    rowStage =0;
    largeCubeStageNo++;

    //DOES MIDDLE ROWQ HEWAPS OF TIMES

    //rowUpTo ++;
    //return;
    //case 1:

    //  doGreenRow(middle-1) ;
    //  if (turnOs.size()>0) {
    //    return;
    //  }
    //  //DOES MIDDLE ROWQ HEWAPS OF TIMES
    //  rowStage=0;
    //  rowUpTo ++;
    //  return;
  }
  //doGreenRow(middle-1) ;



  //if (!cube.blocks[middle][middle-2][n-1].matchesColors(green)) {
  //  fillFaceGap('F', green, 0, 2, 1);
  //}
  //if (!cube.blocks[middle][middle-2][n-1].matchesColors(green)) {
  //  fillFaceGap('F', green, 0, 2, 1);
  //}
  //if (!cube.blocks[middle][middle-2][n-1].matchesColors(green)) {
  //  fillFaceGap('F', green, 0, 2, 1);
  //}
  //if (!cube.blocks[middle][middle-2][n-1].matchesColors(green)) {
  //  fillFaceGap('F', green, 0, 2, 1);
  //}
  //}  

  void doGreenRow(int x) {
    switch(rowStage) {
    case 0:
      //println("stage 0");
      turnOs.add(new TurnO(0, x, false));
      rowStage++;
      return;
    case 1:
      //println("stage 1");
      for (int i = middle-1; i> -middle; i--) {
        if (!cube.blocks[x][middle-i][n-1].matchesColors(green)) {
          fillFaceGap('F', green, x-middle, i, 1, x);
        }
        if (turnOs.size() >0 || turns.length()>0) {
          return;
        }
      }
      rowStage++;
      return;
    case 2:
      //println("stage 2");
      turnOs.add(new TurnO(0, x, true));
      rowStage++;
      return;
    }
  }
  //this only works for y axis at the moment
  void fillFaceGap(char targetFace, color pieceColor, int xIndex, int yIndex, int axis, int rowNo) {

    String faces = "LRB";
    ArrayList<TurnO> adds = new ArrayList();
    char faceChar = 'N';
    boolean found = false;
    for (int i = 0; i< faces.length(); i++) { 

      Block[][] face = cube.getFace(faces.charAt(i));
      faceChar = faces.charAt(i); 

      int xRel = xIndex;
      int yRel = yIndex;
      int xMatrix = middle+xRel;
      int yMatrix = middle-yRel;

      for (int j = 0; j< 4; j++) {
        if (face[xMatrix][yMatrix].matchesColors(pieceColor)) {
          //println("found piece requires " + i + "face turns");
          ////println(f aceChar,);
          for (int k = 0; k<j; k++) {
            adds.add(charToTurnO(faceChar, false));
          } 
          found = true;
          break;
        }
        int temp = xRel;
        xRel = yRel;
        yRel = -temp ;
        xMatrix = middle+xRel;
        yMatrix = middle-yRel;
      }


      if (found) {
        adds.addAll(getTurnObjects(faceChar, targetFace, middle-yIndex, axis));
        turnOs.addAll(adds);
        return;
      }
    }



    //checked faces and none found
    //println("oi mate its fuckede");
    getToLRB(targetFace, pieceColor, xIndex, yIndex, axis, rowNo);
  }


  //this only works for y axis at the moment
  void getToLRB(char targetFace, color pieceColor, int xIndex, int yIndex, int axis, int rowNo) {
    //println("lolololololololololo ");
    String faces = "DFU";
    ArrayList<TurnO> adds = new ArrayList();
    char faceChar = 'N';
    int x = 0;
    int y =0;
    boolean found = false;
    for (int i = 0; i< faces.length(); i++) { 

      Block[][] face = cube.getFace(faces.charAt(i));
      faceChar = faces.charAt(i); 


      int xRel = xIndex;
      int yRel = yIndex;
      int xMatrix = middle+xRel;
      int yMatrix = middle-yRel;

      for (int j = 0; j< 4; j++) {
        if (face[xMatrix][yMatrix].matchesColors(pieceColor)) {
          ////println(f aceChar,);

          if (faceChar == 'D') {

            if (!rowFinished('D', xMatrix, green) || xRel == xIndex ) {
              //println("its NICEEEEEEEEE");

              found = true;
              break;
            } else {
              //println("its hererererereerer");
              int temp = xRel;
              xRel = yRel;
              yRel = -temp ;
              xMatrix = middle+xRel;
              yMatrix = middle-yRel;
              continue;
            }
          }
          if (faceChar != 'F' || xMatrix!=rowNo) {
            found = true;
            break;
          }
        }
        int temp = xRel;
        xRel = yRel;
        yRel = -temp ;
        xMatrix = middle+xRel;
        yMatrix = middle-yRel;
      }


      if (found) {
        switch(faceChar) {
        case 'F':
          adds.add(charToTurnO('F', true));
          int temp = xRel;
          xRel = yRel;
          yRel = -temp ;
          xMatrix = middle+xRel;
          yMatrix = middle-yRel;
          adds.add(new TurnO(1, yMatrix, true));
          adds.add(charToTurnO('F', false));
          turnOs.addAll(adds);
          return;
        case 'U':
          adds.add(new TurnO(2, yMatrix, true));
          adds.add(charToTurnO('L', true));
          //adds.add(charToTurnO('L', true));
          adds.add(new TurnO(2, yMatrix, false));
          turnOs.addAll(adds);
          return;

        case 'D':
          //println("its here boiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
          //cube.rotationSpeed = PI/50.0;
          adds.add(charToTurnO('D', true));
          //adds.add(charToTurnO('L', true));
          temp = xRel;
          xRel = yRel;
          yRel = -temp ;
          xMatrix = middle+xRel;
          yMatrix = middle-yRel;
          //adds.add(charToTurnO('L', true));
          adds.add(new TurnO(2, n-1- yMatrix, false));
          adds.add(charToTurnO('D', false));
          turnOs.addAll(adds);
          return;
        }
      } else {
        //println("offfofofofofofofofofofofo"); 
        //pause = true;
      }
    }



    //      if (face[middle-xIndex][middle-yIndex].matchesColors(pieceColor)) {
    //        x = xIndex;
    //        y = yIndex;
    //        if (faceChar != 'F' || x!=rowNo-middle) {
    //          break;
    //        }
    //      }
    //      if (face[middle-yIndex][middle+xIndex].matchesColors(pieceColor)) {
    //        x = yIndex;
    //        y = -xIndex;
    //        if (faceChar != 'F' || x!=rowNo-middle) {
    //          break;
    //        }
    //      }
    //      if (face[middle+xIndex][middle+yIndex].matchesColors(pieceColor)) {
    //        x = -xIndex;
    //        y = -yIndex;
    //        if (faceChar != 'F' || x!=rowNo-middle) {
    //          break;
    //        }
    //      }
    //      if (face[middle+yIndex][middle-xIndex].matchesColors(pieceColor)) {
    //        x = -yIndex;
    //        y = xIndex;
    //        if (faceChar != 'F' || x!=rowNo-middle) {
    //          break;
    //        }
    //      }
    //    }





    //so now face is in the desired spot but its on a different face 
    //adds.addAll(getTurnObjects(faceChar, targetFace, middle-yIndex, axis));
    //turnOs.addAll(adds);
    ////printTurnos();
  }


  boolean rowFinished(char face, int index, color col ) {
    Block[][] facePieces = cube.getFace(face);

    for (int i = 1; i< n-1; i++) {
      if (!facePieces[index][i].matchesColors(col)) {
        return false;
      }
    } 
    return true;
  }





  //  STAGE 6
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  void finalRotations() {
    if (!(getFaceColor('D') == blue)) {
      positionFace(blue, 'D', 'X');
      return;
    }
    //now blue is down
    if (correctRotation(cube.blocks[n-1][n-1][n-1])) {
      if (turnsDone==4) {
        ////println("FUCK you I did it");
        stageNo++;
        return;
      } else {
        turns+="D";
        turnsDone++;
        return;
      }
    } else {
      turns += "RUR'U'RUR'U'"; 
      return;
    }
  }

  boolean correctRotation(Block piece) {
    return(piece.colors[3] == blue);
  }

  //  STAGE 5
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  void getCornersInCorrectPositions() {
    int correctCounter = 0;
    Block correctPiece = cube.blocks[0][0][0];

    Block testPiece = cube.blocks[0][0][0];
    ////println("enteringthe thing");

    if (cornerInCorrectPosition('L', 'U', 'B', testPiece)) {
      correctCounter ++;
    }
    testPiece = cube.blocks[n-1][0][0];
    if (cornerInCorrectPosition('R', 'U', 'B', testPiece)) {
      correctCounter ++;
      correctPiece = cube.blocks[n-1][0][0];
    }

    testPiece = cube.blocks[n-1][0][n-1];
    if (cornerInCorrectPosition('R', 'U', 'F', testPiece)) {
      correctCounter ++;
      correctPiece = cube.blocks[n-1][0][n-1];
    }

    testPiece = cube.blocks[0][0][n-1];
    if (cornerInCorrectPosition('L', 'U', 'F', testPiece)) {
      correctCounter ++;
      correctPiece = cube.blocks[0][0][n-1];
    }

    if (correctCounter ==4) {
      ////println("allgbro");
      stageNo++;
      return;
    }

    if (correctCounter ==0) {
      ////println("none of them are good mate");
      turns += "URU'L'UR'U'L";
      return;
    }


    //only one is correct
    ////println("only one is tops  aye");
    String temp =getDirectionsCorners(correctPiece.pos, new PVector(n-1, 0, n-1));
    ////println("temp:" + temp);
    turns+=temp;
    turns+="URU'L'UR'U'L";
    turns += reverseDirections(temp);
    ////println("reverse Temp:" +  reverseDirections(temp));
  }


  boolean cornerInCorrectPosition(char face1, char face2, char face3, Block piece) {

    color c1 = getFaceColor(face1);
    color c2 = getFaceColor(face2);
    color c3 = getFaceColor(face3);


    if (piece.getFace(c1) == ' ') {
      return false;
    } else {

      ////println((piece.getFace(c1)));
    }
    if (piece.getFace(c2) == ' ') {
      return false;
    } else {

      ////println((piece.getFace(c2)));
    }
    if (piece.getFace(c3) == ' ') {
      return false;
    } else {

      ////println((piece.getFace(c3)));
    }
    return true;
  }

  //  STAGE 4
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void finishTopCross() {

    if (!(getFaceColor('F') == red)) {
      positionFace(red, 'F', 'Y');
      return;
    }

    color[] order = {orange, yellow, red, white, orange, yellow, red, white, orange, yellow};

    color[] currentOrder = {
      cube.blocks[middle][0][0].colors[4], //add back color
      cube.blocks[n-1][0][middle].colors[1], //right face
      cube.blocks[middle][0][n-1].colors[5], //front face
      cube.blocks[0][0][middle].colors[0], //left face
      cube.blocks[middle][0][0].colors[4] //add back color again

    };

    //also need to check if the order is already correct
    for (int i = 0; i< order.length - 4; i++) {
      boolean perfectMatch = true;
      for (int j = 0; j<4; j++) {
        if (order[i+j] != currentOrder[j]) {
          perfectMatch = false;
        }
      }
      if (perfectMatch) {
        for (int k = 0; k < i%4; k++) {
          turns+="U";
        }
        stageNo++;

        return;
      }
    }

    for (int i = 0; i< order.length - 4; i++) {
      boolean previousMatched = false;
      for (int j = 0; j<5; j++) {
        if (order[i+j] == currentOrder[j]) {
          if (previousMatched) {
            //foundPair
            //for each i rotate U
            for (int k = 0; k < i%4; k++) {
              turns+="U";
            }
            for (int k = 0; k< (i-1+j)%4; k++) {
              turns+="Y'";
            }

            turns+= "RUR'URUUR'U";
            stageNo++;
            return;
          } else {
            previousMatched = true;
          }
        } else {
          previousMatched = false;
        }
      }
    }
    turns+= "RUR'URUUR'";
    return;
  }
  //  STAGE 3
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void positionTopCross() {
    int numberOfBlueEdgesOnTop  = 0;
    //back,front,left, right
    boolean[] topBlueEdges={cube.blocks[middle][0][0].colors[2] == blue, cube.blocks[middle][0][n-1].colors[2] == blue, cube.blocks[0][0][middle].colors[2] == blue, cube.blocks[n-1][0][middle].colors[2] == blue};
    for (int i = 0; i< 4; i++) { 
      if (topBlueEdges[i]) {
        numberOfBlueEdgesOnTop ++;
      }
    }

    //case 1 cross is already formed
    if (numberOfBlueEdgesOnTop == 4) {
      stageNo ++;
      return;
    }

    //case 2 line on top

    if (topBlueEdges[0] && topBlueEdges[1]) {
      turns+= "UFRUR'U'F'"; 
      return;
    }

    if (topBlueEdges[2] && topBlueEdges[3] ) {
      turns+= "FRUR'U'F'";
      return;
    }

    //case 3 just a dot on top
    if (numberOfBlueEdgesOnTop ==0) {
      //this should convert it to case 4
      turns+= "FRUR'U'F'";
      return;
    }

    //case 4 a little L
    //first positionL to top left
    if (!topBlueEdges[0] && topBlueEdges[2]) {
      turns+="U";
    } else if (topBlueEdges[0] && !topBlueEdges[2]) {
      turns+="U'";
    } else if (!topBlueEdges[0] && !topBlueEdges[2]) {
      turns+="UU";
    }
    turns += "FRUR'U'RUR'U'F'";
  }



  //  STAGE 2
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  void finishBottom2Rows() {
    color[][] colorOrder = {{red, yellow}, {yellow, orange}, {orange, white}, {white, red}};
    while (completedEdges<4) {
      positionMiddleEdge(colorOrder[completedEdges][0], colorOrder[completedEdges][1]);
      if (turns.length() > 0) {
        return;
      }
      completedEdges++;
      //////println("Next edge");
    }
    stageNo++;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------
  void  positionMiddleEdge(color c1, color c2) {
    //c1 should be to the left of c2 when green is down



    color[] cols = {c1, c2};
    Block piece = findCenterEdge(cols);
    if (piece.pos.y ==0) {//top layer
      //////println("edge in top layer");
      color frontColor;
      if (piece.colors[2] == c1) {
        frontColor = c2;
      } else {
        frontColor = c1;
      }

      if (getFaceColor('F') != frontColor) {
        positionFace(frontColor, 'F', 'Y');
        //////println("turning to face");

        return;
      }

      //////println("facing correct direction");
      String temp = getDirectionsEdges(piece.pos, new PVector(middle, 0, n-1));
      if (!temp.equals("")) {
        //////println("positioning edge:" + temp);
        turns+=temp;
        return;
      }
      //now the piece is in the top center

      //////println("piece in top center");
      if (frontColor == c1) {//need to put it in the right 
        turns += "URU'R'U'F'UF";
      } else {
        turns += "U'L'ULUFU'F'";
      }
    } else if (piece.pos.y ==middle) {

      //////println("edge in second layer");
      boolean inCorrectSpotAndRotation = true;
      if (piece.colors[2] == c1) {
        color frontColor = c2;
        inCorrectSpotAndRotation = (pvectorsEqual(piece.pos, new PVector(0, middle, n-1)) && piece.colors[5] == getFaceColor('F'));
      } else {
        color frontColor = c1;
        inCorrectSpotAndRotation = (pvectorsEqual(piece.pos, new PVector(n-1, middle, n-1)) && piece.colors[5] == getFaceColor('F'));
      }


      if (!inCorrectSpotAndRotation) {
        //then its not in the right position
        //take it out 
        //////println("edge in wrong spot direction");

        turnCubeToFacePiece(piece, c1, 'Y') ;
        if (turns.length() !=0) {
          //////println("turning cube");
          return;
        }

        //////println("get that shit out of here");

        if (piece.pos.x == n-1) {
          turns += "URU'R'U'F'UF";
        } else {
          turns += "U'L'ULUFU'F'";
        }
      }
    }
  }

  //  STAGE 1
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void positionBottomCorners() {
    color[][] colorOrder = {{red, yellow}, {yellow, orange}, {orange, white}, {white, red}};
    while (completedCorners<4) {
      positionCornerAtBottom(colorOrder[completedCorners][0], colorOrder[completedCorners][1]);
      if (turns.length() > 0) {
        return;
      }
      completedCorners++;
    }
    stageNo++;
  }


  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------


  void  positionCornerAtBottom(color c1, color c2) {
    //c1 should be to the left of c2 when green is down



    color[] cols = {c1, c2, green};
    Block piece = findCornerPiece(cols);
    if (!(getFaceColor('F') == c1)) {
      positionFace(c1, 'F', 'Y');
      return;
    }

    if (piece.pos.y ==0) {//top layer
      String temp = getDirectionsCorners(piece.pos, new PVector(n-1, 0, n-1));
      if (!temp.equals("")) {
        turns+=temp;
        return;
      }
      //now the piece is in the top right
      if (piece.colors[5] == green) {
        turns+= "URU'R'";
      } else if (piece.colors[5] == c1) {
        turns += "RUR'U'";
      } else if (piece.colors[5] == c2) {
        turns += "RUUR'U'RUR'";
      }
      //done
    } else if (piece.pos.y == n-1) {
      if (!pvectorsEqual(piece.pos, new PVector(n-1, n-1, n-1)) || piece.colors[3] != green) {
        //then its not in the right position
        //take it out 
        String temp = getDirectionsCorners(piece.pos, new PVector(n-1, n-1, n-1));
        turns+= temp;
        ////////println("temp:" + temp);
        turns+= "RUR'";
        turns += reverseDirections(temp);
      }
    }
  }

  //  STAGE 0
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  void greenCross() {
    if (!(getFaceColor('D') == green)) {
      ////////println("Shit man");
      positionFace(green, 'D', 'X');
      return;
    }

    if (turns.length() != 0) {
      return;
    }
    positionGreenCrossColor(red);
    if (turns.length() != 0) {
      return;
    }
    positionGreenCrossColor(orange);
    if (turns.length() != 0) {
      return;
    }
    positionGreenCrossColor(yellow);
    if (turns.length() != 0) {
      return;
    }
    positionGreenCrossColor(white);
    if (turns.length() == 0) {
      stageNo++;
    }
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void positionGreenCrossColor(color col) {
    color[] colors = {col, green};
    Block piece = findCenterEdge(colors);
    if (piece.pos.y==n-1) {
      if (piece.getFace(green) == 'D') {
        if (getFaceColor(piece.getFace(col)) != col) {//if not inright place
          char faceToTurn = piece.getFace(col);
          turns += "" + faceToTurn+faceToTurn;
        }
        return;//ignore piece for now
      }
      //piece is on the bottom layer with green facing up
      char pieceFace =piece.getFace(green);
      String temp = getDirection(pieceFace, 'F');
      if (temp.length() ==2 && temp.charAt(0) == temp.charAt(1)) {
        temp = "YY";
      }
      turns+=temp;
      //now the piece we want is at the bottom front edge
      turns+= "FF";//chuck it at the top
      return;
    }
    if (piece.pos.y==middle) {//if in the middle row

      turnCubeToFacePiece(piece, green, 'Y');
      if (turns.length() > 0) {
        return;
      }

      if (piece.pos.x ==0) {
        turns+= "L'U'L";
      } else {
        turns += "RUR'";
      }
    }
    if (piece.pos.y==0) {//if in the top row
      ////////println("y=0");

      if (getFaceColor('F') != col) {
        positionFace(col, 'F', 'Y');//face the desired color to the front
        return;
      }
      if (piece.getFace(green) == 'F') {
        turns+="ULF'L'";
      } else if (piece.getFace(col) == 'F') {
        turns+= "FF";
      } else {
        char pieceFace =piece.getFace(col);
        if (pieceFace =='U') {
          pieceFace = piece.getFace(green);
        }

        String temp = getTurns(pieceFace, 'F', 0);
        temp = replaceDoubles(temp, 'U');
        ////////println(pieceFace, turns);

        turns +=temp;
      }
    }
  }

  //  HELPER FUNCTIONS
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------


  color getFaceColor(char face) {
    int middle = numberOfSides/2;
    int last = numberOfSides-1;
    switch( face) {
    case 'D':
      return(cube.blocks[middle][last][middle].colors[3]);
    case 'U':
      return(cube.blocks[middle][0][middle].colors[2]);
    case 'L':
      return(cube.blocks[0][middle][middle].colors[0]);
    case 'R':
      return(cube.blocks[last][middle][middle].colors[1]);
    case 'F':
      return(cube.blocks[middle][middle][last].colors[5]);
    case 'B':
      return(cube.blocks[middle][middle][0].colors[4]);
    }
    return color(0);
  }


  char getFaceGivenColor(color col) {
    String faces = "UDLRFB";
    for (int i = 0; i< 6; i++) { 
      if (getFaceColor(faces.charAt(i)) == col) {
        return faces.charAt(i);
      }
    }
    return ' ';
  }
  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------





  Block findCenterEdge(color[] pieceColors) {
    for (int i = 0; i< edgeCenters.length; i++) { 
      PVector vec = edgeCenters[i];
      int x = (int)vec.x;
      int y = (int)vec.y;
      int z = (int)vec.z;

      if (cube.blocks[x][y][z].matchesColors(pieceColors)) {
        return cube.blocks[x][y][z];//new PVector(i, j, k);
      }
    }
    return null;
  }

  Block findCornerPiece(color[] pieceColors) {

    for (int i = 0; i< numberOfSides; i+=n-1) { 
      for (int j = 0; j< numberOfSides; j+=n-1) { 
        for (int k = 0; k< numberOfSides; k+=n-1) { 
          if (cube.blocks[i][j][k].matchesColors(pieceColors)) {
            return cube.blocks[i][j][k];//new PVector(i, j, k);
          }
        }
      }
    }

    return null;
  }



  Block findPiece(color[] pieceColors) {

    for (int i = 0; i< numberOfSides; i++) { 
      for (int j = 0; j< numberOfSides; j++) { 
        for (int k = 0; k< numberOfSides; k++) { 
          if (cube.blocks[i][j][k].matchesColors(pieceColors)) {
            return cube.blocks[i][j][k];//new PVector(i, j, k);
          }
        }
      }
    }

    return null;
  }

  //ok so you only need to define a face piece by the position relative to the center in the 1st (top right) quadrant 
  //  for example the very top right face piece on a 7x7 cube would be x =2 y = 2
  Block findFacePiece(color pieceColor, int xIndex, int yIndex ) {
    xIndex += middle;
    yIndex += middle;
    String faces = "LRUDFB";
    for (int i = 0; i< faces.length(); i++) { 

      Block[][] face = cube.getFace(faces.charAt(i));


      if (face[xIndex][yIndex].matchesColors(pieceColor)) {
        return face[xIndex][yIndex];
      }
      if (face[yIndex][-xIndex].matchesColors(pieceColor)) {
        return face[yIndex][-xIndex];
      }
      if (face[-xIndex][-yIndex].matchesColors(pieceColor)) {
        return face[-xIndex][-yIndex];
      }
      if (face[-yIndex][xIndex].matchesColors(pieceColor)) {
        return face[-yIndex][xIndex];
      }
    }


    return null;
  }


  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void scramble() { 
    stageNo = 0;
    completedCorners = 0;
    completedEdges = 0;
    turnsDone = 0;


    if (n>3) {
      for (int i = 0; i< 15 * n; i++) { 
        turnOs.add(new TurnO());
      }
    } else {
      String options = "LRUDFBLRUDFBLRUDFBXYZ"; 
      for (int i = 0; i< 50; i++) { 
        turns += options.charAt(floor(random(options.length())));
      }
    }
  }

  //positions 

  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void positionFace(color col, char face, char turnDirectionThatWontFuckShitUp) {

    String faces = "UDLRFB";
    char fromFace = 'F';
    for (int i = 0; i< faces.length(); i++) { 
      if (getFaceColor(faces.charAt(i)) == col) {
        fromFace = faces.charAt(i);
        break;
      }
    }

    String temp = getDirection(fromFace, face);
    if (temp.length() ==2 && temp.charAt(0) == temp.charAt(1)) {
      temp = "" + turnDirectionThatWontFuckShitUp + turnDirectionThatWontFuckShitUp;
    }

    turns+=temp;
  }


  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------


  String replaceDoubles(String temp, char turnDirectionThatWontFuckShitUp) {
    if (temp.length() ==2 && temp.charAt(0) == temp.charAt(1)) {
      temp = "" + turnDirectionThatWontFuckShitUp + turnDirectionThatWontFuckShitUp;
    }
    return temp;
  }


  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  void turnCubeToFacePiece(Block piece, color col, char turnDirectionThatWontFuckShitUp) {
    char pieceFace =piece.getFace(col);
    String temp = getDirection(pieceFace, 'F');
    if (temp.length() ==2 && temp.charAt(0) == temp.charAt(1)) {
      temp = "" + turnDirectionThatWontFuckShitUp + turnDirectionThatWontFuckShitUp;
    }
    turns +=temp;
  }

  //-----------------------------------------------------------------------------------------------------------------------------------------------------------------

  Block getCorner(char face1, char face2, char face3) {
    color[] cols = {getFaceColor(face1), getFaceColor(face2), getFaceColor(face3)};
    return findCornerPiece(cols);
  }



  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------


  TurnO charToTurnO(char c, boolean clockwise) {
    //println(c);
    int axis =0;
    int index=0;
    switch(c) {
    case 'D':
      axis = 1;
      index = n-1;
      clockwise = !clockwise;
      break;
    case 'U':
      axis = 1;
      break;
    case 'L':
      break;
    case 'R':
      index = n-1;
      clockwise = !clockwise;
      break;
    case 'F':
      axis = 2;
      index = n-1;
      clockwise = !clockwise;
      break;    
    case 'B':
      axis = 2;
      break;
    }

    return new TurnO(axis, index, clockwise);
  }
}
