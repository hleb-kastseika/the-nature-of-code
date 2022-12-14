float t = 0.0;

void setup() {
    size(383, 200);
    smooth();
}


void draw() {
    background(255);
    float xoff = t;
    noFill();
    stroke(0);
    strokeWeight(2);
    beginShape();
    for (int i = 0; i < width; i++) {
        float y = noise(xoff) * height;
        xoff += 0.01;
        vertex(i, y);
    }
    endShape();
    t+= 0.01;
}
