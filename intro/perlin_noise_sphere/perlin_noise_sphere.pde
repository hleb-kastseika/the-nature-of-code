// import the video export library
import com.hamoid.*;

VideoExport videoExport;

PVector[][] globe;
int total = 250;
float bolbingMax = 1.1;
float phase = 0;
float colorMutator = 0.04;
float speed = 0.03;

PVector[] stars;

void setup() {
  size(600, 600, P3D);
  colorMode(HSB, 255);
  globe = new PVector[total + 1][total + 1];
  
  videoExport = new VideoExport(this, "myVideo.mp4");
  videoExport.setFrameRate(30);  
  videoExport.startMovie();
}

float xoff = 0;

void draw() {
  background(0);
  noStroke();
  translate(300, 300, 0);
  
  push();
  
  // Add some rotation
  rotateX(phase / 2);
  rotateY(phase / 2);
  rotateZ(phase / 2);
  
  for (int i = 0; i < total + 1; i++) {
    float lat = map(i, 0, total, 0, PI);
    
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, 0, TWO_PI);
      
      
      float xoff = map(sin(lat) * cos(lon), -1, 1, 0, bolbingMax);
      float yoff = map(sin(lat) * sin(lon), -1, 1, 0, bolbingMax);
      float zoff = map(cos(lat), -1, 1, 0, bolbingMax);
      float pNoise = noise(xoff + phase, yoff + phase, zoff + phase);
      float r = map(pNoise, 0, 1, 100, 200);
      
      float x = r * sin(lat) * cos(lon);
      float y = r * sin(lat) * sin(lon);
      float z = r * cos(lat);
      globe[i][j] = new PVector(x, y, z);
      
      if (i != 0) {
        PVector v1 = globe[i - 1][j];
        PVector v2 = globe[i][j];
        
        // Color with Perlin noise
        float redShift = map(r, 100, 200, 0, 25);
        float cNoise = noise(phase + colorMutator * v1.x, phase + colorMutator * v1.y, phase +colorMutator * v1.z);
        float hu = map(cNoise, 0, 1, 0, 45 - redShift);
        fill(hu, 255, 255);
        
        vertex(v1.x, v1.y, v1.z);
        
        vertex(v2.x, v2.y, v2.z);
      }
    }
    endShape();
  }
  pop();

  phase += speed;
  videoExport.saveFrame();
}

void keyPressed() {
  if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}                                                                                   
