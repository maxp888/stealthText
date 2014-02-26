import processing.serial.*;
/*
	The basic structure and setup of this code
	inlcuding the correct usage of serialEvent
	is taken from the serialEvent() reference 
	page on the processing.org website:
	http://www.processing.org/reference/libraries/serial/serialEvent_.html
*/

Serial port;
String inString;
String showString;
int lf = 10;

boolean sw = true;

void setup(){
	size(480,580);
	port = new Serial(this, Serial.list()[0], 9600);
	port.bufferUntil(lf);
	smooth();
	showString = "";
}

void draw(){
	background(255);
	fill(0);
	if (inString == "DEL"){
		if (showString != null and showString.length() > 1) {
			showString = showString.substring(0,showString.length()-1);
		} else {
			showString = "";
		}
	} else if (inString == "SPC"){
		showString += ' ';
	}else {
		showString += inString;
	}
	textSize(24);
	textAlign(CENTER);
	text(showString,10,60);
}

void serialEvent(Serial p){
	inString = p.readString();
}