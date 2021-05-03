/*#define NOTE_C4  262
#define NOTE_CS4 277
#define NOTE_D4  294
#define NOTE_DS4 311
#define NOTE_E4  330
#define NOTE_F4  349
#define NOTE_FS4 370
#define NOTE_G4  392
#define NOTE_GS4 415
#define NOTE_A4  440
#define NOTE_AS4 466
#define NOTE_B4  494*/

//pins
int buzzerPin = 3;
int buttonPinG = 8;
int buttonPinY = 9;
int buttonPinB = 10;
int buttonPinR = 11;
int switchPin = 5; //turns the buttons on/off

int thisNote = 0;

void setup() {
  pinMode (buttonPinG, INPUT);
  pinMode (buttonPinY, INPUT);
  pinMode (buttonPinB, INPUT);
  pinMode (buttonPinR, INPUT);
  pinMode(buzzerPin, OUTPUT);//buzzer
  Serial.begin(9600);
}

void loop() {
  play();
}

void play() {
  //read

  if (Serial.available()>0) {
    bool buttonStateG = digitalRead(buttonPinG);
    bool buttonStateY = digitalRead(buttonPinY);
    bool buttonStateB = digitalRead(buttonPinB);
    bool buttonStateR = digitalRead(buttonPinR);
    bool switchState = digitalRead(switchPin);

    if (switchState==HIGH && buttonStateG==LOW && buttonStateY==LOW && buttonStateB==LOW && buttonStateR==LOW) {
      noTone (buzzerPin);
      Serial.println('9');
    }
  
    else if (switchState==HIGH && buttonStateG==HIGH && buttonStateY==LOW && buttonStateB==LOW && buttonStateR==LOW) {
      //tone (buzzerPin, NOTE_E4);
      Serial.println('4');
    }
    
    else if (switchState==HIGH && buttonStateG==LOW && buttonStateY==HIGH && buttonStateB==LOW && buttonStateR==LOW) {
      //tone (buzzerPin, NOTE_D4);
      Serial.println('3');
    }
    
    else if (switchState==HIGH && buttonStateG==LOW && buttonStateY==LOW && buttonStateB==HIGH && buttonStateR==LOW) {
      //tone (buzzerPin, NOTE_C4);
      Serial.println('2');
    }
    
    else if (switchState==HIGH && buttonStateG==LOW && buttonStateY==LOW && buttonStateB==LOW && buttonStateR==HIGH) {
      //tone (buzzerPin, NOTE_G4);
      Serial.println('1');
    }
    
    else if (switchState==LOW && buttonStateG==LOW && buttonStateY==LOW && buttonStateB==LOW && buttonStateR==LOW){
      noTone (buzzerPin);
      Serial.println('0');
    }    
   char message = Serial.read();
  }
}
