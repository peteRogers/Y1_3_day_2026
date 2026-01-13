
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
      "Input " + i + ": " + arduinoValues[i],
      10,
      padding + i * lineH
    );
  }
}
