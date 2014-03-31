=== network_server_test ===
Simple server, that loops over dataframes in a given file and sends them to all connected clients. Port 10001.
- Let me know if you need something more sophisticated (e.g. pausing, etc.)


=== network_server_test_processing ===
dtto - but as a Processing's PDE


=== network_client_test_processing ===
Example of network client in Processing, that receives data over network.

If no new data was received, an older version is handed over - this can be detected using getFrameId() method.



==================================


Dataframe - object encapsulating all data send through network

Methods:
int getFrameId() - ID of this frame (usually equals to frameCount in Processing's PApplet)

List<Point> getPoints() - Returns downsampled points, point has integer coordinates x,y,z

List<Centroid> getCentroids() - Returns cluster centroid positions, centroid has Point and ID of the cluster

List<SubCentroid> getSubCentroids() - Returns centroids of subclusters: Every cluster has some (time-variant)
number of subclasters.
SubCentroid has point, subCentroidID and clusterID - ID of it's parent cluster
