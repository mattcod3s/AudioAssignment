import peasy.*;
import ddf.minim.AudioBuffer;
import ddf.minim.AudioPlayer;
import ddf.minim.Minim;
import ddf.minim.analysis.FFT;

/*
* Initialization
*/

//Initializing minim library
Minim minim; 
AudioPlayer ap;
AudioBuffer ab;
FFT fft;

//Initializing PeasyCam
PeasyCam cam;

/*
* Variables
*/
int index = 0;
boolean isStars = false;
boolean isSky = false;
boolean isIndividual = true;

float lerpedAverage = 0;
int highestBand =  0;
int which = 1;

//Terrain
int cols, rows;
int scl = 20;
int w = 1200;
int h = 600;

//Cubes
float cubeAngle = 0;

//Music methods and variables
float log2(float f) {
    return log(f) / log(2.0f);
}

float[] lerpedBuffer;
float[] lerpedTerrain;
float[] lerpedStars;
float[] bands;
float[] smoothedBands;

void calculateFrequencyBands() {
    for(int i = 0; i < bands.length; i++){
        
        int start  = (int) pow(2, i) - 1;
        int w = (int) pow(2, i);
        int end = start + w;
        float average = 0;
        for(int j = start; j < end; j++) {
            average += fft.getBand(j) * (j + 1);
        }
        average /= (float) w;
        bands[i] = average * 5.0f;
        smoothedBands[i] = lerp(smoothedBands[i], bands[i], 0.005f);
    }
}
/*
* STARS
*/
class Star {
  float starX;
  float starY;
  float starZ;
  float prevStarZ;
  
  Star() {
    //Create stars at radnom positions on screen
    starX = random(-width, width);
    starY = random(-height, height);
    starZ = random(width);
 
  }
  
  //Function to reset stars that go off screen to their original positions
  void resetStar(float frequencyData) {
    //decrease the z position of star by value of frequency data
    starZ = starZ - frequencyData;
    // if star goes off screen, draw it again at the previous z position
    if(starZ < 1) {
      starZ = width;
      starX = random(-width, width);
      starY = random(-height, height);
      
    }
  }
  
  //function to display star
  void showStar() {
    fill(255);
    noStroke();
    
    //Get current position of star
    float currentX = map(starX / starZ, 0, 1, 0, width);
    float currentY = map(starY / starZ, 0, 1, 0, height);
    
    //if star z position is large, it means it's supposed to be further back
    //if star z position is small, it means it's supposed to be in front of the watcher
    // Based on the z position of star, give it a size between 0 (far away) to 2 (close up)
    float starRad = map(starZ, 0, width, 2, 0);
    
    stroke(255);
    
    ellipse(currentX, currentY, starRad, starRad);
  }
}
//Stars
Star stars[] = new Star[512];


/*
* PLANETS
*/
class Planet{
  
  float radius;
  float rotation;
  float distance;
  Planet[] planets;
  PVector vector;
  float orbitSpeed;
  
  float c;
  
  Planet(float planetRadius, float planetDistance, float planetOrbit) {
    vector = PVector.random3D();
    radius = planetRadius;
    rotation = random(TWO_PI);
    distance = planetDistance;
    vector.mult(distance);
    orbitSpeed = planetOrbit;
  }

  //Fucntion to create moons
  void createMoons(int level, int total) {
    
    //Assign differnet colors to moons depending on level
    for(int j = 0; j < level; j++) {
      if(j == 0) {
        c = 120;
      } else if(j == 2) {
        c = 200;
      } else if(j == 3) {
        c = 110;
      } else if(j == 4) {
        c = 130;
      } 
      
      
    }
    
    //initialize Planet array
    planets = new Planet[total];
    
    
    for (int i = 0; i < planets.length; i++) {
      //decrease radius of consecutive moon using level
      float moonR = radius / (level * 2);
      float moonD = random((radius + moonR) + 50, ((radius + moonR) * 2) + 50);
      float moonO = random(-0.025, 0.025);
      
      //Create new planet
      planets[i] = new Planet(moonR, moonD, moonO);
      
      //if level is smaller than five, call the loop again 
      if (level < 5) {
      
        planets[i].createMoons(level+1, (int) random(1, 3));
      }
    }
  }
  
  //Function to show all planets
  void showSystem() {
    pushMatrix();
    
    //Get spin axis of current planet
    PVector v2 = new PVector(1, 0, 1);
    
    //get spin axis of tangernt to spin axis of current planet
    PVector pAngle = vector.cross(v2);
    rotate(rotation , pAngle.x, pAngle.y, pAngle.z);
    translate(vector.x, vector.y, vector.x);
    stroke(c, 255, 255);
   
    sphere(radius + (lerpedAverage * 50));
    int res = 10;
    noFill();
    sphereDetail(res);
    if(planets != null) {
      for(int i = 0; i < planets.length; i++) {
        planets[i].showSystem();
      }
    } 
    popMatrix();
  }
  
  
  void orbit() {
    rotation = rotation + orbitSpeed;
    if(planets != null) {
      for (int i = 0; i < planets.length; i++) {
        planets[i].orbit();
      }
    }
  }
}
// Cellestials
Planet cellestial;





void settings() {
  size(1024, 800, P3D);
}



void setup() {
  
  //Setup peasyCam
  cam = new PeasyCam(this,500);
  
  //Setup minim
  minim = new Minim(this);
  ap = minim.loadFile("heroplanet.mp3", width);
  ap.play();
  ab = ap.mix;
  colorMode(HSB);
  
  lerpedBuffer = new float[width];
  lerpedStars = new float[width];
  lerpedTerrain = new float[width];
  fft = new FFT(width, 44100);
  
  bands = new float [(int) log2(width)];
  smoothedBands = new float [bands.length];
  
  //Terrain
  cols = w / scl;
  rows = h / scl;
  
  //Stars
  for(int i = 0; i < stars.length; i++) {
    stars[i] = new Star();
  }
  
  //Cellestials
  cellestial = new Planet(50, 0, 0);
  cellestial.createMoons(3, 3);
}
 

public void keyPressed() {
    if (keyCode >= '0' && keyCode <= '6') {
        which = keyCode - '0';
    }
    if (keyCode == ' ') {
        if (ap.isPlaying()) {
            ap.pause();
        } else {
            ap.rewind();
            ap.play();
        }
    }
}


void mouseClicked(){
  if(mouseX > 25 && mouseX < 233 && mouseY > 19 && mouseY < 103) {
    if(which == 2) {
      if (isStars == true) {
        isStars = false;
      } else {
        isStars = true;
      }
    } else if (which == 1) {
      if (isSky == true) {
        isSky = false;
      } else {
        isSky = true;
      }
    }
  } else if (mouseX > 25 && mouseX < 233 && mouseY > 84 && mouseY < 168) {
    if(which == 1) {
      if(isIndividual == true) {
        isIndividual = false;
      } else {
        isIndividual = true;
      }
    }
  }
}




void draw() {
  background(0);  
  stroke(255);
  
  float average = 0;
  float sum = 0;
  cubeAngle += 0.01;

  if (index < fft.specSize()) {
    index += 1;
  } else {
    index = 0;
  }
  
  for (int i = 0; i < ab.size(); i ++) {
    sum += abs(ab.get(i));
    
  }
  average = sum / ab.size();
  // Move lerpedAverage 10% closer to average every frame
  lerpedAverage = lerp(lerpedAverage, average, 0.1f);
  
  lerpedBuffer[index] = lerp(lerpedBuffer[index], ab.get(index), 0.25f);
  lerpedStars[index] = lerp(lerpedStars[index], ab.get(index), 0.25f);

   
  

  fft.window(FFT.HAMMING);
  fft.forward(ab);
   
  calculateFrequencyBands();
   
   switch(which) {
     case 1: {
       cam.reset(0);
       fill(0);
       rect(-width/2 + 160, -height/2 + 125, 150, 60);
         
        if(isIndividual == true && isSky == true) {
           fill(255);
           text("Individual Rotation", -width/2 + 185, -height/2 + 225);
        } else if(isIndividual == false && isSky == true) {
          fill(255);
          text("Group Rotation", -width/2 + 196, -height/2 + 225);
        } 
       
       if (isSky == true) {
         noFill();
         stroke(255);
         rect(-width/2 + 160, -height/2 + 190, 150, 60);
         //cam.reset(0);
         fill(255);
         text("Turn Cubes Off", -width/2 + 196, -height/2 + 160);
         noFill();
         
         rotateX(PI/2.8);
         translate(-w/2, -h/6);
       
         for(int y = 0; y < rows;  y++) {
           float c = map(y * 0.5, 0, bands.length, 0, 255);
           beginShape(TRIANGLE_STRIP);
           
           stroke(c, 255, 255);
           for (int x = 0; x < cols; x++) {
             
             
             noFill();
             
             lerpedTerrain[y] = lerp(lerpedTerrain[y], fft.getBand(y), 0.0000025f);
             lerpedTerrain[x] = lerp(lerpedTerrain[x], fft.getBand(x), 0.0000025f);
             
             vertex(x * scl, (y) * scl, map(noise(lerpedTerrain[y] * 100, lerpedTerrain[x] * 100), 0, 1, 0, 30));
             vertex(x * scl, (y+1) * scl, map(noise(lerpedTerrain[y] * 100, lerpedTerrain[x] * 100), 0, 1, 0, 30));
           }
           
           endShape();
           
         }
         
         if(isIndividual == true) {
          
           translate(width/2 + 80, -100, 120);
           
           rotateX(cubeAngle);
           rotateY(cubeAngle);
           rotateZ(cubeAngle);
           
           for(int i = 0; i < bands.length; i++) {
             
               lerpedBuffer[i] = lerp(lerpedBuffer[i], smoothedBands[i], 0.4f);
               
               float c = map(i, 0, bands.length, 0, 255);
               
               stroke(c, 255, 255);
               noFill();
               translate(0, 0, 0);
               
               box(60 + (lerpedBuffer[i] * 0.05));
           }
         } else {
         
           translate(width/2 + 80, -100, 120);
           for(int i = 0; i < bands.length; i++) {
             
               lerpedBuffer[i] = lerp(lerpedBuffer[i], smoothedBands[i], 0.4f);
               float c = map(i, 0, bands.length, 0, 255);
               
               stroke(c, 255, 255);
               noFill();
               translate(0, 0, 0);
               rotateX(cubeAngle);
               rotateY(cubeAngle);
               rotateZ(cubeAngle);
               box(50 + (lerpedBuffer[i] * 0.05));
           }
         }
       } else {
         
         fill(255);
         text("Turn Cubes On", -width/2 + 196, -height/2 + 160);
         
         cam.reset(0);
         
         rotateX(PI/2.8);
         translate(-w/2, -h/6);
       
         for(int y = 0; y < rows;  y++) {
           
           beginShape(TRIANGLE_STRIP);
           
           for (int x = 0; x < cols; x++) {
             
             stroke(255);
             noFill();
             
             lerpedTerrain[y] = lerp(lerpedTerrain[y], fft.getBand(y), 0.0000025f);
             lerpedTerrain[x] = lerp(lerpedTerrain[x], fft.getBand(x), 0.0000025f);
             
             vertex(x * scl, (y) * scl, map(noise(lerpedTerrain[y] * 100, lerpedTerrain[x] * 100), 0, 1, 0, 30));
             vertex(x * scl, (y+1) * scl, map(noise(lerpedTerrain[y] * 100, lerpedTerrain[x] * 100), 0, 1, 0, 30));
             
            }
            
            endShape();
            
           }
         }
       break;
     }
     
     case 2: {
       rect(-width/2 + 160, -height/2 + 125, 150, 60);
       
       if (isStars == true) {
         
         cam.reset(10);
         
         text("Turn Stars Off", -width/2 + 196, -height/2 + 160);
         
         for(int i = 0; i < 512; i++) {
           lerpedStars[i] = lerp(lerpedStars[i], fft.getBand(i), 1f);
           stars[i].resetStar(lerpedStars[i] * 8);
           stars[i].showStar();
         }
         
         noFill();
         lights();
         
         cellestial.showSystem();
         cellestial.orbit();
         
       } else {
         
         text("Turn Stars On", -width/2 + 196, -height/2 + 160); 
         noFill();
         lights();
         
         cellestial.showSystem();
         cellestial.orbit();
         
       }
     }
   }
}
