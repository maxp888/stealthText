bool oldb1, oldb2, b1, b2;
unsigned long high1, high2, low1, low2, timer, lTime, hiTime;
unsigned long PUSH_THRESH = 1000;
unsigned long LONGPRESS_THRESH = 1000;
unsigned long ENTRY_THRESH = 25;
unsigned int PRESSURE_THRESH = 250;
int btn1pin = 0;
int btn2pin = 0;
int row, col;
bool delFlg, spcFlg, rowFlg, colFlg;
char code[7][5] = {
	{'a','b','c','d','e'},
	{'f','g','h','i','j'},
	{'l','m','n','o','p'},
	{'q','r','s','t','u'},
	{'v','w','x','y','z'},
	{'1','2','3','4','5'},
	{'6','7','8','9','0'}
};

void clear(){
	row = -1;
	col = -1;
	oldb1 = false;
	oldb2 = false;
	delFlg = false;
	spcFlg = false;
	rowFlg = false;
	colFlg = false;
}

void setup() {
  pinMode(btn1pin, INPUT);
  pinMode(btn2pin, INPUT);
  Serial.begin(9600);
  clear();
}

void push(){
	if (delFlg and not spcFlg) {
		Serial.println("DEL");
	}
	else if (spcFlg and not delFlg;) {
		Serial.println(' ');
	}
  else if (delFlg and spcFlg){
    Serial.println("SEND");
  }
	else if (row > -1 and col > -1) {
		row = row % 7;
		col = col % 5;
		Serial.println(code[row][col]);
	}
}

void loop() {
  // put your main code here, to run repeatedly: 
  lTime = millis();
  b1 = (analogRead(btn1pin) > PRESSURE_THRESH);
  b2 = (analogRead(btn2pin) > PRESSURE_THRESH);

  if (b1 and not oldb1){  //POSITIVE TRANSITION
  	high1 = lTime;
  } 
  else if ((not b1) and oldb1) { //NEGATIVE TRANSITION
  	hiTime = lTime - high1;
  	if (hiTime >= LONGPRESS_THRESH){
  		delFlg = true;
  		low1 = lTime;
  	} else if ((hiTime >= ENTRY_THRESH) and (hiTime < LONGPRESS_THRESH)){
  		rowFlg = true;
  		row++;
  		low1 = lTime;
  	}
  }
  
  if (b2 and not oldb2){  //POSITIVE TRANSITION
  	high2 = lTime;
  } 
  else if ((not b2) and oldb2) { //NEGATIVE TRANSITION
  	hiTime = lTime - high2;
  	if (hiTime >= LONGPRESS_THRESH){
  		spcFlg = true;
  		low2 = lTime;
  	} else if ((hiTime >= ENTRY_THRESH) and (hiTime < LONGPRESS_THRESH)){
  		colFlg = true;
  		col++;
  		low2 = lTime;
  	}
  }

//both button1 and button2 
  if (((low1 > high1) and (low2 > high2)) and ((lTime - low1 > PUSH_THRESH) and (lTime - low2 > PUSH_THRESH))){
  	push();
  	clear();
  }

  //store button vals
  oldb1 = b1;
  oldb2 = b2;
}
//also a test