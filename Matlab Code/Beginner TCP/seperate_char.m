function [index] = seperate_char(arrivedData)
%SEPERATE_TIMES Summary of this function goes here
%   Detailed explanation goes here
k = 1;
for a = 1:length(arrivedData)
    if strcmp(arrivedData(a), '!')
        index(k) = a;
        k = k+ 1;
    elseif k ==4
        break
    end      
end

end

