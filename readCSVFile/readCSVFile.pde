import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.ParseException;
// data structure for storing Location objects (each object stores latitude and longitude together)
ArrayList<Location> locations = new ArrayList<Location>();

// data structure for storing Date objects
ArrayList<Date> days = new ArrayList<Date>();

// 2-dimensional data structure for storing the measurement values
// the outer list containss one inner list per location, 
// and each location list contains the measurement value for that specific location
ArrayList<ArrayList<Float>> values = new ArrayList<ArrayList<Float>>();

// helper object to parse Date information in the format d-M-yyyy, for example 5-6-2013
SimpleDateFormat dateFormat = new SimpleDateFormat("d-M-yyyy");

void setup() {

  // read location input file
  readCoordinates();

  // read measurement values input file
  readValues();
}

// --------------------------------------------------------------------------------------
// INPUT
// --------------------------------------------------------------------------------------

// read in 62 different sensor coordinates
void readCoordinates() {

  // every line of the input file is read and stored into the array "lines"
  String [] lines = loadStrings("geocoordinates.csv");

  // loop through the array "lines"...
  for (String line : lines) {

    // ... and split every line into two parts (latitude and longitude) which are separated by a ";"
    String[] pieces = split(line, ';');

    // get the latitude piece as a String and replace all commas by dots
    String latitudeStr = pieces[0].replace(',', '.');
    // get the longitude piece as a String and replace all commas by dots
    String longitudeStr = pieces[1].replace(',', '.');

    // parse latitude and longitude Strings as FLOAT numbers
    float lat = Float.parseFloat(latitudeStr);
    float lng = Float.parseFloat(longitudeStr);

    // create a new Location object
    Location newLocation = new Location(lat, lng);

    // add newLocation to the list of locations
    locations.add(newLocation);

    // create a list for measurement values for this location as well
    // and add it to the outer list of values
    values.add(new ArrayList<Float>());

    // print the coordinates of the current location
    println("Location found at " + lat + " - " + lng);
  }

  // finally print the number of found and stored locations
  println("Locations found: " + locations.size());
}


// read in values for 62 sensors over 10 years of measurement
void readValues() {

  // every line of the input file is read and stored into the array "lines"
  String [] lines = loadStrings("fijnstof_prepared.csv");

  // loop through the array "lines"...
  for (String line : lines) {

    // ... and split every line into two parts (latitude and longitude) which are separated by a ";"
    String[] pieces = split(line, ';');

    // this "try" is additional security in case the Date parsing fails
    try {
      
      // first column (= first piece) --> Date
      String dateStr = pieces[0];
      
      // parse dateStr (of type String) as Date in teh given format (see above)
      Date d = dateFormat.parse(dateStr);
      
      // add the Date object to the list of all days
      days.add(d);
      
      // print a message that for the given day, data is available
      println("Values found for day: " + d);

      // loop through the remaining piece in the array (= all values)
      // starting at index 1 because we used the piece at index 0 already for the Date
      for (int i = 1; i < pieces.length; i++) {
        
        // default value is 0 (in case no value is given in the file)
        float value = 0;
        
        // check if the piece contains data
        if (pieces[i] != null && pieces[i].length() > 0) {
          
          // if yes, make sure all commas are replaced by dots
          String floatStr = pieces[i].replace(',', '.');
          
          // parse this floatStr as a FLOAT number
          value = Float.parseFloat(floatStr);
        }
        
        // finally add this number to the list of the current location (which is given by the counter i)
        // the trick here is to subtract 1 from the counter i because we used the first piece at index 0
        // already for the day, so the first location is at index 0 while the piece with the data for this location
        // is at index 1...
        values.get(i - 1).add(value);
      }
    }
    catch(ParseException pe) {
      // do nothing, this is only in case the date parsing goes wrong
    }
  }

  // finally count the number of days and output it
  println("Measurement data found for " + days.size() + " days.");
}

