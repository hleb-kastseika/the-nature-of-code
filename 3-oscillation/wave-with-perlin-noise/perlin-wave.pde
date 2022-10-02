float startAngle = 0;
float angleVel = 0.1;

void setup() {
    size(1000, 800);
}

void draw() {
    background(255);

    startAngle += 0.02;
    float angle = startAngle;

    for (int x = 0; x <= width; x += 24) {
        float y = map(noise(angle), -1, 1, 0, height);
        stroke(0);
        fill(0, 50);
        ellipse(x, y, 48, 48);
        angle += angleVel;
    }
}
