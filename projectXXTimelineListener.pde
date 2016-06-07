import TUIO.*;
import processing.video.*;

/*
This is the main code for the project.
Contains the setup() and draw() function.
*/

// Calibration
int WINDOW_HEIGHT = 700;
int WINDOW_WIDTH = 700;
float projector_offset = 133.0; // only for y axis
float cup_outline_diameter = 150.0;

// Screen display
Capture cam = null;
PImage timelineScreen = null;
PImage hulling = null;
PImage wheel1 = null;
PImage wheel2 = null;
Movie starbucksVideo;
Movie hullingTimer;
Movie farmerScene;
Movie cupGrab;
Movie cupPlace;
Movie test;

// Screen flow logic
int storyboardNum = 0;
boolean timelineStarted = false;
boolean hullingDone = false;
int timelineNode = 0;

void setup()
{
  // GUI setup; this sets the relevant parameters for the size of the screen, and framerate.
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
  frameRate(30);
  setupEnvironments();
  setup_TUIO();
  
  // Camera setup
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
      // TODO: Put a safety hack here
      cam = new Capture(this, cameras[15]);
      cam.start();
    }
}

void setupEnvironments()
{
  timelineScreen = loadImage("start.png");
  timelineScreen.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
  background(timelineScreen);
  
  hulling = loadImage("wheel.png");
  hulling.resize(500,500);
  
  wheel1 = loadImage("wheel1.png");
  wheel2 = loadImage("wheel2.png");

  //Initialize cup videos
  hullingTimer = new Movie(this, "p1small.mov");
  starbucksVideo = new Movie(this, "p1small.mov");
  farmerScene = new Movie(this, "farmerScene.mp4");
  cupGrab = new Movie(this, "cupGrab.mov");
  cupPlace = new Movie(this, "cupPlace.mov");
  //test = new Movie(this, "Take1CupGrab.mov");
}

void draw() 
{ 
  draw_TUIO();
}

void movieEvent(Movie m) {
  m.read();
}
