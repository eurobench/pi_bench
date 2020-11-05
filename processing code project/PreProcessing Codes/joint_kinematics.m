function [j_kin, kin_labels] = joint_kinematics(imu_data, calibration_params,fsamp)


%kin = joint_kinematics(imu_data, calibration_params)
%
%imu_data is the STS data obtained from the recording session. IMU signals
%are organized in a cell array, each one containing signals from the j-th
%segment (foot, shank, thigh, pelvis, trunk). Each cell contains singnals
%from accelerometers and gyros in the following order: Ax, Ay, Az, Gx, Gy,
%Gz
%
%calibration_params is the a cell array containing, in each cell, the
%calibration vector related to the i-th joint for calulating the kinematics
%in the sagittal plane (ankle, knee, hip, trunk). Each calibration vector
%contains the coefficients of the first principal component obtained during
%the calibration sequence, leading to a linear combination the the gyro 
%signals which projects the data on a single plane (the one with the 
%highest variance during the calibration of the sagittal plane)
%
%fasmp is the imu sampling frequency in Hz
%
%kin is a Nx4 matrix containing joint kinematics data:
%1-angle plantar and dorsal flexion
%2-knee flexion/extension
%3-hip flexion/extension
%4-trunk flexion/extension
%
%Cristiano De Marchis, September 2020

kin_labels = {'Ankle_FE','Knee_FE','Hip_FE','Trunk_FE'};

for i = 1:length(imu_data)-1
    
    tmp_mat = [imu_data{i}(:,4:6) imu_data{i+1}(:,4:6)]; %takes the gyro components of two adiacent segments
    est_w = tmp_mat*calibration_params(:,i); %projects the gyro components on the calibrated sagittal plane
    j_kin(:,i) = cumtrapz(est_w-mean(est_w))/fsamp; %integrates the gyro component on the sagittal plane so as to obtain the flexion/extension angle
   
    
end

j_kin(:,1) = -j_kin(:,1);
j_kin(:,4) = -j_kin(:,4);
