%% Main script: Client 
% Client: sending data
clear
close all

% set up TCP IP connection for Client
t= tcpip('localhost',30000,'NetworkRole','client');
% set up TCP IP connection for receiving response of client
s = tcpip('0.0.0.0', 30001, 'NetworkRole', 'server');

% initialize ROS node to retrieve time ROS-compatible
rosinit;

% get information about size of data that will be sent
% uint16 data 
% collect and send data struct made from timestamp, values and additional information

    data = struct('time_produced',[],'values',[],'information',[]);
    size_data = 784; % in bytes %empty struct + timestamp + values + info
    t.OutputBufferSize = size_data;
           
    % try to open the tcpip object
    %fopen(t);
    
%     % when tcpip is open save data temporarily  
%     % while loop 
%         % try to send data --> break at the end
%         % save data in matfile
%         % increase amount of packs 
        
    % --> first only fwrite
    disp('Trying to send data...')
    
    NumPackSent = 0;
    error = 0;
    
    while (strcmp(t.Status, 'closed') && strcmp(s.Status, 'closed'))
        try 
            fopen(t);
            disp('TCP IP connenction established')
        catch
            disp('No server listening.')
            pause(0.5)
        end
    end 
    
    while (strcmp(t.Status, 'open')) %&& strcmp(s.Status, 'closed'))
        try
            data.time_produced = rostime('now');
            timeSec = double(data.time_produced.Sec);
            timeNsec = double(data.time_produced.Nsec);
            data.values = randi(100,32,1, 'double');
            data.information = 'no info no info no info no info no info no info no info no info ';
            data_store(NumPackSent+1)= data;
            data_to_send = vertcat( timeSec , timeNsec, data.values, double(data.information)');
            fwrite(t, data_to_send, 'double');
            pause(0.5)
            NumPackSent = NumPackSent + 1;
            %only for beginning
            %data_left = data_left + 1;
        catch
            disp('Server not listening anymore')
            break
        end
        if s.BytesAvailable > 0
            break
        end
        
%         try 
%             fopen(s); %server kann immer aufmachen --> Client aber nicht
%             pause(1)
%             NumPackReceived = fread(s, s.BytesAvailable, 'double');
%             pause(1)
%             break
%         catch
%             error = 1 + error;
%         end
    end

if s.BytesAvailable > 0
    NumPackReceived = fread(s, s.BytesAvailable, 'double');   
    fclose(t);
    pause(1)
    fclose(s);
end
   
% if strcmp(s.Status, 'open')
%     fclose(t);
%     disp('Receiving response from server')
%     NumPackReceived = fread(s, s.BytesAvailable, 'double');
%     pause(1)
%     fclose(s);
% end
    
% tell whether data sending was successfull
disp('Data sent successfully')
disp(['Number of sent packs:', num2str(NumPackSent)])
disp(['Number of received packs:', num2str(NumPackReceived)])
 
rosshutdown