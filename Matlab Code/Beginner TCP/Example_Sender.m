%% Sender = client
clear 
close all

t = tcpip('localhost', 30000, 'NetworkRole', 'client');
fopen(t);

%while loop to generate continous streaming 
for i = 0:3

    %create data to send 
    data = zeros(40,2);
    for a = 1:40
        data(a,:) = [a, randi(50)];
    end

    %plot data for later comparing it to received data
    figure;
    plot(data(:,1), data(:,2), 'r-');
    title('Sent data')


    %reshaping of data to get it as Nx1 matrix
    data_reshape = vertcat(data(:,1), data(:,2));

    fwrite(t, data_reshape, 'uint8')
    %be careful with Output Buffersize --> 512 default

end