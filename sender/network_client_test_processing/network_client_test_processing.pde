import com.sense3d.intersense.network.dataframe.DataframeFromNetwork;

DataframeReceived receiver;
String ADDRESS="127.0.0.1";
int PORT=10001;

void setup() {
  receiver = new DataframeFromNetwork(ADDRESS, PORT);
  receiver.init();
}

void draw() {
  background(0);

  fill(255);
  textSize(30);
  text("FPS: " + ((int) frameRate), 500, 50);

  NetworkFrame nf = null;
  if (receiver.isInitialized()) {
    nf = receiver.receive();
    if (nf != null) {
      text("Frame ID: " + nf.getFrameId(), 50, 50);
      text("Points: " + nf.getPoints().size(), 50, 80);
      text("Centroids: " + nf.getCentroids().size(), 50, 110);
      text("Subcentroids: " + nf.getSubCentroids().size(), 50, 140);
    }
  }
}

int sketchWidth() {
  return 640;
}


int sketchHeight() {
  return 480;
}


String sketchRenderer() {
  return P2D;
}

void exit() {
  receiver.destroy(); //dont forget!!!
  super.exit(); //To change body of generated methods, choose Tools | Templates.
}

