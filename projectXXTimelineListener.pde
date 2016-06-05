import TUIO.*;
import processing.video.*;

/*
This is the main code for the project.
Contains the setup() and draw() function.
*/

// Global variables
int WINDOW_HEIGHT = 800;
int WINDOW_WIDTH = 800;

Movie farmerScene;
String[] environments = new String[7];
String[] assets = new String[5];
PImage bg = null;
PImage welcome = null;
PImage screen1 = null;
PImage screen2 = null;
PImage screen3 = null;
PImage screen4 = null;
PImage screen5 = null;
PImage screen6 = null;
float startTime = second();

Capture cam = null;

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
  } else {
      // TODO: Put a safety hack here
      println(cameras[15]);
      Capture cam = new Capture(this, cameras[15]);
      cam.start();
    }       
}

void setupEnvironments()
{
  background(255,255,255); // white
  welcome = loadImage("start.png");
  welcome.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
  if(bg == null) {
    background(welcome);
  }
  
  screen1 = loadImage("timeline1.png");
  screen1.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
  if(screen1 == null) {
    background(screen1);
  }
  
  screen2 = loadImage("timeline2.png");
  screen2.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
  if(screen2 == null) {
    background(screen1);
  }
  
  screen3 = loadImage("timeline3.png");
  screen3.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
  if(screen3 == null) {
    background(screen3);
  }
  
  screen4 = loadImage("timeline4.png");
  screen4.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
  if(screen4 == null) {
    background(screen4);
  }
  
  screen5 = loadImage("timeline5.png");
  screen5.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
  if(screen5 == null) {
    background(screen5);
  }
  
  screen6 = loadImage("timeline6.png");
  screen6.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
  if(screen6 == null) {
    background(screen6);
  }
  
  
  
  
  // Initialize environment images
  environments[0] = "start.png"; // Start screen
  environments[1] = "timeline1.png";
  environments[2] = "timeline2.png";
  environments[3] = "timeline3.png";
  environments[4] = "timeline4.png";
  environments[5] = "timeline5.png";
  environments[6] = "timeline6.png";
  
  // Initialize asset images
  assets[0] = "pale-green-circle";
  assets[1] = "hovering-circle";
  assets[2] = "green-cup";
  assets[3] = "yellow-cup";
}

void draw() 
{ 
  draw_TUIO();
}

void movieEvent(Movie m) {
  m.read();
}
