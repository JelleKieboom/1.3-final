class Sphere {
  float x; 
  float y; 
  float movementX; 
  float movementY; 
  float circleSize; 
  int randLength; 
  int sphereMax; 
  
  Sphere(float tempSpeedX, float tempSpeedY, float tempX, float tempY, float tempSize, int tempTotal) {
  movementX = tempSpeedX; 
  movementY = tempSpeedY; 
  circleSize = tempSize;
  x = tempX; 
  y = tempY; 
  randLength = int(random(1, 7)); 
  sphereMax = tempTotal; 
  }
  
  void drawCircle() {
    noStroke(); 
    fill(255, 255, 255, 250);
    x = x + movementX; 
    y = y + movementY; 
    ellipse(x, y, circleSize + calculation, circleSize + calculation);
    
    if(x >= width - circleSize / 2 || x <= 0 + circleSize / 2) {
      movementX = -movementX; 
    }
    
    if(y >= height - circleSize / 2 || y <= 0 + circleSize / 2) {
      movementY = -movementY; 
    }
    
    if(x>=width/2-100 && x<=width/2+100 && y>=height/2+35 && y<=height/2+80 || 
    x>=width/2-55 && x<=width/2+55 && y>=height/2-15 && y<=height/2+35 || 
    x>=width/2-20 && x<=width/2+20 && y>=height/2-55 && y<=height/2-15) {
      circles.remove(this); 
      for(int i = 1; i <= sphereMax; i++) {
        small.add(new MiniSphere(random(-7, 7), random(-7, 7), width / 2, height / 2, colors[int(random(7))], random(10, 20)));
      }
    }
  }
}
