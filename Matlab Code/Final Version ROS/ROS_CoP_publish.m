function ROS_CoP_publish(data, publisher_node, msg, num_session)
%ROS_COP_PUBLISH publishes data via ROS in the Point Stamped format for the CoP
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
        
        msg.Point.X = data(a,2);
        msg.Point.Y = data(a,3);
        msg.Point.Z = 0;
        
        send(publisher_node, msg)
        
        
end



