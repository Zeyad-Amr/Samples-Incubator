#include <math.h>
#define cooler 13  //Red
#define heater 7  //Green
const int thermistor_output = A1; //Green
double temperature;
double maxTemp; 
double minTemp;      


//Notes: Heater relay is reversed

void setup() {
  pinMode(cooler, OUTPUT);
  pinMode(heater, OUTPUT);
  digitalWrite(cooler,LOW); 
    digitalWrite(heater,HIGH);
  Serial.begin(9600);  /* Define baud rate for serial communication */
}

void loop() {

  //sending temp
  String x=",";
   temperature = getTemp();
  String z= x+ ""+String(temperature);
  Serial.print(z);
delay(1000);

//reciving from app
if (Serial.available() > 0) {
 String messeage=String(Serial.parseInt(),DEC);

  if(messeage=="200"){ // automatic
    if(temperature>maxTemp){
    //Open cooler relay 
    digitalWrite(cooler,HIGH); 
    digitalWrite(heater,HIGH);
    }else if (temperature<minTemp){
    //Open the  heater relay
    digitalWrite(heater,LOW); 
    digitalWrite(cooler,LOW);
    }else if (temperature>minTemp && temperature<maxTemp){
    //Close the heater and the fan relays
    digitalWrite(heater,HIGH); 
    digitalWrite(cooler,LOW);
    }
  } else if(messeage=="300"){// manual
    digitalWrite(cooler,LOW); 
    digitalWrite(heater,HIGH);
  }else if(messeage=="301"){// cooler on
    digitalWrite(cooler,HIGH); 
    digitalWrite(heater,HIGH);
  }else if(messeage=="302"){// heater on
    digitalWrite(cooler,LOW); 
    digitalWrite(heater,LOW);
  }else if(messeage=="303"){// cooler & heater on
    digitalWrite(cooler,HIGH); 
    digitalWrite(heater,LOW);
  }
  
  if(messeage[0]=='4'){// start
    String m=String(messeage[1])+String(messeage[2]);
    minTemp=m.toDouble();
  }
  
  if(messeage[0]=='5'){// end
   String m=String(messeage[1])+String(messeage[2]);
   maxTemp=m.toDouble();
  }
  
 delay(1000);
 }
}



double getTemp(){
  int thermistor_adc_val;
  double output_voltage, thermistor_resistance, therm_res_ln, temperature; 
  thermistor_adc_val = analogRead(thermistor_output);
  output_voltage = ( (thermistor_adc_val * 5.0) / 1023.0 );
  thermistor_resistance = ( ( 5 * ( 10.0 / output_voltage ) ) - 10 ); /* Resistance in kilo ohms */
  thermistor_resistance = thermistor_resistance * 1000 ; /* Resistance in ohms   */
  therm_res_ln = log(thermistor_resistance);
  /*  Steinhart-Hart Thermistor Equation: */
  /*  Temperature in Kelvin = 1 / (A + B[ln(R)] + C[ln(R)]^3)   */
  /*  where A = 0.001129148, B = 0.000234125 and C = 8.76741*10^-8  */
  temperature = ( 1 / ( 0.001129148 + ( 0.000234125 * therm_res_ln ) + ( 0.0000000876741 * therm_res_ln * therm_res_ln * therm_res_ln ) ) ); /* Temperature in Kelvin */
  temperature = temperature - 273.15; /* Temperature in degree Celsius */
//  Serial.print("Temperature in degree Celsius = ");
//  Serial.print(temperature);
//  Serial.print("\t\t");
//  Serial.print("Resistance in ohms = ");
//  Serial.print(thermistor_resistance);
//  Serial.print("\n\n");

  return temperature;
 
  }
  
  
