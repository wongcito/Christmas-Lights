// Christmas Lights (ver 1.0)
// A Processing game made by Luis Wong
// luis@luiswong.com
// ENJMIN M1 - 2015
// The object of the game is to have as most light as possible,
// by turning them on when they are dimming. 
// If most lights are off, the amount of light will go down 
// and you will lose.
// 
// I used an Object Oriented Programming approach for creating a Light class
// (creating methods and for creating a 2D array of this objects),
// a SmallLight subclass that also moves for adding difficulty,
// used the lightning() function for total lightning bar.
// Finally I added some text and sound using Pfont and the Minim library.
//
// For restarting the game you have to play again the Processing file.
// I will work on a reinit() function soon.
// This project was made for a student project where the object was to
// make a Processing program with a Christmas theme.


import ddf.minim.*; // For adding sound
Minim minim; // Name of the sound variable
AudioPlayer player; // For adding sound
AudioInput input; // For adding sound
PImage img; // Name of the image
int cols = 2; // Number of columns of normal lights
int rows = 4; // Number of rows of normal lights
int colsb = 3; // Number of columns for moving lights
int rowsb = 2; // Number of columns for moving lights
int universeLights = cols * rows + colsb * rowsb; // Number of lights
boolean st = boolean ( round ( random (0,1))); // Expression for getting a random boolean
float percentage; // I will use this for the bar
float totalAlpha; // I will use this for the percentage
float rectWidth; // I will use this for the bar
PFont f; // For adding text


//Declaring a 2D array of Light objects
Light[][] lights = new Light[cols][rows];

//Declaring a 2D array of smallLight objects
SmallLight[][] smallLights = new SmallLight[colsb][rowsb];

//Adding the initial elements
void setup() {
  img = loadImage("tree.png");
  rectWidth = 150; // Width of the bar
  f = loadFont("SansSerif-32.vlw");
  minim = new Minim(this); // For adding sound
  player = minim.loadFile("end.wav"); // Name of the sound
  input = minim.getLineIn(); // For adding sound
  // Adding fixed lights
  for (int i = 0; i < cols; i++){
    for (int j = 0; j < rows; j++){
    //Initializing each light with a fixed position position and a random state (on/off)
    lights[i][j] = new Light(215+i*80,210+j*85,st);
    println (lights[i][j].x,lights[i][j].y, lights[i][j].state); // For debugging purposes
    st = boolean ( round ( random (0,1))); // Randomize of number of lights that are turned on
    }
  }
  //Adding small lights that move
  for (int i = 0; i < colsb; i++){
    for (int j = 0; j < rowsb; j++) {
    //Initializing each small light with a fixed position position and a random state (on/off)
    smallLights[i][j] = new SmallLight(175+i*80,300+j*85,st);
    println (smallLights[i][j].x,smallLights[i][j].y, smallLights[i][j].state); // For debugging purposes
    st = boolean ( round ( random (0,1))); // Randomize of number of small lights that are turned on
    }
  }
  size(img.width, img.height); // The size of the canvas is equal to the size of the image
  smooth();
}

// Main loop of the game
void draw() {
  background(255);
  image(img, 0, 0);
  percentage = totalAlpha/(universeLights*255)*100; // This is how I calculate the percentage of the bar
  textFont(f,14);                 
  fill(0);                         
  text("Luis Wong - ENJMIN M1 - 2015",10,20);  // Credits
  text("Click on the lights to win the game.",270,20);  // Instructions of the game
  println("total alpha",totalAlpha); // For debugging purposes
  println("percentage", percentage); // For debugging purposes
  
  lightning(); // Calling the function for updating the lightning bar
  // Display initial set of lights with a display function of the Light class
  for (int i=0; i < cols; i++){
    for (int j = 0; j < rows; j++){
      lights[i][j].display();// display all lights 
    }
  }
  // Display initial set of small lights with a display function of the SmallLight class
  for (int i=0; i < colsb; i++){
    for (int j = 0; j < rowsb; j++){
      smallLights[i][j].display();// display all small lights 
      smallLights[i][j].move();// start moving all small lights 
    }
  }
  
  
  // Activating each light when I click on each one with a fullDisplay function of the Light class
  for (int i=0; i < cols; i++){
    for (int j = 0; j < rows; j++){
      if ( (sqrt(sq(lights[i][j].x - mouseX)+sq(lights[i][j].y - mouseY)) < lights[i][j].dim/2    )  && (mousePressed)){
        lights[i][j].fullDisplay(); // Calling the fullDisplay method
        lights[i][j].state = true; // They are with 255 alpha
      } 
    }
  }
  
  // Activating each small light when I click on each one with a fullDisplay function of the Light class
  for (int i=0; i < colsb; i++){
    for (int j = 0; j < rowsb; j++){
      if ( (sqrt(sq(smallLights[i][j].x - mouseX)+sq(smallLights[i][j].y - mouseY)) < smallLights[i][j].dim/2    )  && (mousePressed)){
        smallLights[i][j].fullDisplay(); // Calling the fullDisplay method
        smallLights[i][j].state = true; // They are with 255 alpha
      } 
    }
  }
  
  // For adding each light and small light to total lightning
  for (int i=0; i < cols; i++){
    for (int j = 0; j < rows; j++){
      totalAlpha = totalAlpha + lights[i][j].alpha/1500 + smallLights[0][0].alpha/1500;
      }
     }
     
}
// End of the main loop of the game

// I create a function for the bar that shows the amount of light gathered
 void lightning(){
  // Draw bar
  if ((percentage <100) && (percentage > 0)) {
  noStroke();
  float drawWidth = (percentage/100) * rectWidth; // This will move the progress bar
  println("drawWidth", drawWidth); // Debugging purposes
  println("rectWidth", rectWidth); // Debugging purposes
  fill(255, 0, 0); 
  rect(350, 30, drawWidth, 25);
   
  // Draw outline
  stroke(0);
  noFill();
  rect(350, 30, rectWidth, 25);
  // Win state
  } else if (percentage >=100) {
    println("You won");
    textFont(f,28);                 
    fill(0);                        
    player.play(); // Play a win sound
    text("You won!",10,100); 
    text("Merry Christmas!",10,130); 
    stop();
  // Lose state
  } else if (percentage < 0){
    println("You lost");
    textFont(f,28);                 
    fill(0);                        
    text("You lost!",10,100);  
    stop();
  }
}
// End of the function

//Here I'm creating a Light class for adding them and changing its properties easily
class Light {
  // Declaring class variables
  float x, y; // location of each light
  float dim; // dimension of each light
  color c; // color of each light
  boolean state; // state of each light
  float alpha; // state of alpha of the color of each light
  float velocity; // how quick the alpha goes down (difficulty of the game!)
  //For the array of colors of the lights...
  int[] colors = new int[3];
  int index;
  int hex;
  
  // Initializing values for each light
  Light(float x, float y, boolean state) {
    this.x = x;
    this.y = y;
    dim = 25;
    alpha = 255;
    velocity = 0.5;
    // For randomizing the array of colors
    int[] colors = { #f60101, #01f61e, #0901f6}; //Red, Green, Blue
    int index = int(random(colors.length));  
    hex = colors[index];
    c = color(hex,alpha); // I'm using a hex color with an alpha channel
    this.state = st; // Initial state of the light
  }

  //Here I'm creating a display function for the Light class that will be called at the start of the game
  void display() {
    if (state) {
      fill(hex,alpha); // If the light is on, it starts with the color with full alpha
      alpha = alpha - velocity; // For dimming the light (I low the alpha)
    } else {
      fill(0xFFFFFF,alpha); //If the light is off the color is transparent
      }
    ellipse(x,y,dim,dim); 
  }
  
  //Here I'm creating a fullDisplay function for the Light class that will be called when I click on a light
  void fullDisplay(){
    st = true;
    alpha = 255;
    fill(hex,alpha);
    ellipse(x,y,dim,dim);
  }

}
// End of the Light class


// I will create a small light class that will move
class SmallLight extends Light {
  
  int speed;
  float range;
  float depart;
  
  SmallLight (float x, float y, boolean state) {
    
    
    
    super (x,y,state); // I call the Light properties
    dim = 20; // I change the size of the diameter
    speed = 1; // For the moving lights
    depart = y;
    range = y + 20;
    
  }
  
  // I will add a method for moving up and down the small light
  void move(){
    
    y = y + speed;
    if ((y >= range) || (y <= depart)) { // I change the speed when they arrive to a certain point
      speed = speed * -1;
      
    }
    
  }
  
}
