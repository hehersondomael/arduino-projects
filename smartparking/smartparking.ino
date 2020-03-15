/*
This is the Arduino code for the prototype of a proposed smart parking system at Pamantasan ng Lungsod ng Maynila.
The gate that caters incoming and outgoing vehicles in PLM is of "half-duplex" type.
This means only one vehicle can enter or exit the gate for a time.
Created by: Heherson I. Domael
Date created: February 2019
*/

#include <LiquidCrystal.h>
#include <Servo.h>

const int rs = 1, en = 2, d4 = 4, d5 = 5, d6 = 6, d7 = 7;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7); // 16x2 LCD configuration
Servo servo; // Servomotor configuration

byte occupied[8] = {  B11111,
                      B11111,
                      B11111,
                      B11111,
                      B11111,
                      B11111,
                      B11111,
                      B11111  }; // LCD character indicating the parking slot is occupied
byte nonocc[8] = {    B11111,
                      B10001,
                      B10001,
                      B10001,
                      B10001,
                      B10001,
                      B10001,
                      B11111  }; // LCD character indicating the parking slot is not occupied

const int numSlots        = 10;
const int slot[numSlots]  = {A1, A2, A3, A4, A5, A6, A7, A8, A9, A10}; // pins for LDRs
const int entGate         = A11; // pin for LDR at entrance gate
const int exGate          = A0; // pin for LDR at exit gate

int numCarsIn = 0, angle;
bool arrive = false, inSlot[numSlots];

void setup()
{
  servo.attach(8);
  servo.write(0);
  lcd.begin(16,2);
  delay(500);

  lcd.createChar(7,occupied);
  lcd.createChar(6,nonocc);
  lcd.clear();

  for (int i=0; i<10; i++)
    inSlot[i] = false;
}

void loop()
{
  for (int i=0; i<10; i++)
  {
    lcd.setCursor(i,0);
    if (i==9)
      lcd.print("A"); // name of the 10th slot
    else
      lcd.print(i+1);

    lcd.setCursor(i,1);
    if (inSlot[i]==true)
      lcd.write(7); // indicate the slot is occupied
    else
      lcd.write(6); // indicate the slot is not occupied
  }
  lcd.setCursor(11,0);
  lcd.print("VIn:");
  if (numCarsIn==10)
    lcd.print("F"); // indicate all slots are occupied
  else
    lcd.print(numCarsIn);
  lcd.setCursor(11,1); //
  lcd.print("PLM51");

  if (analogRead(entGate)<120 && numCarsIn<numSlots) // triggered when a vehicle at the entrance zone is detected
  {
    numCarsIn++;
    arrive = true;

    for (angle=0; angle<=90; angle++) // servomotor at the gate rises from 0 to 90 degrees
    {
      servo.write(angle);
      delay(15);
    }
    delay(1500);
    for (angle=90; angle>0; angle--) // servomotor at the gate lowers from 90 to 0 degrees
    {
      servo.write(angle);
      delay(15);
    }
    delay(50);
  }

  if (numCarsIn!=0 && numCarsIn<=numSlots)
  {
      for (int i=0; i<numSlots; i++)
      {
		// variations in detected light intensity due to placement of LDRs
        if (i==0 || i==1 || i==5 || i==7 || i==8)
        {
          if (analogRead(slot[i])<260 && inSlot[i]==false)
          {
            lcd.setCursor(i,1);
            lcd.write(7);
            inSlot[i] = true;
          }
          if (analogRead(slot[i]) >= 260 && inSlot[i]==true)
          {
            lcd.setCursor(i,1);
            lcd.write(6);
            inSlot[i] = false;
          }
        }
        else if (i==8)
        {
          if (analogRead(slot[i])<350 && inSlot[i]==false)
          {
            lcd.setCursor(i,1);
            lcd.write(7);
            inSlot[i] = true;
          }
          if (analogRead(slot[i]) >=350 && inSlot[i]==true)
          {
            lcd.setCursor(i,1);
            lcd.write(6);
            inSlot[i] = false;
          }          
        }
        else
        {
          if (analogRead(slot[i])<130 && inSlot[i]==false)
          {
              lcd.setCursor(i,1);
              lcd.write(7); 
              inSlot[i] = true;
          }
          if (analogRead(slot[i])>=130 && inSlot[i]==true)
          {
              lcd.setCursor(i,1);
              lcd.write(6); 
              inSlot[i] = false;
          }
        }
    }
  }

  if (analogRead(exGate)<120 && numCarsIn>0) // triggered when a vehicle at the exit zone is detected
  {
    numCarsIn--;
    delay(250);
    for (angle=0; angle<=90; angle++)
    {
      servo.write(angle);
      delay(15);
    }
    delay(1500);
    for (angle=90; angle>0; angle--)
    {
      servo.write(angle);
      delay(15);
    }
    delay(50);
  }

  arrive = false;
  delay(500);
}