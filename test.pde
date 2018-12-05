//This demo allows wekinator to control background color (hue)
//This is a continuous value between 0 and 1

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import ddf.minim.*;

OscP5 oscP5;
NetAddress dest;
Minim minim;
AudioPlayer player;

//Parameters of sketch
float myHue;
PFont myFont;

void setup() {
  //Initialize OSC communication
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  size(512, 200, P3D);
  
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);

  //Initialize appearance
  sendOscNames();
  myFont = createFont("Arial", 14);
  
  player = minim.loadFile("/home/yuyakawakami/Downloads/180053__drandarko__drum-loop.wav");
  player.setGain(1);
}

void draw() {
  background(255, 255, 255);
  drawtext();
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
     if(theOscMessage.checkTypetag("f")) { // looking for 1 control value
        float var1 = theOscMessage.get(0).floatValue();
        //float var2 = theOscMessage.get(1).floatValue();
        //float var3 = theOscMessage.get(2).floatValue();
        //float var4 = theOscMessage.get(3).floatValue();
        //float var5 = theOscMessage.get(4).floatValue();
        println (var1);
        if (!player.isPlaying()){
            player.setGain(var1*1000.0);
            player.play();
         } else {
           player.setGain(var1*1000.0);
         }
        println(player.getGain());
        //println(var2);
     } else {
        println("Error: unexpected OSC message received by Processing: ");
        theOscMessage.print();
      }
 }
}

//Sends current parameter (hue) to Wekinator
void sendOscNames() {
  OscMessage msg = new OscMessage("/wekinator/control/setOutputNames");
  msg.add("hue"); //Now send all 5 names
  oscP5.send(msg, dest);
}

//Write instructions to screen.
void drawtext() {
    stroke(0);
    textFont(myFont);
    textAlign(LEFT, TOP); 
    fill(0, 0, 255);
    text("Receiving 1 continuous parameter: hue, in range 0-1", 10, 10);
    text("Listening for /wek/outputs on port 12000", 10, 40);
}
