function ROS2_publish(data, publisher_node, msg, num_session)
%ROS_PUBLISH publishes data via ROS in the Wrench Stamped format 
%INPUT: - data: data that needs to be send
%       - publisher node: node which is publishing the ros messages
%       - msg: messages format
for a = 1:size(data,1)
        
        % turn the frame number into a string to meet data type expectations of
        % ROS messages
        %frame_id = num2str(a);
        frame_id = num2str(num_session);
        
        % prepare and send message 
        msg.header.frame_id = frame_id;
        time_tmp = rostime(data(a,1));
        sec = time_tmp.Sec;
        nsec = time_tmp.Nsec;
        msg.header.stamp.sec = int32(sec);
        msg.header.stamp.nanosec = uint32(nsec);
        
        msg.wrench.force.x = data(a,2);
        msg.wrench.force.y = data(a,3);
        msg.wrench.force.z = data(a,4); 
        msg.wrench.torque.x = data(a,5);
        msg.wrench.torque.y = data(a,6);
        msg.wrench.torque.z = data(a,7);
        
        send(publisher_node, msg)
        
        %
        
end

