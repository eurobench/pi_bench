function [Chair_data,data_sh] = synch_acq(sh,s)

%[data_ni,data_sh] = synch_acquisition(devicename,channels,COMPORT,fsamp_ni,range)
%acquire data from a specified NI device in background mode and from the shimmer devices connected into the sh shimmer handle class
%and saves data in the workspace

%Required Inputs:
%
%sh: a cell array containing the connected Shimmer Handle classes (output of connect_shimmer.m)
%
%s: Handle class of the NI-Daq
%
%Outputs:
%
%Chair_data: a matrix containing data from the two force plates. The data
%are organized as follows:
%trigger,Fx1,Fy1, Fz1, Mx1, My1, Mz1, CoPx1, CoPy1,Fx2,Fy2, Fz2, Mx2, My2,
%Mz2, CoPx2, CoPy2
%where 1 is the force plate under the seat
%
%data_sh: a cell array containing data from the shimmer sensors in each
%cell
%Cristiano De Marchis, July 2020


s.UserData.signals = [];

cellfun(@(x) x.start,sh,'uniformoutput',false);
pause(15);


s.startBackground;


cellfun(@(x) x.getdata('c'),sh,'uniformoutput',false);


disp('press a key to stop acquisition')
w = waitforbuttonpress;

close all

s.stop;


data_sh = cellfun(@(x) x.getdata('c'),sh,'uniformoutput',false);

cellfun(@(x) x.stop,sh,'uniformoutput',false);



data_ni = s.UserData.signals;
data_ni = data_ni(:,[1 2 3 8 7 9 6 10 5 4 11 16 15 17 14 18 13 12]);
data1 = data_ni(:,3:10);
data2 = data_ni(:,11:end);

[Platform1] = calculate_CoP (data1);
[Platform2] = calculate_CoP (data2);

Chair_data = [data_ni(:,2) Platform1 Platform2];





end



