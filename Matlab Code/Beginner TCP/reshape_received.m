function [data_reshaped] = reshape_received(data_received)
%RESHAPE_RECEIVED Summary of this function goes here
%   Detailed explanation goes here

global row
global col 

data_reshaped = zeros(row, col);

for a=1:col
    data_reshaped(:, a) = data_received(1+(a-1)*row:row+(a-1)*row);
end

end

