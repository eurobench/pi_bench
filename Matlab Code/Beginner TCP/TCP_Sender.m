%% Sender of TCP communication

clc
clear
close all

%set up configuration and connection
t = tcpip('localhost', 3001, 'NetworkRole', 'client'); %remote IP address inserted here

%generate data that should be sended
random_nr = rand(100,1);

%open socket
fopen(t);
pause(0.5);

%send data
fwrite(t, random_nr);

plot(random_nr)

%close connection
fclose(t);
%delete(t);

