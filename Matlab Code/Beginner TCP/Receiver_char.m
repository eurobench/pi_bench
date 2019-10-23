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

data = fread(t, t.BytesAvailable, 'char');


fclose(t);