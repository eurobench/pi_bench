function [j_kin, kin_labels] = joint_kinematics(data, calibration_params,fsamp)


%kin = joint_kinematics(imu_data, calibration_params)
%
%data is the STS data obtained from the recording session.
%
%calibration_params is the a matrix containing, in each column, the
%calibration vector related to the i-th joint for calulating the kinematics
%in the sagittal plane (ankle, knee, hip, trunk). Each calibration vector
%contains the coefficients of the first principal component obtained during
%the calibration sequence, leading to a linear combination the the gyro 
%signals which projects the data on a single plane (the one with the 
%highest variance during the calibration of the sagittal plane)
%
%fasmp is the imu sampling frequency in Hz
%
%kin is a Nx4 matrix containing joint kinematics data (as indicated in the labels):
%1-angle plantar and dorsal flexion
%2-knee flexion/extension
%3-hip flexion/extension
%4-trunk flexion/extension


kin_labels = {'Ankle_FE','Knee_FE','Hip_FE','Trunk_FE'};

imu_data{1} = data(:,18:23);
imu_data{2} = data(:,24:29);
imu_data{3} = data(:,30:35);
imu_data{4} = data(:,36:41);
imu_data{5} = data(:,42:47);

for i = 1:length(imu_data)-1
    
    tmp_mat = [imu_data{i}(:,4:6) imu_data{i+1}(:,4:6)]; %takes the gyro components of two adiacent segments
    est_w = tmp_mat*calibration_params(:,i); %projects the gyro components on the calibrated sagittal plane
    j_kin(:,i) = cumtrapz(est_w-mean(est_w))/fsamp; %integrates the gyro component on the sagittal plane so as to obtain the flexion/extension angle
   
    
end

tmp = j_kin(:,1)./max(abs(j_kin(:,1)));
[mm,loc] = findpeaks(tmp,'minpeakheight',0.4,'minpeakdistance',round(fsamp*0.1),'doublesided');

if length(find(mm<0)) > length(find(mm>0))
j_kin(:,1) = -j_kin(:,1);
end

for i = 2:4
  if max(j_kin(:,i)) < abs(min(j_kin(:,i)))
    j_kin(:,i) = -j_kin(:,i);
  end
end

