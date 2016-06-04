/* //<>//
 TUIO 1.1 Demo for Processing
 Copyright (c) 2005-2014 Martin Kaltenbrunner <martin@tuio.org>

 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files
 (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge,
 publish, distribute, sublicense, and/or sell copies of the Software,
 and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/



// import the TUIO library
import TUIO.*;
// declare a TuioProcessing client
TuioProcessing tuioClient;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
float buffer_scale = 0.15; //NOTE THIS MAY HAVE TO BE ADJUSTED AFTER TESTING PHYSICAL SETUP
PFont font;

boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks

int storyboardNum = 0;

void setup_TUIO()
{
  
  font = createFont("Arial", 18);
  float buffer_scale = height/table_size;
  
  // finally we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods in this class (see below)
  tuioClient  = new TuioProcessing(this);
}

// SCREEN METHODS
//Assume the fiducial is placed in the middle of the cup's lid, so we 
//measure a square buffer around the cup centered about the fiducial
//Function takes in intended coordinates of where the cup is "expected" to be
boolean checkCupPosition(TuioObject tobj, float xExpected, float yExpected) {
    float xCup = tobj.getX() * width;
    float yCup = tobj.getY() * height;
    float horizontal_buff = width * buffer_scale;
    float vertical_buff = height * buffer_scale;
  //if cup is within buffered expcted coordinates, return true
  if ((abs(xExpected - xCup) <= horizontal_buff) && (abs(yExpected - yCup) <= vertical_buff)) {
    return true;
  } else { 
    return false;
  }
}



void startScreen(TuioObject tobj) {
  if (tobj.getSymbolID() == 0) {
//    if (tobj.getScreenX() < 
    println(tobj.getX() * width);
    println(tobj.getY() * height);
    println(width);
    println(height);
    float xCoord = tobj.getX() * width;
    float yCoord = tobj.getY() * height;
    
  

    //advance storyboardNum counter
    storyboardNum = 1;
  }
}

void timelineScreen(TuioObject tobj) {
  //advance storyboardNum counter
  storyboardNum = 2;
}

void hullingScreen(TuioObject cup) {
  //advance storyboardNum counter
  storyboardNum = 3;

  println(cup.getX() * table_size);
  println(cup.getY() * table_size);
  
  // Hulling zone
  float hullingStartX = table_size/4;
  float hullingEndX = 3*table_size/4;
  float hullingStartY = table_size/4;
  float hullingEndY = 3*table_size/4;
  
  // Define a rotation with hitting 4 points around a circle in the right order
  float topX = table_size/2;
  float topY = hullingStartY;
  float rightX = hullingEndX;
  float rightY = table_size/2;
  float bottomX = table_size/2;
  float bottomY = hullingEndY;
  float leftX = hullingStartX;
  float leftY = table_size/2;
  
  int numRotations = 0;
  int pointsHit = 0;
  int lastPointHit = 0;

  float cupX = cup.getX() * table_size;
  float cupY = cup.getY() * table_size;
  
  if ((cupX == topX) && (cupY == topY) && (lastPointHit == 0 || lastPointHit == 4)) {
    if (pointsHit == 4) {
      numRotations++;
      pointsHit = 1;
    }
    lastPointHit = 1;
    //println(lastPointHit);
  } else if ((cupX == rightX) && (cupY == rightY) && (lastPointHit == 1)) {
    pointsHit = 2;
    lastPointHit = 2;
    //println(lastPointHit);
  } else if ((cupX == bottomX) && (cupY == bottomY) && (lastPointHit == 2)) {
    pointsHit = 3;
    lastPointHit = 3;
    //println(lastPointHit);
  } else if ((cupX == leftX) && (cupY == leftY) && (lastPointHit == 3)) {
    pointsHit = 4;
    lastPointHit = 4;
    //println(lastPointHit);
  }
  println(numRotations);
}

// within the draw method we retrieve an ArrayList of type <TuioObject>, <TuioCursor> or <TuioBlob>
// from the TuioProcessing client and then loops over all lists to draw the graphical feedback.
void draw_TUIO()
{
  textFont(font,18*scale_factor);   
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  
   /* -------------------------------------------------------------
   --- FEDUCIAL DETECTION (ENVIRONMENT AND OBJECT CHANGES) -----
   --------------------------------------------------------------- */
   // Determine which fiducials are present on the screen
   
   if(tuioObjectList.size() > 0) {
     TuioObject last = tuioObjectList.get(0); // Coffee cup
     if (storyboardNum == 0) { // start screen
       startScreen(last);
     } else if (storyboardNum == 1) { // timeline screen
       timelineScreen(last);
     } else if (storyboardNum == 2) { // hulling screen
       hullingScreen(last);
     } else { // Default to start screen
       background(welcome);
     }
     
   }
}

// --------------------------------------------------------------
// these callback methods are called whenever a TUIO event occurs
// there are three callbacks for add/set/del events for each object/cursor/blob type
// the final refresh callback marks the end of each TUIO frame

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
          +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}

// --------------------------------------------------------------
// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  //redraw();
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
          +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  //redraw();
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called when a blob is added to the scene
void addTuioBlob(TuioBlob tblb) {
  if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
  //redraw();
}

// called when a blob is moved
void updateTuioBlob (TuioBlob tblb) {
  if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
          +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
  //redraw()
}

// called when a blob is removed from the scene
void removeTuioBlob(TuioBlob tblb) {
  if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}


