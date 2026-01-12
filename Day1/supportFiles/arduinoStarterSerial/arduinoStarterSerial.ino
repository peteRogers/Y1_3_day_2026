int x = 100;
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  delay(1000);
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.print("0:");
  Serial.println(x);
  Serial.print("1:");
  Serial.println(1024-x);
  delay(20);
  x = x + 1;
  if(x > 1024){
    x = 0;
  }

}
