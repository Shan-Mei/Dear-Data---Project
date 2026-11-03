PImage Messages;
PImage Instagram;
PImage Snapchat;
PImage WhatsApp;
PImage Facetime;
PImage Phone;

Table data;

// Array creation for days of the week
String[] days = {
  "Mon", "Tue", "Wed", "Thur", "Fri",
  "Sat", "Sun"
};

int[] dayPositions = {
  75, 225, 375, 525, 675, 825, 975
};

int[] timePositions = new int[24];


void setup () {
  size (1050, 840);

  data = loadTable("data.csv", "header");

  for (TableRow row : data.rows()) {
    String day = row.getString("Day of week");
    String time = row.getString("Time");

    println(day + " " + time);
  }

  int[] timePositions = new int[24];

  for (int i = 0; i < 24; i++) {
    timePositions[i] = i * 35;
  }
}

void draw () {
  background(#D6FBFC);
}


void keyPressed () {
  TableRow row = data.getRow(0);

  String day = row.getString("Day of week");
  String time = row.getString("Time");
  String platform = row.getString("Platform");

  println(day);
  println(time);
  println(platform);
}
