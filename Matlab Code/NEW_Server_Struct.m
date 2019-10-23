%% Main script: Server
% Server: sending data
clear
close all

% set up TCP IP connection for Client
% enter IP adress of the computer that will send 
%t= tcpip('localhost',30000,'NetworkRole','client');
t= tcpip('129.69.180.171',30000,'NetworkRole','client');

% % initialize ROS node to retrieve time ROS-compatible
% rosinit;

% collect and send data struct made from timestamp, values and additional information
    data = struct('time_pro',[],'values',[],'information',[]);
    %size_data = 784; % in bytes %timestamp + values + info
    size_data = 776; % without rostime
    t.OutputBufferSize = size_data;

    
disp('Trying to send data...')

NumPackSent = 0;
error = 0;
    
    while (strcmp(t.Status, 'closed'))
        try 
            fopen(t);
            disp('TCP IP connection established')
        catch
            disp('No client listening.')
            pause(0.5)
        end
    end 
    
    while (strcmp(t.Status, 'open')) %&& strcmp(s.Status, 'closed'))
        try
            %data.time_produced = rostime('now');
            %timeSec = double(data.time_produced.Sec);
            %timeNsec = double(data.time_produced.Nsec);
            data.time_pro = posixtime(datetime('now'));
            data.values = randi(100,32,1, 'double');
            data.information = 'no info no info no info no info no info no info no info no info ';
            data_store(NumPackSent+1)= data;
            %data_to_send = vertcat( timeSec , timeNsec, data.values, double(data.information)');
            data_to_send = vertcat( data.time_pro, data.values, double(data.information)');
            fwrite(t, data_to_send, 'double');
            %pause(0.0001)
            NumPackSent = NumPackSent + 1;
        catch
            disp('Client not listening anymore')
            break
        end
    end


% tell whether data sending was successfull
disp('Data sent successfully')
disp(['Number of sent packs:', num2str(NumPackSent)])
 
% % close ros node
% rosshutdown