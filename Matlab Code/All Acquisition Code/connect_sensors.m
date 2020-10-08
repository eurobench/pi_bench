function [sh,s] = connect_sensors(COMPORT,fsamp_sh, devicename, ni_channels, fsamp_ni, range_ni)

%INPUT:
%
%COMPORT: cell array list of the COM PORTS for connecting the Shimmer sensors. The last port
%corresponds to the EMG Shimmer sensor providing the trigger signal
%
%fsamp_sh: sampling rate of the shimmer sensors
%
%sh: cell array containing the Shimmer handle classes

for i = 1:length(COMPORT)
    sh{i} = ShimmerHandleClass(COMPORT{i});
end

cellfun(@(x) x.connect,sh,'uniformoutput',false);
cellfun(@(x) x.setsamplingrate(fsamp_sh),sh,'uniformoutput',false);
cellfun(@(x) x.enabletimestampunix(1),sh,'uniformoutput',false);

SensorMacros = SetEnabledSensorsMacrosClass;

sh{end}.setinternalboard('EMG');

for i = 1:length(sh)
    
    if i == length(sh)
        sh{i}.setenabledsensors('LowNoiseAccel',1,'Gyro',1,'Mag',0,'WideRangeAccel',0,'EMG',1);
    else
        sh{i}.setenabledsensors('LowNoiseAccel',1,'Gyro',1,'WideRangeAccel',0,'Mag',0);
    end
end


s = daq.createSession('ni');
s.Rate = fsamp_ni;
s.addAnalogInputChannel(devicename,ni_channels,'Voltage');
NChan = length(ni_channels);

for i = 1:NChan
    s.Channels(i).Range = range_ni;
    s.Channels(i).TerminalConfig = 'SingleEnded';
end

s.IsContinuous = 1;
s.IsNotifyWhenDataAvailableExceedsAuto = 1;



