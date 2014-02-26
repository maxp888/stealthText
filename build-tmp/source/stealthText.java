import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class stealthText extends PApplet {

boolean sw = true;

public void setup(){
	size(480,480);
}

public void draw(){
	fill(0);
	textSize(24);
	text("Draw this message repeatedly",10,60);
	if (sw) text("Draw this message once",10,60);
	sw = false;
	noLoop();
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "stealthText" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
