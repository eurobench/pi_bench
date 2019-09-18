%% Main script: Client 
% Client
clear
close all

% set up TCP IP connection for Client
t = tcpip('localhost', 30000, 'NetworkRole', 'client');

% get information about size of data that will be sent
% uint16 data 
% collect and send data
    % 'collect' = load special data file that was created before
    load data.mat
    % set outpt Buffer Size according to Data Size
    size_data = size(data,1)*size(data,2)*2; %2 Bytes per sample 
    % try to open the tcpip object
    fopen(t);
%     % when tcpip is open save data temporarily
%     % while loop 
%         % try to send data --> break at the end
%         % save data in matfile
%         % increase amount of packs 
        
    % --> first only fwrite
    disp('Trying to send data')
    fwrite(t, size_data, 'uint16');
    
    disp('Data sent successfully')
    % tell whether data sending was succesfull or not 