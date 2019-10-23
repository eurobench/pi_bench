%% Main script: Client 
% Client: sending data
clear
close all

%data = randi(100,1, 100, 'uint16');
% set up TCP IP connection for Client
t= tcpip('localhost',30000,'NetworkRole','client');
% set up TCP IP connection for receiving response of client
s = tcpip('0.0.0.0', 30001, 'NetworkRole', 'server');
    

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
            data_add = randi(100,100,1, 'uint16');
            data = horzcat(data,data_add);
            data_part = data(1+NumPackSent*100:100+NumPackSent*100);
            fwrite(t, data_part, 'uint16');
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
   