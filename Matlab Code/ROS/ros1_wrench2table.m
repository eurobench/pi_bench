function wrench_tbl = ros1_wrench2table(wrench)
%header2table: convert many wrench ROS messages into a table
%   The Wrench message consists of force and torque which each consist of 
%   x,y z components. The created table has 6 columns listing first force x
%   y and z component and then torque and its x y z component.

% converting the force component into a table
    force = [wrench(1:end).Force];
    fx = [force(1:end).X];
    fy = [force(1:end).Y];
    fz = [force(1:end).Z];
    force_mod = horzcat(fx',fy',fz');
    force_tbl = array2table(force_mod);
    force_tbl.Properties.VariableNames = {'F_x','F_y','F_z'};
    
% converting the force component into a table
    torque = [wrench(1:end).Torque];
    tx = [torque(1:end).X];
    ty = [torque(1:end).Y];
    tz = [torque(1:end).Z];
    torque_mod = horzcat(tx',ty',tz');
    torque_tbl = array2table(torque_mod);
    torque_tbl.Properties.VariableNames = {'T_x','T_y','T_z'};
    
% fusing both parts to one table 
    wrench_tbl = horzcat(force_tbl, torque_tbl);
end

