import processing.serial.*;

Serial myPort;
Float[] arduinoValues;
Float[] preValues;

void startSerial(int portnumber, int sensors){
  printArray(Serial.list());
  try {
    myPort = new Serial(this, Serial.list()[portnumber], 9600);
  }
  catch(Exception e) {
    println(e);
  }
   arduinoValues = new Float[sensors];
   preValues = new Float[sensors];
   for(int i = 0; i < sensors; i ++){
     arduinoValues[i] = 0.0;
     preValues[i] = 0.0;
   }
}

void serialEvent(Serial p) {
  String inString = p.readStringUntil('\n');
  if (inString == null) return;
  inString = trim(inString);
  if (inString.length() == 0) return;
  String[] sensorArray = split(inString, ':');
  if (sensorArray == null || sensorArray.length < 2) return;
  int address;
  float value;
  try {
    address = Integer.parseInt(sensorArray[0]);
    value   = Float.parseFloat(sensorArray[1]);
  } catch (Exception e) {
    return; // not valid integers
  }
  if (address < 0 || address >= arduinoValues.length) return;
    arduinoValues[address] = value;
  
}

Boolean pinPressed(int i){
  if(arduinoValues[i] == 1.0){
  if(arduinoValues[i] != preValues[i]){
      return true;
    }
  }
  return false;
}

void updateValues(){
  for(int i = 0; i < arduinoValues.length; i ++){
    if(arduinoValues[i] != preValues[i]){
      preValues[i] = arduinoValues[i];
    }
  }
}
void drawInterface() {
  int panelW = 150;
  int lineH  = 25;
  int padding = 15;
  fill(0, 150);
  noStroke();
  rect(0, 0, panelW, arduinoValues.length * lineH + padding);

  fill(255, 255, 0);
  textAlign(LEFT, CENTER);

  for (int i = 0; i < arduinoValues.length; i++) {
    text(
      "Input " + i + ": " + arduinoValues[i] + ": "+preValues[i],
      10,
      padding + i * lineH
    );
  }
}
