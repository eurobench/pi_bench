function [ult_os,ult_time] = unidirectional_load_transfer(chair_data,quiet_standing_data, kinematics, sts_points, fs)

% ult_time = time_needed_ult(chair_data,imu_data)
% 
% PI4: Time needed for unidirectional load transfer – this PI is an two elements array
% of scalars indicating the AP and ML unidirectional load transfer overshoot times, 
% corresponding to the time at which the distance between the quiet standing CoP position 
% and the local maxima of anteroposterior and medio-lateral CoP during sts transition are reached. 
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
%kinematics: is the matrix containing the lower limb kinematics
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



