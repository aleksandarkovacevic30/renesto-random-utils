function closeGPS(GPSreceiverHandle)
%   CLOSEGPS   closes the communication port.
%
%   Usage:
%   closeGPS(GPSreceiverHandle) closes the unclosed communication port,
%   defined using handle
%
%   Arguments:
%   -GPSreceiverHandle     : opened port handle, of type "serial"
%
%   Author: Aleksandar Kovacevic
%   Email: Aleksandar.Kovacevic@rwth-aachen.de
fclose(GPSreceiverHandle);
end