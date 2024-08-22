#include <Servo.h>

Servo myservo;  // crée un objet servo pour contrôler un servo

void setup() {
  myservo.attach(10);  // attache le servo à la broche numérique 9 de l'Arduino
}

void loop() {
  // Boucle de 0 à 180 degrés par incréments de 10 degrés
  for (int angle = 90; angle <= 130; angle += 1) {
    myservo.write(angle);  // place le servo à l'angle spécifié
    delay(500);            // attend 0,5 seconde
  }

  // Boucle de 180 à 0 degrés par incréments de 10 degrés
  for (int angle = 130; angle >= 50; angle -= 1) {
    myservo.write(angle);  // place le servo à l'angle spécifié
    delay(500);            // attend 0,5 seconde
  }

  // Boucle de 180 à 0 degrés par incréments de 10 degrés
  for (int angle = 50; angle <= 90; angle += 1) {
    myservo.write(angle);  // place le servo à l'angle spécifié
    delay(500);            // attend 0,5 seconde
  }
}
