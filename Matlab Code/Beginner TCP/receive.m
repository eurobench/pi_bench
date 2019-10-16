function [data_received] = receive(t)
%RECEIVE Summary of this function goes here
%   Detailed explanation goes here

%t = tcpip('0.0.0.0', port, 'NetworkRole', 'server');

%connect to Client
fopen(t);

%wait until input is sent
while t.BytesAvailable ==0
    pause(0.5)
end

% while streaming 
data_received = fread(t, [10,2], 'uint16');
    %data_received_reshaped = reshape_received(data_received);

    
% end 
end

