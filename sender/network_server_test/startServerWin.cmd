rem usage: application <FPS> <filename>
rem <FPS> - number of frames per second
rem <filename> - name of the file with  dataframe

java -cp ./dist/*;./dist/lib/* -Xms256m -Xmx1024m com.sense3d.intersense.network.TestDataLoadAndNetworkSend 30 data.bin
