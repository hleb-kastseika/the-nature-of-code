import java.util.Random;

Random generator;
int frameSize = 800;

void setup() {
    size(800, 800);
    background(1);
    generator = new Random();
}


void draw() {
    noStroke();
    fill(getDistributedValue(255, 100), getDistributedValue(255, 100), getDistributedValue(255, 100), 70);
    ellipse(getDistributedValue(frameSize, 60), getDistributedValue(frameSize, 60), 16, 16);
}

float getDistributedValue(int value, float sd) {
    float num = (float) generator.nextGaussian();
    float mean = value / 2;
    return sd * num + mean;
}
