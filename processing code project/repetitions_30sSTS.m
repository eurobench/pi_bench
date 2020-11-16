function ncycles = repetitions_30sSTS(kinematics, fs)

%ncycles = repetitions_30sSTS(kinematics, fs)
%
% PI1: 30sSTS duration - it is calculated as the number of full sit-to-stand 
% cycles executed in the 30s after the GO signal. Only the data coming from 
% the force plates are used for calculating this PI.
%
%INPUT:
%
%kinematics: is the matrix containing the movement kinematics calculated through
%the joint_kinematics.m function
%
%fs: is the sampling frequency in Hz
%
%
%OUTPUT:
%
%ncycles: is the number of full sit-to-stand cycles executed in the 30s after the GO signal

sts_init = find(kinematics(:,4)>5,1);
sts_end = sts_init + round(30*fs);

%the task starts when the trunk bends 5° forward for the first time after the GO signal
%the task ends after 30s

[m,zvel_stand] = findpeaks(kinematics(:,3)-min(kinematics(:,3))+0.01,'minpeakheight',40-min(kinematics(:,3))+0.01,'minpeakdistance',0.5*fs);

%the zero velocity points in standing position correpsond to the maximum
%hip extension points, and denotes the end of a sit-to-stand cycle. Each
%time this position is reached a stand is counted

standings = zvel_stand(zvel_stand<sts_end);
ncycles = length(standings);

if (min(zvel_stand>sts_end)-sts_end) < 3*(min(zvel_stand>sts_end)-standings(end))/4
    
    ncycles = ncycles+1;  %if the first stand after the sts_end is close enough to the sts_end, the last stand is counted
    
end


