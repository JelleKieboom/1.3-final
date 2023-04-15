class MiniSphere {
  float x; 
  float y; 
  float movementX; 
  float movementY; 
  float circleSize; 
  color circleColor;
  
  MiniSphere(float tempSpeedX, float tempSpeedY, float tempX, float tempY, color tempCol, float tempSize) {
  movementX = tempSpeedX; 
  movementY = tempSpeedY; 
  circleSize = tempSize;
  circleColor = tempCol; 
  x = tempX; 
  y = tempY; 
  }
  
  void miniCircle() {
    noStroke(); 
    fill(circleColor, 150);
    x = x + movementX; 
    y = y + movementY; 
    ellipse(x, y, circleSize + calculation, circleSize + calculation);
    
    if(x >= width - circleSize / 2 || x <= 0 + circleSize / 2) {
      movementX = -movementX; 
    }
    
    if(y >= height - circleSize / 2 || y <= 0 + circleSize / 2) {
      movementY = -movementY; 
    }
  }  
}
