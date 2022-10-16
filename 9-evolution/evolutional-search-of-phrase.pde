class DNA {
    char[] genes;
    float fitness;

    DNA() {
        genes = new char[target.length()];
        for (int i = 0; i < genes.length; i++) {
            genes[i] = (char) random(32, 128);
        }
    }
  
    DNA(int length) {
        genes = new char[length];
        for (int i = 0; i < genes.length; i++) {
            genes[i] = (char) random(32, 128);
        }
    }
  
    void fitness() {
        int score = 0;
        for (int i = 0; i < genes.length; i++) {
            if (genes[i] == target.charAt(i)) {
                score++;
            }
         }
         fitness = float(score) / target.length();
         
         if (target.equals(new String(genes))) {
             println("We riched the target!");
             exit();
         }
    }
  
    DNA crossover(DNA partner) {
        DNA child = new DNA(genes.length);
        int midpoint = int(random(genes.length));
        for (int i = 0; i < genes.length; i++) {
            if (i > midpoint) {
                child.genes[i] = genes[i];
            } else {
                child.genes[i] = partner.genes[i];
            }
        }
        return child;
    }
  
    void mutate(float mutationRate) {
        for (int i = 0; i < genes.length; i++) {
            if (random(1) < mutationRate) {
                genes[i] = (char) random(32, 128);
            }
        }
    }
  
    String getPhrase() {
        return new String(genes);
    }
}

float mutationRate;
int totalPopulation = 150;
DNA[] population;
ArrayList<DNA> matingPool;
String target;

void setup() {
    size(640, 360);

    target = "to be or not to be";
    mutationRate = 0.01;

    population = new DNA[totalPopulation];
    for (int i = 0; i < population.length; i++) {
        population[i] = new DNA();
    }
}
int genNumber = 0;

void draw() {
    genNumber++;
    println(genNumber);
    for (int i = 0; i < population.length; i++) {
        population[i].fitness();
    }

    ArrayList<DNA> matingPool = new ArrayList<DNA>();

    for (int i = 0; i < population.length; i++) {
        int n = int(population[i].fitness * 100);
        for (int j = 0; j < n; j++) {
            matingPool.add(population[i]);
        }
    }

    for (int i = 0; i < population.length; i++) {
        int a = int(random(matingPool.size()));
        int b = int(random(matingPool.size()));
        DNA partnerA = matingPool.get(a);
        DNA partnerB = matingPool.get(b);
        DNA child = partnerA.crossover(partnerB);
        child.mutate(mutationRate);

        population[i] = child;
    }
}
