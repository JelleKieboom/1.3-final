import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

int scene = 0; 
boolean sceneButton = true;

BPM bpm = new BPM();
int beats = 120; 
float calculation; 
boolean beatButton = true; 

//origin define 
boolean mistKnop = false; 

PGraphics bg; 

Stars[] stars = new Stars[800]; 
int randomVar = int(random(10, 100));

float xMist1 = 200; 
float yMist1 = 200; 
float xMist2 = 600; 
float yMist2 = 200; 
float xMist3 = 200; 
float yMist3 = 600; 
float xMist4 = 600; 
float yMist4 = 600; 
float xMist5 = 400; 
float yMist5 = 400; 

color[] mistColors = {
#30BCED, //cyan
#FC5130, //orange
#F5F749, //yellow
#FF6663, //hotpink
#9FFCDF, //mint 
#6B0504, //crimson
#73EC43, //green
#3E1A3D, //dark purple
#B370B0, //light purple
#2D2DA7, //blue 
#FF8F93 //pink
}; 

int[] randomMist = new int[5]; 

//prism define 
boolean ingedrukt = true; 
ArrayList <Sphere> circles = new ArrayList<Sphere>();
ArrayList <MiniSphere> small = new ArrayList<MiniSphere>(); 

color[] colors = {
#68D8D6, 
#E365C1, 
#0D2149, 
#E36414, 
#A1E44D, 
#E94F37, 
#FFFC31, 
}; 

int[] randomColors = new int[10]; 

//kaleidoscope define 
boolean gemButton = true; 
int colorScene = 0; 

float randomCrystal = random(0.9, 3);
float rotation = 0; 
int varCalc = 25; 

int ballAmount = int(random(2, 5.9));
int sineAmount = int(random(3, 6.9)); 
int miniAmount = int(random(3, 7.9));

void setup() {
  size(800, 800, P3D); 

  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(5, Arduino.INPUT);
  arduino.pinMode(6, Arduino.INPUT);
  arduino.pinMode(7, Arduino.INPUT);
  
  for(int i = 0; i < randomColors.length; i++) {
    randomColors[i] = #ffffff; 
  }
  
  bg = createGraphics(width, height);
  for(int i = 0; i < stars.length; i++) {
    stars[i] = new Stars();
  }
  for(int i = 0; i < randomMist.length; i++) {
    randomMist[i] = #000000; 
  }
}

void draw() {
  background(0); 
  bpm.run(beats); 
  
  int pento1 = arduino.analogRead(0);
  int pento2 = arduino.analogRead(1);
  
  if (arduino.digitalRead(7) == arduino.HIGH && sceneButton == false) {
    sceneButton = true; 
    scene++; 
    if(scene > 2) {
      scene = 0; 
    }
  }
  if (arduino.digitalRead(7) == arduino.LOW) {
    sceneButton = false;
  }
  
  if (arduino.digitalRead(6) == arduino.HIGH && beatButton == false) {
    beatButton = true; 
    beats++; 
    if(beats > 200) {
      beats = 20; 
    }
  }
  if (arduino.digitalRead(6) == arduino.LOW) {
    beatButton = false;
  }

  //origin
  if(scene == 0) {
    int starAmount = int(map(pento2, 0, 1023, 10, 800)); 
    float starSpeed = map(pento1, 0, 1023, 1, 15); 
    
    if (arduino.digitalRead(5) == arduino.HIGH && mistKnop == false) {
      mistKnop = true; 
      randomMist[0] = mistColors[int(random(10))];
      randomMist[1] = mistColors[int(random(10))];
      randomMist[2] = mistColors[int(random(10))];
      randomMist[3] = mistColors[int(random(10))];
      randomMist[4] = mistColors[int(random(10))];
    }
    if (arduino.digitalRead(5) == arduino.LOW) {
      mistKnop = false;
    } 
    
    pushMatrix(); 
    translate(width / 2, height / 2); 
    noStroke(); 
    for(int i = 1; i <= 50; i++) {
      fill(255 - i * 5.1, 3); 
      ellipse(0, 0, 5 + 10 * i, 5 + 10 * i);
    }
    popMatrix(); 
    
    calculation = bpm.triggerNorm * 5; 
    
    pushMatrix(); 
    mist(); 
    image(bg, 0, 0);
    translate(width / 2, height / 2);   
    if(bpm.every_4_once) {
      randomVar = int(random(10, 800));
    } 
    for(int i = 0; i < starAmount; i++) {
      stars[i].update(starSpeed); 
      stars[i].show(); 
    }
    popMatrix(); 
  }
  //prism
  if(scene == 1) {
    int sphereTotal = int(map(pento2, 0, 1023, 1, 7)); 
    int triSpeed = int(map(pento1, 0, 1023, 1, 4)); 
  
    if (arduino.digitalRead(5) == arduino.HIGH && ingedrukt == false) {
      ingedrukt = true; 
      circles.add(new Sphere(random(0, 7), random(0, 7), 50, 50, random(30, 50), sphereTotal)); 
    }
    if (arduino.digitalRead(5) == arduino.LOW) {
      ingedrukt = false;
    } 
  
    
    if(triSpeed == 1) {
      if(bpm.every_2_once) {
        randomColors[int(random(10))] = colors[int(random(7))]; 
      } 
    } 
    if(triSpeed == 2) {
      if(bpm.every_4_once) {
        randomColors[int(random(10))] = colors[int(random(7))]; 
      } 
    } 
    if(triSpeed == 3) {
      if(bpm.every_8_once) {
        randomColors[int(random(10))] = colors[int(random(7))]; 
      } 
    } 
    if(triSpeed == 4) {
      if(bpm.every_16_once) {
        randomColors[int(random(10))] = colors[int(random(7))]; 
      } 
    } 
    
    if(bpm.every_4_once) {
      randomColors[int(random(10))] = #ffffff; 
    }
    
    for(int i = 0; i < circles.size(); i++){
      Sphere s = circles.get(i);
      s.drawCircle(); 
    }  
    
    for(int i = 0; i < small.size(); i++){
      MiniSphere m = small.get(i);
      m.miniCircle(); 
    }
    calculation = bpm.triggerNorm * 15; 
    
    fill(255); 
    textSize(30); 
    text("Amount of big circles: " + circles.size(), width / 2 - 140, 50);
    
    noStroke(); 
    mainPrism(); 
    beatPrism(); 
    smallPrisms(); 
  }
  //kaleidoscope 
  if(scene == 2) {
    if (arduino.digitalRead(5) == arduino.HIGH && gemButton == false) {
      gemButton = true; 
      colorScene++; 
      if(colorScene > 2) {
        colorScene = 0; 
      }
    }
    if (arduino.digitalRead(5) == arduino.LOW) {
      gemButton = false;
    } 
  
    float increment = map(pento1, 0, 1023, 0.005, 0.1); 
    float arduino2 = map(pento2, 0, 1023, 20, 500);
    
    calculation = bpm.triggerNorm * varCalc; 
  
    if(bpm.every_2_once) {
       varCalc =  -varCalc; 
    }
  
    pushMatrix(); 
    translate(width / 2, height / 2);
    pushMatrix(); 
    rotate(rotation * 0.3);
    iris(arduino2); 
    crystalBall(); 
    popMatrix(); 
    pushMatrix(); 
    rotate(rotation); 
    waves(arduino2); 
    popMatrix(); 
    eye(); 
    rotate(rotation); 
    crystal(); 
  
    pushStyle(); 
    if(colorScene == 0) {
      fill(255, 50, 60, 170);
    }
    if(colorScene == 1) {
      fill(60, 255, 50, 170);
    }
    if(colorScene == 2) {
      fill(50, 60, 255, 170);
    } 
    miniCrystals(); 
    rotate(rotation + 0.1);
    outerCrystals(); 
    chainCrystals(); 
    popStyle(); 
    
    popMatrix();   
    
    rotation = rotation + increment; 
  }

  }

//origin functions 
void mist() {
  float moveX1 = random(-10, 10);
  float moveY1 = random(-10, 10);
  float moveX2 = random(-10, 10);
  float moveY2 = random(-10, 10);
  float moveX3 = random(-10, 10);
  float moveY3 = random(-10, 10);
  float moveX4 = random(-10, 10);
  float moveY4 = random(-10, 10);
  float moveX5 = random(-10, 10);
  float moveY5 = random(-10, 10);
  
  xMist1 = xMist1 + moveX1; 
  yMist1 = yMist1 + moveY1; 
  xMist2 = xMist2 + moveX2; 
  yMist2 = yMist2 + moveY2; 
  xMist3 = xMist3 + moveX3; 
  yMist3 = yMist3 + moveY3; 
  xMist4 = xMist4 + moveX4; 
  yMist4 = yMist4 + moveY4; 
  xMist5 = xMist5 + moveX5; 
  yMist5 = yMist5 + moveY5; 
  
  //Mist 1
  if(xMist1 > width) {
    xMist1 = xMist1 - 10; 
  }
  if(yMist1 > height) {
    yMist1 = yMist1 - 10; 
  }
  if(xMist1 < 0) {
    xMist1 = xMist1 + 10; 
  }
  if(yMist1 < 0) {
    yMist1 = yMist1 + 10; 
  }
  
  //Mist 2
  if(xMist2 > width) {
    xMist2 = xMist2 - 10; 
  }
  if(yMist2 > height) {
    yMist2 = yMist2 - 10; 
  }
  if(xMist2 < 0) {
    xMist2 = xMist2 + 10; 
  }
  if(yMist2 < 0) {
    yMist2 = yMist2 + 10; 
  }
  
  //Mist 3
  if(xMist3 > width) {
    xMist3 = xMist3 - 10; 
  }
  if(yMist3 > height) {
    yMist3 = yMist3 - 10; 
  }
  if(xMist3 < 0) {
    xMist3 = xMist3 + 10; 
  }
  if(yMist3 < 0) {
    yMist3 = yMist3 + 10; 
  }
  
  //Mist 4
  if(xMist4 > width) {
    xMist4 = xMist4 - 10; 
  }
  if(yMist4 > height) {
    yMist4 = yMist4 - 10; 
  }
  if(xMist4 < 0) {
    xMist4 = xMist4 + 10; 
  }
  if(yMist4 < 0) {
    yMist4 = yMist4 + 10; 
  }
  
  //Mist 5
  if(xMist5 > width) {
    xMist5 = xMist5 - 10; 
  }
  if(yMist5 > height) {
    yMist5 = yMist5 - 10; 
  }
  if(xMist5 < 0) {
    xMist5 = xMist5 + 10; 
  }
  if(yMist5 < 0) {
    yMist5 = yMist5 + 10; 
  }

  bg.beginDraw(); 
  bg.noStroke(); 
  bg.fill(randomMist[0], 3); 
  bg.ellipse(xMist1, yMist1, 30, 30); 
  bg.fill(randomMist[1], 3);
  bg.ellipse(xMist2, yMist2, 30, 30);
  bg.fill(randomMist[2], 3); 
  bg.ellipse(xMist3, yMist3, 30, 30); 
  bg.fill(randomMist[3], 3);
  bg.ellipse(xMist4, yMist4, 30, 30);
  bg.fill(randomMist[4], 3); 
  bg.ellipse(xMist5, yMist5, 30, 30); 
  bg.endDraw(); 
}

//prism functions 

void mainPrism() {
  fill(255);
  beginShape(); 
  vertex(width / 2, height / 2 - 80); 
  vertex(width / 2 + 140, height / 2 + 80); 
  vertex(width / 2 - 140, height / 2 + 80); 
  endShape(CLOSE); 
}
  
void beatPrism() {
  fill(255, 255, 255, 100);
  beginShape(); 
  vertex(width / 2, height / 2 - 80 - calculation); 
  vertex(width / 2 + 140 + calculation * 2, height / 2 + 80 + calculation); 
  vertex(width / 2 - 140 - calculation * 2, height / 2 + 80 + calculation); 
  endShape(CLOSE);
}
  
void smallPrisms() {
  fill(randomColors[0], 220); 
  beginShape(); 
  vertex(width / 2 - 140, height / 2 + 80);
  vertex(width / 2 - 85, height / 2 + 80);
  vertex(width / 2 - 101, height / 2 + 34);
  endShape(CLOSE); 
  
  fill(randomColors[1], 220); 
  beginShape(); 
  vertex(width / 2 - 85, height / 2 + 80);
  vertex(width / 2 - 65, height / 2 + 80);
  vertex(width / 2 - 65, height / 2 + 35);
  vertex(width / 2 - 91, height / 2 + 23);
  vertex(width / 2 - 101, height / 2 + 34);
  endShape(CLOSE); 
  
  fill(randomColors[2], 220); 
  beginShape(); 
  vertex(width / 2 - 65, height / 2 + 80);
  vertex(width / 2 - 5, height / 2 + 80);
  vertex(width / 2 - 45, height / 2 + 44);
  vertex(width / 2 - 65, height / 2 + 35);
  endShape(CLOSE); 
  
  fill(randomColors[3], 220); 
  beginShape(); 
  vertex(width / 2 - 5, height / 2 + 80);
  vertex(width / 2 + 105, height / 2 + 40);
  vertex(width / 2 - 20, height / 2 + 50);
  vertex(width / 2 - 30, height / 2 + 58);
  endShape(CLOSE); 
  
  fill(randomColors[4], 220); 
  beginShape(); 
  vertex(width / 2 - 5, height / 2 + 80);
  vertex(width / 2 + 75, height / 2 + 80);
  vertex(width / 2 + 35, height / 2 + 65);
  endShape(CLOSE); 
  
  fill(randomColors[5], 220); 
  beginShape(); 
  vertex(width / 2 + 75, height / 2 + 80);
  vertex(width / 2 + 140, height / 2 + 80);
  vertex(width / 2 + 105, height / 2 + 40);
  vertex(width / 2 + 35, height / 2 + 65);
  endShape(CLOSE); 
  
  fill(randomColors[6], 220); 
  beginShape(); 
  vertex(width / 2 - 91, height / 2 + 24);
  vertex(width / 2 - 45, height / 2 + 44);
  vertex(width / 2 - 35, height / 2 + 5);
  vertex(width / 2 - 57, height / 2 - 15);
  endShape(CLOSE); 
  
  fill(randomColors[7], 220); 
  beginShape(); 
  vertex(width / 2 - 45, height / 2 + 44);
  vertex(width / 2 - 30, height / 2 + 58);
  vertex(width / 2 + 49, height / 2 - 5);
  vertex(width / 2 - 35, height / 2 + 5);
  endShape(CLOSE); 
  
  fill(randomColors[8], 220); 
  beginShape(); 
  vertex(width / 2 - 20, height / 2 + 50);
  vertex(width / 2 + 105, height / 2 + 40);
  vertex(width / 2 + 56, height / 2 - 16);
  endShape(CLOSE); 
  
  fill(randomColors[9],  220); 
  beginShape(); 
  vertex(width / 2 - 57, height / 2 - 15);
  vertex(width / 2 - 35, height / 2 + 5);
  vertex(width / 2 + 42, height / 2 - 4);
  vertex(width / 2 + 56, height / 2 - 16);
  vertex(width / 2, height / 2 - 80);
  endShape(CLOSE); 
}

//kaleidoscope functions 

void crystalBall() {
  pushMatrix(); 
  float ballAngle = 90; 
  if(ballAmount == 2) {
    ballAngle = 120; 
  }
  if(ballAmount == 3) {
    ballAngle = 90; 
  }
  if(ballAmount == 4) {
    ballAngle = 72; 
  }
  
  for(int i = 0; i <= ballAmount; i++) {
      if(colorScene == 0) {
        fill(255, 60, 70, 220);
      }
      if(colorScene == 1) {
        fill(60, 255, 60, 220);
      }
      if(colorScene == 2) {
        fill(60, 70, 255, 220);
      }  
      noStroke(); 
      ellipse(300 + calculation / 2, 0, 80 + calculation / 4, 80 + calculation / 4);
      if(colorScene == 0) {
        fill(255, 100, 110, 200);
      }
      if(colorScene == 1) {
        fill(110, 255, 100, 200);
      }
      if(colorScene == 2) {
        fill(100, 110, 255, 200);
      } 
      ellipse(300 + calculation / 2, 0, 60 + calculation / 4, 60 + calculation / 4);
      fill(255, 160); 
      ellipse(320 + calculation / 2, -15, 15 + calculation / 8, 15 + calculation / 8);
      ellipse(316 + calculation / 2, 18, 6 + calculation / 8, 6 + calculation / 8);
      if(colorScene == 0) {
        fill(255, 255, 110, 100);
      }
      if(colorScene == 1) {
        fill(255, 110, 255, 100);
      }
      if(colorScene == 2) {
        fill(110, 255, 255, 100);
      } 
      ellipse(283 + calculation / 2, -10, 10 + calculation / 12, 10 + calculation / 12);
      ellipse(310 + calculation / 2, 15, 10 + calculation / 12, 10 + calculation / 12);
      ellipse(290 + calculation / 2, 12, 10 + calculation / 12, 10 + calculation / 12);
      pushStyle(); 
      stroke(255, 130, 255, 150);
      strokeWeight(4);
      noFill(); 
      ellipse(300 + calculation / 2, 0, 30 + calculation / 4, 30 + calculation / 4); 
      popStyle(); 
      rotate(radians(ballAngle));
    }
  popMatrix(); 
  }


void waves(float arduinoMap) {
  pushMatrix(); 
  float sineAngle = 60; 
  if(sineAmount == 3) {
    sineAngle = 90; 
  }
  if(sineAmount == 4) {
    sineAngle = 72; 
  }
  if(sineAmount == 5) {
    sineAngle = 60; 
  }
  if(sineAmount == 6) {
    sineAngle = 51.428; 
  }
  
  for(int i = 0; i <= sineAmount; i++) {
    for(int x = 0; x <= width * 10; x = x + 10) {
      
      if(colorScene == 0) {
        fill(arduinoMap, 255, 255, 150);
      }
      if(colorScene == 1) {
        fill(255, arduinoMap, 255, 150);
      }
      if(colorScene == 2) {
        fill(255, 255, arduinoMap, 150);
      } 
      
      float r = 50; 
      float y = r * sin(radians(x));
      noStroke(); 
      ellipse(x * arduinoMap / 100, y, 10 + calculation / 5, 10 + calculation / 5);
    }
    rotate(radians(sineAngle));
  }
  popMatrix(); 
}

void eye() {
  fill(255); 
  beginShape(); 
  vertex(-200, 0); 
  vertex(-170, 20 - calculation / 2); 
  vertex(-130, 50 - calculation); 
  vertex(0, 90 - calculation); 
  vertex(130, 50 - calculation); 
  vertex(170, 20 - calculation / 2); 
  vertex(200, 0); 
  vertex(170, -20 + calculation / 2); 
  vertex(130, -50 + calculation); 
  vertex(0, -90 + calculation); 
  vertex(-130, -50 + calculation); 
  vertex(-170, -20 + calculation / 2); 

  endShape(CLOSE); 
  fill(0); 
  ellipse(0, 0, 90, 90); 
}

void crystal() {
  noStroke(); 
  for(int i = 0; i <= 4; i++) {
    pushMatrix();
    float r = radians(i * 72); 
    rotate(r);
  if(colorScene == 0) {
    fill(255, 60, 70, 220);
  }
  if(colorScene == 1) {
    fill(60, 255, 60, 220);
  }
  if(colorScene == 2) {
    fill(60, 70, 255, 220);
  } 
    beginShape(); 
    vertex(25 - calculation, 0);
    vertex(75 - calculation, -35);
    vertex(255 - calculation, 0);
    vertex(75 - calculation, 35);
    endShape(CLOSE); 
  if(colorScene == 0) {
    fill(255, 100, 110, 200);
  }
  if(colorScene == 1) {
    fill(110, 255, 100, 200);
  }
  if(colorScene == 2) {
    fill(100, 110, 255, 200);
  } 
    beginShape(); 
    vertex(30 - calculation, 0);
    vertex(55 - calculation, -15);
    vertex(140 - calculation, 0);
    vertex(55 - calculation, 15);
    endShape(CLOSE); 
    popMatrix();
  }
}

void miniCrystals() {
  float miniAngle = 45; 
  if(miniAmount == 3) {
    miniAngle = 90; 
  }
  if(miniAmount == 4) {
    miniAngle = 72; 
  }
  if(miniAmount == 5) {
    miniAngle = 60; 
  }
  if(miniAmount == 6) {
    miniAngle = 51.428; 
  }
  if(miniAmount == 7) {
    miniAngle = 45; 
  }
  
  noStroke(); 
  for(int i = 0; i <= miniAmount; i++) {
    pushMatrix();
    float r = radians(i * miniAngle); 
    rotate(r);
    beginShape(); 
    vertex(15 - calculation * 0.4, 0);
    vertex(40 - calculation * 0.4, -10);
    vertex(60 - calculation * 0.4, 0);
    vertex(40 - calculation * 0.4, 10);
    endShape(CLOSE); 
    popMatrix();
  }
}

void outerCrystals() {
  noStroke(); 
  for(int i = 0; i <= 15; i++) {
    pushMatrix();
    float r = radians(i * 22.5); 
    rotate(r);
    beginShape(); 
    vertex(245 - calculation * randomCrystal, 0);
    vertex(260 - calculation, -15);
    vertex(265 - calculation * randomCrystal, 0);
    vertex(260 - calculation, 15);
    endShape(CLOSE); 
    popMatrix();
  }
}

void chainCrystals() {
  noStroke(); 
  for(int i = 0; i <= 9; i++) {
    pushMatrix();
    float r = radians(i * 36); 
    rotate(r);
    for(int j = 0; j < width; j = j + 40) {
      beginShape(); 
      vertex(j + calculation / 3, 0);
      vertex(j + 10 + calculation / 3, 5);
      vertex(j + 20 + calculation / 3, 0);
      vertex(j + 10 + calculation / 3, -5);
      endShape(CLOSE); 
    }
    popMatrix();
  }
}

void iris(float tempArduino) {
      if(colorScene == 0) {
        stroke(tempArduino, 255, 255, 60);
      }
      if(colorScene == 1) {
        stroke(255, tempArduino, 255, 60);
      }
      if(colorScene == 2) {
        stroke(255, 255, tempArduino, 60);
      } 
      strokeWeight(1); 
  noFill();
  beginShape(); 
  for(int i = 0; i < 360; i+=1) {
    float rIris = random(420, 470); 
    float xIris = rIris * cos(i);
    float yIris = rIris * sin(i);
    vertex(xIris, yIris);
  }
  endShape(CLOSE); 
}

void keyPressed() {
  if(key == 'c' || key == 'C') {
    bg.clear(); 
  }
  if(key == 'b' || key == 'B') {
    beats++; 
    if(beats > 200) {
      beats = 20; 
    }
  }
  if(key == 'v' || key == 'V') {
    beats--; 
    if(beats < 20) {
      beats = 200; 
    }
  }
}
