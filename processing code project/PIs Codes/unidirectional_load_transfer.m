function [ult_os,ult_time] = unidirectional_load_transfer(chair_data,quiet_standing_data, sts_points, fs)

% ult_time = time_needed_ult(chair_data,imu_data)
% 
% PI4: Time needed for unidirectional load transfer – this PI is an two elements array
% of scalars indicating the AP and ML unidirectional load transfer times, 
% corresponding to the time at which the quiet standing CoP position 
% are reached in each dynamic transition. 
% The data is averaged across 5 STS cycles. 
% Data from both the Chair and lower limb kinematics are needed for calculating this PI.
%
% PI5: Unidirectional load transfer overshoot – this PI is an two elements 
% array of scalars indicating the AP and ML unidirectional load transfer overshoot 
% as the distance between the quiet standing CoP position and the local maxima 
% of anteroposterior and medio-lateral CoP during sts transition. 
% The data is averaged across 5 STS cycles.
% Data from both the Chair and lower limb kinematics are needed for calculating this PI. 
%
%
%INPUT:
%
%chair_data: is the matrix containing all the data from the BENCH chair
%
%quiet_standing_data: this is the CoP data recorded during the initial
%standing
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
%ult_os conditions

t0 = sts_points(1,:);
fhe = sts_points(4,:);

CoP_ground = (chair_data(:,15:16));

CoP_standing = mean(quiet_standing_data);


for i = 1:length(fhe)
    
    os_AP(i) = max(abs(CoP_ground(t0(i):fhe(i)+round(0.2*fs),1)-CoP_standing(1)))*sign(max(CoP_ground(t0(i):fhe(i)+round(0.2*fs),1)-CoP_standing(1)));
    os_ML(i) = max(abs(CoP_ground(t0(i):fhe(i)+round(0.2*fs),2)-CoP_standing(2)))*sign(max(CoP_ground(t0(i):fhe(i)+round(0.2*fs),2)-CoP_standing(2)));
    
    os_AP_t(i) = (find(CoP_ground(t0(i):fhe(i)+round(0.2*fs),1)<CoP_standing(1),1))/fs;    
    os_ML_t(i) = (find(CoP_ground(t0(i):fhe(i)+round(0.2*fs),2)<CoP_standing(2),1))/fs;    
end

ult_os = mean([os_AP;os_ML],2);
ult_time = mean([os_AP_t;os_ML_t],2);
    