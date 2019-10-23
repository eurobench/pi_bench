%% Calculate the time difference between producing and receiving the data

receivedPacks = size(data_storage, 2);

time_diff = zeros(receivedPacks,1);

for i = 1:receivedPacks
    %t1 = data_storage(i).time_pro_sec + 10^(-9)* data_storage(i).time_pro_nsec;
    %t2 = data_storage(i).time_rec_sec + 10^(-9)*data_storage(i).time_rec_nsec;
    t1 = data_storage(i).time_pro;
    t2 = data_storage(i).time_rec;
    
    time_diff(i)= t2-t1;  %in seconds
end
