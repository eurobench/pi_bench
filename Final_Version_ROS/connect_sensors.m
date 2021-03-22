function [sh,s] = connect_sensors(COMPORT,fsamp_sh, devicename, ni_channels, fsamp_ni, range_ni)

%INPUT:
%
%COMPORT: cell array list of the COM PORTS for connecting the Shimmer sensors. The last port
%corresponds to the EMG Shimmer sensor providing the trigger signal
%
%fsamp_sh: sampling rate of the shimmer sensors
%
%sh: cell array containing the Shimmer handle classes
flag = zeros(size(COMPORT));
flag(end) = 1;

for i = 1:length(COMPORT)
    sh{i} = ShimmerHandleClass(COMPORT{i});
end

for i = 1:length(sh)
    
    connectshimmer(sh{i},fsamp_sh,flag(i));
end

idx_out = get_shimmer_to_connect(sh);

count = 1;

while ~isempty(idx_out) && count<10
    
    for i = 1:length(idx_out)
        connectshimmer(sh{idx_out(i)},fsamp_sh,flag(idx_out(i)));
    end
    idx_out = get_shimmer_to_connect(sh);
    
    count = count+1;
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

