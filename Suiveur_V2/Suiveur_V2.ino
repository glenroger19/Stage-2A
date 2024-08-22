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
float max_power_mW = 0;
int max_power_angle = 0;

void setup() {
  Serial.begin(9600);
  Wire.begin();
  
  // Initialisation de l'INA219
  ina219.begin();
  
  // Initialisation du servomoteur
  myservo.attach(servoPin);
  myservo.write(30); // Positionner le servomoteur à 30°

  Serial.println("Appuyez sur la barre d'espace pour rechercher la puissance maximale.");
}

void loop() {
  // Vérifier si la barre d'espace est appuyée
  if (Serial.available() > 0) {
    char incomingChar = Serial.read();
    if (incomingChar == ' ') {
      max_power_mW = 0;
      max_power_angle = 0;

      // Balayer les angles du servomoteur de 60° à 120°
      for (int angle = 60; angle <= 120; angle += 2) {
        myservo.write(angle);
        delay(1000); // Attendre que le servomoteur se stabilise
        
        // Lire le courant et la tension
        current_mA = ina219.getCurrent_mA();
        busVoltage_V = ina219.getBusVoltage_V();
        shuntVoltage_mV = ina219.getShuntVoltage_mV();
        loadVoltage_V = busVoltage_V + (shuntVoltage_mV / 1000);
        
        // Calculer la puissance
        power_mW = current_mA * loadVoltage_V;
        
        // Vérifier si cette puissance est la plus grande
        if (power_mW > max_power_mW) {
          max_power_mW = power_mW;
          max_power_angle = angle;
        }

        // Afficher les valeurs courantes
        Serial.print("Angle: ");
        Serial.print(angle);
        Serial.print(" | Power: ");
        Serial.print(power_mW);
        Serial.println(" mW");
      }

      // Placer le servomoteur à l'angle de puissance maximale
      myservo.write(max_power_angle);
      
      // Afficher les valeurs maximales
      Serial.print("Max Power Angle: ");
      Serial.print(max_power_angle);
      Serial.print(" | Max Power: ");
      Serial.print(max_power_mW);
      Serial.println(" mW");
    }
  }
}
