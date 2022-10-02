class Walker {
    float x, y;
    float tx, ty;
 
    Walker() {
        tx = random(10000);
        ty = random(10000);
    }
 
    void step() {
        x = map(noise(tx), 0, 1, 0, width);
        y = map(noise(ty), 0, 1, 0, height);
 
        tx += 0.01;
        ty += 0.01;
    }
  
    void display() {
        stroke(0);
        ellipse(x, y, 5, 5);
        point(x, y);
    }
}


Walker w1;

void setup() {
    size(800, 800);
    w1 = new Walker();
    background(255);
    rect(380, 380, 350, 350);
    fill(0);
}

void draw() {
    w1.step();
    w1.display();
}
