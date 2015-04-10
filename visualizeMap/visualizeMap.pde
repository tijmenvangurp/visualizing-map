import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.ParseException;
ArrayList<Location> locations = new ArrayList<Location>();
ArrayList<Date> days = new ArrayList<Date>();
ArrayList<ArrayList<Float>> values = new ArrayList<ArrayList<Float>>();
SimpleDateFormat dateFormat = new SimpleDateFormat("d-M-yyyy");

// minimum and maximum values for both latitude and longitude
// this is useful for normalizing the paint positions later on
// these values are computed in the readCoordinates() function
float minLatCoord = 1000;
float maxLatCoord = -1000;
float minLongCoord = 1000;
float maxLongCoord = -1000;

// simple frame counter
int animationCounter = 0;

void setup() {

  // input
  readCoordinates();
  readValues();

  // graphics setup
  size(500, 500);
  noStroke();
  smooth();
  frameRate(7);
  ellipseMode(CENTER);
  background(10, 10, 10);
}

void draw() {

  fill(10, 10, 10, 20);
  rect(0, 0, width, height);

  // loop through all the locations
  for (int i = 0; i < locations.size(); i++) {

    // retrieve a location
    Location l = locations.get(i);

    // retrieve the current measurement value for this location
    // the value is divided by 5 and shifted by 2 to optimize the graphical output
    float value = 2 + (Float) values.get(i).get(animationCounter) / 5;

    // adjust color according to the current measurement value:
    // the higher the value, the more RED and the less BLUE will be shown (GREEN and ALPHA are constant)
    fill(20 + value * 10, 50, 255 - value * 10, 120);

    // get position and :
    // 1. normalize the value between the minimum and maximum latitude or longitude values (new value between 0 and 1)
    // 2. blow up the value between 0 and 1 by muliplying by the width or height of the screen (reduced by the margin 2 * 20 pixel)
    // 3. shift the position by 20 pixel for the margin
    float xPosition = 20 + (width-40) * norm(l.longitude, minLongCoord, maxLongCoord);
    float yPosition = 20 + (height-40) * norm(l.latitude, minLatCoord, maxLatCoord);
    
    // draw ellipse with the size of the adjusted measurement value
    ellipse(xPosition, yPosition, value, value);
  }

  // if not yet all values have been plotted, increased the frame counter
  if (animationCounter < days.size() - 1) {
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
    
    // compute new min and max value for latitude    
    minLatCoord = Math.min(minLatCoord, lat);
    maxLatCoord = Math.max(maxLatCoord, lat);
    float lng = Float.parseFloat(pieces[1].replace(',', '.'));
    
    // compute new min and max value for longitude
    minLongCoord = Math.min(minLongCoord, lng);
    maxLongCoord = Math.max(maxLongCoord, lng);

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

