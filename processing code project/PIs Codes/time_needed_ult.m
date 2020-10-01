function ult_time = time_needed_ult(chair_data,imu_data)

% ult_time = time_needed_ult(chair_data,imu_data)
% 
% PI4: Time needed for unidirectional load transfer – this PI is a scalar 
% indicating the average time elapsed between the beginning of a sit to stand
% (or stand to sit) movement and the full transfer of the weight on a single platform. 
% During sit-to-stand this time corresponds to the time needed to move 
% the CoP purely on the ground platform. 
% Data from both the Chair and lower limb kinematics are needed for calculating this PI. 
%
%INPUT:
%
%
%OUTPUT:
%
%