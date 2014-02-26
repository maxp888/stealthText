boolean sw = true;

void setup(){
	size(480,480);
}

void draw(){
	fill(0);
	textSize(24);
	text("Draw this message repeatedly",10,60);
	if (sw) text("Draw this message once",10,60);
	sw = false;
	noLoop();
}