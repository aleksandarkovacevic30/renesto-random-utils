function closeUnclosedGPS(portNumber)
%   CLOSEUNCLOSEDGPS   closes "unclosed" port opened previously by matlab.
%   This is very useful tool when application suddenly breaks and doesnt
%   close the ports it opened.
%
%   Usage:
%   closeUnclosedGPS(portNumber) closes the unclosed communication port
%
%   Arguments:
%   -portNumber     : defines a port number. Different types are
%   supported: double, serial and char types.
%
%   Author: Aleksandar Kovacevic
%   Email: Aleksandar.Kovacevic@rwth-aachen.de
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
fclose(GPSReceiverHandle(1));
end
end