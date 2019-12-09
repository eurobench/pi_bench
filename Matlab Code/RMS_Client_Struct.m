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
%           Pre-Processed data e.g. RMS value will be stored in RMS_Stream_x, according to the stream number

clear 
close all

%----set up TCP IP connection

% set up TCP object
% enter IP adress of the computer data will be received from
t = tcpip('localhost', 30000, 'NetworkRole', 'server');  

% create empty data struct made from timestamp, values and additional information
datastruct = struct('time_pro',[], 'values',[],'information',[],'time_rec',[]);

% introduce variables for TCP connection
size_data = 776; % size of one package (time stamp + data values + information) 
t.InputBufferSize = size_data; % adjust Input Buffer size of TCP object

global streaming; %can be adjusted via GUI
streaming = 0;
num_pack_received = 0;
num_stream_session = 1;
num_RMS = 0;


%----set up GUI for controlling the streaming process
 
uf = figure;
uf.Name = 'Streaming of gathered data';
uf.Position = [500 300 400 275];

% start streaming button
uicontrol('Style', 'pushbutton', 'Position', [50 175 125 50], 'String', 'Start Streaming', 'Callback', @StartButton);
% stop streaming button
uicontrol('Style', 'pushbutton', 'Position', [225 175 125 50], 'String', 'Stop Streaming', 'Callback', @StopButton);
% exit button 
uicontrol('Style', 'pushbutton', 'Position', [150 75 100 50], 'String', 'EXIT', 'Callback', @ExitButton);


%----Streaming process 
% wait until streaming is started
while streaming == 0 
    pause(0.1)
end

while or(streaming ==1, streaming == 2) % while loop is needed here in order start and stop streaming multiple times
    if streaming == 1 % meaning the start button was pressed
        
        % open TCP IP object when not open yet
        if not(strcmp(t.Status,'open'))
            fopen(t);
        end

        disp('Waiting for data to arrive')
        
        % wait for data to arrive
        while t.BytesAvailable == 0
            pause(0.1)
        end
 
        disp('Data arriving')
 
        while streaming ==1 % while start button had been pressed
            data = fread(t, size_data/8, 'double'); % divided by 8 as a variable type double has 8 Bytes
            
            if isempty(data)
                disp('No new data received')
            elseif isequal(data(1:4),[0 0 0 0]') % if label is [0 0 0 0] it is a preprocessed data package like RMS value
                rms.time_pro = data(5);
                rms.value = data(6);
                rms.time_rec = posixtime(datetime('now'));
                drawnow(); 
                
                % store the preprocessed data
                rms_storage(num_RMS+1)= rms; 
                num_RMS = num_RMS + 1;
                
            else % receive raw data
                datastruct.time_pro = data(1);
                datastruct.values = data(2:33);
                datastruct.information = char(data(34:end));
                datastruct.time_rec = posixtime(datetime('now'));
                drawnow();  
                
                % store the raw data
                data_storage(num_pack_received+1) = datastruct;
                num_pack_received = num_pack_received +1;
                
            end 
        end
    end


    if streaming == 2 % streaming button was pressed
        disp('Stream is stopped!')
        if exist('rms_storage', 'var')
            % save rms values
            rms_name = sprintf('RMS_Stream_%d.mat', num_stream_session);
            save(rms_name, 'rms_storage');
            session_name = sprintf('Data_Stream_%d.mat', num_stream_session);
            save(session_name,  'data_storage');
            
            pause(0.1)
            % empty storage
            rms_storage = struct('time_pro',[], 'value',[],'time_rec',[]);
            data_storage = struct('time_pro',[], 'values',[],'information',[],'time_rec',[]);

        else
            % save data values
            session_name = sprintf('Data_Stream_%d.mat', num_stream_session);
            save(session_name,  'data_storage');
            
            pause(0.1)
            % empty storage
            data_storage = struct('time_pro',[], 'values',[],'information',[],'time_rec',[]);
        end
        
        disp('Data is saved!')
        
        % increase streaming session number for the next saving processes
        num_stream_session = num_stream_session +1 ;
        num_pack_received = 0;
        num_RMS = 0;
        
        % fake "listening" to data, so that there is no package accumulation of data we don't want to listen to
        while streaming == 2
            data_junk = fread(t, size_data/8, 'double');
            pause(0.00001)
        end
    end

end

if streaming == 3 % exit button was pressed 
    disp('Exit script!')
    disp(['Number of streaming sessions:', num2str(num_stream_session - 1)])
    pause(0.5)
    % end data communication
    fclose(t);
    % close figure
    close all
end