function duration_5sts = sts_duration_5sts(chair_data, kinematics,fs)

% duration_5sts = sts_duration_5sts(chair_data)
%
% PI2: 5sts duration - this function calculates the PI1: 5STS duration - it is calculated as
% the time elapsed between the first movement after the GO signal and the 
% fifth dynamic contact with the chair (thus excluding the initial static 
% contact). Data coming from the chiar and from the kinematics are used for 
% calculating this PI.
%
%INPUT:
%
%chair_data: is the matrix containing all the data from the BENCH chair
%
%kinematics: is the matrix containing the lower limb kinematics
%
%fs: is the sampling frequency in Hz
%
%
%OUTPUT:
%
%duration_5sts: is the time elapsed between the start and the end of the
%5STS protocol (in seconds)

sts_init = find(kinematics(:,4)>5,1);

%the task starts when the trunk bends 5° forward for the first time after the GO signal

dcopx = abs(diff(chair_data(:,7)));
dcopx = dcopx/max(dcopx);
 
sts_end = find(dcopx>0.25,1,'last');

%the task ends when the AP coordinate of the CoP substantially changes for
%the last time, in correpondence of the 5th time the buttocks touches the
%seat force plate

duration_5sts = (sts_end - sts_init)/fs;
