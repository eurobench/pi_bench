%% Main script: Client 
% Client
clear
close all

%data = randi(100,1, 100, 'uint16');
% set up TCP IP connection for Client
    t= tcpip('localhost',30000,'NetworkRole','client');

% get information about size of data that will be sent
% uint16 data 
% collect and send data
    % 'collect' = load special data file that was created before
    %load data.mat
    %data = data';
    % set outpt Buffer Size according to size of packs
    %size_data = size(data,1)*size(data,2)*2; %2 Bytes per sample 
    data = randi(100,100,1,'uint16');
    size_data = 200;
    t.OutputBufferSize = size_data;
           
    % try to open the tcpip object
    fopen(t);
    
%     % when tcpip is open save data temporarily  
%     % while loop 
%         % try to send data --> break at the end
%         % save data in matfile
%         % increase amount of packs 
        
    % --> first only fwrite
    disp('Trying to send data')
    
    NumPackSent = 0;
    data_left = 0; 
    while (data_left < 50)
        data_add = randi(100,100,1, 'uint16');
        data = horzcat(data,data_add);
        data_part = data(1+NumPackSent*100:100+NumPackSent*100);
        fwrite(t, data_part, 'uint16');
        pause(0.5)
        NumPackSent = NumPackSent + 1;
        %only for beginning
        data_left = data_left + 1;
    end
    
    % tell whether data sending was succesfull
    disp('Data sent successfully')
    disp(['Number of sent packs:', num2str(NumPackSent)])
   