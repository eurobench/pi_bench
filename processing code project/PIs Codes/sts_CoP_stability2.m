function [AP_MoS, ML_MoS] = sts_CoP_stability2(chair_data, imu_data)

% [AP_MoS, ML_MoS] = sts_CoP_stability2(chair_data, imu_data)
%
%
% PI3_alternative -  STS CoP stability – this PI consists of a 2 elements array
% of scalars indicating the dynamic margin of stability during the execution of STS. 
% MoS is calculated as the distance between the extrapolated center of mass xCoM 
% and the center of pressure CoP both in the AP and ML directions.
% The data is averaged across 5 STS cycles.
%
%INPUT:
%
%
%OUTPUT:
%
%