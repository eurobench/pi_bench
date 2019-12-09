%% Main script: Client
% Purpose:  Receiving data via TCP IP from the server in packages of datatype double.
%           One packages is made up from:
%           - time stamp: 8 Byte
%           - 32 values: 256 Byte
%           - information made from max. 64 characters: 512 Byte
% Guide:    Running the script opens a GUI which allows to start and stop
%           the stream of data packages and to exit the whole script.
%           Please stop the stream before you press exit!
%           Data will be stored in the variable Data_Stream_x, according to the stream number.
clear 
close all

global streaming 
streaming = 0;
NumPackReceived = 0;
NumStreamSession = 1;
NumRMS = 0;

% set up TCP IP connection for Data Server
t = tcpip('localhost', 30000, 'NetworkRole', 'server'); %leo: 129.69.180.174 %Ich: 129.69.180.171 %Server : 129.69.168.20 %phone: 141.58.54.180

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
uf.Position = [500 300 400 275];

% start streaming button
uicontrol('Style', 'pushbutton', 'Position', [50 175 125 50], 'String', 'Start Streaming', 'Callback', @StartButton);
% stop streaming button
uicontrol('Style', 'pushbutton', 'Position', [225 175 125 50], 'String', 'Stop Streaming', 'Callback', @StopButton);
% exit button (only for practical purposes)
uicontrol('Style', 'pushbutton', 'Position', [150 75 100 50], 'String', 'EXIT', 'Callback', @ExitButton);


while streaming == 0 
    pause(0.1)
end

while or(streaming ==1, streaming == 2)
    if streaming == 1 %while

        if not(strcmp(t.Status,'open'))
            fopen(t);
        end

        disp('Waiting for data to arrive')

        while t.BytesAvailable == 0
            pause(0.1)
        end
        % data arrives in a single column
        % Size*Precision must be equal to InputBufferSize 
        disp('Data arriving')
 
        while streaming ==1
            data = fread(t, size_data/8, 'double'); %divided by 8 as double has 8 Byte
            
            if isempty(data)
                disp('No new data received')
%             elseif isequal(data(1:4),[0 0 0 0]')
%                 rms.time_pro = data(5);
%                 rms.value = data(6);
%                 rms.time_rec = posixtime(datetime('now'));
%                 drawnow();
%                 rms_storage(NumRMS+1)= rms;
%                 NumRMS = NumRMS + 1;
            else
                datastruct.time_pro = data(1);
                datastruct.values = data(2:33);
                datastruct.information = char(data(34:end));
                datastruct.time_rec = posixtime(datetime('now'));
                drawnow();  
                data_storage(NumPackReceived+1) = datastruct;
                NumPackReceived = NumPackReceived +1;
            end 
        end
    end


    if streaming == 2
        disp('Stream is stopped!')
        if exist('rms_storage', 'var')
%            rms_name = sprintf('RMS_Stream_%d.mat', NumStreamSession);
            save(rms_name, 'rms_storage');
            session_name = sprintf('Data_Stream_%d.mat', NumStreamSession);
            save(session_name,  'data_storage');
        else
            session_name = sprintf('Data_Stream_%d.mat', NumStreamSession);
            save(session_name,  'data_storage');
        end
        
        disp('Data is saved!')
        NumStreamSession = NumStreamSession +1 ;
        NumPackReceived = 0;
        NumRMS = 0;
        while streaming == 2
            data_junk = fread(t, size_data/8, 'double');
            pause(0.00001)
        end
    end

end

if streaming == 3
    disp('Exit script!')
    %save data_storage
    disp(['Number of streaming sessions:', num2str(NumStreamSession - 1)])
    pause(0.5)
    %end data communication
    fclose(t);
    %close figure
    close all
end


% % close ros node
% rosshutdown