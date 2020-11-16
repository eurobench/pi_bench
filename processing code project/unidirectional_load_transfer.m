function [ult_os,ult_time] = unidirectional_load_transfer(data, sts_points, fs)

% [ult_os, ult_time] = time_needed_ult(data,sts_points, fs)
% 
% PI4: Time needed for unidirectional load transfer – this PI is scalar 
% indicating the unidirectional load transfer time, 
% corresponding to the time at which the average standing CoP position 
% is reached in each dynamic transition. 
% The data is averaged across STS cycles. 
%
% PI5: Unidirectional load transfer overshoot – this PI is an two elements 
% array of scalars indicating the AP and ML unidirectional load transfer overshoot 
% as the distance between the average standing CoP position and the local maxima 
% of anteroposterior and medio-lateral CoP during sts transition. 
% The data is averaged across STS cycles.
%
%
%INPUT:
%
%data: is the matrix containing all the data from the BENCH chair
%
%
%
%sts_points: is the second output of the segment_sts function, and contains
%the samples for segmenting the different sts cycles
%
%fs: is the sampling frequency in Hz
%
%
%OUTPUT:
%
%ult_os: this is an two elements array containing the unidirectional load
%transfer overshoot (average across sts_cycles) along the antero-posterior and medial-lateral
%directions, respectively
%
%ult_time: is the average time (across sts cycles) needed to reach the
%average standing CoP position

t0 = sts_points(1,:);
lo = sts_points(2,:);
mad = sts_points(3,:);
fhe = sts_points(4,:);

CoP_seat = (data(:,14:15));
CoP_ground = (data(:,16:17));
CoP_ground(:,1) = CoP_ground(:,1)+0.4; %the AP coordinate of the ground force plate has a 0.4m offset

F_seat = sqrt(sum(data(:,2:4).^2,2));
F_ground = sqrt(sum(data(:,8:10).^2,2));


CoP_avg = ((CoP_seat.*F_seat + CoP_ground.*F_ground)./(F_seat+F_ground))/2; %this is the average CoP coordinate across the 2 force plates
CoP_stand = [];

for i = 1:length(lo)
  tmp = CoP_avg(lo(i):fhe(i),:);
  CoP_stand = [CoP_stand;tmp];
end

CoP_avg(:,1) = CoP_avg(:,1)+0.4;
CoP_standing = mean(CoP_stand);
CoP_standing(1) = CoP_standing(1)+0.4;


for i = 1:length(fhe)
    
    %search for the maximum distance between ground CoP and standing CoP
    %during the extension phase (i.e. after maximum ankle dorsiflexion)
    
    os_AP(i) = max(abs(CoP_avg(mad(i):fhe(i)+round(0.2*fs),1)-CoP_standing(1)))*sign(max(CoP_avg(mad(i):fhe(i)+round(0.2*fs),1)-CoP_standing(1)));
    os_ML(i) = max(abs(CoP_avg(mad(i):fhe(i)+round(0.2*fs),2)-CoP_standing(2)))*sign(max(CoP_avg(mad(i):fhe(i)+round(0.2*fs),2)-CoP_standing(2)));
    
    %load transfer time corresponds to the time point at which the ground
    %CoP is the closest to the standing CoP
    
    tmp = sqrt((CoP_avg(mad(i):fhe(i)+round(0.2*fs),1)-CoP_standing(1)).^2 + (CoP_avg(mad(i):fhe(i)+round(0.2*fs),2)-CoP_standing(2)).^2);
    [mm,loc_min] = min(tmp);
    lt_time(i) = (loc_min+mad(i)-t0(i))/fs;
end

ult_os = mean([os_AP;os_ML],2);
ult_time = mean(lt_time);
    