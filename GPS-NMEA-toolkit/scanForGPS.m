function portList=scanForGPS()
%   SCANFORGPS   Scans communication ports for GPS receiver. It further
%   checks what is sent through serial port in order to determine if they
%   are correct NMEA sentences.
%
%   Examples:
%   1) portList=scanForGPS()
% 
%    Serial Port Object : Serial-/dev/ttyUSB0
% 
%    Communication Settings 
%       Port:               /dev/ttyUSB0
%       BaudRate:           4800
%       Terminator:         'LF'
% 
%    Communication State 
%       Status:             closed
%       RecordStatus:       off
% 
%    Read/Write State  
%       TransferStatus:     idle
%       BytesAvailable:     1
%       ValuesReceived:     79
%       ValuesSent:         0
%      
%   Author: Aleksandar Kovacevic
%   Email: Aleksandar.Kovacevic@rwth-aachen.de

portList=[];
GPSReceiverHandles = instrfind;
%fclose(obj1);
if (isempty(GPSReceiverHandles))
    disp('Something annoying is happening');
else
    for (i=1:length(GPSReceiverHandles))
        fopen(GPSReceiverHandles(i));
        j=1;
        while j<5
            data = fscanf(GPSReceiverHandles(i));
            if (~isempty(strfind(data, '$GPGSV,')) || ~isempty(strfind(data, '$GPGGA,')) || ~isempty(strfind(data, '$GPGSA,')))
                %it is GPS!
                portList=[portList;GPSReceiverHandles(i)];
                break;
            end
            j=j+1;
        end
        fclose(GPSReceiverHandles(i));
    end
end
end