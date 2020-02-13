function [s,ns] = getROStime
%GETROSTIME 
%   get the actual rostime in seconds s and nanoseconds ns
 t = rostime('now');
 s = t.Sec;
 ns = t.Nsec;
end

