%% Main script: Server
% Server
clear 
close all

% set up TCP IP connection for Server
t = tcpip('0.0.0.0', 30000, 'NetworkRole', 'server');

% get information about size of data that will be arriving
size_data = 1*1000*2; %we know this only because we created the data previously
t.InputBufferSize = size_data;

fopen(t);

% receive data (local function)
disp('Waiting for data to arrive')

while t.BytesAvailable ==0
    pause(1)
end
% data arrives in a column
% Size*Precision must be equal to InputBufferSize 
% uint 16 has 2 Bytes --> divided by 2
data = fread(t, size_data/2, 'uint16');

disp('Data arrived')
plot(data)
title('Received')

%end communication
fclose(t);
    % needs GUI control
    % create mat file where data is stored later
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
        
    % new data always needs to be added columnwise because of fread