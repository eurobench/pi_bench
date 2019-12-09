%% Main script: Server
% Purpose:  Providing data of datatype double in packages to Client upon request via TCP IP
%           One packages is made up from:
%           - time stamp: 8 Byte
%           - 32 data values: 256 Byte
%           - information made from max. 64 characters: 512 Byte  
% Guide:    Simply run the script once and stop it manually when no data should be gathered anymore.

clear
close all

%----set up TCP IP connection

% set up TCP object
% enter IP adress of the computer that will receive data sets
t= tcpip('0.0.0.0',30000,'NetworkRole','client'); %129.69.180.171

% create empty data struct made from timestamp, values and additional information
data = struct('time_pro',[],'values',[],'information',[]);

% introduce variables for TCP connection
size_data = 776; % size of one package (time stamp + data values + information) 
t.OutputBufferSize = size_data; % adjust Output Buffer size of TCP object

num_pack_sent = 0; % counts the amount of packages that had been sent
rms_counter = 0; % counts the packages that had been sent since the last "RMS value" was sent
zero_pack = zeros(91,1); % matrix that is added when RMS value is sent in order to keep the package size consistent


%----establish TCP IP connection 

    
disp('Trying to send data...')

% wait until client is listening (only until first connection is established)
while (strcmp(t.Status, 'closed'))
    try 
        fopen(t);
        disp('TCP IP connection established')
    catch
        disp('No client listening.')
        pause(0.5)
    end
end 

%----sending data via TCP IP
disp('Sending data...')
    
while (strcmp(t.Status, 'open')) 
    try
        % generates artifical data for sending 
        data.time_pro = posixtime(datetime('now'));
        data.values = randi(100,32,1, 'double');
        data.information = 'no info no info no info no info no info no info no info no info ';
        
        % fill up free characters in information with blanks to ensure
        % constant size of the packages
        if length(data.information) < 64
            info = data.information;
            for a = 1:(64 -length(info))
                info = horzcat(info, ' ');
            end
            data.information = info;
        end
        % store the sent data --> helpful in development of code
        data_store(num_pack_sent+1)= data;
        
        % create a single column array to send data
        % characters are converted into doubles for sending purpose only (one package has to have the same data type)
        data_to_send = vertcat( data.time_pro, data.values, double(data.information)');
        fwrite(t, data_to_send, 'double');
        
        % increase counters
        num_pack_sent = num_pack_sent + 1;
        rms_counter = rms_counter + 1;
        
        % every 200th value e.g. a RMS value (here artifical) should be
        % send to the client 
        if rms_counter == 200
            rms.label = [0 0 0 0]'; % labeling the package as RMS
            rms.time_pro = posixtime(datetime('now')); % time stamp when produced 
            rms.value = randi(100,1,'double');
            
            % create a single column array
            rms_to_send = vertcat( rms.label, rms.time_pro, rms.value, zero_pack);
            fwrite(t, rms_to_send, 'double'); 
            
            % reset counter 
            rms_counter = 0; 
        end
    catch
        disp('Client not listening anymore')
    end
end


% show amount of packages that were send --> only when somehow
% automatically stopped
disp('Data sent successfully')
disp(['Number of sent packs:', num2str(num_pack_sent)])
 