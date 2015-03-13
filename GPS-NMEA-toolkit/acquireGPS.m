function GPSlog=acquireGPS(GPSreceiverHandle,NMEAdump, doItQuick)
%   ACQUIREGPS   Reads one set of NMEA sentences and parses it into GPSlog
%   struct
%
%
%   Arguments:
%   -GPSreceiverHandle      : defines a port handle.
%   -NMEAdump               : a flag to set whether NMEA dump is required
%   or not. (1 - generate NMEA dump, 0 - don't generate)
%   -doItQuick              : a flag to set whether this function needs
%   work in more optimized manner. Less information is obtained, but
%   overall function processing delay is 25% less
%
%   Examples:
%   1) GPSlog=acquireGPS(GPSReceiverHandle,1, 0)
%
%GPSlog = 
%
%                        GSV_PRNs: [11x4 double]
%                        NMEAdump: [1x465 char]
%                 GSV_numMessages: 3
%               GSV_numSatellites: 11
%                      GPRMC_time: [16 30 22]
%                    GPRMC_status: 86
%                GPRMC_statusText: 'Void'
%                       GPRMC_lat: 50.7902
%                      GPRMC_long: 6.0635
%              GPRMC_speedInKnots: 0
%    GPRMC_speedInMetersPerSecond: 0
%       GPRMC_trackAngleInDegrees: 0
%                      GPRMC_date: [14 7 11]
%         GPRMC_MagneticVariation: '0.7000,E'
%                        GGA_time: [16 30 22]
%                         GGA_lat: 50.7902
%                        GGA_long: 6.0635
%                         GGA_fix: 0
%                     GGA_fixText: 'invalid'
%               GGA_NumSatellites: 0
%                        GGA_HDOP: 0
%                    GGA_Altitude: 0
%               GGA_HeightOfGeoID: 0
%                         GSA_fix: 1
%                     GSA_fixText: 'no fix'
%                        GSA_PRNs: [1x12 double]
%                        GSA_PDOP: 0
%                        GSA_HDOP: 0
%                        GSA_VDOP: 0
%                HorErrorInMeters: 0
%                        datetime: [1x6 double]
%                    acquireDelay: 0.0159
%
%
%   2) GPSlog=acquireGPS(GPSReceiverHandle,1, 1)
% 
% GPSlog = 
% 
%                         GSV_PRNs: []
%                         NMEAdump: [1x189 char]
%                       GPRMC_time: [16 30 25]
%                     GPRMC_status: 86
%                 GPRMC_statusText: 'Void'
%                        GPRMC_lat: 50.7902
%                       GPRMC_long: 6.0635
%               GPRMC_speedInKnots: 0
%     GPRMC_speedInMetersPerSecond: 0
%        GPRMC_trackAngleInDegrees: 0
%                       GPRMC_date: [14 7 11]
%          GPRMC_MagneticVariation: '0.7000,E'
%                         datetime: [1x6 double]
%                     acquireDelay: 0.0022
%
%   3) GPSlog=acquireGPS(GPSReceiverHandle,0, 1)
% 
% GPSlog = 
% 
%                         GSV_PRNs: []
%                         NMEAdump: []
%                       GPRMC_time: [16 30 26]
%                     GPRMC_status: 86
%                 GPRMC_statusText: 'Void'
%                        GPRMC_lat: 50.7902
%                       GPRMC_long: 6.0635
%               GPRMC_speedInKnots: 0
%     GPRMC_speedInMetersPerSecond: 0
%        GPRMC_trackAngleInDegrees: 0
%                       GPRMC_date: [14 7 11]
%          GPRMC_MagneticVariation: '0.7000,E'
%                         datetime: [1x6 double]
%                     acquireDelay: 0.0034
%      
%   Author: Aleksandar Kovacevic
%   Email: Aleksandar.Kovacevic@rwth-aachen.de


testIt=rem(now,1);
measGPSLoc1=[];
measGPSLoc2=[];
measGPSLoc3=[];
measGPSLoc4=[];
measGPSLoc5=[];
measGPSLoc6=[];
data='';
i=1;

GSV_string=[];
GPSlog.GSV_PRNs=[];
GPSlog.NMEAdump=[];
j=1;
while i<9
data = fscanf(GPSreceiverHandle);
if (NMEAdump==1)
    if (~isempty(data))
    if (strcmp(data(1),'$'))
    GPSlog.NMEAdump=sprintf('%s%s',GPSlog.NMEAdump,data);
    end
    end
end
data = strrep(data, ',,,,,,', ',0,0,0,0,0,');
data = strrep(data, ',,,,,', ',0,0,0,0,');
data = strrep(data, ',,,,', ',0,0,0,');
data = strrep(data, ',,,', ',0,0,');
data = strrep(data, ',,', ',0,');
if (~doItQuick)
    measGPSLoc1=[measGPSLoc1;sscanf(data,'$GPGGA,%d,%f,N,%f,E,%d,%d,%f,%f,M,%f,M,,*%X')'];
    measGPSLoc2=[measGPSLoc2;sscanf(data,'$GPGSA,A,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%f,%f,%f*%X')'];

    if (~isempty(strfind(data, '$GPGSV,')))
        GSV_string=data(8:end-3);
        %disp(GSV_string);
        %disp((length(GSV_string)-7)/13);
        switch (floor((length(GSV_string)-7)/13))
            case 1
                %disp('1');
                temp=sscanf(data,'$GPGSV,%d,%d,%d,%d,%d,%d,%d*%X')';
                if (temp(2)==j)
                    GPSlog.GSV_numMessages=temp(1);
                    GPSlog.GSV_numSatellites=temp(3);
                    GPSlog.GSV_PRNs=[GPSlog.GSV_PRNs;temp(4) temp(5) temp(6) temp(7)];
                    if (j<temp(1))
                        j=j+1;
                    end        
                end
            case 2
                %disp('2');
                temp=sscanf(data,'$GPGSV,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d*%X')';
                if (temp(2)==j)
                    GPSlog.GSV_numMessages=temp(1);
                    GPSlog.GSV_numSatellites=temp(3);
                    GPSlog.GSV_PRNs=[GPSlog.GSV_PRNs;temp(4) temp(5) temp(6) temp(7);temp(8) temp(9) temp(10) temp(11)];
                    if (j<temp(1))
                        j=j+1;
                    end
                end
            case 3
                %disp('3');
                temp=sscanf(data,'$GPGSV,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d*%X')';
                if (temp(2)==j)        
                    GPSlog.GSV_numMessages=temp(1);
                    GPSlog.GSV_numSatellites=temp(3);
                    GPSlog.GSV_PRNs=[GPSlog.GSV_PRNs;temp(4) temp(5) temp(6) temp(7);temp(8) temp(9) temp(10) temp(11);temp(12) temp(13) temp(14) temp(15)];
                    if (j<temp(1))
                        j=j+1;
                    end
                end
            case 4
                %disp('4');
                temp=sscanf(data,'$GPGSV,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d*%X')';
                if (temp(2)==j)        
                    GPSlog.GSV_numMessages=temp(1);
                    GPSlog.GSV_numSatellites=temp(3);
                    GPSlog.GSV_PRNs=[GPSlog.GSV_PRNs;temp(4) temp(5) temp(6) temp(7);temp(8) temp(9) temp(10) temp(11);temp(12) temp(13) temp(14) temp(15);temp(16) temp(17) temp(18) temp(19)];
                    if (j<temp(1))
                        j=j+1;
                    end
                end 
        end
    end
    
end
measGPSLoc6=[measGPSLoc6;sscanf(data,'$GPRMC,%d,%[AV],%f,N,%f,E,%f,%f,%d,%f,%[NWES]*%X')'];
if (~isempty(measGPSLoc6) && doItQuick)
    break;
end
i=i+1;
end
%$GPRMC
GPSlog.GPRMC_time=[floor(measGPSLoc6(1,1)/10000) floor(mod(measGPSLoc6(1,1),10000)/100) mod(measGPSLoc6(1,1),100)];%     123519       Fix taken at 12:35:19 UTC
GPSlog.GPRMC_status=measGPSLoc6(1,2);%     A            Status A=active or V=Void.
if (strcmp(GPSlog.GPRMC_status,'A'))
    GPSlog.GPRMC_statusText='Active';
else
    GPSlog.GPRMC_statusText='Void';
end
GPSlog.GPRMC_lat=floor(measGPSLoc6(1,3)/100)+(mod(measGPSLoc6(1,3),100))/60;%     4807.038,N   Latitude 48 deg 07.038' N
GPSlog.GPRMC_long=floor(measGPSLoc6(1,4)/100)+(mod(measGPSLoc6(1,4),100))/60;%     01131.000,E  Longitude 11 deg 31.000' E
GPSlog.GPRMC_speedInKnots=measGPSLoc6(1,5);%     022.4        Speed over the ground in knots
GPSlog.GPRMC_speedInMetersPerSecond=0.514444*GPSlog.GPRMC_speedInKnots;
GPSlog.GPRMC_trackAngleInDegrees=measGPSLoc6(1,6);%     084.4        Track angle in degrees True
GPSlog.GPRMC_date=[floor(measGPSLoc6(1,7)/10000) floor(mod(measGPSLoc6(1,7),10000)/100) mod(measGPSLoc6(1,7),100)];%     230394       Date - 23rd of March 1994
GPSlog.GPRMC_MagneticVariation=sprintf('%.4f,%s',measGPSLoc6(1,8),measGPSLoc6(1,9));%     003.1,W      Magnetic Variation
if (~doItQuick)
%     GGA          Global Positioning System Fix Data
GPSlog.GGA_time=[floor(measGPSLoc1(1,1)/10000) floor(mod(measGPSLoc1(1,1),10000)/100) mod(measGPSLoc1(1,1),100)]; %     123519       Fix taken at 12:35:19 UTC
GPSlog.GGA_lat=floor(measGPSLoc1(1,2)/100)+(mod(measGPSLoc1(1,2),100))/60; %     4807.038,N   Latitude 48 deg 07.038' N
GPSlog.GGA_long=floor(measGPSLoc1(1,3)/100)+(mod(measGPSLoc1(1,3),100))/60;%     01131.000,E  Longitude 11 deg 31.000' E
GPSlog.GGA_fix=measGPSLoc1(1,4);
switch GPSlog.GGA_fix
    case 0
        GPSlog.GGA_fixText='invalid';%     1            Fix quality: 0 = invalid
    case 1
        GPSlog.GGA_fixText='GPS fix (SPS)';%                               1 = GPS fix (SPS)
    case 2
        GPSlog.GGA_fixText='DGPS fix';%                               2 = DGPS fix
    case 3
        GPSlog.GGA_fixText='PPS fix';%                               3 = PPS fix
    case 4
        GPSlog.GGA_fixText='Real Time Kinematic';%			       4 = Real Time Kinematic
    case 5
        GPSlog.GGA_fixText='Float RTK';%			       5 = Float RTK
    case 6
        GPSlog.GGA_fixText='estimated (dead reckoning)';%                               6 = estimated (dead reckoning) (2.3 feature)
    case 7
        GPSlog.GGA_fixText='Manual input mode';%			       7 = Manual input mode
    case 8
        GPSlog.GGA_fixText='Simulation mode';%			       8 = Simulation mode
end
GPSlog.GGA_NumSatellites=measGPSLoc1(1,5);%     08           Number of satellites being tracked
GPSlog.GGA_HDOP=measGPSLoc1(1,6);%     0.9          Horizontal dilution of position
GPSlog.GGA_Altitude=measGPSLoc1(1,7);%     545.4,M      Altitude, Meters, above mean sea level
GPSlog.GGA_HeightOfGeoID=measGPSLoc1(1,8);%     46.9,M       Height of geoid (mean sea level) above WGS84 ellipsoid
%GPSlog.GGA_TimeSinceLastDGPSUpdate=measGPSLoc1(1,9);%     (empty field) time in seconds since last DGPS update
%GPSlog.GGA_DGPSstationID=measGPSLoc1(1,10);%     (empty field) DGPS station ID number
%     *47          the checksum data, always begins with *

%     GSA      Satellite status
GPSlog.GSA_fix=measGPSLoc2(1,1);
switch GPSlog.GSA_fix
    case 1
        GPSlog.GSA_fixText='no fix';%     3        3D fix - values include: 1 = no fix
    case 2
        GPSlog.GSA_fixText='2D fix';%                                       2 = 2D fix
    case 3
        GPSlog.GSA_fixText='3D fix';%                                       3 = 3D fix
end
GPSlog.GSA_PRNs=measGPSLoc2(1,2:13);%     04,05... PRNs of satellites used for fix (space for 12) 
GPSlog.GSA_PDOP=measGPSLoc2(1,14);%     2.5      PDOP (dilution of precision) 
GPSlog.GSA_HDOP=measGPSLoc2(1,15);%     1.3      Horizontal dilution of precision (HDOP) 
GPSlog.GSA_VDOP=measGPSLoc2(1,16);%     2.1      Vertical dilution of precision (VDOP)
GPSlog.HorErrorInMeters=3.71*GPSlog.GSA_HDOP;
end
GPSlog.datetime=[2000+GPSlog.GPRMC_date(3) GPSlog.GPRMC_date(2) GPSlog.GPRMC_date(1) GPSlog.GPRMC_time];
GPSlog.acquireDelay=(rem(now,1)-testIt)*3600*24;
end