import processing.video.*;

/*
This is the main code for the project.
Contains the setup() and draw() function.
*/

// Global variables
int WINDOW_HEIGHT = 720;
int WINDOW_WIDTH = 1280;

Movie farmerScene;
String[] environments = new String[5];
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
  environments[1] = "node1.png";
  environments[2] = "node2.png";
  environments[3] = "node3.png";
  environments[4] = "hulling.png";
}

void draw() 
{  
  background(255,255,255);
  draw_TUIO();  

}

void movieEvent(Movie m) {
  m.read();
}
