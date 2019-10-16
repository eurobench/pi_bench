function [data_reshape] = reshape_sent(data)
%Reshapes a matrix into the required format for the tcpip connection 
%   m-n-Matrix gets shaped into a m*n-1-matrix

global col
global row 
col = size(data, 2);
row = size(data, 1);

data_reshape = zeros(col * row, 1);

for a = 1:col
    data_reshape(1+(a-1)*row:row+(a-1)*row) = data(:,a);
end
end

