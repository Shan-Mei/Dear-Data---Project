PImage Messages;
PImage Instagram;
PImage Snapchat;
PImage WhatsApp;
PImage Facetime;
PImage Phone;

Table data;

// Array of objects
ArrayList<DataPoint> points = new ArrayList<DataPoint>();
int visiblePoints = 0;  // <-- keeps track of visible images, 0 = no images visible

String[] days = {
  "Mon", "Tues", "Wed", "Thur", "Fri",
  "Sat", "Sun"
};

int[] dayPositions = {75, 225, 375, 525, 675, 825, 975};


void setup () {
  size (1050, 840);
  
  Messages = loadImage("Messages.png");
  Instagram = loadImage("Instagram.png");
  Snapchat = loadImage("Snapchat.png");
  WhatsApp = loadImage("WhatsApp.png");
  Facetime = loadImage("Facetime.png");
  Phone = loadImage("Phone.png");
  
  data = loadTable("data.csv", "header");
  
  for (TableRow row : data.rows()) {
   
    String day = row.getString("Day of week");
    String time = row.getString("Time");
    String platform = row.getString("Platform");
    
    // Calculate X position
    float x = 0;
    
    for (int i = 0; i < days.length; i++) {
     if(day.equals(days[i])) {
      x = dayPositions[i];
      break;
     }
    }
    // Calculate Y position
    String[] parts = split(time, ':');
    
    int hour = int(parts[0]);
    int minute = int(parts[1]);
    
    float y = (hour + minute / 60.0) * 35;
    
    //Create object for table row
    DataPoint point = new DataPoint(x, y, platform); 
    points.add(point);
  }
}

void draw () {
  background(#D6FBFC);

  //Display all data points
  for (int i = 0; i < visiblePoints; i++) {
    DataPoint point = points.get(i);
    point.display();
  }
}

void keyPressed() {
 
  if (visiblePoints < points.size()) {  // points.size = 106
    visiblePoints++;
  }
  
}
