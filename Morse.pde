//////////////////////////////////////////////// //<>//
//Decodificador Morse a Arduino para faros LED//
////////////////////////////////////////////////

import controlP5.*;
import processing.serial.*;
import cc.arduino.*;

ControlP5 cp5;

//Serial myPort;

String morse1;
String morse2;
//String test = "0123";

Arduino arduino;
int ledPin1 = 5;
int ledPin2 = 3;
int dotTime = 200; //en milisegundos

int ON1 = 0;
int ON2 = 0;

void setup() {
  //println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(ledPin1, Arduino.OUTPUT);
  arduino.pinMode(ledPin2, Arduino.OUTPUT);

  size(500, 380);

  textSize(20);

  cp5 = new ControlP5(this);

  cp5.addTextlabel("Titulo1")
    .setText("Salida 'A' | AUDIO")
    .setPosition(15, 15)
    .setColorValue(0xffffffff)
    .setFont(createFont("isocpeur", 27))
    ;

  cp5.addTextfield("Texto1")
    .setPosition(20, 50)
    .setSize(180, 40)
    .setFont(createFont("isocpeur", 25))
    .setFocus(true)
    .setColor(color(255, 255, 255))
    .setLabel("Texto")
    ;
  ;

  cp5.addBang("Empezar1")
    .setPosition(300, 125)
    .setSize(90, 40)
    .setFont(createFont("isocpeur", 22))
    .setLabel("Empezar")
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;

  cp5.addBang("Parar1")
    .setPosition(400, 125)
    .setSize(80, 40)
    .setFont(createFont("isocpeur", 22))
    .setLabel("Parar")
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;

  cp5.addTextlabel("Titulo2")
    .setText("Salida 'B' | LUCES")
    .setPosition(15, 215)
    .setColorValue(0xffffffff)
    .setFont(createFont("isocpeur", 27))
    ;

  cp5.addTextfield("Texto2")
    .setPosition(20, 250)
    .setSize(180, 40)
    .setFont(createFont("isocpeur", 25))
    .setFocus(true)
    .setColor(color(255, 255, 255))
    .setLabel("Texto")
    ;
  ;

  cp5.addBang("Empezar2")
    .setPosition(300, 325)
    .setSize(90, 40)
    .setFont(createFont("isocpeur", 22))
    .setLabel("Empezar")
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;

  cp5.addBang("Parar2")
    .setPosition(400, 325)
    .setSize(80, 40)
    .setFont(createFont("isocpeur", 22))
    .setLabel("Parar")
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
    ;
}

void draw() {
  background(150);
  fill(70);
  noStroke();
  rect(0, 180, 500, 15);

  fill(255);

  translateMorse();

  ifArduino();
}

void ifArduino() {
  if (ON1 == 1) {
    morseToArduino(morse1, ledPin1);
  } 
  if (ON2 == 1) {
    morseToArduino(morse2, ledPin2);
  }
}

void translateMorse() {
  morse1 = encodeMorseCode(cp5.get(Textfield.class, "Texto1").getText());
  //text(cp5.get(Textfield.class, "Texto1").getText(), 270, 50);
  String morse1Display = encodeMorseCodeDisplay(cp5.get(Textfield.class, "Texto1").getText());
  text(morse1Display, 210, 80);

  morse2 = encodeMorseCode(cp5.get(Textfield.class, "Texto2").getText());
  //text(cp5.get(Textfield.class, "Texto2").getText(), 270, 50);
  String morse2Display = encodeMorseCodeDisplay(cp5.get(Textfield.class, "Texto2").getText());
  text(morse2Display, 210, 280);
}

public void Empezar1() {
  ON2 = 1;
  ON1 = 1;
}

public void Parar1() {
  ON1 = 0;
  ON2 = 0;
}

//public void Empezar2() {
//  ON1 = 0;
//  ON2 = 1;
//}

//public void Parar2() {
//  ON2 = 0;
//}


void morseToArduino(String morse, int ledPin) {
  int i;
  for (i = 0; i < morse.length(); i++) {
    if (morse.charAt(i) == 46) {
      println("PUNTO");
      arduino.digitalWrite(ledPin, Arduino.HIGH);
      delay(dotTime);
    } else if (morse.charAt(i) == 95) {
      println("RAYA");
      arduino.digitalWrite(ledPin, Arduino.HIGH);
      delay(dotTime*3);
    } else if (morse.charAt(i) == 110) {
      println("ESPACIO ENTRE CARACTERES");
      arduino.digitalWrite(ledPin, Arduino.LOW);
      delay(dotTime);
    } else if (morse.charAt(i) == 99) {
      println("ESPACIO ENTRE LETRAS");
      arduino.digitalWrite(ledPin, Arduino.LOW);
      delay(dotTime*3);
    } else if (morse.charAt(i) == 119) {
      println("ESPACIO ENTRE PALABRAS");
      arduino.digitalWrite(ledPin, Arduino.LOW);
      delay(dotTime);
    }
  }
  delay(dotTime*4);
}


String encodeMorseCode(String in_string) {

  String TextInput = in_string.toLowerCase();
  String MorseCode = new String();
  String[] AlphabetArray = {
    " ", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
    "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
  };
  String[] MorseCodeArray = {
    "w", ".n_", "_n.n.n.", "_n.n_n.", "_n.n.", ".", ".n.n_n.", "_n_n.", ".n.n.n.", ".n.", ".n_n_n_", "_n.n_", ".n_n.n.", "_n_", 
    "_n.", "_n_n_", ".n_n_n.", "_n_n.n_", ".n_n.", ".n.n.", "_", ".n.n_", ".n.n.n_", ".n_n_", "_n.n.n_", "_n.n_n_", "_n_n.n."
  };

  for (int i=0; i<TextInput.length(); i++) {
    for (int j=0; j<AlphabetArray.length; j++) {
      if (String.valueOf(TextInput.charAt(i)).equals(AlphabetArray[j])) {
        MorseCode += MorseCodeArray[j] + "c" ;
      }
    }
  }
  return MorseCode;
}

String encodeMorseCodeDisplay(String in_string) {

  String TextInput = in_string.toLowerCase();
  String MorseCode = new String();
  String[] AlphabetArray = {
    " ", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
    "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
  };
  String[] MorseCodeArray = {
    "", "._", "_...", "_._.", "_..", ".", ".._.", "__.", "....", "..", ".___", "_._", "._..", "__", 
    "_.", "___", ".__.", "__._", "._.", "...", "_", ".._", "..._", ".__", "_.._", "_.__", "__.."
  };

  for (int i=0; i<TextInput.length(); i++) {
    for (int j=0; j<AlphabetArray.length; j++) {
      if (String.valueOf(TextInput.charAt(i)).equals(AlphabetArray[j])) {
        MorseCode += MorseCodeArray[j] + " " ;
      }
    }
  }
  return MorseCode;
}
