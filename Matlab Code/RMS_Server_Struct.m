%% Main script: Server
% Purpose:  Providing data of datatype double in packages to Client upon request via TCP IP
%           One packages is made up from:
%           - time stamp: 8 Byte
%           - 32 values: 256 Byte
%           - information made from max. 64 characters: 512 Byte  
% Guide:    Simply run the script once.
clear
close all

% set up TCP IP connection for Client
% enter IP adress of the computer that will send 
%t= tcpip('localhost',30000,'NetworkRole','client');
t= tcpip('0.0.0.0',30000,'NetworkRole','client'); %129.69.180.171
%s= tcpip('0.0.0.0',30001,'NetworkRole','client');
% % initialize ROS node to retrieve time ROS-compatible
% rosinit;

% collect and send data struct made from timestamp, values and additional information
    data = struct('time_pro',[],'values',[],'information',[]);
    %size_data = 784; % in bytes %timestamp + values + info
    size_data = 776; % without rostime
    t.OutputBufferSize = size_data;

    
disp('Trying to send data...')

NumPackSent = 0;
rms_counter = 0;
ZeroPack = zeros(91,1);
    
    while (strcmp(t.Status, 'closed'))
        try 
            fopen(t);
            disp('TCP IP connection established')
            %running = 1;
        catch
            disp('No client listening.')
            pause(0.5)
        end
    end 
    
    disp('Sending data...')
    
    while (strcmp(t.Status, 'open')) %&& strcmp(s.Status, 'closed'))
        try
            %data.time_produced = rostime('now');
            %timeSec = double(data.time_produced.Sec);
            %timeNsec = double(data.time_produced.Nsec);
            %data.time_pro = posixtime(datetime(getutc,'ConvertFrom','datenum'));
            data.time_pro = posixtime(datetime('now'));
            %data.time_pro = getutc;
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
            data_store(NumPackSent+1)= data;
            %data_to_send = vertcat( timeSec , timeNsec, data.values, double(data.information)');
            data_to_send = vertcat( data.time_pro, data.values, double(data.information)');
            fwrite(t, data_to_send, 'double');
            %pause(0.0001)
            NumPackSent = NumPackSent + 1;
            rms_counter = rms_counter + 1;
            if rms_counter == 200
                rms.label = [0 0 0 0]';
                rms.time_pro = posixtime(datetime('now'));
                rms.value = randi(100,1,'double');
                rms_to_send = vertcat( rms.label, rms.time_pro, rms.value, ZeroPack);
                fwrite(t, rms_to_send, 'double'); 
                rms_counter = 0;
            end
        catch
            disp('Client not listening anymore')
            %break
        end
    end


% tell whether data sending was successfull
disp('Data sent successfully')
disp(['Number of sent packs:', num2str(NumPackSent)])
 
% % close ros node
% rosshutdown