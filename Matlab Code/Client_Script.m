%% script for the client
%only script that needs to be running on the client
%global streaming_completed

clear 
close all 

global streaming_wanted
streaming_wanted = 1;

% %ask for IP of the server
% prompt = 'What is the IP adress of the receiver? ';
% role = input(prompt, 's');

% create tcp object of localhost
    t = tcpip('localhost',3000 , 'NetworkRole', 'client');
    %t = tcpip( role ,3000 , 'NetworkRole', 'client');

if streaming_wanted 
    gather_and_send_data(t)
elseif not(streaming_wanted)
    fclose(t);
end

% close tcpip connection?
% if streaming_completed
%     fclose(t);
% end
