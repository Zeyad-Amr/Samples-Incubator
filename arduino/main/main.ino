#include <math.h>
#define fan_relayC 13  //Red
#define se4war_relayH 7  //Green
const int thermistor_output = A1; //Green

void setup() {
  pinMode(fan_relayC, OUTPUT);
  pinMode(se4war_relayH, OUTPUT);
  Serial.begin(9600);  /* Define baud rate for serial communication */
}

void loop() {
  Serial.print(",22.1");

 delay(1000);
//  float temperature= getTemp();
//  float maxTemp =35;  //serial.read();
//  float minTemp =30;      //serial.read();
//  
//  if(temperature>maxTemp){
//    //Open fan relay 
//    digitalWrite(fan_relayC,HIGH); 
//    digitalWrite(se4war_relayH,LOW);
//    }   
//  if (temperature<minTemp){
//    //Open the se4war heater relay
//    digitalWrite(se4war_relayH,HIGH); 
//    digitalWrite(fan_relayC,LOW);}
//    
//  if (temperature>minTemp && temperature<maxTemp){
//    //Close the se4war and the fan relays
//    digitalWrite(se4war_relayH,LOW); 
//    digitalWrite(fan_relayC,LOW);}
//       
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
