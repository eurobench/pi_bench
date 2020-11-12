filename = 'subject_01_5sts_chair_raw_01.csv';

data = csvread(filename);
data(1,:) = [];
fsamp = (length(data(:,1))-1)/data(end,1);

pkg load signal
pkg load statistics



if length(strfind(filename,'calib')) > 0
  
  calibration_params = calibration(data);
  calib_flag = 1;
  
elseif length(strfind(filename,'5sts')) > 0 && calib_flag
  
  [kinematics, kin_labels] = joint_kinematics(data, calibration_params,fsamp);
  
  duration_5sts = sts_duration_5sts(data, kinematics,fsamp);
  [subphases,points] = segment_sts(data, kinematics, fsamp, 0);
  CoP_dist = sts_CoP_stability(data, points);
  [ult_os,ult_time] = unidirectional_load_transfer(data, points, fsamp);
  kinematic_reg = kinematic_repeatability(kinematics,fsamp);
  CoM_work = tot_mech_pwr(data,kinematics);
  
  PIs = {[duration_5sts],[subphases],[CoP_dist],[ult_time],[ult_os],[kinematic_reg],[CoM_work]};
  
  scrsz = get(0,'ScreenSize');

  for i = 1:4
    figure('Position',[(scrsz(3)/4)*(i-1)+1 scrsz(4)/2+50 scrsz(3)/4-50 scrsz(4)/2-100]);
    bar(PIs{i});
  end

  for i = 1:3
    figure('Position',[(scrsz(3)/4)*(i-1)+1 50  scrsz(3)/4-50 scrsz(4)/2-100]);
    bar(PIs{i+4});
  end


  
elseif length(strfind(filename,'30sts')) > 0 && calib_flag
  
  [kinematics, kin_labels] = joint_kinematics(data, calibration_params,fsamp);
  
  ncycles = repetitions_30sSTS(kinematics, fsamp);
  [subphases,points] = segment_sts(data, kinematics, fsamp, 0);
  CoP_dist = sts_CoP_stability(data, points);
  [ult_os,ult_time] = unidirectional_load_transfer(data, points, fsamp);
  kinematic_reg = kinematic_repeatability(kinematics,fsamp);
  CoM_work = tot_mech_pwr(data,kinematics);
  
  PIs = {[ncycles],[subphases],[CoP_dist],[ult_time],[ult_os],[kinematic_reg],[CoM_work]};
  
  scrsz = get(0,'ScreenSize');

  for i = 1:4
    figure('Position',[(scrsz(3)/4)*(i-1)+1 scrsz(4)/2+50 scrsz(3)/4-50 scrsz(4)/2-100]);
    bar(PIs{i});
  end

  for i = 1:3
    figure('Position',[(scrsz(3)/4)*(i-1)+1 50  scrsz(3)/4-50 scrsz(4)/2-100]);
    bar(PIs{i+4});
  end
  
else
  
  disp('datafile or calibration data are missing');
  
end





