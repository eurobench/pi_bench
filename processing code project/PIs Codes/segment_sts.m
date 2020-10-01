function subphases = segment_sts(chair_data, imu_data)

% PI2: STS subphases duration - this PI consists of a 3 elements array of scalars 
% indicating the average duration of each STS subphase. Each subphase duration 
% is the average across the 5 sit-to-stand cycles characterizing the protocol. 
% 
% The 3 phases are defined according to Caruthers et al. 2016, and based on the 4 time points:
% 
% -	1: t0: in each STS cycle, the start corresponds to the first trunk bending after the 0 velocity has been reached
% -	2: lift-off: when the COP vertical force of the seat force plate goes to 0
% -	3: maximum ankle dorsiflexion: corresponds to the point at which the shank bends over the foot, generating a maximum ankle dorsiflexion. 
% -	4: full hip extension: detected when the hip is fully extended, the sit-to-stand cycle ends. A subsequent beginning of the hip flexion identifies the beginning of the stand-to-sit cycle
% These 4 points in each cycle lead to the following 3 subphases:
% 
% -	Phase 1: Forward leaning
% -	Phase 2: Momentum transfer
% -	Phase 3: Extension
% Data from both the Chair and lower limb kinematics are needed for calculating this PI. 
%
%INPUT:
%
%
%OUTPUT:
%
%
