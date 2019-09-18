%% Receiver =  server
clear all
close all

t = tcpip('0.0.0.0', 30000, 'NetworkRole', 'server');

%connect to Client
fopen(t);

%wait until input is sent
while t.BytesAvailable ==0
    pause(0.5)
end

data = fread(t, t.BytesAvailable, 'uint8');

data_reshape_small = zeros(40,2,4);
for i=0:3
%reshaping of data to get it back as Mx2 matrix
data_reshape_small(:,:,i+1) = horzcat(data(1+i*80:40+i*80), data(41+i*80:80+i*80));
end

%store multiple data packets 
data_storage= horzcat( data_reshape_small(:,:,1),data_reshape_small(:,:,2), data_reshape_small(:,:,3), data_reshape_small(:,:,4));

% plot(data_reshape(:,1), data_reshape(:,2), 'b-');
% title('Received data');


%double 64 bits, float 32 bits
%default buffer input size 512
%t.BytesAvailable 64 bits