filename = uigetfile('.csv');

data = csvread(filename);
data(1,:) = [];
fsamp = (length(data(:,1))-1)/data(end,1);

pkg load signal
pkg load statistics



if length(strfind(filename,'calib')) > 0
  
  calibration_params = calibration(data);
  disp('calibration parameters have been calculated, launch the main script and load a trial file');

  
elseif length(strfind(filename,'5sts')) > 0 && exist('calibration_params')
  
  [kinematics, kin_labels] = joint_kinematics(data, calibration_params,fsamp);
  
  duration_5sts = sts_duration_5sts(data, kinematics,fsamp);
  [subphases,points] = segment_sts(data, kinematics, fsamp, 0);
  CoP_dist = sts_CoP_stability(data, points);
  [ult_os,ult_time] = unidirectional_load_transfer(data, points, fsamp);
  kinematic_reg = kinematic_repeatability(kinematics,fsamp);
  CoM_work = abs(tot_mech_pwr(data,kinematics));
  
  PI = {[duration_5sts],[subphases],[CoP_dist],[ult_time],[ult_os],[kinematic_reg],[CoM_work]};
  
  scrsz = get(0,'ScreenSize');
  

  for i = 1:4
    figure('Position',[(scrsz(3)/4)*(i-1)+1 scrsz(4)/2+50 scrsz(3)/4-50 scrsz(4)/2-100]);
  end

  for i = 1:3
    figure('Position',[(scrsz(3)/4)*(i-1)+1 50  scrsz(3)/4-50 scrsz(4)/2-100]);
  end

  %PI1 - 5 seconds sit-to-stand
  
  figure(1);
  bar(PI{1},'k','barwidth',0.3);set(gca,'FontSize',16);
  axis([0 2 0 20]);
  dim = [.2 .5 5 5];
  title('PI_1','FontSize',16);
  ylabel('5 times Sit-to-stand duration (s)','FontSize',16)
  str = strcat(num2str(PI{1}),' s');
  text(0.1,2,str,'FontSize',16);
  grid('on');
  xticklabels([]);

  %PI2 - STS subphases 
  
  figure(2);
  subplot(2,1,1);bar(PI{2},'k','barwidth',0.3);set(gca,'FontSize',16);
  axis([0 4 0 1]);
  title('PI_2','FontSize',16);
  ylabel('STS subphases duration (s)','FontSize',16)
  grid('on');
  xticklabels({'Phase1','Phase2', 'Phase3'});
  subplot(2,1,2):pie(PI{2}*10,{'Ph1-Forward Leaning','Ph2-Momentum Transfer','Ph3-Extension'});set(gca,'FontSize',16);

  
  %PI3 - STS CoP Stability
  
  figure(3);
  bar(PI{3},'k','barwidth',0.3);set(gca,'FontSize',16);hold on;
  axis([0 3 0 max(PI{3})+0.05]);
  title('PI_3','FontSize',16);
  ylabel('Distance travelled by the CoP (m)','FontSize',16)
  grid('on');
  xticklabels({'AP','ML'});
  
  %PI4 - Time  needed for ult_os
  
  figure(4);
  bar(PI{4},'k','barwidth',0.3);set(gca,'FontSize',16);hold on;
  axis([0 2 0 max(PI{4}+0.2)]);
  title('PI_4','FontSize',16);
  ylabel('Time needed for ULT (s)','FontSize',16)
  str = strcat(num2str(PI{4}),' s');
  text(0.1,0.05,str,'FontSize',16);
  grid('on');
  xticklabels([]);
  
  %PI5 - Load Trabsfer Overshoot
  
  figure(5);
  bar(PI{5},'k','barwidth',0.3);set(gca,'FontSize',16);hold on;
  axis([0 3 0 max(PI{5}+0.05)]);
  title('PI_5','FontSize',16);
  ylabel('Load Transfer Overshoot (m)','FontSize',16)
  grid('on');
  xticklabels({'AP','ML'});
  
  %PI6 - Kinematic repeatability
  
  figure(6);
  barh(PI{6},'k','barwidth',0.3);set(gca,'FontSize',16);hold on;
  axis([0 1 0 5]);
  title('PI_6','FontSize',16);
  xlabel('Kinematic repeatability','FontSize',16)
  grid('on');
  yticklabels({'Ankle','Knee', 'Hip', 'Trunk'});
  
  %PI7 - Work done by the CoM
  
  figure(7);
  bar(PI{7},'k','barwidth',0.3);set(gca,'FontSize',16);hold on;
  axis([0 3 0 max(PI{7}+2)]);
  title('PI_7','FontSize',16);
  ylabel('CoM Work (J)','FontSize',16)
  grid('on');
  xticklabels({'VT','AP'});
  
  
elseif length(strfind(filename,'30sts')) > 0 && exist('calibration_params')
  
  [kinematics, kin_labels] = joint_kinematics(data, calibration_params,fsamp);
  
  ncycles = repetitions_30sSTS(kinematics, fsamp);
  [subphases,points] = segment_sts(data, kinematics, fsamp, 0);
  CoP_dist = sts_CoP_stability(data, points);
  [ult_os,ult_time] = unidirectional_load_transfer(data, points, fsamp);
  kinematic_reg = kinematic_repeatability(kinematics,fsamp);
  CoM_work = abs(tot_mech_pwr(data,kinematics));
  
  PI = {[ncycles],[subphases],[CoP_dist],[ult_time],[ult_os],[kinematic_reg],[CoM_work]};
  
  scrsz = get(0,'ScreenSize');

  for i = 1:4
    figure('Position',[(scrsz(3)/4)*(i-1)+1 scrsz(4)/2+50 scrsz(3)/4-50 scrsz(4)/2-100]);
  end

  for i = 1:3
    figure('Position',[(scrsz(3)/4)*(i-1)+1 50  scrsz(3)/4-50 scrsz(4)/2-100]);
  end

  %PI1 - sit-to-stand repetitions in 30s
  
  figure(1);
  bar(PI{1},'k','barwidth',0.3);set(gca,'FontSize',16);hold on;
  axis([0 2 0 20]);
  dim = [.2 .5 5 5];
  title('PI_1','FontSize',16);
  ylabel('Number of STS cycles','FontSize',16)
  str = strcat(num2str(PI{1}),' cycles');
  text(0.1,2,str,'FontSize',16);
  grid('on');
  xticklabels([]);

  %PI2 - STS subphases 
  
  figure(2);
  subplot(2,1,1);bar(PI{2},'k','barwidth',0.3);set(gca,'FontSize',16);hold on;
  axis([0 4 0 1]);
  title('PI_2','FontSize',16);
  ylabel('STS subphases duration(s)','FontSize',16)
  grid('on');
  xticklabels({'Phase1','Phase2', 'Phase3'});
  subplot(2,1,2):pie(PI{2}*10,{'Ph1-Forward Leaning','Ph2-Momentum Transfer','Ph3-Extension'});set(gca,'FontSize',16);
 
  
  
  %PI3 - STS CoP Stability
  
  figure(3);
  bar(PI{3},'k','barwidth',0.3);set(gca,'FontSize',16);hold on;
  axis([0 3 0 max(PI{3})+0.05]);
  title('PI_3','FontSize',16);
  ylabel('Distance travelled by the CoP (m)','FontSize',16)
  grid('on');
  xticklabels({'AP','ML'});
  
  %PI4 - Time  needed for ult_os
  
  figure(4);
  bar(PI{4},'k','barwidth',0.3);set(gca,'FontSize',16);hold on;
  axis([0 2 0 max(PI{4}+0.2)]);
  title('PI_4','FontSize',16);
  ylabel('Time needed for ULT (s)','FontSize',16)
  str = strcat(num2str(PI{4}),' s');
  text(0.1,0.05,str,'FontSize',16);
  grid('on');
  xticklabels([]);
  
  %PI5 - Load Trabsfer Overshoot
  
  figure(5);
  bar(PI{5},'k','barwidth',0.3);set(gca,'FontSize',16);hold on;
  axis([0 3 0 max(PI{5}+0.05)]);
  title('PI_5','FontSize',16);
  ylabel('Load Transfer Overshoot (m)','FontSize',16)
  grid('on');
  xticklabels({'AP','ML'});
  
  %PI6 - Kinematic repeatability
  
  figure(6);
  barh(PI{6},'k','barwidth',0.3);set(gca,'FontSize',16);hold on;
  axis([0 1 0 5]);
  title('PI_6','FontSize',16);
  xlabel('Kinematic repeatability','FontSize',16)
  grid('on');
  yticklabels({'Ankle','Knee', 'Hip', 'Trunk'});
  
  %PI7 - Work done by the CoM
  
  figure(7);
  bar(PI{7},'k','barwidth',0.3);set(gca,'FontSize',16);hold on;
  axis([0 3 0 max(PI{7}+2)]);
  title('PI_7','FontSize',16);
  ylabel('CoM Work (J)','FontSize',16)
  grid('on');
  xticklabels({'VT','AP'});
  
else
  
  disp('calibration data are missing');
  
end





