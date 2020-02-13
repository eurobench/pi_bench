%% Main ROS Publisher
% master node which is publishing the raw data of the chair consisting of:
%   - 2 arm rails:
%           - topic AR1 and AR2
%           - ROS message format: geometry_msgs/WrenchStamped
%   - 2 force plates: 
%           - topic FP1 and FP2
%           - ROS message format: still needs to be defined
% GUIDE: run script to start publishing

clearvars
close all

% enter data here
subject = 1;
session = 1;

%rosinit;
% define sending node
% rosinit
pub_node = ros2node("/pub_node");

% topics
% force sensors: geometry_msgs/WrenchStamped
AR1_pub = ros2publisher(pub_node, "/AR1", "geometry_msgs/WrenchStamped");
AR2_pub = ros2publisher(pub_node, "/AR2", "geometry_msgs/WrenchStamped");

% messages for ground reaction forces still need to be defined
% FP1_pub = ros2publisher(pub_node, "/FP1", "geometry_msgs/WrenchStamped");
% FP2_pub = ros2publisher(pub_node, "/FP2", "geometry_msgs/WrenchStamped");

% ensure that publisher is registered
pause(2)

% define message 
msg_AR1 = ros2message(AR1_pub);
msg_AR2 = ros2message(AR2_pub);

% define header
seq = session; 
frame = 1; % numbers of packages
frame_id = num2str(frame);

% wait until subscriber is ready
pause (5)

while true
    
    % acquire data with the NI Box
    
    % AR 1
    % update time header
    [s,ns]= getROStime; %instead of getting time using time stamps of NI box
    msg_AR1.header.sequence = 1;
    msg_AR1.header.stamp.sec = int32(s);
    msg_AR1.header.stamp.nanosec = uint32(ns);
    msg_AR1.header.frame_id = frame_id;
    
    % define forces 
    msg_AR1.wrench.force.x = randi(9);
    msg_AR1.wrench.force.y = randi(9);
    msg_AR1.wrench.force.z = randi(9);
    
    % define torques
    msg_AR1.wrench.torque.x = randi(9);
    msg_AR1.wrench.torque.y = randi(9);
    msg_AR1.wrench.torque.z = randi(9);

    % send message 
    send(AR1_pub, msg_AR1)
    
     % AR 2
    % update time header
    [s,ns]= getROStime;
    msg_AR2.header.stamp.sec = int32(s);
    msg_AR2.header.stamp.nanosec = uint32(ns);
    msg_AR2.header.frame_id = frame_id;
    
    % define forces 
    msg_AR2.wrench.force.x = randi(9);
    msg_AR2.wrench.force.y = randi(9);
    msg_AR2.wrench.force.z = randi(9);
    
    % define torques
    msg_AR2.wrench.torque.x = randi(9);
    msg_AR2.wrench.torque.y = randi(9);
    msg_AR2.wrench.torque.z = randi(9);

    % send message 
    send(AR2_pub, msg_AR2)
    
    
    frame= frame+ 1;
    frame_id = num2str(frame);
    pause(0.2)

end
