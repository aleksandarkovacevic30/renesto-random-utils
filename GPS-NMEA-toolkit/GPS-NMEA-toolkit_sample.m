GPSReceiverHandle=openGPS(1,38400);
GPSlog=acquireGPS(GPSReceiverHandle,0, 1)
closeGPS(GPSReceiverHandle);