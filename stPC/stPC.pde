import processing.serial.*;
/*
	The basic structure and setup of this code
	inlcuding the correct usage of serialEvent
	is taken from the serialEvent() reference 
	page on the processing.org website:
	http://www.processing.org/reference/libraries/serial/serialEvent_.html
*/

static protected color colorScheme[] = {
	#000000, //black
	#D3D3E1, //background
	#B5B5CD, //key grey
	#FFFF5C, //row/col highlite
	#FFCC00, //cell selection
	#00FF00, //last used
};

Serial port;
String showString;
String bldString;
int lf = 10;
boolean clr = true;
Grid grid;
PFont msgFont, defFont;

void setup(){	
	size(480,580);
	grid = new Grid(5,(height/3)+5,width-10,((height/3)*2)-5, 5);
	port = new Serial(this, Serial.list()[0], 9600);
	port.bufferUntil(lf);
	smooth();
	showString = "";
	background(colorScheme[1]);
	msgFont = createFont("LiquidCrystal-Normal.otf", 36);
	defFont = createFont("Ubuntu",15);
}

void draw(){
	background(colorScheme[1]);
	stroke(colorScheme[0]);
	fill(#DAFF8F);
	rect(5,5,width-10,(height/3)-5);
	if (showString != null && showString.length() >= 1) {
		textSize(36);
		textAlign(CENTER);
		textFont(msgFont);
		fill(#000000);
		text(showString,width/2,60);	
		//showString = null;
	}
	grid.draw();
}

void serialEvent(Serial p){
	String inString = null;
	if (p != null && p.available() > 0){
		println("first guard");
		inString = p.readString();
		println("first line");
		if (inString != null){
			println("second guard");
			inString = trim(inString);
			println("second line");
			if (inString == null){
				println("was null");
			} else{
				println(inString);	
				println("print line");
			}
		} 
		if (inString != null) {
			try {
				parseString(inString);
				println("parsestring line");
			}
			catch (Exception e) {
				println(e);
			}
		}
		
	}
}

void parseString(String s){
	if (s.equals("DEL")){
		if ((bldString != null) && (bldString.length() >= 1)) {
			bldString = bldString.substring(0,bldString.length()-1);
		} else {
			bldString = "";
		}
		showString = bldString;
		grid.setDel();

	} else if (s.equals("SPC")){
		if (bldString == null) {
			bldString = " ";
		} else {
			bldString += " ";
		} 
		showString = bldString;
		grid.setSpc();
	} else if (s.equals("SEND")){
		if ((bldString == null)||(bldString.length() == 0)) {
			showString = "MSG NOT SENT: \nNo valid msg!";
		}else {
			showString = "MSG SENT:" + '\n' + bldString;
		}
		bldString = null;
		grid.setSend();
	} else if (s.substring(0,1).equals("#")){
		if (s.substring(0,2).equals("#R")) {
			grid.setRow(int(s.substring(2)));
		} else if (s.substring(0,2).equals("#C")) {
			grid.setCol(int(s.substring(2)));
		}
	} else {
		if (bldString == null){
			bldString = s;
		} else {
			bldString += s;
		}
		showString = bldString;
		grid.setSelect();
	}
	
}


protected class Grid{
	protected int x, y, w, h;
	protected int cellWidth, cellHeight, cellSpacing;
	protected int specialWidth;
	protected int rowSelected, colSelected;
	protected int specialSelected;
	protected boolean charEntered;
	protected int nrow, ncol, nspc;
	protected char[][] code = {
			{'A','B','C','D','E'},
			{'F','G','H','I','J'},
			{'L','M','N','O','P'},
			{'Q','R','S','T','U'},
			{'V','W','X','Y','Z'},
			{'1','2','3','4','5'},
			{'6','7','8','9','0'}
		};
	protected String[] special = {"SPACE","DEL","SEND"};

	public Grid(int x, int y, int width, int height, int spacing) {
		this.nrow = code.length;
		this.ncol = code[0].length;
		this.nspc = special.length;

		this.x = x;
		this.y = y;
		this.w = width;
		this.h = height;
		this.cellSpacing = spacing;

		this.cellWidth = (w - (spacing * (ncol - 1))) / ncol;
		this.cellHeight = (h - (spacing * nrow)) / (nrow + 1);
		this.specialWidth = (w - (spacing * 2 * (nspc - 1))) / nspc;
		this.clear();
	}

	public void clear(){
		rowSelected = -1;
		colSelected = -1;
		specialSelected = -1;
		charEntered = false;
	}

	public void setDel(){
		clear();
		specialSelected = 1;
	}
	public void setSpc(){
		clear();
		specialSelected = 0;
	}
	public void setSend(){
		clear();
		specialSelected = 2;
	}
	public void setRow(int row){
		if (charEntered == true || specialSelected > -1) {
			clear();
		}

		rowSelected = row;
	}
	public void setCol(int col){
		if (charEntered == true || specialSelected > -1) {
			clear();
		}
		
		colSelected = col;
	}
	public void setSelect(){
		charEntered = true;
	}

	public void draw() {
		int r, c, ox, oy, i;
		textSize(15);
		textAlign(CENTER, CENTER);

		for (r = 0, oy=this.y; r < nrow; r++, oy += cellHeight+cellSpacing){
			for (c = 0, ox=this.x; c < ncol; c++, ox += cellWidth + cellSpacing){
				if (specialSelected>=0){
					fill(colorScheme[2]);
				} else if ((rowSelected == r) && (colSelected == c)){
				 	if (charEntered){
				 		fill(colorScheme[5]);
					} else {
						fill(colorScheme[4]);
					}
				} else if((rowSelected == r) || (colSelected == c)) {
					fill(colorScheme[3]);
				} else {
					fill(colorScheme[2]);
				}
				rect(ox,oy,cellWidth,cellHeight);
				fill(colorScheme[0]);
				textFont(defFont);
				text(code[r][c],ox+cellWidth/2,oy+cellHeight/2);
			}
		}
		for (i = 0, ox = this.x; i< nspc; i++, ox += specialWidth+(cellSpacing*2)){
			if (specialSelected == i){
				fill(colorScheme[5]);
			}else {
				fill(colorScheme[2]);
			}

			rect(ox, oy, specialWidth, cellHeight);
			fill(colorScheme[0]);
			text(special[i],ox+specialWidth/2,oy+cellHeight/2);
		}
	}
}