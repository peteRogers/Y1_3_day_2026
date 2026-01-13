
#include "DFRobot_BloodOxygen_S.h"
#define I2C_ADDRESS    0x57
DFRobot_BloodOxygen_S_I2C MAX30102(&Wire ,I2C_ADDRESS);
long mills;
int cPulse;
int prePulse; 
long pdelay = 0;
long pmills = 0;
int inc = 8;
int diff = 0;

void setup()
{
  Serial.begin(9600);
  while (false == MAX30102.begin()){
    delay(1000);
  }
  MAX30102.sensorStartCollect();
  mills = 0;
  cPulse = 0;
  prePulse = 0;
}

void loop(){
  if(mills + 2000 < millis()){
    MAX30102.getHeartbeatSPO2();
    mills = millis();
    prePulse = cPulse;
    cPulse = MAX30102._sHeartbeatSPO2.Heartbeat * 0.66;
    diff = cPulse - prePulse;
  }
 
  if(cPulse > 0 && pdelay + pmills < millis()){
    pdelay = 60000 / cPulse;
    if(diff < 0){
      cPulse ++;
      
    }else if (diff > 0) {
      cPulse --;
    }
    pmills = millis();
    Serial.println(cPulse);
    //Serial.print(" : ");
    //Serial.println(cPulse);
   
  }
}
