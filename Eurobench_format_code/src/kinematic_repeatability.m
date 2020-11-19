function kinematic_reg = kinematic_repeatability(kinematics,fs)
%
% kinematics_reg = kinematic_repeatability(kinematics,fs)
%
% PI6: kinematic repeatability – this PI is a four elements array of scalars
% indicating the regularity of the ankle, knee, hip and trunk
% kinematics, respectively. Regularity is calculated through the normalized
% autocorrelation of the kinematics. In particular, for knee and hip he
% regularity corresponds to amplitude of the first peak of the normalized
% auto-correlation function at lag different from zero, while for the ankle
% and trunk it corresponds to the second peak.
%
%
%INPUT:
%
%kinematics: is the matrix containing the movement kinematics calculated through
%the joint_kinematics.m function
%
%fs: is the sampling rate
%
%OUTPUT:
%
%kinematic_reg: four elements array of scalars indicating the regularity of
%the ankle, knee, hip and trunk kinematics, respectively

for i = 1:4
    
    joint_angle = kinematics(:,i);
    Rxx = xcorr(joint_angle,'unbiased');
    Rxx = Rxx/max(Rxx);
    [reg,locs] = findpeaks(Rxx-min(Rxx)+0.01,'minpeakdistance',round(fs*0.7));
    reg = reg(locs>length(Rxx)/2+2);
    reg = reg+min(Rxx)-0.01;
    
    if i == 1 || i == 4
        kinematic_reg(i) = reg(2);
    else
        kinematic_reg(i) = reg(1);
    end
    
end
    
    
    
    
    
