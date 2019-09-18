%% Sender of TCP communication

clc
clear
close all

disp('Initiation of TCP/IP communication...')
%

%set up configuration and connection
t = tcpip('0.0.0.0', 3001, 'NetworkRole', 'server'); %remote IP address inserted here



%Establishing connection
disp('Waiting for connection')
fopen(t);
disp('Connected')

DataReceived=fread(t, t.BytesAvailable);

%fprintf 

plot(DataReceived, 'r-')



