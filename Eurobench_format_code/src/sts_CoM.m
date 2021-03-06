function [pos, vel_corrected, evt] = sts_CoM(pelvis_IMU,kinematics)

[m,zvel_stand] = findpeaks(kinematics(:,3)-min(kinematics(:,3))+0.01,'minpeakheight',40-min(kinematics(:,3))+0.01,'minpeakdistance',0.5*128);

kk = -sum(kinematics');

init_seat = min(find(kinematics(:,4)>5));

[m,zvel_seat] = findpeaks(kk'-min(kk)+0.01,'minpeakheight',-20-min(kk)+0.01,'minpeakdistance',0.5*128);

zvel_seat(zvel_seat<init_seat) = [];

zvel_seat = [init_seat;zvel_seat];

aa = pelvis_IMU(:,1:3);
gg = pelvis_IMU(:,4:6);

acc_init = mean(aa(51:150,:));

for i = 1:3
    
    gg(:,i) = gg(:,i)-mean(gg(:,i));
end

% 
% ang2_init = atan2(mean(aa(1:50,1)),sqrt(mean(aa(1:50,2)).^2+mean(aa(1:50,3)).^2));
% ang3_init = atan2(mean(aa(1:50,2)),mean(aa(1:50,3)));

% ang3_init = pi-acos(mean(aa(1:50,1))/sqrt(mean(aa(1:50,1)).^2+mean(aa(1:50,3)).^2));
% ang2_init = pi/2-asin(sqrt(1-mean(aa(1:50,2)).^2));



ang = (pi*cumtrapz(gg)/128)/180;
% ang(:,2) = ang(:,2) + ang2_init;
% ang(:,3) = ang(:,3) + ang3_init;
% ang(:,1) = ang(:,1);
% ang(:,1) = pi/2 - ang(:,1);




for i = 1:length(ang)
    
    alpha = ang(i,1);
    beta = ang(i,2);
    gamma = ang(i,3);
    
    mat_rot(:,:,i) = [cos(alpha)*cos(beta) cos(alpha)*sin(beta)*sin(gamma)-sin(alpha)*cos(gamma) cos(alpha)*sin(beta)*cos(gamma)+sin(alpha)*sin(gamma);...
        sin(alpha)*cos(beta) sin(alpha)*sin(beta)*sin(gamma)+cos(alpha)*cos(gamma) sin(alpha)*sin(beta)*cos(gamma)-cos(alpha)*sin(gamma);...
        -sin(beta) cos(beta)*sin(gamma) cos(beta)*cos(gamma)];
    
    rotated_data(:,i) = mat_rot(:,:,i)*aa(i,:)';
    
end

rotated_data = rotated_data';

[a,b] = butter(4, [0.2]/64, 'high');


acc_filt = filtfilt(a,b,rotated_data);
vel = cumtrapz(acc_filt)/128;


vel_corrected = [];
pos_corrected = [];
vel_tmp_correc = [];

evt = sort([zvel_seat;zvel_stand],'ascend');

for i = 1:length(evt)-1
    
    vel_tmp = vel(evt(i)+1:evt(i+1),:);
    ramp1 = linspace(vel_tmp(1,1),vel_tmp(end,1),length(vel_tmp));
    ramp2 = linspace(vel_tmp(1,2),vel_tmp(end,2),length(vel_tmp));
    ramp3 = linspace(vel_tmp(1,3),vel_tmp(end,3),length(vel_tmp));
    
    vel_tmp(:,1) = vel_tmp(:,1) - ramp1';
    vel_tmp(:,2) = vel_tmp(:,2) - ramp2';
    vel_tmp(:,3) = vel_tmp(:,3) - ramp3';
    
    vel_corrected = [vel_corrected;vel_tmp];
    vel_tmp_correc = [vel_tmp_correc;vel_tmp];
    
    
    
    
end


vel_corrected(:,3) = -vel_corrected(:,3);
% vel_corrected(:,1) = -vel_corrected(:,1);
vel_corr = filtfilt(a,b,vel_corrected);


pos = cumtrapz(vel_corr)/128;




