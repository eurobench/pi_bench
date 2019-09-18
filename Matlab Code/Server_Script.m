%% script for the server
%only script that needs to be running on the server 
clear
close all

% % ask for IP of client
% prompt = 'What is the IP adress of sender? ';
% role = input(prompt, 's');

global streaming
streaming = 0;
global streaming_completed
streaming_completed = 0;
%streaming = 0;
%global allowedRows

% create tcpip object
t = tcpip('0.0.0.0', 3000, 'NetworkRole', 'server');
% t = tcpip(role, 3000, 'NetworkRole', 'server'); 

% open ui figure for streaming 
uf = figure;
uf.Name = 'Streaming of gathered data';
uf.Position = [500 300 400 175];

% start streaming button
uicontrol('Style', 'pushbutton', 'Position', [50 75 125 50], 'String', 'Start Streaming', 'Callback', @StartButton);
% stop straming button
uicontrol('Style', 'pushbutton', 'Position', [225 75 125 50], 'String', 'Stop Streaming', 'Callback', @StopButton);

pack = 1;

% while t.BytesAvailable == 0
%     pause(0.1)
% end



while streaming
    data_received =receive(t);
    
   % data_saved(1+(pack-1)*allowedRows:allowedRows+(pack-1)*allowedRows,:) = data_received;
% else 
%     fclose(t);
end

while (not(streaming) && streaming_completed) 
    fclose(t);
end


