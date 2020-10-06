function [CoP_dist_AP, CoP_dist_ML] = sts_CoP_stability(chair_data, sts_points)

% [CoP_dist_AP, CoP_dist_ML] = sts_CoP_stability(chair_data, imu_data)
%
% PI3: STS CoP stability – this PI consists of a 2 elements array of scalars 
% indicating the average distance travelled by the CoP both in AP and ML directions. 
% Distance data are averaged across the 5 STS cycles. 
% Data from both the Chair and lower limb kinematics are needed for calculating this PI. 
%
%INPUT:
%
%kinematics: is the matrix containing the lower limb kinematics
%
%sts_points: is the second output of the segment_sts function, and contains
%the samples for segmenting the different sts cycles
%
%
%
%
%OUTPUT:
%
%CoP_dist_AP: is the average distance travelled by the CoP in the
%antero-posterior direction
%
%CoP_dist_ML: is the average distance travelled by the CoP in the
%medial-lateral direction

t0 = sts_points(1,:);
fhe = sts_points(4,:);

CoP_seat = (chair_data(:,7:8));
CoP_ground = (chair_data(:,15:16));
CoP_ground(:,1) = CoP_ground(:,1)+0.4; %the AP coordinate of the ground force plate has a 0.4m offset

F_seat = sqrt(sum(chair_data(:,1:3).^2,2));
F_ground = sqrt(sum(chair_data(:,9:11).^2,2));


CoP_avg = ((CoP_seat.*F_seat + CoP_ground.*F_ground)./(F_seat+F_ground))/2; %this is the average CoP coordinate across the 2 force plates

for i = 1:length(t0)
    
   CoP_AP(i) = sum(abs(diff(CoP_avg(t0(i):fhe(i),1))));
   CoP_ML(i) = sum(abs(diff(CoP_avg(t0(i):fhe(i),2))));
   
end

CoP_dist_AP = mean(CoP_AP);
CoP_dist_ML = mean(CoP_ML);








