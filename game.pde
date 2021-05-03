class game {
  PFont font1;
  PImage menuImg;
  
  String[] notesArr1 = loadStrings("melody1.txt");
  boolean play = false;
  boolean gameEnd = false;
  int score = 0;
  int[] noteSeq = new int [26];
  int nextNote;
  int pressX;
  int timer=0;
  int[] noteUpdate = {0, 0};

  game(int tempVal, int[] tempX, int[] tempY, int tempW, int tempH, int tempNote, SoundFile[] tempSound) {
    serialReading = tempVal;
    gridX = tempX;
    gridY = tempY;
    windowWidth = tempW;
    windowHeight = tempH;
    noteNum = tempNote;
    sounds = tempSound;
  }
  
  void displayMenu() {      //function to show the menu page
    menuImg = loadImage("mainpage.jpg");
    image(menuImg, 0, 0, windowWidth, windowHeight);
  }
  
  void display() {          //function that plays the game     
   background(#F69D99);
   
   makeGrid();              //make visible grid with nested boxes
   scoreDisplay();          //display user game score
   timeCheck();             //check input time limit
   checkPress();            //check user input
  }
  
  void makeGrid() {         //function to make visible game grid
    for(int B=0;B<4;B++){
      fill(#F14D32);        
      if (B == 3) {         //change colors for the bottom tile based on the time elapsed
        if (timer <= 3) {
          fill(#F14D32);
        }
        else if (timer > 3 & timer <= 6) {
          fill(#C13636);
        }
        else if (timer > 6 & timer < 9) {
          fill(#9B0808);
        }
      }
      rect(windowWidth/4*round(gridX[B]),windowHeight/4*gridY[B],windowWidth/4,windowHeight/4);
      strokeWeight(5);
      stroke(#E83440);
      line(windowWidth/4*(B),0,windowWidth/4*(B),windowHeight);
    }
  }
  
  void scoreDisplay() {                                         //function in charge of user score display
    font1 = createFont("font3.otf", 140);
    
    if (gameEnd == true) {                                      //game over page (score display if game end)
      String scoreStr = "score: " + score;
      background(#F69D99);
      textAlign(CENTER);
      textFont(font1);
      textSize(100);      
      fill(#E83440);
      text("game over", windowWidth/2, windowHeight/2+25);
      text(scoreStr,windowWidth/2,windowHeight/2-100);
      println(play,timer);
    }
    
    else if (gameEnd == false) {                                //score display if game is on
      fill(#363435);
      textFont(font1);
      textSize(70);
      textAlign(CENTER);
      text(score,windowWidth/2,70);
    }
  }
  
  void fromSerial() {                                  //function that interprets values incoming from the serial 
    if (serialReading == 1) {                          //red button pressed
      pressX = windowWidth-3*windowWidth/4;
    }                                                  
    else if (serialReading == 2) {                     //if blue button pressed
      pressX = windowWidth-2*windowWidth/4;
    }
    else if (serialReading == 3) {                     //if yellow button pressed
      pressX = windowWidth-windowWidth/4;
    }
    else if (serialReading == 4) {                     //if green button pressed
      pressX = windowWidth;
    }
    else if (serialReading == 0) {                     //if switch is off
      play = false;                                    
      if (gameEnd == true) {                           //call the reset variables functions if game is over
        playAgain();                                          
      }  
      pressX = 0;
    }
    else if (serialReading == 9) {                     //if switch is on 
      myGame.play = true;
      pressX = 0;
    }
  }
  
  void checkPress() {                                                                 //function that checks if piano tile was pressed
    fromSerial();
    if (gameEnd == false & pressX == windowWidth/4*round(gridX[3]+1)) {               //check if X-coordinates of pressed box and nested box match 
      if (serialReading == 1) {                                                       //check which sound file to play
        sounds[serialReading-1].play();
      }
      else if (serialReading == 2) {
        sounds[serialReading-1].play();
      }
      else if (serialReading == 3) {
        sounds[serialReading-1].play();
      }
      else if (serialReading == 4) {
        sounds[serialReading-1].play();
      }      
      score++;                                                                        //indent game score by one  
      gridX[3] = gridX[2];                                                            //move down the nested boxes
      gridX[2] = gridX[1];
      gridX[1] = gridX[0];
      gridX[0] = noteSeq[noteNum];                                                    //nest the top box with the next note
      noteNum = noteNum + 1;                                                          //move to the next note
      if (noteNum >= myGame.noteSeq.length) {                                         //read the string over if user came to the last note of the melody
        noteNum = 0;
      }
      pressX = 0;                                                                     //annulate user input
      timer = 0;
    }
    else if (pressX != windowWidth/4*round(gridX[3]+1) & pressX != 0) {               //if wrong button was pressed -> game over
      gameEnd = true;
    }
  }
  
  void xPlace() {                                                                     //function that converts the note values into button/tile values
    String[] list1 = split(notesArr1[0], ' ');                                        //make an array with separated notes
    String NoteE = "NOTE_E4";
    String NoteD = "NOTE_D4";
    String NoteC = "NOTE_C4";
    String NoteG = "NOTE_G4";
    String s1;
    
    for (int i=0; i<list1.length; i++) {                                              //for loop to connect the note to a button
      s1 = list1[i];
      
      if (NoteE.equals(s1)) {                                                         //check if note E
        nextNote = 3;
        noteSeq[i] = nextNote;
      }
      else if (NoteD.equals(s1)) {                                                    //check if note D
        nextNote = 2;
        noteSeq[i] = nextNote;
      }
      else if (NoteC.equals(s1)) {                                                    //check if note C
        nextNote = 1;
        noteSeq[i] = nextNote;
      }
      else if (NoteG.equals(s1)) {                                                    //check if note G
        nextNote = 0;
        noteSeq[i] = nextNote;
      }
    }
  }
  
  void playAgain() {                                                                  //function to reset game variables
    gameEnd = false;
    score = 0;
    noteNum = 0;
    timer = 0;
  }
  
  void timeCheck() {                                                                  //function that limits the time within which the user can play a button
    if (play == true) {                                                               //indent the timer when the game is on
      timer += 1;
    }
    if (timer == 1) {                                                                 //write down the score at the beginning of given time limit
      noteUpdate[0] = score;
    }
    if (timer >= 9) { //4*3                                                           //limit user thinking time to 3 seconds
      noteUpdate[1] = score;                                                          //write down the score at the end of the given time limit
      if (noteUpdate[0]==noteUpdate[1]) {                                             //if score didn't change -> button wasn't pressed -> end of the game
        sounds[4].play();
        timer = 0;
        gameEnd = true;
      }
      else {
        timer = 0;                                                                    //start the 3 seconds timer over
      }
    }
  }  
}
