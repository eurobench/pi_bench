function kinematics_CV = kinematic_repeatability(chair_data, imu_data)
% 
% kinematics_CV = kinematic_repeatability(chair_data, imu_data)
% 
% PI6: kinematic repeatability – this PI is a four elements array of scalars 
% indicating the coefficient of variation of the ankle, knee, hip and trunk 
% kinematics, respectively. CV are calculated point-by-point starting from a 
% fixed number of points resampling of the kinematics data in each sts cycle. 
% The output is the average of the CV across time points for each joint.
%
%INPUT:
%
%
%OUTPUT:
%
%