class Connection {
    Neuron a;
    Neuron b;
  
    float weight;

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

    Network(float x, float y) {
        location = new PVector(x, y);
        neurons = new ArrayList<Neuron>();
    }

    void addNeuron(Neuron n) {
        neurons.add(n);
    }
  
    void connect(Neuron a, Neuron b) {
        Connection c = new Connection(a, b, random(1));
        a.addConnection(c);
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

class Neuron {
    PVector location;
    ArrayList<Connection> connections;
  
    Neuron(float x, float y) {
        location = new PVector(x, y);
        connections = new ArrayList<Connection>();
    }
  
    void addConnection(Connection c) {
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

Network network;

void setup() {
    size(800, 200); 
    smooth();
  
    network = new Network(width / 2, height / 2);
  
    Neuron a = new Neuron(-300, 0);
    Neuron b = new Neuron(0, 75);
    Neuron c = new Neuron(0, -75);
    Neuron d = new Neuron(300, 0);
  
    network.connect(a, b);
    network.connect(a, c);
    network.connect(b, d);
    network.connect(c, d);

    network.addNeuron(a);
    network.addNeuron(b);
    network.addNeuron(c);
    network.addNeuron(d);
}

void draw() {
    background(255);
    network.display();
    noLoop();
}
