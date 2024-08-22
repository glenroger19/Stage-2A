#include <Wire.h>
#include <Adafruit_INA219.h>
#include <Servo.h>

// Initialisation de l'INA219
Adafruit_INA219 ina219;

// Initialisation du servomoteur
Servo myservo;
int servoPin = 10;

// Variables pour mesurer la puissance
float current_mA = 0;
float busVoltage_V = 0;
float shuntVoltage_mV = 0;
float loadVoltage_V = 0;
float power_mW = 0;

void setup() {
  Serial.begin(9600);
  Wire.begin();
  
  // Initialisation de l'INA219
  ina219.begin();
  
  // Initialisation du servomoteur
  myservo.attach(servoPin);
  myservo.write(50); // Positionner le servomoteur à 30°
  
  Serial.println("Appuyez sur la barre d'espace pour lire les valeurs de l'INA219.");
}

void loop() {
  // Vérifier si la barre d'espace est appuyée
  if (Serial.available() > 0) {
    char incomingChar = Serial.read();
    if (incomingChar == ' ') {
      // Lire le courant et la tension
      current_mA = ina219.getCurrent_mA();
      busVoltage_V = ina219.getBusVoltage_V();
      shuntVoltage_mV = ina219.getShuntVoltage_mV();
      loadVoltage_V = busVoltage_V + (shuntVoltage_mV / 1000);
      
      // Calculer la puissance
      power_mW = current_mA * loadVoltage_V;
      
      // Afficher les valeurs lues
      Serial.print("Current: ");
      Serial.print(current_mA);
      Serial.println(" mA");
      
      Serial.print("Bus Voltage: ");
      Serial.print(busVoltage_V);
      Serial.println(" V");
      
      Serial.print("Shunt Voltage: ");
      Serial.print(shuntVoltage_mV);
      Serial.println(" mV");
      
      Serial.print("Load Voltage: ");
      Serial.print(loadVoltage_V);
      Serial.println(" V");
      
      Serial.print("Power: ");
      Serial.print(power_mW);
      Serial.println(" mW");
    }
  }
}
