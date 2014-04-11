/* 
   Intersense 2013 @ IIM 

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import processing.net.*;

/////////////////////////
import java.util.*;

import com.sense3d.intersense.network.dataframe.DataframeFromNetwork;

DataframeReceived receiver;

String ADDRESS="127.0.0.1";
int PORT=10001;

//////////////////////////////

PVector center = new PVector(100,100,100);
boolean DEBUG = true;

//////////////////////////////

int num = 300;

PVector [] pnts;
float speed = 1000.0;
float spread = 30.0;

//////////////////////////////


PShader mat;

float rozsah = 1000;

float SMOOTHING = 20.0;

Client client;
String input;

PGraphics pass1, pass2;

ArrayList body;

void setup(){

  size(1280,720,OPENGL);

  receiver = new DataframeFromNetwork(ADDRESS, PORT);
  receiver.init();


  body = new ArrayList();

  pnts = new PVector[num];

  smooth();



  for(int i = 0 ; i < num;i++){
    body.add(new Bod(new PVector(random(-100,100),random(-100,100),random(-100,100))));
  }

  ortho();
}

void draw(){

  background(0);

  projection();

  stroke(255,55);
  fill(255,55);

  for(int i = 1 ; i < pnts.length-1;i++){

    float d = dist(pnts[i+1].x,pnts[i+1].y,pnts[i-1].x,pnts[i-1].y);
    /*
       line(pnts[i].x-pnts[i].z*10.0,pnts[i].y,pnts[i].x+pnts[i].z*10.0,pnts[i].y);
       line(pnts[i].x,pnts[i].y-pnts[i].z,pnts[i].x,pnts[i].y+pnts[i].z);
       line(pnts[i].x,pnts[i].y,pnts[i].x,0);
     */
    ellipse(pnts[i].x,pnts[i].y,d/2,d/2);

  }

  try{
    ArrayList tmp2 = new ArrayList() ;

    tmp2 = getData2();

    // dostavam data?
    if(tmp2!=null)
      for(int i = 0; i < tmp2.size();i++){
        Bod a = (Bod)tmp2.get(i);
        Bod b = (Bod)body.get(i);

        if(DEBUG && i==0)
        println(b.pos.x+" "+b.pos.x+" "+b.pos.z);
        b.pos.x += (a.pos.x-b.pos.x)/SMOOTHING;
        b.pos.y += (a.pos.y-b.pos.y)/SMOOTHING;
        b.pos.z += (a.pos.z-b.pos.z)/SMOOTHING;
      }
 }catch(Exception e)
  {
    println("Chyba pri prijmu dat: "+e);
    //meh
  }

}

// get data from client and parse them
//returns array of Points or null, if no data were received

/* TODO

   Implement all datatypes

   getFrameId();
   getPoints();
   getCentroids();
   getSubCentroids();

 */

ArrayList getData2(){
  ArrayList pointArray = new ArrayList();

  NetworkFrame nf = null;
  if (receiver.isInitialized()) {
    nf = receiver.receive();
    if (nf != null) {

      List<SubCentroid> tmp = nf.getSubCentroids();
      for(Object p : tmp){
        ArrayList arr = (ArrayList)tmp;
        for(Object sc: arr){
          SubCentroid sub = (SubCentroid)sc;
          Point pp = sub.getPoint();
          pointArray.add(new Bod(new PVector(
                  map(pp.getX(),-rozsah,rozsah,-100,100),
                  map(pp.getY(),-rozsah,rozsah,100,-100),
                  map(pp.getZ(),-rozsah,rozsah,-100,100)
                  ))); 
        }
      }
    }
  }else{
    return null;
  }
  return pointArray;
}

class Bod{
  PVector pos;
  color c;

  Bod(PVector _pos){
    pos = _pos;
    c = color(255);
  }

  Bod(int [] data){
    pos = new PVector(data[0],data[1],data[2]);
  }

  void draw(){
    for(int i = 0 ; i < body.size();i++ ){
      Bod tmp = (Bod)body.get(i);
      float d = dist(tmp.pos.x,tmp.pos.y,tmp.pos.z,pos.x,pos.y,pos.z);
      line(tmp.pos.x,tmp.pos.y,tmp.pos.z,pos.x,pos.y,pos.z);
    }
  }
}

int sketchWidth() {
  return 1280;
}

int sketchHeight() {
  return 720;
}

String sketchRenderer() {
  return OPENGL;
}

void exit() {
  receiver.destroy(); //dont forget!!!
  super.exit(); //To change body of generated methods, choose Tools | Templates.
}

void projection(){


  Bod hlava = new Bod(new PVector(0,0,0));
  
  float len = body.size()+0.0;
  for(Object o : body){
    Bod b = (Bod)o;
    hlava.pos.x += b.pos.x/len;
    hlava.pos.y += b.pos.y/len;
    hlava.pos.z += b.pos.z/len;
  }



  pushMatrix();
  camera(hlava.pos.x,hlava.pos.y,hlava.pos.z,center.x,center.y,center.z,0,0,1);
  translate(center.x,center.y,center.z);
  for(int i = 0 ; i < pnts.length;i++){

    PVector origin = new PVector(
        (noise((frameCount+i*spread)/speed,0,0)-0.5)*height,
        (noise(0,(frameCount+i*spread)/speed,0)-0.5)*height,
        (noise(0,0,(frameCount+i*spread)/speed)-0.5)*height
        );    

    pnts[i] = new PVector(
        screenX(origin.x,origin.y,origin.z),
        screenY(origin.x,origin.y,origin.z),
        screenZ(origin.x,origin.y,origin.z)
        );

  }

  popMatrix();

}
