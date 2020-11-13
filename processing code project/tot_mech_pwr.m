function CoM_work = tot_mech_pwr(data,kinematics)

%CoM_work = tot_mech_pwr(chair_data,imu_data)
%
% PI7: total mechanical power – this PI consists of a scalar indicating the 
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

pelvis_IMU = data(:,36:41);

[pp, vel, evt] = sts_CoM(pelvis_IMU,kinematics);

F_seat = data(evt(1)+1:evt(end),2:4);
F_ground = data(evt(1)+1:evt(end),8:10);

F_tot = F_seat + F_ground;

CoM_work = sum(vel.*F_tot);
CoM_work = CoM_work([1 3]);



