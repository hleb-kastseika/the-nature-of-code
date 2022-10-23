float yoff = 0;
int seed = 5;


void setup() {
    size(380, 200);
    smooth();
}

void draw() {
    background(255);
    fill(0);
  
    stroke(0);
    translate(width / 2, height);
    yoff += 0.005;
    randomSeed(seed);
    branch(60, 0);
}

void mousePressed() {
    yoff = random(1000);
    seed = millis();
}

void branch(float h, float xoff) {
    float sw = map(h, 2, 100, 1, 5);
    strokeWeight(sw);
    line(0, 0, 0, -h);
    translate(0, -h);
    
    h *= 0.7f;
  
    xoff += 0.1;

    if (h > 4) {
        int n = int(random(0, 5));
        for (int i = 0; i < n; i++) {
            float theta = map(noise(xoff+i, yoff), 0, 1, -PI / 3, PI / 3);
            if (n%2==0) theta *= -1;
            pushMatrix();
            rotate(theta);
            branch(h, xoff);
            popMatrix();
        }
    }
}
