PImage Messages;
PImage Instagram;
PImage Snapchat;
PImage WhatsApp;
PImage Facetime;
PImage Phone;

Table data;

DataPoint selectedPoint = null;

// Array of objects
ArrayList<DataPoint> points = new ArrayList<DataPoint>();

ArrayList<String> dates = new ArrayList<String>();
int visibleDates = 0;

ArrayList<DataPoint> dayInteractions = new ArrayList<DataPoint>();

int currentInteraction = -1;

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
    String date = row.getString("Date");
    if (!dates.contains(date)) {
      dates.add(date);
    }
    String time = row.getString("Time");
    String platform = row.getString("Platform");
    String reason = row.getString("Reason");

    // Calculate X position
    float x = 0;

    for (int i = 0; i < days.length; i++) {
      if (day.equals(days[i])) {
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
    DataPoint point = new DataPoint(x, y, platform, day, date,
      time, reason);

    points.add(point);
  }
}

void draw () {
  background(#F0EDE1);

  drawDayGrid();
  drawTimeGrid();

  displayVisibleDates();

  if (selectedPoint != null) {
    noFill();
    stroke(#453855);
    strokeWeight(3);
    ellipse(selectedPoint.x, selectedPoint.y, 65, 65);
    noStroke();
  }

  drawInteractionDetails();
}

void keyPressed() {

  if (key == CODED) {
    if (keyCode == RIGHT) {
      if (currentInteraction < dayInteractions.size() -1) {
        currentInteraction++;
        selectedPoint = dayInteractions.get(currentInteraction);
      }
    } else if (keyCode == LEFT) {
      if (currentInteraction > 0) {
        currentInteraction--;
        selectedPoint = dayInteractions.get(currentInteraction);
      }
    }
  } else {
    if (visibleDates < dates.size()) {
      visibleDates++;
      selectedPoint = null;
      dayInteractions.clear();
      currentInteraction = -1;
    }
  }
}

void drawDayGrid() {

  textAlign(CENTER);
  textSize(18);
  fill(#456B78);

  for (int i = 0; i < days.length; i++) {

    float x = dayPositions[i];

    // Weekday label
    text(days[i], x, 25);

    // Vertical grid line
    stroke(#A9D8DF);
    strokeWeight(1);
    line(x, 40, x, height);
  }
  noStroke();
}

void drawTimeGrid() {

  textAlign(LEFT);
  textSize(12);

  for (int hour = 0; hour < 24; hour += 3) {

    float y = hour * 35;

    //Time label
    fill(#456B78);
    text(nf(hour, 2) + ":00", 5, y + 4);

    // Horizontal grid line
    stroke (#B7E0E5);
    strokeWeight(1);
    line(45, y, width, y);
  }
  noStroke();
}

void displayVisibleDates() {

  for (DataPoint point : points) {

    int dateIndex = dates.indexOf(point.date);

    if (dateIndex >= 0 && dateIndex < visibleDates) {
      point.display();
    }
  }
}

void selectDate(String selectedDate) {

  dayInteractions.clear();

  for (DataPoint point : points) {

    if (point.date.equals(selectedDate)) {
      dayInteractions.add(point);
    }
  }
  for (int i = 0; i < dayInteractions.size(); i++) {
    for (int j = i + 1; j < dayInteractions.size(); j++) {

      DataPoint first = dayInteractions.get(i);
      DataPoint second = dayInteractions.get(j);

      if (first.time.compareTo(second.time) > 0) {
        dayInteractions.set(i, second);
        dayInteractions.set(j, first);
      }
    }
  }
}

void mousePressed() {

  selectedPoint = null;

  for (int i = points.size() -1; i >= 0; i--) {

    DataPoint point = points.get(i);

    int dateIndex = dates.indexOf(point.date);

    if (dateIndex >= 0 &&
      dateIndex < visibleDates &&
      point.isClicked()) {

      selectDate(point.date);   // <-- load interactions for clicked date
      currentInteraction = 0;   // <-- start at earliest interaction

      if (dayInteractions.size() > 0) {
        selectedPoint = dayInteractions.get(currentInteraction);
      }
      break;
    }
  }
}

void drawInteractionDetails() {

  if (selectedPoint != null) {

    noStroke();
    fill(255, 245);
    rect(50, 640, 290, 175, 12);

    fill(#BFBAC6);
    textAlign(LEFT);
    textSize(14);
    text("CONVERSATION DETAILS", 60, 675);

    textSize(20);
    fill(#674E54);
    text(selectedPoint.platform, 60, 710);

    textSize(13);
    fill(#55395A);
    text(selectedPoint.day + " " + selectedPoint.date, 60, 735);
    text("Time: " + selectedPoint.time, 60, 755);
    text("Reason: " + selectedPoint.reason, 60, 780);

    textAlign(LEFT);
    textSize(11);
    fill(#151313);
    text("<- Previous       Next ->", 60, 805);
  }
}
