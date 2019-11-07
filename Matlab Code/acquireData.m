function [data,time] = acquireData(devicename,channels,iscont,duration,fsamp,range,filename)

%[data,count] = acquireData(devicename,channels,iscont,duration,fsamp,range,filename)
%acquire data from a specified NI device in background or foreground mode, logs the data
%in a .bin file at the end of the acquisition and loads saves data in the workspace
%Required Inputs:
%devicename: a string containing the name of the NI device
%channels: a vector containing the analog input channels to acquire
%iscont: a boolean indicating whether the acquisition is continuous (if iscont=true the function runs startBackground)
%duration: duration of the acquisition in seconds (is used only when iscont=false and runs startForeground)
%fsamp: sampling rate of the device
%range: a two elements row vector indicating the range of the AD converter
%filename: indicate a .bin file for logging the data
%Cristiano De Marchis, November 2019

%---- Creates the DAQ NI session and sets the main device parameters ----

s = daq.createSession('ni');
s.Rate = fsamp;
s.addAnalogInputChannel(devicename,channels,'Voltage');
NChan = length(channels);

for i = 1:NChan
    s.Channels(i).Range = range;
    s.Channels(i).TerminalConfig = 'SingleEnded';
end

s.IsContinuous = iscont;

if iscont==0
    s.DurationInSeconds = duration;
end

%---- builds a signals sub-field within the field UserData of the current NI session.

s.UserData.signals = [];

%---- this file is created and opened in write mode for the final logging
%of the recorded data ----

fid1 = fopen(filename,'w');

%---- a listener with a callback function to addUserData is used to append
%the data to the structure s.UserData.signals each time data are available
%in the NI data stream

lh = addlistener(s,'DataAvailable',@(src,evt) addUserData(src,evt));


%---- NI data acquisition ----

if iscont
    s.startBackground;
    disp('press a key to stop acquisition')
    w = waitforbuttonpress;
    s.stop
else
    s.startForeground;
end

%---- separates time reference from the actual data and creates an external
%log file

time = s.UserData.signals(:,1);
data = s.UserData.signals(:,2:end);
fwrite(fid1,[time,data],'double');


fclose(fid1);

end

function addUserData(src,evt)
data = [evt.TimeStamps, evt.Data];
src.UserData.signals = [src.UserData.signals;data];
end
