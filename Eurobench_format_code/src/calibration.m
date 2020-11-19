function calibration_params = calibration(data, isOctave)

%calibration_params = calibration(data, isOctave)
%
%calculates the calibration vector for each joint, finding the linear
%combination for projecting the recorded data on the sagittal plane
%
%data is a matrix containing all the data recorded from
%teh BENCH device during the calibration procedure.
%
%isOctave is a boolean indicating wheter the machine is running a version of Octave
%if isOctave is false, Matlab functions will be run
%
%calibration_params contains the first principal component, which consists
%of a 6x4 vector containing the coefficients for the linear combination of
%the gyrposcope signals of two adiacent segments, to be applied to the 6xN
%matrix M = [Gx_distal;Gy_distal;Gz_distal;Gx_proximal;Gy_proximal;Gz_proximal]
%in order to obtain an estimation of the i-th joint angular velocity w in the
%sagittal plane. The estimation is obtained as w_sagittal(:,i) =
%M*calibration_params(:,i)


imu_calibration_data{1} = data(:,18:23);
imu_calibration_data{2} = data(:,24:29);
imu_calibration_data{3} = data(:,30:35);
imu_calibration_data{4} = data(:,36:41);
imu_calibration_data{5} = data(:,42:47);

for i = 1:length(imu_calibration_data)-1
    
    tmp_mat = [imu_calibration_data{i}(:,4:6) imu_calibration_data{i+1}(:,4:6)];
    if isOctave
      [coef,score,latent] = princomp(tmp_mat);
    else
      [coef,score,latent] = pca(tmp_mat);
    end
    calibration_params(:,i) = coef(:,1);
    
end