//-------------------------------------------------------------------------------------------------
//Hey bro, here are some values you can change so go nuts...
//actually probably dont
//dont go too big (trust me)
//dont do even sized cubes (it wont work)
//Have fun

int numberOfSides = 25;//<<< change this to change the size of the cube
float cubeSpeed = PI/20.0; //<<< this is the speed that the cube rotates 

/*
  some controls
 L lock/unlock cube (allows you to turn the cube with the mouse)
 SPACE pause/play (the program will automatically pause after the scramble, you will need to play the thing when you wanna start the scramble and when you wanna start the solve.
 */

//----------------------------------------------------------------------------------------------

int blockWidth = 400/numberOfSides; //you can change this value to increase the size of the cube in the window
//also if you've got a 4k monitor then check out line 97


//Global colors

color green = color(0, 255, 0);
color blue = color(0, 0, 255);
color red = color(255, 0, 0);
color white = color(255);
color yellow = color(255, 255, 0);
color orange =  color(255, 140, 0);



int n = numberOfSides;//better variable name
int middle = n/2;
int faceWidth = blockWidth;
int blacksShown = 0;
int speedUpCounter = 1;
boolean pause = true;
int rotateYCounter = 0;
int rotateXCounter = 0;
Cube cube;
int stageTestCounter =100;
int scrambleCounter = 100;
String turns = "";
ArrayList<TurnO> turnOs = new ArrayList();

int moveCount = 0;
int solveCounter =0;

boolean fixCubeRotation = false;
float  XRotationCompensation = 0;
float  YRotationCompensation = 0;
float  ZRotationCompensation = 0;

ArrayList<String> rotations = new ArrayList();
int[] turnCounter = new int[7];

float spinCounter =0;

boolean lockRotation = true;
float xRotationKey = 0;
float yRotationKey = 0;
float xRotationKeyTarget = 0;
float yRotationKeyTarget= 0;
//float zRotationKey = 0;
float rotationSpeed =100.0;

boolean justScrambled = true;
int pauseCounter = 0;

boolean showingOffFace = true;
float xTargetRotation = PI;
float yTargetRotation = PI;

int previousStageNo = 0;
int previousLargeCubeStageNo = 0;

boolean actualPause = false;
PVector lockedMousePos = new PVector();
PVector[] edgeCenters= {new PVector(middle, 0, 0), new PVector(n-1, 0, middle), new PVector(middle, 0, n-1), 
  new PVector(0, 0, middle), new PVector(middle, n-1, 0), new PVector(0, n-1, middle), new PVector(middle, n-1, n-1), new PVector(n-1, n-1, middle), 
  new PVector(0, middle, 0), new PVector(n-1, middle, 0), new PVector(0, middle, n-1), new PVector(n-1, middle, n-1)};

boolean firstPause = true;


boolean enableMouseX = true;
boolean enableMouseY = true;
boolean enableSpin = false;
boolean autoShow = false;
boolean repeatSolves = false;
int solveCounterThing =0;
int startTime =0;
void setup() {
  size(1000, 1000, P3D);
  //size(2000, 2000, P3D); //if you've got a 4K monitor then you can uncomment this out to have a bigger window, also make sure to comment out the line before 

  //turns+= "FFULL";
  cube = new Cube();
  for (int i= 0; i < 7; i++) {
    turnCounter[i] = 0;
  }
  cube.algos.scramble();
  //turns+= "XYZXYZXYZXYZXYZXYZXYZXYZYXYZXYZXYZXYZYXYZXYXZ";
  frameRate(60);
}

void resetCube() {
  cube = new Cube();
  cube.algos.scramble();
}

void draw() {
  if (!actualPause) {

    if (autoShow) {
      if (!pause && !cube.scrambling && cubeSpeed < PI) {
        if (cubeSpeed > PI/3) {
          cubeSpeed =PI;
          speedUpCounter =1;
        } else {
          cubeSpeed+=0.005;
        }
      }
    }
    println(cubeSpeed, PI);
    //cubeSpeed = PI;
    cube.rotationSpeed = cubeSpeed;
    //if (showingOffFace) {
    //  //pause = true;
    //  float wholeCubeRotationSpeed = 2;
    //  yRotationKey += yTargetRotation-yRotationKey/ abs(yRotationKey-yTargetRotation)*wholeCubeRotationSpeed;
    //  xRotationKey += xTargetRotation-xRotationKey/ abs(xRotationKey-xTargetRotation)*wholeCubeRotationSpeed;
    //}


    //println(frameRate);
    pushMatrix();

    translate(width/2, height/2, 0);
    rotateX(-PI/6);
    if (autoShow) {
      if (!lockRotation && pause && spinCounter/rotationSpeed>2*PI) {
        //println(spinCounter);
        pause = false;
        lockRotation=true;
        spinCounter = 0;

        switch(cube.algos.largeCubeStageNo) {
        case 1:
          xRotationKeyTarget -=PI/2.0;
          break;
        case 2:
          xRotationKeyTarget +=PI/2.0;
          break;
        case 9:
          yRotationKeyTarget +=PI/2.0;
          break;
        case 10:
          yRotationKeyTarget -=PI/2.0;
          break;
        }
        if (cube.algos.stageNo ==7) {
          actualPause = true;
        }
      }
    }

    if (abs(yRotationKey - yRotationKeyTarget)>0.15) {
      if (yRotationKey < yRotationKeyTarget) {
        yRotationKey+=0.1;
      } else {
        yRotationKey-=0.1;
      }
    } else {

      yRotationKey = yRotationKeyTarget;
    }
    if (abs(xRotationKey - xRotationKeyTarget) >0.15) {
      if (xRotationKey < xRotationKeyTarget) {
        xRotationKey+=0.1;
      } else {
        xRotationKey-=0.1;
      }
    } else {

      xRotationKey = xRotationKeyTarget;
    }
    if (lockRotation) {
      rotateY(PI/5- yRotationKey);
      rotateX(-xRotationKey);
    } else {
      //println(lockedMousePos, mouseX, mouseY);

      if (enableMouseY) {
        rotateX(-xRotationKey +((lockedMousePos.y -mouseY))/rotationSpeed);
      } else {
        rotateX(-xRotationKey);
      }

      if (enableMouseX) {
        rotateY(PI/5- yRotationKey-((lockedMousePos.x -mouseX) + spinCounter)/rotationSpeed);
      } else {
        //rotateY(PI/5- yRotationKey);

        rotateY(PI/5- yRotationKey-(spinCounter)/rotationSpeed);
      }

      if (enableSpin) {
        spinCounter+=1.0;
      }
    }  


    for (int i = 0; i< rotations.size(); i++) {
      int rotationDirection = 1;

      if (rotations.get(i).length() ==2) {
        rotationDirection = -1;
      } 

      switch(rotations.get(i).charAt(0)) {
      case 'X':
        rotateX(rotationDirection * PI/2);
        break;
      case 'Y':
        rotateY(rotationDirection * PI/2);
        break;
      case 'Z':
        rotateZ(rotationDirection * PI/2);
        break;
      }
    }
    //rotateX(XRotationCompensation) ;
    //rotateY(YRotationCompensation);

    //rotateZ(ZRotationCompensation);
    //if (cube.algos.stageNo ==7) {
    //  cube.rotationSpeed = PI/50.0;
    //}

    //  if (cube.algos.stageNo ==5) {
    //        cube.rotationSpeed = PI/1.0;

    //    //pause = true;
    //  }
    //}
    if (pause) {
      //print("paused");
    }
    if (!autoShow || cube.algos.largeCubeStageNo > 5) {
      background(255);
      cube.show();
      //saveFrame(n+"x" + n+"_rubiksCube_part2/"+ n+"x" + n+"_rubiksCube#########.jpg");
    } else {
      if (frameCount%10==0) {
        background(255);
        cube.show();
      }
    }
    int upTo =30;
    if (n<30) {
      upTo =1;
    }
    if (!autoShow && cube.scrambling && justScrambled) {
      //if first run through show the scramble slowly
      upTo = 1;
    }
    if (autoShow && speedUpCounter<upTo) {
      upTo = speedUpCounter;
      speedUpCounter++;
    }
    if (autoShow && cube.algos.largeCubeStageNo > 9) {
      upTo =1;
      cubeSpeed = PI/10.0;
    }
    if (autoShow && cubeSpeed<PI) {
      upTo = 1;
    }

    for (int i = 0; i < upTo; i++) {
      cube.update();
      if (!pause && turns.length() == 0 && turnOs.size() ==0 && !cube.turning) {
        cube.scrambling=false;
        cube.algos.continueSolve();
        if (autoShow) {
          if (!pause && (previousLargeCubeStageNo != cube.algos.largeCubeStageNo || cube.algos.stageNo > 6 )) {

            if (previousLargeCubeStageNo!= 3 && previousLargeCubeStageNo!= 5 && previousLargeCubeStageNo!= 7) {
              spinCounter =0;
              pause = true;
              lockRotation = false;
              cubeSpeed = PI/60.0;
            }
            previousStageNo = cube.algos.stageNo;
            previousLargeCubeStageNo = cube.algos.largeCubeStageNo;
          }
        }
      }



      if (!cube.scrambling && justScrambled) {

        //cubeSpeed= PI;
        pause = true;
        if (autoShow) {
          upTo=1;
          cubeSpeed = PI/60.0;
        }
        //if(
        justScrambled = false;
      }


      if (!pause &&!cube.turning) {
        if (!cube.scrambling) {
          //turnCounter[cube.algos.stageNo]+=1;
        }
        if (turns.length() >0 ) {
          doTurn();
        } else if (turnOs.size()  >0) {
          doTurnFromObj();
        }
      }
    }


    //if (cube.algos.stageNo ==7) {

    //  if (scrambleCounter <0) {
    //    int sum = 0;
    //    solveCounter +=1;
    //    for (int i = 0; i< 7; i++) { 
    //      println("stage " + i + ": " + (turnCounter[i]/solveCounter) + " turns");
    //      sum += turnCounter[i];
    //      //turnCounter[i] =0;
    //    }
    //    println("Total : " + (sum/solveCounter));
    //    println("____________________________________________________");
    //    scrambleCounter = 1;
    //    cube.algos.scramble();
    //    cube.scrambling = true;
    //  } else {
    //    scrambleCounter--;
    //  }
    //}



    popMatrix();
  }
}


void keyPressed() {

  switch(key) {
  case 'p':
    actualPause =!actualPause;
    break;
  case 'l':
    lockRotation = !lockRotation;
    lockedMousePos = new PVector(mouseX, mouseY);
    spinCounter =0;
    break;
  case ' ':
    pause=!pause;
    if (!pause && !justScrambled) {
      startTime = millis();
    }
    break;
  case 'm':
    enableMouseX = !enableMouseX;
    enableMouseY = !enableMouseY;
    break;
  case 's':
    enableSpin = !enableSpin;
    break;
  }
  float spinVal = PI/2;
  switch(keyCode) {
  case RIGHT:
    yRotationKey +=spinVal;
    break;
  case LEFT:
    yRotationKey -=spinVal;
    break;
  case UP:
    xRotationKey +=spinVal;
    break;
  case DOWN:
    xRotationKey -=spinVal;
    break;
  }
}

void doTurn() {
  //input is a string e.g. RUL'DD
  //  void turnCube(int index, int xOrYOrZ, boolean turnClockwise) {
  char turn = turns.charAt(0);
  turns = turns.substring(1, turns.length());

  boolean clockwise = true;




  if (turns.length() > 0 && turns.charAt(0) == '\'') {
    clockwise = false;
    turns = turns.substring(1, turns.length());
    //println("Turning cube " + turn +"'");
    if (turns.length()>=4) {      
      if (turns.substring(0, 4).equals( "" + turn  + "'" + turn + "'")) {
        //println("replaced: " +  turn + "'" + turns.substring(0, 4) + " with " +turn); 

        clockwise = true;
        turns = turns.substring(4, turns.length());
      }
    }
  } else {
    //println("Turning cube " + turn);
    if (turns.length()>=2) {
      if (turns.charAt(0)== turn && turns.charAt(1) == turn) {
        //println("replaced: " +  turn+ turns.substring(0, 2) + " with " +turn + "'"); 
        clockwise = false;
        turns = turns.substring(2, turns.length());
      }
    }
  }



  if (turn == 'R' || turn =='D' || turn == 'F') {
    clockwise = !clockwise;
  }


  if (fixCubeRotation) {
    compensateForTurn(turn, clockwise);
  }


  switch(turn) {
  case 'R':
    cube.turnCube(numberOfSides-1, 0, clockwise);
    break;
  case 'L':
    cube.turnCube(0, 0, clockwise );
    break;
  case 'U':
    cube.turnCube(0, 1, clockwise);
    break;
  case 'D':
    cube.turnCube(numberOfSides-1, 1, clockwise);
    break;
  case 'F':
    cube.turnCube(numberOfSides-1, 2, clockwise);
    break;
  case 'B':
    cube.turnCube(0, 2, clockwise);
    break;
  case 'X':
    cube.turnWholeCube(0, clockwise);

    break;
  case 'Y':
    cube.turnWholeCube(1, clockwise);
    break;
  case 'Z':
    cube.turnWholeCube(2, clockwise);
    break;
  }
}

void doTurnFromObj() {
  //println("turnos");
  //input is a string e.g. RUL'DD
  //  void turnCube(int index, int xOrYOrZ, boolean turnClockwise) {
  TurnO turn = turnOs.remove(0);

  if (turnOs.size() >= 2) {
    if (turn.matches(turnOs.get(0)) && turn.matches(turnOs.get(1))) {
      turnOs.remove(0);
      turnOs.remove(0);
      turn.clockwise = !turn.clockwise;
    }
  }
  cube.turnCubeFromObj(turn);
}

void compensateForTurn(char direction, boolean clockwise) {
  if (clockwise) {
    rotations.add(""+direction);
  } else {
    rotations.add(""+direction +"'");
  }
  switch(direction) {
  case 'X':
    if (clockwise) {
      XRotationCompensation += PI/2;
    } else {
      XRotationCompensation -= PI/2;
    }
    break;
  case 'Y':
    if (clockwise) {
      YRotationCompensation += PI/2;
    } else {
      YRotationCompensation -= PI/2;
    }
    break;

  case 'Z':
    if (clockwise) {
      ZRotationCompensation += PI/2;
    } else {
      ZRotationCompensation -= PI/2;
    }
    break;//   float  YRotationCompensation = 0;
    //   float  ZRotationCompensation = 0;
  }
}

String mappings = "LRUDBF";


void simulateRotation(int axis, boolean clockwise) {
  if (!clockwise) {
    simulateRotation(axis, true);
    simulateRotation(axis, true);
    simulateRotation(axis, true);
  }
  //LRUDBF
  switch(axis) {
  case 0:
    for (int i = 0; i< mappings.length(); i++) { 
      int index = XRotation.indexOf(mappings.charAt(i));
      if (index != -1) {
        mappings = mappings.substring(0, i) + XRotation.charAt((index +1)%4) + mappings.substring(i+1, mappings.length());
      }
    }
    break;
  case 1:
    for (int i = 0; i< mappings.length(); i++) { 
      int index = YRotation.indexOf(mappings.charAt(i));
      if (index != -1) {
        mappings = mappings.substring(0, i) + YRotation.charAt((index +1)%4) + mappings.substring(i+1, mappings.length());
      }
    }
    break;
  case 2:
    for (int i = 0; i< mappings.length(); i++) { 
      int index = ZRotation.indexOf(mappings.charAt(i));
      if (index != -1) {
        mappings = mappings.substring(0, i) + ZRotation.charAt((index +1)%4) + mappings.substring(i+1, mappings.length());
      }
    }
    break;
  }
}


void printTurnos() {
  println("turnos mamte");
  for (int i = 0; i< turnOs.size(); i++) { 
    turnOs.get(i).printTurn();
  }
}

boolean moreTurns() {
  return turnOs.size() != 0 || turns.length() !=0;
}
