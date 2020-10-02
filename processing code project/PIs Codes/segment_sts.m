function [subphases,points] = segment_sts(chair_data, kinematics, fs)

% PI2: STS subphases duration - this PI consists of a 3 elements array of scalars 
% indicating the average duration of each STS subphase. Each subphase duration 
% is the average across the 5 sit-to-stand cycles characterizing the protocol. 
% 
% The 3 phases are defined according to Caruthers et al. 2016, and based on the 4 time points:
% 
% -	1: t0: in each STS cycle, the start corresponds to the first trunk bending after the 0 velocity has been reached
% -	2: lift-off (lo): when the COP vertical force of the seat force plate goes to 0
% -	3: maximum ankle dorsiflexion (mad): corresponds to the point at which the shank bends over the foot, generating a maximum ankle dorsiflexion. 
% -	4: full hip extension (fhe): detected when the hip is fully extended, the sit-to-stand cycle ends. A subsequent beginning of the hip flexion identifies the beginning of the stand-to-sit cycle
% These 4 points in each cycle lead to the following 3 subphases:
% 
% -	Phase 1: Forward leaning
% -	Phase 2: Momentum transfer
% -	Phase 3: Extension
% Data from both the Chair and lower limb kinematics are needed for calculating this PI. 
%
%INPUT:
%
%
%OUTPUT:
%
%


[m,zvel_stand] = findpeaks(kinematics(:,3),'minpeakheight',40,'minpeakdistance',0.5*fs);

%the zero velocity points in standing position correpsond to the maximum hip extension points

init_seat = find(kinematics(:,4)>5,1); %this is the initial trunk bending

kk = -sum(abs(kinematics'));
[m,zvel_seat] = findpeaks(kk','minpeakheight',-20,'minpeakdistance',0.5*fs);

zvel_seat(zvel_seat<init_seat) = [];
zvel_seat = [init_seat;zvel_seat];

%the zero velocity points in seated position correspond to those points in
%which the sum of the absolute joint angles is mimimum

%the zvel_seat points are used to start the segmentation (excluding the last one)

fz = chair_data(:,3)-min(chair_data(:,3));

for i = 1:length(zvel_seat)-1
    t0(i) = find(kinematics(zvel_seat(i):end,4)>5,1)+zvel_seat(i);
    lo(i) = find(fz(zvel_seat(i):end)<0.2,1)+zvel_seat(i);
    mad(i) = find(kinematics(zvel_seat(i):round(zvel_seat(i)+0.7*fs),1) == max(kinematics(zvel_seat(i):round(zvel_seat(i)+0.7*fs),1)))+zvel_seat(i);
    fhe(i) = zvel_stand(i);
end

t0(1) = zvel_seat(1);

points = [t0;lo;mad;fhe];

subphases(1) = mean(lo-t0)/fs;
subphases(2) = mean(mad-lo)/fs;
subphases(3) = mean(fhe-mad)/fs;
