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
import processing.video.*;

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
  
  background(timelineScreen);
  line(tobj.getX() * width, 0, tobj.getX() * width, height); // x
  stroke(#0000ff);
  line(0, tobj.getY() * height, width, tobj.getY() * height); // y
  stroke(#0000ff);
  
  line(abs(xExpected - xCup), 0, abs(xExpected - xCup), height); // x
  stroke(#00ff00);
  line(0, abs(yExpected - yCup), width, abs(yExpected - yCup)); // y
  stroke(#00ff00);

  //if cup is within buffered expcted coordinates, return true
  if ((abs(xExpected - xCup) <= horizontal_buff) && (abs(yExpected - yCup) <= vertical_buff)) {
    return true;
  } else { 
    return false;
  }
}


void drawZone(float x, float y) {
  rect(x - cup_outline_diameter/2.0,y - cup_outline_diameter/2.0,cup_outline_diameter,cup_outline_diameter);
}


void drawCupOutline(TuioObject cup) {
  redraw();
  if(timelineScreen == null) {
    timelineScreen = loadImage("start.png");
    timelineScreen.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
  } 
  
  //background(timelineScreen);
  float xCup = cup.getX() * width;
  float yCup = cup.getY() * height - projector_offset;
  //ellipse(xCup,yCup,cup_outline_diameter,cup_outline_diameter);
  //noFill();
  //stroke(#000000);
}


void loadTimelineScreen(String screenname) {
  println("this is screenname " + screenname);
  timelineScreen = loadImage(screenname);
  timelineScreen.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
  background(timelineScreen);
}


void startScreen(TuioObject tobj) {
  if (checkCupPosition(tobj, table_size * 0.5 - cup_outline_diameter/2.0, table_size * 0.1)) {
    loadTimelineScreen("timeline0.png");
    storyboardNum = 1; //advance storyboardNum counter
    drawZone(5.0*table_size/6.0, table_size/6.0);
  }
}


void timelineScreen(TuioObject tobj) {
  if (checkCupPosition(tobj, 5.0*table_size/6.0, table_size/6.0) && (timelineNode == 0)) { // NODE 1
    loadTimelineScreen("timeline1.png");
    //drawZone(5.0*table_size/6.0, table_size/6.0);
    //stroke(#ff0000);
    timelineNode = 1;
  } else if (checkCupPosition(tobj, 4.0*table_size/6.0, table_size/6.0) && (timelineNode == 1)) { //NODE 2
    loadTimelineScreen("timeline2.png"); 
//    drawZone(4.0*table_size/6.0, table_size/6.0);
//    stroke(#00ff00);
    timelineNode = 2; 
  } else if (checkCupPosition(tobj, 3.0*table_size/6.0, table_size/6.0) && (timelineNode == 2)) { // NODE 3
    loadTimelineScreen("timeline3.png");
//    drawZone(3.0*table_size/6.0, table_size/6.0);
//    stroke(#0000ff);
    timelineNode = 3;
  } else if (checkCupPosition(tobj, 2.0*table_size/6.0, table_size/6.0) && (timelineNode == 3)) { // NODE 4
    loadTimelineScreen("timeline4.png");
//    drawZone(2.0*table_size/6.0, table_size/6.0);
//    stroke(#ffffff);
    timelineNode = 4;
  } else if (checkCupPosition(tobj, 1.0*table_size/6.0, table_size/6.0) && (timelineNode == 4)) { // NODE 5 pt.2
    loadTimelineScreen("timeline4.png");
//    drawZone(2.0*table_size/6.0, table_size/6.0);
//    stroke(#0fffff);
    timelineNode = 5;
  } else if (checkCupPosition(tobj, 1.0*table_size/6.0, table_size/6.0) && (timelineNode == 5)) { // NODE Video
    storyboardNum = 2; //advance storyboardNum counter
  }
}


void videoScreen(TuioObject cup) {
  clear();
  println("video screen");
  
  // Fake play the last starbucks video to time the cup grab video right
  starbucksVideo.play();
  starbucksVideo.volume(0);
  background(#ffffff);
  float starbucks_md = starbucksVideo.duration();
  float starbucks_mt = starbucksVideo.time();
  if (starbucks_mt == starbucks_md) {
    cupGrab.play();
    image(cupGrab, 0, 0);
    
    float grab_md = cupGrab.duration();
    float grab_mt = cupGrab.time();
    
    if (grab_mt == grab_md) { // TODO: play other half after hulling
      // Fake play Zach's video
      farmerScene.play();
      farmerScene.volume(0);
      background(#ffffff);
      
      float farmer_md = farmerScene.duration();
      float farmer_mt = farmerScene.time();
      
      if (farmer_mt >= farmer_md*.6) {
        farmerScene.pause();
        storyboardNum = 3;
      }
    }
  }
}


void hullingScreen(TuioObject cup) {
  // Use the starbucks video as a ten second timer
  hullingTimer.play();
  hullingTimer.volume(0);
  float hulling_md = hullingTimer.duration();
  float hulling_mt = hullingTimer.time();
  if (hulling_md == hulling_mt) {
    hullingDone = true;
  }
      
  clear();
  background(#ffffff);
  println("hulling screen");
  image(hulling,height/2 - 100, width/2 - 250);

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
  
  // Once hulling is done, continue the storyboard
  if (hullingDone) {
    float farmer_md = farmerScene.duration();
    float farmer_mt = farmerScene.time();
    farmerScene.play();
    if (farmer_mt == farmer_md) {
      storyboardNum = 4;
    }  
  }
}

void endingScreen(TuioObject cup) {
  loadTimelineScreen("wheel2.png");
  delay(1000);
  loadTimelineScreen("wheel1.png");
  delay(1000);
  background(#ffffff);
  cupPlace.play();
  image(cupPlace,0,0);
  
  float place_md = cupPlace.duration();
  float place_mt = cupPlace.time();
  if (place_md == place_mt) {
    storyboardNum = 5;
    background(#ffffff);
  } 
}

// within the draw method we retrieve an ArrayList of type <TuioObject>, <TuioCursor> or <TuioBlob>
// from the TuioProcessing client and then loops over all lists to draw the graphical feedback.
void draw_TUIO()
{
  if (cam.available()) { 
    // Reads the new frame
    cam.read(); 
  }
  textFont(font, 18*scale_factor);   
  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();

  /* -------------------------------------------------------------
   --- FEDUCIAL DETECTION (ENVIRONMENT AND OBJECT CHANGES) -----
   --------------------------------------------------------------- */
  if (tuioObjectList.size() > 0) {
    TuioObject last = tuioObjectList.get(0); // Coffee cup
    
    if (storyboardNum == 0) { // start screen
      startScreen(last);
    } else if (storyboardNum == 1) { // timeline flow
      timelineScreen(last);
    } else if (storyboardNum == 2) { // video screen
      videoScreen(last);
    } else if (storyboardNum == 3) { // hulling screen
      hullingScreen(last);
    } else if (storyboardNum == 4) { // ending flow
      endingScreen(last);
    } else { // Default to white background
      background(#ffffff);
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

