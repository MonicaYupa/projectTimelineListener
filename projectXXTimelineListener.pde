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
Movie farmerScene;
Movie cupGrab;
Movie cupPlace;

// Screen flow logic
int storyboardNum = 0;
boolean timelineStarted = false;

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
  background(255,255,255); // white
  timelineScreen = loadImage("start.png");
  timelineScreen.resize(WINDOW_WIDTH, WINDOW_HEIGHT);

  //Initialize cup videos
  cupGrab = new Movie(this, "cupGrab.mov");
  cupPlace = new Movie(this, "cupplace.mov");
}

void draw() 
{ 
  draw_TUIO();
}

void movieEvent(Movie m) {
  m.read();
}
