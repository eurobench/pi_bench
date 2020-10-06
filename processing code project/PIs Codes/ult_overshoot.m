function ult_os = ult_overshoot(chair_data, imu_data)

% ult_os = ult_overshoot(chair_data, imu_data)
%
% PI5: Unidirectional load transfer overshoot – this PI is an two elements 
% array of scalars indicating the AP and ML unidirectional load transfer overshoot 
% as the distance between the quiet standing CoP position and the local maxima 
% of anteroposterior and medio-lateral CoP during sts transition. 
% The data is averaged across 5 STS cycles.
% Data from both the Chair and lower limb kinematics are needed for calculating this PI. 
%
%INPUT:
%
%
%OUTPUT:
%
%