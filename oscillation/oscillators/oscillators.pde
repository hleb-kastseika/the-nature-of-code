class Oscillator {
    PVector angle;
    PVector velocity;
    PVector amplitude;

    Oscillator() {
        angle = new PVector(random(width), random(height));
        velocity = new PVector(random(-0.05, 0.05), random(-0.05, 0.05));
        amplitude = new PVector(random(width / 2), random(height / 2));
    }

    void oscillate(PVector aVelocity) {
        angle.add(aVelocity);
    }

      void display() {
          float x = sin(angle.x) * amplitude.x;
          float y = sin(angle.y) * amplitude.y;

          pushMatrix();
          translate(width / 2, height / 2);
          stroke(0);
          fill(175);

          line(0, 0, x, y);
          ellipse(x, y, 16, 16);
          popMatrix();
    }
}

Oscillator[] oscilators = new Oscillator[20];
float tx = random(100);

void setup() {
    size(1000, 800);
  
  
    for (int i = 0; i < 20; i++) {
        Oscillator o = new Oscillator();
        oscilators[i] = o;
    }
}

void draw() {
    background(255);
    for (int i = 0; i < 20; i++) {
        Oscillator o = oscilators[i];
        
        o.oscillate(new PVector(map(noise(tx), 0, 1, -0.1, 0.1), map(noise(tx), 0, 1, -0.1, 0.1)));
        
        o.display();
    }
    tx += 0.01;
}
