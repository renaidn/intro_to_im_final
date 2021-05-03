import processing.serial.*;
import processing.sound.*;
Serial myPort;
game myGame;

SoundFile[] sounds;

int[] gridX = new int[4];
int[] gridY = new int[4];
int windowWidth = 660;
int windowHeight = 900;
int noteNum = 4;
int serialReading; 

void setup() {
  size(660, 900);
  frameRate(4);
  
  sounds = new SoundFile[5];
  for (int i = 0; i < 5; i++) {                                     //add sound files to the array
    sounds[i] = new SoundFile(this, (i+1) + ".aiff");
    if (i == 4) {
      sounds[i] = new SoundFile(this, (i+1) + ".wav");              //'game over' sound
    }
  }
  
  myGame = new game(serialReading, gridX, gridY, windowWidth, windowHeight, noteNum, sounds);
  String portname=Serial.list()[0];
  myPort = new Serial(this, portname, 9600);
  myPort.bufferUntil('\n');
  
  myGame.xPlace();

  for (int A=0; A<4; A++) {                                        //make a grid
    gridX[A] = myGame.noteSeq[A];                                  //nest by note
    gridY[A] = A;
  }
}

void serialEvent(Serial myPort) {
  String s = myPort.readStringUntil('\n');                         //read from serial
  s = trim(s);
  if (s != null) {
    serialReading = int(s);                                        //convert to int
  }
}

void draw() {  
  myPort.write(0);
  myGame.fromSerial();
  if (myGame.play == false) {                                      //if game not started -> show display menu
    myGame.displayMenu();
  } else if (myGame.play == true) {
    myGame.display();
  }
}
