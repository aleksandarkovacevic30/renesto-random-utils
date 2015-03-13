function GPSReceiverHandle=openGPS(portNumber,BaudRate)
%   OPENGPS   Opens up a port in order to read NMEA sentences from GPS
%   Receiver
%
%   Usage:
%   openGPS() will automatically scans and opens port which sends NMEA sentences
%   openGPS(portNumber, BaudRate): opens a port defined with
%   portNumber,BaudRate parameters
%
%   Arguments:
%   -portNumber     : defines a port number. Different types are
%   supported: double, serial and char types.
%   -BaudRate       : optionally can define baudrate of the connection.
%
%   Examples:
%   1) GPSReceiverHandle=openGPS(1,4800)
%
%   Serial Port Object : Serial-/dev/ttyUSB0
%
%   Communication Settings 
%      Port:               /dev/ttyUSB0
%      BaudRate:           4800
%      Terminator:         'LF'
%
%   Communication State 
%      Status:             open
%      RecordStatus:       off
%
%   Read/Write State  
%      TransferStatus:     idle
%      BytesAvailable:     0
%      ValuesReceived:     0
%      ValuesSent:         0
%
%   2) GPSReceiverHandle=openGPS('/dev/ttyUSB0',4800)
%
%   Serial Port Object : Serial-/dev/ttyUSB0
%
%   Communication Settings 
%      Port:               /dev/ttyUSB0
%      BaudRate:           4800
%      Terminator:         'LF'
%
%   Communication State 
%      Status:             open
%      RecordStatus:       off
%
%   Read/Write State  
%      TransferStatus:     idle
%      BytesAvailable:     0
%      ValuesReceived:     0
%      ValuesSent:         0
%
%   3) GPSReceiverHandle=openGPS()
%scanning for GPS receiver...
%
%   Serial Port Object : Serial-/dev/ttyUSB0
%
%   Communication Settings 
%      Port:               /dev/ttyUSB0
%      BaudRate:           4800
%      Terminator:         'LF'
%
%   Communication State 
%      Status:             open
%      RecordStatus:       off
%
%   Read/Write State  
%      TransferStatus:     idle
%      BytesAvailable:     0
%      ValuesReceived:     0
%      ValuesSent:         0
%      
%   Author: Aleksandar Kovacevic
%   Email: Aleksandar.Kovacevic@rwth-aachen.de

if (nargin==0)
    %scan ports
    disp('scanning for GPS receiver...');
    portNumber=scanForGPS();
    BaudRate=portNumber.BaudRate;
end
if (strcmp(class(portNumber),'double'))
%portNumber '/dev/ttyUSB0'
if (isunix)
    portNumber=sprintf('/dev/ttyUSB%d',portNumber-1);
    elseif (ispc)
        portNumber=sprintf('COM%d',portNumber);
end
elseif (strcmp(class(portNumber),'serial'))    
portNumber=portNumber.Port;
end
if (strcmp(class(portNumber),'char'))
GPSReceiverHandle = instrfind('Type', 'serial', 'Port',portNumber , 'Tag', '');
%fclose(obj1);
if (isempty(GPSReceiverHandle))
    disp('Something annoying is happening');
else
GPSReceiverHandle = GPSReceiverHandle(1);
%GPSreceiverHandle.BaudRate = 4800;
GPSreceiverHandle.BaudRate =BaudRate;
fopen(GPSReceiverHandle);
end
else
    disp('Error: Not Valid input');
end
end

