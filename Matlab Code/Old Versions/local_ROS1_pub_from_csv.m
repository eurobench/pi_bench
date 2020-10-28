%% Main ROS Publisher using ROS publishing raw data from csv file
% master node which is publishing the raw data of the chair consisting of:
%   - 2 arm rails:
%           - topic AR1 and AR2
%           - ROS message format: geometry_msgs/WrenchStamped
%   - 2 force plates (not added yet): 
%           - topic FP1 and FP2
%           - ROS message format: still needs to be defined
% GUIDE: type rosinit, which is making the publisher node the master node;
%        type in the name of the file in section ENTER VALUES;
%        run script to start publishing;
%        to close ROS node type rosshutdown;

close all
clear
%% ENTER VALUES
file = 'subject_01_chair_raw_02.csv';

%% Publish
% load file
data_tbl = readtable(file);
data = table2array(data_tbl);

% defining the published topics
% publishers concerning the arm rails 
pub_AR1 = rospublisher("/AR1", "geometry_msgs/WrenchStamped");
pub_AR2 = rospublisher("/AR2", "geometry_msgs/WrenchStamped");

% wait to ensure that publisher is registered
pause(1)

% define messages that will be published 
 msg_AR1 = rosmessage(pub_AR1);
 msg_AR2 = rosmessage(pub_AR2);

% predefine parts of the message header
num_session = str2double(cell2mat(extractBetween(file, 'raw_', '.csv')));
msg_AR1.Header.Seq = num_session;
msg_AR2.Header.Seq = num_session;

disp('Sending data...')
% publish the available data package
    for a = 1:size(data,1)
        
        % turn the frame number into a string to meet data type expectations of
        % ROS messages
        frame_id = num2str(a);
        
        % prepare and send message AR1
        msg_AR1.Header.FrameId = frame_id;
        time_tmp = rostime(data(a,1));
        sec = time_tmp.Sec;
        nsec = time_tmp.Nsec;
        msg_AR1.Header.Stamp.Sec = sec;
        msg_AR1.Header.Stamp.Nsec = nsec;
        
        msg_AR1.Wrench.Force.X = data(a,2);
        msg_AR1.Wrench.Force.Y = data(a,3);
        msg_AR1.Wrench.Force.Z = data(a,4); 
        msg_AR1.Wrench.Torque.X = data(a,5);
        msg_AR1.Wrench.Torque.Y = data(a,6);
        msg_AR1.Wrench.Torque.Z = data(a,7);
        
        send(pub_AR1, msg_AR1)
        
        % prepare and send message AR2
        msg_AR2.Header.FrameId = frame_id;
        msg_AR2.Header.Stamp.Sec = sec;
        msg_AR2.Header.Stamp.Nsec = nsec;
        
        msg_AR2.Wrench.Force.X = data(a,8);
        msg_AR2.Wrench.Force.Y = data(a,9);
        msg_AR2.Wrench.Force.Z = data(a,10); 
        msg_AR2.Wrench.Torque.X = data(a,11);
        msg_AR2.Wrench.Torque.Y = data(a,12);
        msg_AR2.Wrench.Torque.Z = data(a,13);
        send(pub_AR2, msg_AR2)
        
    end
disp('Data is sent.')
