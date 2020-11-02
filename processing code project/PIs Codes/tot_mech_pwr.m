function CoM_work = tot_mech_pwr(chair_data,imu_data,kinematics)

%CoM_work = tot_mech_pwr(chair_data,imu_data)
%
% PI7: total mechanical power � this PI consists of a scalar indicating the 
% total mechanical work done by the Center of mass. The CoM work is calculated
% as the scalar product between the CoM velocity and the force plates resultant
% force
%
%INPUT:
%
%
%OUTPUT:
%
%

pelvis_IMU = imu_data{4};

[pp, vel, events] = sts_CoM(pelvis_IMU,kinematics);

F_seat = chair_data(events(1)+1:events(end),1:3);
F_ground = chair_data(events(1)+1:events(end),9:11);

F_tot = F_seat + F_ground;

CoM_work = vel.*F_tot;


