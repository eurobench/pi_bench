%% Main ROS Publisher using ROS
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

%set up variables for acquiring data
devicename = 'Dev2'; % Dev1 real device, Dev2 simulated device
channels = (1:31);
iscont = true;
duration =  2;
fsamp = 250000;
range = [-10,10];
filename = 'test.bin';

%[data,time] = acquireData(devicename,channels,iscont,duration,fsamp,range,filename);

% enter data here
subject = 1;
num_session = 1;
sample = 1;

%rosinit('129.69.142.119', 30001) %eduroam 141.58.221.169
% define sending node
%rosinit


% topics
% force sensors: geometry_msgs/WrenchStamped
AR1_pub = rospublisher("/AR1", "geometry_msgs/WrenchStamped");


% messages for ground reaction forces still need to be defined
% FP1_pub = ros2publisher(pub_node, "/FP1", "geometry_msgs/WrenchStamped");
% FP2_pub = ros2publisher(pub_node, "/FP2", "geometry_msgs/WrenchStamped");

% ensure that publisher is registered
pause(2)

% define message 
msg_AR1 = rosmessage(AR1_pub);
% msg_AR2 = ros2message(AR2_pub);

% define header
frame = 1; % numbers of packages
frame_id = num2str(frame);

% wait until subscriber is ready
pause (5)

while true
    
    % acquire data with the NI Box
    [data,time] = acquireData(devicename,channels,iscont,duration,fsamp,range,filename);
    
    % AR 1
    % update time header
    [s,ns]= getROStime; %instead of getting time using time stamps of NI box
    msg_AR1.Header.Seq = num_session;
    msg_AR1.Header.Stamp.Sec = int32(s);
    msg_AR1.Header.Stamp.Nsec = uint32(ns);
    msg_AR1.Header.FrameId = frame_id;
    
    % define forces 
    msg_AR1.Wrench.Force.X = data(sample,1);
    msg_AR1.Wrench.Force.Y = data(sample,2);
    msg_AR1.Wrench.Force.Z = data(sample,3);
    
    % define torques
    msg_AR1.Wrench.Torque.X = data(sample,4);
    msg_AR1.Wrench.Torque.Y = data(sample,5);
    msg_AR1.Wrench.Torque.Z = data(sample,6);

    % send message 
    send(AR1_pub, msg_AR1)
    
    frame= frame+ 1;
    sample = sample + 1;
    frame_id = num2str(frame);
    pause(0.2)

end
