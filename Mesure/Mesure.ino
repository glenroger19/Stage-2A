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
float total_power_mW = 0;
float average_power_mW = 0;
float max_power_mW = 0;
int max_power_angle = 0;
int sample_count = 0;

void setup() {
  Serial.begin(9600);
  Wire.begin();
  
  // Initialisation de l'INA219
  ina219.begin();
  
  // Initialisation du servomoteur
  myservo.attach(servoPin);
}

void loop() {
  max_power_mW = 0;
  max_power_angle = 0;
  
  // Balayer les angles du servomoteur
  for (int angle = 90; angle <= 120; angle += 2) {
    myservo.write(angle);
    delay(1000); // Attendre que le servomoteur se stabilise
    
    // Lire le courant et la tension
    current_mA = ina219.getCurrent_mA();
    busVoltage_V = ina219.getBusVoltage_V();
    shuntVoltage_mV = ina219.getShuntVoltage_mV();
    loadVoltage_V = busVoltage_V + (shuntVoltage_mV / 1000.0);
    
    // Calculer la puissance
    power_mW = current_mA * loadVoltage_V;
    
    // Vérifier si cette puissance est la plus grande
    if (power_mW > max_power_mW) {
      max_power_mW = power_mW;
      max_power_angle = angle;
    }
    
    Serial.print("Angle: ");
    Serial.print(angle);
    Serial.print(" | Power: ");
    Serial.print(power_mW);
    Serial.println(" mW");
  }

  for (int angle = 120; angle >= 60; angle -= 2) {
    myservo.write(angle);
    delay(1000); // Attendre que le servomoteur se stabilise
    
    // Lire le courant et la tension
    current_mA = ina219.getCurrent_mA();
    busVoltage_V = ina219.getBusVoltage_V();
    shuntVoltage_mV = ina219.getShuntVoltage_mV();
    loadVoltage_V = busVoltage_V + (shuntVoltage_mV / 1000.0);
    
    // Calculer la puissance
    power_mW = current_mA * loadVoltage_V;
    
    // Vérifier si cette puissance est la plus grande
    if (power_mW > max_power_mW) {
      max_power_mW = power_mW;
      max_power_angle = angle;
    }
    
    Serial.print("Angle: ");
    Serial.print(angle);
    Serial.print(" | Power: ");
    Serial.print(power_mW);
    Serial.println(" mW");
  }

  for (int angle = 60; angle <= max_power_angle; angle += 2) {
    myservo.write(angle);
    delay(1000); // Attendre que le servomoteur se stabilise

    Serial.print("Angle: ");
    Serial.println(angle);
  }
  
  // Placer le servomoteur à l'angle de puissance maximale
  myservo.write(max_power_angle);

  Serial.print("Max Power Angle: ");
  Serial.print(max_power_angle);
  Serial.print(" | Max Power: ");
  Serial.print(max_power_mW);
  Serial.println(" mW");
  
  // Attendre une minute avant de refaire la mesure (30 minutes = 1800 secondes)
  int duration = 1800; // 30 minutes en secondes
  int interval = 10;   // Intervalle de mesure en secondes (ajustez si nécessaire)
  sample_count = duration / interval;

  total_power_mW = 0;

  for (int i = 0; i < sample_count; i++) {
    // Lire le courant et la tension
    current_mA = ina219.getCurrent_mA();
    busVoltage_V = ina219.getBusVoltage_V();
    shuntVoltage_mV = ina219.getShuntVoltage_mV();
    loadVoltage_V = busVoltage_V + (shuntVoltage_mV / 1000.0);
    
    // Calculer la puissance
    power_mW = current_mA * loadVoltage_V;
    total_power_mW += power_mW;
    
    // Afficher la puissance
    Serial.print("Temps (s): ");
    Serial.print(i * interval);
    Serial.print(" | Puissance: ");
    Serial.print(power_mW);
    Serial.println(" mW");
    delay(interval * 1000);
  }

  // Calculer la puissance moyenne
  average_power_mW = total_power_mW / sample_count;

  // Envoyer les résultats via le port série
  Serial.print("Max Power Angle: ");
  Serial.print(max_power_angle);
  Serial.print(" | Average Power: ");
  Serial.print(average_power_mW);
  Serial.println(" mW");
  
  // Réinitialiser les variables pour la prochaine mesure
  total_power_mW = 0;
  average_power_mW = 0;
  delay(1000); // Attendre une seconde avant de commencer une nouvelle boucle
}
