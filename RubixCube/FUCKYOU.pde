String XRotation = "FDBU";
String YRotation = "FLBR";//'F', 'R', 'B', 'R'};
String ZRotation = "LDRB";//{'L', 'D', 'R', 'B'};

ArrayList<TurnO> getTurnObjects(char fromFace, char toFace, int index, int idealAxis) {
  int fromIndex = XRotation.indexOf(fromFace);
  int toIndex = XRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotationGimmeObj(fromIndex, toIndex, index, 0, idealAxis);
  }
  fromIndex = YRotation.indexOf(fromFace);
  toIndex = YRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotationGimmeObj(fromIndex, toIndex, index, 1, idealAxis);
  }
  fromIndex = ZRotation.indexOf(fromFace);
  toIndex = ZRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotationGimmeObj(fromIndex, toIndex, index, 2, idealAxis);
  }
  return null;
}

//move edge to front left if not alreay in the middle row
ArrayList<TurnO> moveEdgeToFrontLeft(char face1, char face2) {
  ArrayList<TurnO> returnList = new ArrayList();
  String middleRowFaces = "FRBL";
  boolean face1Middle = middleRowFaces.indexOf(face1) != -1;
  boolean face2Middle = middleRowFaces.indexOf(face2) != -1;

  if (face1Middle && face2Middle) {
    return new ArrayList<TurnO>();
  }
  char nonMidFace = face1;
  char midFace = face2;
  if (face1Middle) {
    nonMidFace = face2; 
    midFace = face1;
  }
  int yIndex = 0;
  if (nonMidFace == 'D') {
    yIndex = n-1;
  }

  returnList.addAll(getTurnObjects(midFace, 'L', yIndex, 1));


  if (nonMidFace == 'D') {
    returnList.add(new TurnO(0, 0, false));
  } else {
    returnList.add(new TurnO(0, 0, true));
  }
  return returnList;
}



//move edge to front right 
ArrayList<TurnO> moveEdgeToFrontRight(char face1, char face2) {

  ArrayList<TurnO> returnList = new ArrayList();
  String middleRowFaces = "FRBL";
  boolean face1Middle = middleRowFaces.indexOf(face1) != -1;
  boolean face2Middle = middleRowFaces.indexOf(face2) != -1;

  if (face1Middle && face2Middle) {
    String test = "FL";
    if (test.indexOf(face1)!=-1 &&test.indexOf(face2)!=-1) {
      returnList.add(new TurnO(2, n-1, true));
      returnList.add(new TurnO(2, n-1, true));
      return returnList;
    }
    test = "BL";
    if (test.indexOf(face1)!=-1 &&test.indexOf(face2)!=-1) {
      returnList.add(new TurnO(0, 0, true));
      returnList.add(new TurnO(1, 0, false));
      returnList.add(new TurnO(2, n-1, false));
      return returnList;
    }

    test = "BR";
    if (test.indexOf(face1)!=-1 &&test.indexOf(face2)!=-1) {
      returnList.add(new TurnO(0, n-1, true));
      returnList.add(new TurnO(0, n-1, true));

      return returnList;
    }
    return new ArrayList<TurnO>();
  }


  char nonMidFace = face1;
  char midFace = face2;
  if (face1Middle) {
    nonMidFace = face2; 
    midFace = face1;
  }
  int yIndex = 0;
  if (nonMidFace == 'D') {
    yIndex = n-1;
  }

  returnList.addAll(getTurnObjects(midFace, 'R', yIndex, 1));


  if (nonMidFace == 'D') {
    returnList.add(new TurnO(0, n-1, false));
  } else {
    returnList.add(new TurnO(0, n-1, true));
  }
  return returnList;
}


String getTurns(char fromFace, char toFace, int index) {
  int fromIndex = XRotation.indexOf(fromFace);
  int toIndex = XRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    if (index ==0) {
      return foundRotation(fromIndex, toIndex, 'L');
    } else {
      return foundRotation(fromIndex, toIndex, 'R');
    }
  }
  fromIndex = YRotation.indexOf(fromFace);
  toIndex = YRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    if (index ==0) {
      return foundRotation(fromIndex, toIndex, 'U');
    } else {
      return foundRotation(fromIndex, toIndex, 'D');
    }
  }
  fromIndex = ZRotation.indexOf(fromFace);
  toIndex = ZRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    if (index ==0) {
      return foundRotation(fromIndex, toIndex, 'B');
    } else {
      return foundRotation(fromIndex, toIndex, 'F');
    }
  }
  return "";
}


String getDirection(char fromFace, char toFace) {
  int fromIndex = XRotation.indexOf(fromFace);
  int toIndex = XRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotation(fromIndex, toIndex, 'X');
  }
  fromIndex = YRotation.indexOf(fromFace);
  toIndex = YRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotation(fromIndex, toIndex, 'Y');
  }
  fromIndex = ZRotation.indexOf(fromFace);
  toIndex = ZRotation.indexOf(toFace);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotation(fromIndex, toIndex, 'Z');
  }
  return "";
}



ArrayList<TurnO> foundRotationGimmeObj(int fromIndex, int toIndex, int index, int axis, int idealAxis) {
  ArrayList<TurnO> turns = new ArrayList();
  TurnO t = new TurnO(idealAxis, index, true);
  if (abs(fromIndex - toIndex) == 2) {
    turns.add(t);
    turns.add(t);
    return turns;
  }

  t.axis = axis;

  if (fromIndex<=toIndex) {
    for (int i = fromIndex; i< toIndex; i++) { 
      turns.add(t);
    }
  } else {
    t.clockwise = false;
    for (int i = toIndex; i< fromIndex; i++) { 
      turns.add(t);
    }
  }
  return turns;
}

String foundRotation(int fromIndex, int toIndex, char turnCharacter) {
  String returnString ="";
  if (abs(fromIndex - toIndex) ==2) {
    return "" + turnCharacter + turnCharacter;
  }
  if (fromIndex<=toIndex) {
    for (int i = fromIndex; i< toIndex; i++) { 
      returnString += turnCharacter;
    }
  } else {
    for (int i = toIndex; i< fromIndex; i++) { 
      returnString += turnCharacter + "\'";
    }
  }
  return returnString;
}




PVector[] cornerRotationU = {new PVector(0, 0, 0), new PVector(n-1, 0, 0), new PVector(n-1, 0, n-1), new PVector(0, 0, n-1)};
PVector[] cornerRotationD = {new PVector(0, n-1, 0), new PVector(0, n-1, n-1), new PVector(n-1, n-1, n-1), new PVector(n-1, n-1, 0)};


String getDirectionsCorners(PVector from, PVector to) {

  int fromIndex = getIndex(cornerRotationU, from);
  int toIndex = getIndex(cornerRotationU, to);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotation(fromIndex, toIndex, 'U');
  }

  fromIndex = getIndex(cornerRotationD, from);
  toIndex = getIndex(cornerRotationD, to);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotation(fromIndex, toIndex, 'D');
  }

  return "";
  //will add others if needed
}


int getIndex(PVector[] arr, PVector c) {
  for (int i = 0; i< arr.length; i++) { 
    if (pvectorsEqual(arr[i], c)) {
      return i;
    }
  }
  return -1;
}
boolean pvectorsEqual(PVector p1, PVector p2) {
  return(p1.x ==p2.x && p1.y == p2.y &&  p1.z == p2.z);
}
//converts into reverse e.g. RULR' becomes RL'U'R'
String reverseDirections(String original) {
  String reverse = "";
  for (int i = 0; i< original.length(); i++) {
    if (i+1< original.length() && original.charAt(i+1) == '\'') {
      reverse = original.charAt(i) + reverse;
      i+=1;
    } else {
      reverse = original.charAt(i) + "'" + reverse;
    }
  }

  return reverse;
}




PVector[] edgeRotationU = {new PVector(middle, 0, 0), new PVector(n-1, 0, middle), new PVector(middle, 0, n-1), new PVector(0, 0, middle)};
PVector[] edgeRotationD = {new PVector(middle, n-1, 0), new PVector(0, n-1, middle), new PVector(middle, n-1, n-1), new PVector(n-1, n-1, middle)};


String getDirectionsEdges(PVector from, PVector to) {

  int fromIndex = getIndex(edgeRotationU, from);
  int toIndex = getIndex(edgeRotationU, to);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotation(fromIndex, toIndex, 'U');
  }

  fromIndex = getIndex(edgeRotationD, from);
  toIndex = getIndex(cornerRotationD, to);
  if (fromIndex != -1 && toIndex !=-1) {
    return foundRotation(fromIndex, toIndex, 'D');
  }

  return "";
  //will add others if needed
}
