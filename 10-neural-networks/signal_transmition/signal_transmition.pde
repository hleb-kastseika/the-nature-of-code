class Neuron {
    PVector location;
    ArrayList<Connection> connections;
    float sum = 0;
    float r = 32;
  
    Neuron(float x, float y) {
        location = new PVector(x, y);
        connections = new ArrayList<Connection>();
    }

    void addConnection(Connection c) {
        connections.add(c);
    } 
  
    void feedforward(float input) {
        sum += input;
        if (sum > 1) {
            fire();
            sum = 0;
        } 
    }

    void fire() {
        r = 64;
        for (Connection c : connections) {
            c.feedforward(sum);
        } 
    }
  
    void display() {
        stroke(0);
        strokeWeight(1);
        float b = map(sum, 0, 1, 255, 0);
        fill(b);
        ellipse(location.x, location.y, r, r);
        r = lerp(r, 32, 0.1);
    }
}

class Connection {
    Neuron a;
    Neuron b;
    float weight;
    boolean sending = false;
    PVector sender;
    float output = 0;

    Connection(Neuron from, Neuron to, float w) {
        weight = w;
        a = from;
        b = to;
    }

    void feedforward(float val) {
        output = val * weight;
        sender = a.location.copy();
        sending = true;
    }
  
    void update() {
        if (sending) {
            sender.x = lerp(sender.x, b.location.x, 0.1);
            sender.y = lerp(sender.y, b.location.y, 0.1);
            float d = PVector.dist(sender, b.location);
            if (d < 1) {
                b.feedforward(output);
                sending = false;
            }
        }
    }
  
    void display() {
        stroke(0);
        strokeWeight(1 + weight * 4);
        line(a.location.x, a.location.y, b.location.x, b.location.y);

        if (sending) {
            fill(0);
            strokeWeight(1);
            ellipse(sender.x, sender.y, 16, 16);
        }
    }
}

class Network {
    ArrayList<Neuron> neurons;
    ArrayList<Connection> connections;
    PVector location;

    Network(float x, float y) {
        location = new PVector(x, y);
        neurons = new ArrayList<Neuron>();
        connections = new ArrayList<Connection>();
    }

    void addNeuron(Neuron n) {
        neurons.add(n);
    }

    void connect(Neuron a, Neuron b, float weight) {
        Connection c = new Connection(a, b, weight);
        a.addConnection(c);
        connections.add(c);
    } 
  
    void feedforward(float input1, float input2, float input3, float input4) {
        Neuron n1 = neurons.get(0);
        n1.feedforward(input1);
    
        Neuron n2 = neurons.get(1);
        n2.feedforward(input2);
        
        Neuron n3 = neurons.get(2);
        n3.feedforward(input3);
    
        Neuron n4 = neurons.get(3);
        n4.feedforward(input4);
    }
  
    void update() {
        for (Connection c : connections) {
            c.update();
        }
    }
  
    void display() {
        pushMatrix();
        translate(location.x, location.y);
        for (Neuron n : neurons) {
            n.display();
        }

        for (Connection c : connections) {
            c.display();
        }
        popMatrix();
    }
}

Network network;

void setup() {
    size(1000, 800); 
    smooth();

    network = new Network(width / 2, height / 2);

    int layers = 10;
    int inputs = 4;

    Neuron output = new Neuron(250, 0);
    for (int i = 0; i < layers; i++) {
        for (int j = 0; j < inputs; j++) {
            float x = map(i, 0, layers, -300, 300);
            float y = map(j, 0, inputs-1, -75, 75);
            Neuron n = new Neuron(x, y);
            if (i > 0) {
                for (int k = 0; k < inputs; k++) {
                    Neuron prev = network.neurons.get(network.neurons.size() - inputs + k - j); 
                    network.connect(prev, n, random(1));
                }
            }
            if (i == layers - 1) {
                network.connect(n, output, random(1));
            }
            network.addNeuron(n);
        }
    } 
    network.addNeuron(output);
}

void draw() {
    background(255);
    network.update();
    network.display();
    
    if (frameCount % 30 == 0) {
        network.feedforward(random(1), random(1), random(1), random(1));
    }
}
