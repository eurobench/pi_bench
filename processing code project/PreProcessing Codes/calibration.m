function [calibration_params, calibration_quality] = calibration(imu_calibration_data)

%[calibration_params, calibration_quality] = calibration(imu_calibration_data)
%
%calculates the calibration vector for each joint, finding the linear
%combination for projecting the recorded data on the sagittal plane
%
%imu_calibration_data is a cell array containing the data recorded from
%each IMU sensor during the calibration procedure. Cells from 1 to 5
%correspond to foot, shank, thigh, pelvis and trunk. Each cell contains Ax,
%Ay, AZ, Gx, Gy Gz.
%
%calibration_params contains the first principal component, which consists
%of a 6x1 vector containing the coefficients for the linear combination of
%the gyrposcope signals of two adiacent segments, to be applied to the 6xN
%matrix M = [Gx_distal;Gy_distal;Gz_distal;Gx_proximal;Gy_proximal;Gz_proximal]
%in order to obtain an estimation of the i-th joint angular velocity w in the
%sagittal plane. The estimation is obtained as w_sagittal(i) =
%M*calibration_params(i)
%
%calibration_quality is a vector containing the "sagittality" of the
%calibration movement for each joint, thus providing a direct information on how much was
%the calibration procedure carried out in a proper way. Values >0.8 can be
%taken as acceptable, inhdicating that the variance explained by the first
%principal components (sagittal plane) contains more than 90% of the gyro 
%signals variability

for i = 1:length(imu_calibration_data)-1
    
    tmp_mat = [imu_calibration_data{i}(:,4:6) imu_calibration_data{i+1}(:,4:6)];
    [coef,score,latent] = pca(tmp_mat);
    q = cumsum(latent)/sum(latent);
    calibration_quality(i) = q(1);
    calibration_params(:,i) = coef(:,1);
    
end