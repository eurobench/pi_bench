function gather_and_send_data(t)
% gather data and send if possible --> example data in beginning

% define variables and data
%global streaming_completed
global streaming_wanted
% global allowedRows
%pack = 1;
data = randi(10, 2, 'uint16'); % ni USB 6218 --> 16 bit

% %while not streaming also save data 
% while not(streaming_wanted)
%     pause(0.5)  
% end

% %calculate correct size to match the buffer size
% dataSize = size(data);
% %sizeInBytes = dataSize(1,1)*dataSize(1,2); %new data is added in a new row
% 
% allowedRows = floor(206/dataSize(1,2)); %206 numbers à 2 bytes because of the default buffer size
% 
% % define size of the package that will be send 
% data_to_send = zeros(allowedRows, dataSize(1,2));
% allowedRows = 10;
data_to_send = data;

while strcmpi(get(t,'status'), 'open')
%     for a = 1:allowedRows
%         data_to_send(a, :) = data(1+(pack-1)*allowedRows,:);
%     end
    
    %send data
    try
        send(t, data_to_send)    
        streaming_wanted = 0;
    catch
        disp('Sending not possible')
    end
    
    
    % %increase package number
    % pack= pack + 1;
    
end 
