function ROS_publish(data, publisher_node, msg, num_session)
%ROS_PUBLISH publishes data via ROS in the Wrench Stamped format 
%INPUT: - data: data that needs to be send
%       - publisher node: node which is publishing the ros messages
%       - msg: messages format
%       - num_session: number of the held session needed for the header
for a = 1:size(data,1)
        
        % turn the frame number into a string to meet data type expectations of
        % ROS messages
        frame_id = num2str(a);
        
        % prepare and send message 
        msg.Header.FrameId = frame_id;
        msg.Header.Seq = num_session;
        time_tmp = rostime(data(a,1));
        sec = time_tmp.Sec;
        nsec = time_tmp.Nsec;
        msg.Header.Stamp.Sec = sec;
        msg.Header.Stamp.Nsec = nsec;
        
        msg.Wrench.Force.X = data(a,2);
        msg.Wrench.Force.Y = data(a,3);
        msg.Wrench.Force.Z = data(a,4); 
        msg.Wrench.Torque.X = data(a,5);
        msg.Wrench.Torque.Y = data(a,6);
        msg.Wrench.Torque.Z = data(a,7);
        
        send(publisher_node, msg)
        
end

