class KochLine {
    PVector start;
    PVector end;

    KochLine(PVector a, PVector b) {
        start = a.copy();
        end = b.copy();
    }

    void display() {
        stroke(0);
        line(start.x, start.y, end.x, end.y);
    }

    PVector kochA() {
        return start.copy();
    }

    PVector kochB() {
        PVector v = PVector.sub(end, start);
        v.div(3);
        v.add(start);
        return v;
    }    

    PVector kochC() {
        PVector a = start.copy();
        PVector v = PVector.sub(end, start);
        v.div(3);
        a.add(v);
        rotate(v, -radians(60));
        a.add(v);
        return a;
    }    

    PVector kochD() {
        PVector v = PVector.sub(end, start);
        v.mult(2 / 3.0);
        v.add(start);
        return v;
    }

    PVector kochE() {
        return end.copy();
    }
}

public void rotate(PVector v, float theta) {
    float xTemp = v.x;
    v.x = v.x * PApplet.cos(theta) - v.y * PApplet.sin(theta);
    v.y = xTemp * PApplet.sin(theta) + v.y * PApplet.cos(theta);
}

ArrayList<KochLine> lines;

void setup() {
    size(600, 692);
    background(255);
    lines = new ArrayList<KochLine>();
    PVector a   = new PVector(0, 173);
    PVector b   = new PVector(width, 173);
    PVector c   = new PVector(width / 2, 173 + width * cos(radians(30)));
  
    lines.add(new KochLine(a, b));
    lines.add(new KochLine(b, c));
    lines.add(new KochLine(c, a));
  
    for (int i = 0; i < 5; i++) {
        generate();
    }
    smooth();
}

void draw() {
    background(255);
    for (KochLine l : lines) {
        l.display();
    }
}

void generate() {
    ArrayList next = new ArrayList<KochLine>();
    for (KochLine l : lines) {
        PVector a = l.kochA();                 
        PVector b = l.kochB();
        PVector c = l.kochC();
        PVector d = l.kochD();
        PVector e = l.kochE();
        next.add(new KochLine(a, b));
        next.add(new KochLine(b, c));
        next.add(new KochLine(c, d));
        next.add(new KochLine(d, e));
    }
    lines = next;
}
