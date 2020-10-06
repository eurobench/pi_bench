function plot_kinematics(kinematics, sts_points)


t0 = sts_points(1,:);
fhe = sts_points(4,:);

kin_res = [];

for i = 1:length(t0)
    
    tmp = kinematics(t0(i):fhe(i),:);
    tmp_res = interp1(linspace(t0(i),fhe(i),fhe(i)-t0(i)+1),tmp,linspace(t0(i),fhe(i),100));
    kin_res = cat(3,kin_res,tmp_res);
    
end

