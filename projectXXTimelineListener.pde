import processing.video.*;

/*
This is the main code for the project.
Contains the setup() and draw() function.
*/

// Global variables
int WINDOW_HEIGHT = 720;
int WINDOW_WIDTH = 1280;

Movie farmerScene;
String[] environments = new String[7];
String[] assets = new String[5];
PImage bg = null;
PImage welcome = null;
float startTime = second();

void setup()
{
  // GUI setup; this sets the relevant parameters for the size of the screen, and framerate.
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
  frameRate(30);
  setupEnvironments();
  setup_TUIO();
}

void setupEnvironments()
{
  farmerScene = new Movie(this, "farmerScene.mp4");
  
  
  background(255,255,255); // white
  welcome = loadImage("welcome.png");
  welcome.resize(WINDOW_WIDTH, WINDOW_HEIGHT);
  if(bg == null) {
    background(welcome);
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
  background(255,255,255);
  draw_TUIO();  

}

void movieEvent(Movie m) {
  m.read();
}
