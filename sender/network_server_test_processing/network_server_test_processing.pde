import processing.net.*;

import com.sense3d.intersense.network.dataframe.DataframeFromFile;
import com.sense3d.intersense.network.dataframe.DataframeSender;
import com.sense3d.intersense.network.dataframe.DataframeReceived;
import com.sense3d.intersense.network.dataframe.Dataframe2Network;
import com.sense3d.intersense.network.dataframe.NetworkFrame;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * Loads dataframes from file and sends them through network (posing as an server).
 * 
 * @author wildman
 */
    DataframeReceived receiver;
    DataframeSender sender;
    int SERVER_PORT=10001;

    
    void setup() {        
        frameRate(30);
        
        // we will be saving to a file
        //receiver = new DataframeFromFile("/Users/wildman/Documents/Processing/network_server_test/data/data.bin");
        receiver = new DataframeFromFile(sketchPath+"/data/data.bin");
        receiver.init();
        sender=new Dataframe2Network(this,SERVER_PORT);
        sender.init();
    }

    void draw() {
        background(0);
        NetworkFrame nf = null;
        if (receiver.isInitialized()) {
            nf = receiver.receive();
            if(sender.isInitialized()){
                sender.send(nf);
            }
        }else{
            receiver.init();
        }

        //draw logs
        fill(255);
        textSize(30);
        text("FPS: " + ((int) frameRate), 500, 50);

        if (nf != null) {
            text("Frame ID: " + nf.getFrameId(), 50, 50);
            text("Points: " + nf.getPoints().size(), 50, 80);
            text("Centroids: " + nf.getCentroids().size(), 50, 110);
            text("Subcentroids: " + nf.getSubCentroids().size(), 50, 140);
            text("Sender initialized: " + sender.isInitialized(), 50, 250);
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
        sender.destroy();
        super.exit(); //To change body of generated methods, choose Tools | Templates.
    }


