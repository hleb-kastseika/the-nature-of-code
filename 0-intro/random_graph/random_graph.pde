void setup() {
    size(383, 200);
    smooth();
}


void draw() {
    background(255);
    noFill();
    stroke(0);
    strokeWeight(2);
    beginShape();
    for (int i = 0; i < width; i++) {
        float y = random(height);
        vertex(i, y);
    }
    endShape();
    noLoop();
}
