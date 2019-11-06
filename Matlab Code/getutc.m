function utctime = getutc(timezone)
%UTCTIME = GETUTC(TIMEZONE) Retrieves the Coordinated Universal Time of a given TIMEZONE and converts it
% to a Matlab datenum. 
% INPUT:
% TIMEZONE an integer in the range of -12 to 12 specifies the time zone
% OUTPUT:
% UTCTIME returns the current UTC time as a MATLAB datenum. It can be converted to a date string of specified format by the
% the MATLAB function datestr.
%
% Example:
% utctime = getutc(8); % get the UTC time of No.8 time zone (Beijing)
% datestr(utctime,'yyyy-mm-dd HH:MM:SS')
%
% See also DATENUM,DATESTR,WEBREAD,URLREAD

% Dr.Qun Han
% College of Precision Instrument and Opto-electronics Engineering,
% Tianjin University, Tianjin, P.R. China

if nargin<1
    timezone = 0;
end
if timezone>12 || timezone<-12
    error('Invalid TIMEZONE:Timezone should be in the range of [-12,12].')
end
floor(timezone);
timeServer = 'https://time.is/UTC';
o = weboptions('CertificateFilename','');
uniTime = str2double(regexp(webread(timeServer,o),'\d{13}','match','once'))/1000; % Retrieve the universal time and convert it to seconds
localTime = uniTime+timezone*60*60;
ml = [1970,1,1,0,0,localTime]; %Matlab datenum is defied relative to Jan-01,1970,00:00:00,
utctime = datenum(ml);