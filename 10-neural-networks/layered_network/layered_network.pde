class Neuron {
    PVector location;
    ArrayList<Connection> connections;

    Neuron(float x, float y) {
        location = new PVector(x, y);
        connections = new ArrayList<Connection>();
    }

    void connect(Neuron n) {
        Connection c = new Connection(this, n, random(1));
        connections.add(c);
    } 

    void display() {
        stroke(0);
        strokeWeight(1);
        fill(0);
        ellipse(location.x, location.y, 16, 16);

        for (Connection c : connections) {
            c.display();
        }
    }
}

class Connection {
    float weight;
    Neuron a;
    Neuron b;

    Connection(Neuron from, Neuron to, float w) {
        weight = w;
        a = from;
        b = to;
    }

    void display() {
        stroke(0);
        strokeWeight(weight * 4);
        line(a.location.x, a.location.y, b.location.x, b.location.y);
    }
}

class Network {
    ArrayList<Neuron> neurons;
    PVector location;
  
    Network(int layers, int inputs, int outputs) {
        location = new PVector(width / 2, height / 2);
        neurons = new ArrayList<Neuron>();
    
        Neuron output = new Neuron(250, 0);
        for (int i = 0; i < layers; i++) {
            for (int j = 0; j < inputs; j++) {
                float x = map(i, 0, layers, -200, 200);
                float y = map(j, 0, inputs-1, -100, 100);
                println(j + " " + y);
                Neuron n = new Neuron(x, y);
        
                if (i > 0) {
                    for (int k = 0; k < inputs; k++) {
                        Neuron prev = neurons.get(neurons.size() - inputs + k - j); 
                        prev.connect(n);
                    }
                }
        
                if (i == layers - 1) {
                    n.connect(output);
                }
                neurons.add(n);
            }
        } 
        neurons.add(output);
    }

    void display() {
        pushMatrix();
        translate(location.x, location.y);
        for (Neuron n : neurons) {
            n.display();
        }
        popMatrix();
    }
}

Network network;

void setup() {
    size(640, 360); 
    smooth();
    network = new Network(4, 3, 1);
}

void draw() {
    background(255);
    network.display();
}
