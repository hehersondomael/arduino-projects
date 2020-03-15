/*
This is the Processing code for the real-time graphical user interface for the prototype of a
smart greenhouse monitoring and maintenance system for a productive urban farming market. It
retrieves the data gathered from the Arduino program by importing the Processing's Serial library.
Created by: Heherson I. Domael
Date created: December 2019
*/

import meter.*;
import processing.serial.*;

Serial port;
Meter m, m2, m3, m4;
int temp, hum, soil;

void setup()
{
  size(940, 670);
  background(20, 20, 20);

  port = new Serial(this, "COM5", 9600); // Configuring the port for retrieving data from the Arduino

  // Meter display for temperature in Celsius
  m = new Meter(this, 18, 38);
  m.setTitleFontSize(16);
  m.setTitleFontName("Arial");
  m.setTitle("Temperature (°C)");
  String[] scaleLabels = {"0","10", "20", "30", "40"};
  m.setScaleLabels(scaleLabels);
  m.setScaleFontSize(16);
  m.setScaleFontName("Times New Roman");
  m.setScaleFontColor(color(200,30,70));
  m.setDisplayDigitalMeterValue(true);
  m.setArcColor(color(141,113,178));
  m.setArcThickness(15);
  m.setMaxScaleValue(100);
  m.setMinInputSignal(0);
  m.setMaxInputSignal(100);
  m.setNeedleThickness(3);

  // Meter display for humidity percentage
  int mx = m.getMeterX();
  int my = m.getMeterY();
  int mw = m.getMeterWidth();
  m2 = new Meter(this, mx+mw+20,my);
  m2.setTitleFontSize(16);
  m2.setTitleFontName("Arial");
  m2.setTitle("Humidity (%)");
  String[] scaleLabels2 = {"0","10","20","30","40","50","60","70","80","90","100"};
  m2.setScaleLabels(scaleLabels2);
  m2.setScaleFontSize(16);
  m2.setScaleFontName("Times New Roman");
  m2.setScaleFontColor(color(200,30,70));
  m2.setDisplayDigitalMeterValue(true);
  m2.setArcColor(color(141,113,178));
  m2.setArcThickness(15);
  m2.setMaxScaleValue(100);
  m2.setMinInputSignal(0);
  m2.setMaxInputSignal(100);
  m2.setNeedleThickness(3);

  // Meter display for light intensity (0 if dark, 1 if lit)
  m3 = new Meter(this, mx,my+320);
  m3.setTitleFontSize(16);
  m3.setTitleFontName("Arial");
  m3.setTitle("Light");
  String[] scaleLabels3 = {"0","10","20","30","40","50","60","70","80","90","100"};
  m3.setScaleLabels(scaleLabels3);
  m3.setDisplayDigitalMeterValue(true);
  m3.setArcColor(color(141,113,178));
  m3.setArcThickness(15);
  m3.setMaxScaleValue(100);
  m3.setMinInputSignal(0);
  m3.setMaxInputSignal(100);
  m3.setNeedleThickness(3);

  // Meter display for soil moisture percentage
  int mx2 = m3.getMeterX();
  int my2 = m3.getMeterY();
  int mw2 = m3.getMeterWidth();
  m4 = new Meter(this, mx2+mw2+20,my2);
  m4.setTitleFontSize(16);
  m4.setTitleFontName("Arial");
  m4.setTitle("Soil Moisture");
  String[] scaleLabels4 = {"0","10","20","30","40","50","60","70","80","90","100"};
  m4.setScaleLabels(scaleLabels4);
  m4.setDisplayDigitalMeterValue(true);
  m4.setArcColor(color(141,113,178));
  m4.setArcThickness(15);
  m4.setMaxScaleValue(100);
  m4.setMinInputSignal(0);
  m4.setMaxInputSignal(100);
  m4.setNeedleThickness(3);
}

void draw()
{
  background(0);

  if(port.available()>0)
  {
    String val = port.readString();
    String[] list = split(val,',');

    int T = int(list[0]);
    int H = int(list[1]);
    int L = int(list[2]);
    int S = int(list[3]);

    m.updateMeter(T);
    m2.updateMeter(H);
    m3.updateMeter(L);
    m4.updateMeter(S);
    
    if (int(T)>=26.7 && int(T)<=29.4)
      temp = 0; //good
    else if (int(T)<=26.7)
      temp = 1; // low
    else if (int(T)>=29.4)
      temp = 2; // high

    if (int(H)>=40 && int(H)<=80)
      hum = 0;
    else if (int(H)<=40)
      hum = 1;
    else if (int(H)>=80)
      hum = 2;

    if (int(S)>=40 && int(S)<=80)
      soil = 0;
    else if (int(S)<=40)
      soil = 1;
    else if (int(S)>=80)
      soil = 2; 

    textSize(25);
    if (temp==0 && hum==0 && soil==0)
    {
      fill(0, 255, 0);
      text("             GREENHOUSE IS DOING GOOD!            ", 118, 650);
    }
    if (temp==0 && hum==0 && soil==1)
    {
      fill(255, 255, 0);
      text("              WARNING! SOIL: TOO DRY              ", 118, 650);
    }
    if (temp==0 && hum==0 && soil==2)
    {
      fill(255, 255, 0);
      text("             WARNING! SOIL: TOO WET               ", 118, 650);
    }
    if (temp==0 && hum==1 && soil==0)
    {
      fill(255, 255, 0);
      text("             WARNING! HUM: TOO DRY                ", 118, 650);
    }
    if (temp==0 && hum==1 && soil==1)
    {
      fill(255, 0, 0);
      text("         ALERT! HUM: TOO LOW; SOIL: TOO DRY       ", 118, 650);
    }
    if (temp==0 && hum==1 && soil==2)
    {
      fill(0, 255, 0);
      text("             GREENHOUSE IS DOING GOOD!            ", 118, 650);
    }
    if (temp==0 && hum==2 && soil==0)
    {
      fill(255, 255, 0);
      text("             WARNING! HUM: TOO HIGH               ", 118, 650);
    }
    if (temp==0 && hum==2 && soil==1)
    {
      fill(0, 255, 0);
      text("             GREENHOUSE IS DOING GOOD!            ", 118, 650);
    }
    if (temp==0 && hum==2 && soil==2)
    {
      fill(255, 0, 0);
      text("        ALERT! HUM: TOO HIGH; SOIL: TOO WET       ", 118, 650);
    }
    if (temp==1 && hum==0 && soil==0)
    {
      fill(255, 255, 0);
      text("             WARNING! TEMP: TOO LOW               ", 118, 650);
    }
    if (temp==1 && hum==0 && soil==1)
    {
      fill(0, 255, 0);
      text("            GREENHOUSE IS DOING GOOD!             ", 118, 650);
    }
    if (temp==1 && hum==0 && soil==2)
    {
      fill(255, 0, 0);
      text("        ALERT! TEMP: TOO LOW; SOIL: TOO WET       ", 118, 650);
    }
    if (temp==1 && hum==1 && soil==0)
    {
      fill(255, 255, 0);
      text("         WARNING! UNPREDICTABLE CONDITION         ", 118, 650);
    }
    if (temp==1 && hum==1 && soil==1)
    {
      fill(255, 255, 0);
      text("   WARNING! UNPREDICTABLE CONDITION; SOIL: DRY    ", 118, 650);
    }
    if (temp==1 && hum==1 && soil==2)
    {
      fill(255, 255, 0);
      text("   WARNING! UNPREDICTABLE CONDITION; SOIL: WET    ", 118, 650);
    }
    if (temp==1 && hum==2 && soil==0)
    {
      fill(255, 255, 0);
      text("       WARNING! TEMP: TOO LOW; HUM: TOO HIGH      ", 118, 650);
    }
    if (temp==1 && hum==2 && soil==1)
    {
      fill(0, 255, 0);
      text("            GREENHOUSE IS DOING GOOD!             ", 118, 650);
    }
    if (temp==1 && hum==2 && soil==2)
    {
      fill(255, 0, 0);
      text("ALERT! TEMP: TOO LOW; HUM: TOO HIGH; SOIL: TOO WET", 118, 650);
    }
    if (temp==2 && hum==0 && soil==0)
    {
      fill(0, 255, 0);
      text("              WARNING: TEMP: TOO HIGH             ", 118, 650);
    }
    if (temp==2 && hum==0 && soil==1)
    {
      fill(255, 0, 0);
      text("      ALERT! TEMP: TOO HIGH; SOIL: TOO DRY        ", 118, 650);
    }
    if (temp==2 && hum==0 && soil==2)
    {
      fill(0, 255, 0);
      text("            GREENHOUSE IS DOING GOOD!             ", 118, 650);
    }
    if (temp==2 && hum==1 && soil==0)
    {
      fill(255, 0, 0);
      text("       ALERT! TEMP: TOO HIGH; HUM: TOO LOW        ", 118, 650);
    }
    if (temp==2 && hum==1 && soil==1)
    {
      fill(255, 0, 0);
      text("ALERT! TEMP: TOO HIGH; HUM: TOO LOW; SOIL: TOO DRY", 118, 650);
    }
    if (temp==2 && hum==1 && soil==2)
    {
      fill(0, 255, 0);
      text("            GREENHOUSE IS DOING GOOD!             ", 118, 650);
    }
    if (temp==2 && hum==2 && soil==0)
    {
      fill(255, 255, 0);
      text("        WARNING! UNPREDICTABLE CONDITION          ", 118, 650);
    }
    if (temp==2 && hum==2 && soil==1)
    {
      fill(255, 255, 0);
      text("   WARNING! UNPREDICTABLE CONDITION; SOIL: DRY    ", 118, 650);
    }
    if (temp==2 && hum==2 && soil==2)
    {
      fill(255, 255, 0);
      text("   WARNING: UNPREDICTABLE CONDITION; SOIL: WET    ", 118, 650);
    }

    String hot = "Temperature and Humidity | Fan Status: ON";
    String cold = "Temperature and Humidity | Fan Status: OFF";
    if (L >= 26.7)
       text(hot, 265,30);
     else
       text(cold, 265,30);

    String dark = "Light intensity | LED Status: ON";
    String bright = "Light intensity | LED Status: OFF";
    if (L <= 55)
       text(dark, 80,350);
     else
       text(bright, 80,350);

    String wet = "Soil moisture | Pump Status: ON";
    String dry = "Soil moisture | Pump Status: OFF";
    if (S <= 40)
       text(wet, 520,350);
     else
       text(dry, 520,350);

    println(L + "," + H + "," + L + "," + S);
  }
}
