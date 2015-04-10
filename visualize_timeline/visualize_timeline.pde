

import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.ParseException;


ArrayList<Location> locations = new ArrayList<Location>();
ArrayList<Date> days = new ArrayList<Date>();
ArrayList<ArrayList<Float>> values = new ArrayList<ArrayList<Float>>();
SimpleDateFormat dateFormat = new SimpleDateFormat("d-M-yyyy");

// counter to count the frames
int animationCounter = 0;

void setup() {

  // input
  readCoordinates();
  readValues();

  // graphics setup, screen should be 700 by 200 pixels
  size(700, 200);

  // no border around objects
  noStroke();
}

void draw() {

  // if the counter is 0 (= at program start), then retrieve and output the location of sensor 5
  if (animationCounter == 0) {

    // get sensor 5 (= index 4) from the list of locations
    Location sensor5 = locations.get(4);

    // print out message with latitude and longitude of this sensor
    println("Sensor 5 is located at: " + sensor5.latitude + " - " + sensor5.longitude);
  }

  // get list of values for sensor 5 (= index 4)
  ArrayList sensor5Values = values.get(4);

  // get single value at the current position of the animation counter
  float value = (Float) sensor5Values.get(animationCounter);

  // draw red line
  fill(200, 30, 30);
  rect(animationCounter % 700 + 1, 0, 1, 200);

  // set the background color for weekdays and weekends
  if (days.get(animationCounter).getDay() == 0 || days.get(animationCounter).getDay() == 6) {
    fill(170);
  } 
  else {
    fill(200);
  }
  
  // erase the current vertical line
  rect(animationCounter % 700, 0, 1, 200);

  // values are drawn in black
  fill(0);
  
  // draw value on the previously erased line
  rect(animationCounter % 700, 190 - value, 1, 1);

  // if not yet all values have been plotted, increased the frame counter
  if (animationCounter < sensor5Values.size() - 1) {
    animationCounter++;
  }
  // otherwise quit the program
  else {
    exit();
  }
}

// --------------------------------------------------------------------------------------
// INPUT
// --------------------------------------------------------------------------------------

// read in 62 different sensor coordinates
void readCoordinates() {
  String [] lines = loadStrings("geocoordinates.csv");
  for (String line : lines) {

    // split into two parts
    String[] pieces = split(line, ';');

    // ... latitude field and longitude field
    float lat = Float.parseFloat(pieces[0].replace(',', '.'));
    float lng = Float.parseFloat(pieces[1].replace(',', '.'));

    locations.add(new Location(lat, lng));
    values.add(new ArrayList<Float>());
  }
}


// read in values for 62 sensors over 10 years of measurement
void readValues() {
  String [] lines = loadStrings("fijnstof_prepared.csv");
  for (String line : lines) {
    String[] pieces = split(line, ';');

    // first column: date
    try {
      Date d = dateFormat.parse(pieces[0]);
      days.add(d);
      println(d);

      for (int i = 1; i < pieces.length; i++) {
        float value = 0;
        if (pieces[i] != null && pieces[i].length() > 0) {
          value = Float.parseFloat(pieces[i].replace(',', '.'));
        }

        values.get(i - 1).add(value);
      }
    } 
    catch(ParseException pe) {
      // do nothing
    }
  }
}

