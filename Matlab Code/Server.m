%% Main script: Data Server
% Server: receiving data
clear 
close all

global streaming 
streaming = 0;
NumPackReceived = 0;

% set up TCP IP connection for Data Server
t = tcpip('0.0.0.0', 30000, 'NetworkRole', 'server');
% set up TCP IP connection for sending response to client
s = tcpip('localhost', 30001, 'NetworkRole', 'client');

% get information about size of data that will be arriving
size_data = 1*100*2; %we know this only because we created the data previously
t.InputBufferSize = size_data;

% create mat file where data is stored later
data_storage = zeros(100,100);


%GUI for starting streaming 
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


if streaming == 1
    fopen(t);

    % receive data (local function)
    disp('Waiting for data to arrive')

    while t.BytesAvailable == 0
        pause(1)
    end
    % data arrives in a column
    % Size*Precision must be equal to InputBufferSize 
    % uint 16 has 2 Bytes --> divided by 2
    
    disp('Data arriving')
    % while NumPackReceived < 60
    while streaming ==1
        data = fread(t, size_data/2, 'uint16');
        pause(1)
        if not(size(data,1) == 100) %add zeros if data flow is interrupted during one package
            if isempty(data)
                disp('No new data received')
            else
                missing = 100 - size(data,1);
                fill_up = zeros(missing,1);
                data = vertcat(data, fill_up); 
                data_storage(:,NumPackReceived+1) = data;
                NumPackReceived = NumPackReceived +1;
            end
        else
            data_storage(:,NumPackReceived+1) = data;
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
    
    %swap roles to send response to client that server is not listening anymore
    disp('Sending response to Client')
    fopen(s);
    fwrite(s, NumPackReceived, 'double')
    pause(1)

    fclose(s);
end



    % needs GUI control
    % set data size for receiving data --> adjust buffer
    % While streaming = 1 
        % while loop
        %--> receive one package in DataSize that was
            % adjusted before: Data size = channel*fsample*time
        % store variable in the matlab file that was created before
        % increase amount of packs to store at the right place
        % break if try is used 
        % tell whether receiving was successful
    % pause at the end of data streaming of 0.01 seconds
% close connection if first while loop is not active, so when stop button
% is pressed 
        
    