%% Main script: Client
% Client: receiving data
clear 
close all

global streaming 
streaming = 0;
NumPackReceived = 0;

% set up TCP IP connection for Data Server
t = tcpip('0.0.0.0', 30000, 'NetworkRole', 'server');
%t = tcpip('129.69.168.20', 30000, 'NetworkRole', 'server');

% % initialize ROS node to retrieve time ROS-compatible
% rosinit;

% get information about size of data that will be arriving
% size_data = 784; %timestamp + values + info (double has 8 bytes)
size_data = 776; %without rostime
t.InputBufferSize = size_data;

% create data struct 
%datastruct = struct('time_pro_sec',[],'time_pro_nsec',[], 'values',[],'information',[],'time_rec_sec',[],'time_rec_nsec',[]);
datastruct = struct('time_pro',[], 'values',[],'information',[],'time_rec',[]);

% GUI for starting streaming 
uf = figure;
uf.Name = 'Streaming of gathered data';
uf.Position = [500 300 400 175];

% start streaming button
uicontrol('Style', 'pushbutton', 'Position', [50 75 125 50], 'String', 'Start Streaming', 'Callback', @StartButton);
% stop straming button
uicontrol('Style', 'pushbutton', 'Position', [225 75 125 50], 'String', 'Stop Streaming', 'Callback', @StopButton);

while streaming == 0 
    pause(0.1)
end

if streaming == 1 %while
    %data_storage = stream_data(t,size_data);
    
    fopen(t);

    % receive data (local function)
    disp('Waiting for data to arrive')

    while t.BytesAvailable == 0
        pause(0.1)
    end
    % data arrives in a single column
    % Size*Precision must be equal to InputBufferSize 
    
disp('Data arriving')
% possibly insert an error count 
    while streaming ==1
        data = fread(t, size_data/8, 'double'); %divided by 8 as double has 8 Byte
        %time_rec = rostime('now');
 
        %seperate data into struct
%         datastruct.time_pro_sec = data(1);
%         datastruct.time_pro_nsec = data(2);
%         datastruct.values = data(3:34);
%         datastruct.information = char(data(35:end));
%         datastruct.time_rec_sec = time_rec.Sec;
%         datastruct.time_rec_nsec = time_rec.Nsec;
        
% without ros time, with posixtime
        datastruct.time_pro = data(1);
        datastruct.values = data(2:33);
        datastruct.information = char(data(34:end));
        datastruct.time_rec = posixtime(datetime('now'));

        pause(0.0001)
        
        if isempty(data)
            disp('No new data received')
        else
            data_storage(NumPackReceived+1) = datastruct;
            NumPackReceived = NumPackReceived +1;
        end
    end
end
if streaming == 2
    disp('Data arrived')
    save data_storage
    pause(0.5)
    %end data communication
    fclose(t);
end

% % close ros node
% rosshutdown