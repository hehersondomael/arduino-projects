/*
This is the Arduino code for the prototype of a smart greenhouse monitoring and maintenance system for a productive
urban farming market. Specifically, the system provides automation for ventilation,  lighting, and irrigation
inside a glasshouse that is utilized for planting various agricultural products in the Philippine setting.
Created by: Heherson I. Domael
Date created: December 2019
*/

#include <DHT.h>

#define DHTTYPE DHT22
#define DHTPIN 12 // The DHT22 sensor detects the temperature and humidity inside the greenhouse.
DHT dht(DHTPIN, DHTTYPE); // configure DHT22 temperature and humidity sensor

#define ldrPin A1 // The LDR detects light intensity outside the greenhouse.
#define soilPin A2  // The soil moisture sensor detects the wetness of soil inside the greenhouse.

#define pwmFan A0 // The fan is installed inside the greenhouse in order to regulate its temperature and humidity.
#define ledPin 3 // The LEDs provide illumination for the greenhouse during nighttime.
#define pumpPin 5 // The pump moves the water supply stored beneath the plants irrigation purposes.

void setup()
{
  Serial.begin(9600);
  dht.begin();
  pinMode(pwmFan,OUTPUT);
  pinMode(ledPin, OUTPUT);
  pinMode(pumpPin, OUTPUT);
}

void loop()
{
  float hum  = dht.readHumidity();
  float temp = dht.readTemperature();

  Serial.print(temp); // read temperature in Celsius
  Serial.print(",");
  Serial.print(hum); // read humidity percentage

  int light = map(analogRead(ldrPin), 0, 1023, 0, 99);
  Serial.print(",");
  Serial.print(light); // read light intensity

  float soilMoisture = (((1023-analogRead(soilPin))/1023.00)*100);
  Serial.print(",");
  Serial.print(soilMoisture);  // read soil moisture percentage
  Serial.println(",");

  if(temp>=26.7 && hum<=80) // based on ideal temperature and humidity needed by generic edible plants
    analogWrite(pwmFan,224); // turn on fan
  else
    analogWrite(pwmFan,0); // turn off fan

  if (light <= 55) // based on ideal light intensity needed by edible plants for sustained growth as well as for aesthetic purposes
    digitalWrite(ledPin, HIGH);  // turn on LEDs
  else
    digitalWrite(ledPin, LOW);  // turn on LEDs

  if (soilMoisture <= 40) // based on ideal soil moisture needed by generic edible plants
    analogWrite(pumpPin, 255); // turn on the pump to move water for irrigation
  else
    analogWrite(pumpPin, 0); // turn off the pump to move water for irrigation

  delay(1000);
}