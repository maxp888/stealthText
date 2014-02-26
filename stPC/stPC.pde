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
String bldString;
int lf = 10;
boolean clr = true;

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
	if (showString != null && showString.length() >= 1) {
		textSize(24);
		textAlign(CENTER);
		text(showString,width/2,60);	
		//showString = null;
	}
	
}

void serialEvent(Serial p){
	inString = p.readString();
	inString = inString.substring(0,inString.length()-2);
	print(inString);
	parseString(inString);
}

void parseString(String s){
	if (s.equals("DEL")){
		if ((bldString != null) && (bldString.length() >= 1)) {
			bldString = bldString.substring(0,bldString.length()-1);
		} else {
			bldString = "";
		}
		showString = bldString;
	} else if (s.equals("SPC")){
		if (bldString == null) {
			bldString = " ";
		} else {
			bldString += " ";
		} 
		showString = bldString;
	} else if (s.equals("SEND")){
		if ((bldString == null)||(bldString.length() == 0)) {
			showString = "MSG NOT SENT: \nNo valid msg!";
		}else {
			showString = "MSG SENT:" + '\n' + bldString;
		}
		bldString = null;
	} else {
		if (bldString == null){
			bldString = s;
		} else {
			bldString += s;
		}
		showString = bldString;
	}
	
}