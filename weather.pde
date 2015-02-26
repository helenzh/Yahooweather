import com.temboo.core.*;
import com.temboo.Library.Yahoo.Weather.*;

// Create a session using your Temboo account application details
TembooSession session = new TembooSession("helenhair", "myFirstApp", "294b0ba3ae7245f498bb14224049870c");

//Delare location array 
String[] location;
int currentLocation = 0;

// Declare fonts
PFont fontTemperature, fontLocation, fontInstructions;

// Give on-screen user instructions
String instructions = "Press any key to change cities";

// Set up some global values
int temperature;
int temperatureText;
int windSpeed;
int humidity;
XML weatherResults;
float yoff = 0.0;
ParticleSystem ps;

void setup() {
  size(1280, 590);
//background(50);
  // Set up fonts
  fontTemperature = loadFont("HelveticaNeue-Bold-150.vlw");
  //fontT =loadFont("HelveticaNeue-Bold-60.vlw");
  fontLocation = loadFont("HelveticaNeue-Bold-36.vlw");
  fontInstructions = loadFont("HelveticaNeue-12.vlw");
  fill(255); // Font color
ps = new ParticleSystem(new PVector(width,100));

  // Set up locations
  location = new String[8]; // Total number of locations listed below
  location[0] = "Champaign";
  location[1] = "San Francisco";
  location[2] = "New York";
  location[3] = "Bangkok";
  location[4] = "London";
  location[5] = "Las Vegas";
  location[6] = "Melbourne";
  location[7] = "Barrow";


  // Display initial location
  runGetWeatherByAddressChoreo(); // Run the GetWeatherByAddress Choreo function
  getTemperatureFromXML(); // Get the temperature from the XML results
  //getTemperatureTextFromXML();
  getwindSpeedFromXML();
  gethumidityFromXML();
 // displayColor(); // Set the background color
  //displayText(); // Display text
  
}

void draw() {
   
  displayWind();
  //displayhumidity();
  displayText();
  ps.addParticle();
  ps.run();
  //displayHum();
  
  if (mousePressed) {
   
  
    // Switch to next location
    currentLocation++;

    // If you've reached the end of the list, go back to the start
    if (currentLocation > location.length-1 ) {
      currentLocation = 0;
    }

    runGetWeatherByAddressChoreo(); // Run the GetWeatherByAddress Choreo function
    getTemperatureFromXML(); // Get the temperature from the XML results
     // getTemperatureTextFromXML();
   getwindSpeedFromXML();
   gethumidityFromXML();
    //displayColor(); // Set the background color
    displayText(); // Display text
  }
}

void runGetWeatherByAddressChoreo() {
  // Create the Choreo object using your Temboo session
  GetWeatherByAddress getWeatherByAddressChoreo = new GetWeatherByAddress(session);

  // Set inputs
  getWeatherByAddressChoreo.setAddress(location[currentLocation]);

  // Run the Choreo and store the results
  GetWeatherByAddressResultSet getWeatherByAddressResults = getWeatherByAddressChoreo.run();

  // Store results in an XML object
  weatherResults = parseXML(getWeatherByAddressResults.getResponse());
  println(weatherResults);
}

void getTemperatureFromXML() {
  // Narrow down to weather condition
  XML condition = weatherResults.getChild("channel/item/yweather:condition");

  // Get the current temperature in Fahrenheit from the weather conditions
  temperature = condition.getInt("temp");
 // temperatureText = condition.getInt("text");
 
 // Narrow down to weather condition
  println("The current temperature in "+location[currentLocation]+" is "+temperature+"ºF" );
  // Get the current temperature in Fahrenheit from the weather conditions

}

//void getTemperatureTextFromXML() {
  // Narrow down to weather condition
  //XML condition = weatherResults.getChild("channel/item/yweather:condition");


  // Get the current temperature in Fahrenheit from the weather conditions
  //temperatureText = condition.getInt("text");

  //Print temperature value

    // Narrow down to weather condition
//}

void getwindSpeedFromXML() {
  // Narrow down to weather condition
  XML wind = weatherResults.getChild("channel/yweather:wind");

  // Get the current wind speed 
  windSpeed = wind.getInt("speed");

  // Print wind value
  println("The current wind speed in "+location[currentLocation]+" is "+windSpeed);
}

void gethumidityFromXML() {
  // Narrow down to weather condition
  XML atmosphere = weatherResults.getChild("channel/yweather:atmosphere");

  // Get the current wind speed 
  humidity = atmosphere.getInt("humidity");

  // Print wind value
  println("The current humidity in "+location[currentLocation]+" is "+humidity);
}

//void displayColor() {
  // Set up the temperature range in Fahrenheit
  //int minTemp = 10;
  //int maxTemp = 95;

  // Convert temperature to a 0-255 color value
  //float temperatureColor = map(temperature, minTemp, maxTemp, 0, 255);    

  // Set background color using temperature on a blue to red scale     
  //background(color(temperatureColor, 0, 255-temperatureColor));


 //}
   void displayWind(){
     int minTemp = 10;
  int maxTemp = 95;

  // Convert temperature to a 0-255 color value
  float temperatureColor = map(temperature, minTemp, maxTemp, 0, 255);    

  // Set background color using temperature on a blue to red scale     
  background(color(temperatureColor, 0, 255-temperatureColor));
   fill(255);
  // We are going to draw a polygon out of the wave points
  beginShape(); 
  noStroke();
  
  float xoff = 0;       // Option #1: 2D Noise
  // float xoff = yoff; // Option #2: 1D Noise
  
  // Iterate over horizontal pixels
  for (float x = 0; x <= width; x += 20-windSpeed) {
    // Calculate a y value according to noise, map to 
    float y = map(noise(xoff, yoff), 0, 1, 600,480); // Option #1: 2D Noise
    // float y = map(noise(xoff), 0, 1, 200,300);    // Option #2: 1D Noise
    
    // Set the vertex
    vertex(x, y); 
    // Increment x dimension for noise
    xoff += 0.05;
  }
  // increment y dimension for noise
  yoff += windSpeed*0.005;
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);

   }

void displayText() {
  // Set up text margins
  int margin = 65;
  int marginTopTemperature = 200;
  int marginTopLocation = 225;

  // Display temperature
  textFont(fontTemperature);
  text(temperature + "F", margin, marginTopTemperature);

  // Display location
  textFont(fontLocation);
  text(location[currentLocation], margin, marginTopLocation, width-margin, height-margin);

  // Display instructions
  textFont(fontInstructions);
  text("Humidity" +" "+ humidity, width-marginTopTemperature, margin+35);
  
   textFont(fontInstructions);
  text("Wind Speed" +" "+ windSpeed, margin, height-margin-60);
  
  
}


  class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, humidity/1000);
    velocity = new PVector(random(-humidity/10, humidity/10),random(-humidity/10, humidity/20));
    location = l.get();
    lifespan = 255.0;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1;
  }

  // Method to display
  void display() {
    //stroke(255,lifespan);
    fill(255,lifespan);
    smooth();
    noStroke();
    ellipse(location.x,location.y,2,2);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}




// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    particles.add(new Particle(origin));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}


