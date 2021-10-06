function CoP_dist = sts_CoP_stability(data, sts_points)

% CoP_dist = sts_CoP_stability(data, sts_points)
%
% PI3: STS CoP stability – this PI consists of a 2 elements array of scalars 
% indicating the average distance travelled by the CoP both in AP and ML directions. 
% Distance data are averaged across the 5 STS cycles. 
% Data from both the Chair and lower limb kinematics are needed for calculating this PI. 
%
%INPUT:
%
%data: is the matrix containing the data recorded from the BENCH devce
%
%sts_points: is the second output of the segment_sts function, and contains
%the samples for segmenting the different sts cycles
%
%
%
%
%OUTPUT:
%
%CoP_dist: is the average distance travelled by the CoP in the
%antero-posterior direction and medial-lateral directions
%

t0 = sts_points(1,:);
fhe = sts_points(4,:);

CoP_seat = (data(:,8:9));
CoP_ground = (data(:,16:17));
CoP_ground(:,1) = CoP_ground(:,1)+0.4; %the AP coordinate of the ground force plate has a 0.4m offset

F_seat = sqrt(sum(data(:,2:4).^2,2));
F_ground = sqrt(sum(data(:,10:12).^2,2));


CoP_avg = ((CoP_seat.*F_seat + CoP_ground.*F_ground)./(F_seat+F_ground))/2; %this is the average CoP coordinate across the 2 force plates

for i = 1:length(t0)
    
   CoP_AP(i) = sum(abs(diff(CoP_avg(t0(i):fhe(i),1))));
   CoP_ML(i) = sum(abs(diff(CoP_avg(t0(i):fhe(i),2))));
   
end

CoP_dist_AP = mean(CoP_AP);
CoP_dist_ML = mean(CoP_ML);

CoP_dist = [CoP_dist_AP;CoP_dist_ML];








