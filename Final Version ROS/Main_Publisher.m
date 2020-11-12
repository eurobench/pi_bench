%% Main ROS Publisher using ROS
% master node which is publishing the raw data of the chair consisting of:
%   - 2 force plates 
%           - topic FP_seat and FP_feet
%           - ROS message format: WrenchStamped
%   - 2 CoP Points
%           - topic CoP_seat and CoP_feet
%           - ROS message format: PointStamped
%   - 6 shimmer sensors
%           - topic SH1-SH6
%           - ROS message format: WrenchStamped
%   Raw data is saved in a csv file as well.
%
% GUIDE: type rosinit, which is making the publisher node the master node;
%        enter the needed values in the section ENTER VALUES then run script;
%        to close ROS node, type rosshutdown;

clearvars -except num_session 
close all

%% ENTER VALUES
% ENTER SUBJECT NUMBER, COMPORT LIST FOR SHIMMER RECORDING AND PROTOCOL HERE
%
%protocol can be one of the following
%
%'calib'
%'5sts'
%'30sts'

subject = 1;
COMPORT = {'COM1', 'COM2'};
protocol = '30sts';
%% Initiation process
% sessions are counted after starting matlab
if exist('num_session', 'var')
    num_session = num_session + 1;
else
    num_session = 1;
end

% create name of the file
if subject < 10
    subject_str = append('subject_0', num2str(subject),'_',protocol);
else
    subject_str = append('subject_', num2str(subject),'_',protocol);
end

if num_session < 10
    num_session_str = append('0', num2str(num_session));
else
    num_session_str = num2str(num_session);
end

%set up variables for acquiring data
devicename = 'Dev2'; % Dev1 real device, Dev2 simulated device
ni_channels = (1:31); 
fsamp_ni = 128;
fsamp_sh = 128;
ni_range = [-10,10];
filename = append(subject_str, '_chair_raw_', num_session_str, '.csv');

% check whether filename already exists to not overwrite any data
counter = 1;
while exist(filename, 'file')==2
    filename = append(subject_str, '_chair_raw_', num_session_str, '_0', num2str(counter), '.csv');
    counter = counter + 1;
end

%create txt file with all the information about raw data
fileID = fopen('raw_data.txt','w');
text = sprintf('Raw data of the chair acquired by an AD-Converter running with a frequency of %d Hz and shimmer sensors with a frequency of %d Hz.\n 1st column: time in seconds.\n 2nd-7th column: force plate 1.\n 8th-9th column: centre of pressure 1.\n 10th-15th column: force plate 2.\n 16th-17th column: centre of pressure 2.\n 18th-53th column: shimmer sensors 1-6', fsamp_ni, fsamp_sh);
fprintf(fileID,text);
fclose(fileID);

% defining the published topics
% publishers concerning the arm rails 
pub_FP_seat = rospublisher("/FP_seat", "geometry_msgs/WrenchStamped");
pub_FP_feet = rospublisher("/FP_feet", "geometry_msgs/WrenchStamped");
pub_CoP_seat = rospublisher("/CoP_seat", "geometry_msgs/PointStamped");
pub_CoP_feet = rospublisher("/CoP_feet", "geometry_msgs/PointStamped");
pub_SH1 = rospublisher("/SH1", "geometry_msgs/WrenchStamped");
pub_SH2 = rospublisher("/SH2", "geometry_msgs/WrenchStamped");
pub_SH3 = rospublisher("/SH3", "geometry_msgs/WrenchStamped");
pub_SH4 = rospublisher("/SH4", "geometry_msgs/WrenchStamped");
pub_SH5 = rospublisher("/SH5", "geometry_msgs/WrenchStamped");
pub_SH6 = rospublisher("/SH6", "geometry_msgs/WrenchStamped");

% wait to ensure that publisher is registered
pause(1)

% define messages that will be published 
 msg_FP_seat = rosmessage(pub_FP_seat);
 msg_FP_feet = rosmessage(pub_FP_feet);
 msg_CoP_seat = rosmessage(pub_CoP_seat);
 msg_CoP_feet = rosmessage(pub_CoP_feet);
 msg_SH1 = rosmessage(pub_SH1);
 msg_SH2 = rosmessage(pub_SH2);
 msg_SH3 = rosmessage(pub_SH3);
 msg_SH4 = rosmessage(pub_SH4);
 msg_SH5 = rosmessage(pub_SH5);
 msg_SH6 = rosmessage(pub_SH6);

%% Creating session s for the NI instrument and sh for the shimmer sensors
% % connect sensors
% [sh,s] = connect_sensors(COMPORT,fsamp_sh, devicename, ni_channels, fsamp_ni, range_ni);
% 
% % synch acquisition of the shimmer and NI
% [Chair_data,data_sh] = synch_acq(sh,s);
% 
% % synchronize data
% [Synch_chair_data, Synch_shimmer_data, chair_labels, shimmer_labels] = synchronize_data(chair_data, data_sh,fsamp_sh);

% alternative to work with example data
load("S01_30sts_data.mat")

% create time stamps
timestamps = linspace(0,length(Synch_chair_data)/fsamp_ni, length(Synch_chair_data));

%% reshape data for ROS_publish
% chair seat
chair_seat =  horzcat(timestamps',Synch_chair_data(:, 1:6));
% chair feet
chair_feet =  horzcat(timestamps',Synch_chair_data(:, 9:14));
% CoP seat
CoP_seat = horzcat(timestamps', Synch_chair_data(:, 7:8));
% CoP feet
CoP_feet = horzcat(timestamps', Synch_chair_data(:, 15:16));
% Shimmer sensors 1-6
shimmer1 = horzcat(timestamps', Synch_shimmer_data{1, 1});
shimmer2 = horzcat(timestamps', Synch_shimmer_data{1, 2});
shimmer3 = horzcat(timestamps', Synch_shimmer_data{1, 3});
shimmer4 = horzcat(timestamps', Synch_shimmer_data{1, 4});
shimmer5 = horzcat(timestamps', Synch_shimmer_data{1, 5});
shimmer6 = horzcat(timestamps', Synch_shimmer_data{1, 6});


%% NI data acquisition 

% send the collected data with function
disp('Sending data...')
ROS_publish(chair_seat, pub_FP_seat, msg_FP_seat, num_session); 
ROS_publish(chair_feet, pub_FP_feet, msg_FP_feet, num_session);
disp('Chair data sent.')
ROS_CoP_publish(CoP_seat, pub_CoP_seat, msg_CoP_seat, num_session)
ROS_CoP_publish(CoP_feet, pub_CoP_feet, msg_CoP_feet, num_session)
disp('CoP data sent.')
ROS_publish(shimmer1, pub_SH1, msg_SH1, num_session);
ROS_publish(shimmer2, pub_SH2, msg_SH2, num_session);
ROS_publish(shimmer3, pub_SH3, msg_SH4, num_session);
ROS_publish(shimmer4, pub_SH4, msg_SH4, num_session);
ROS_publish(shimmer5, pub_SH5, msg_SH5, num_session);
ROS_publish(shimmer6, pub_SH6, msg_SH6, num_session);
disp('Shimmer data sent.')
disp('Data successfully sent.')

% saves the raw data in a table
for a=1:6
    for l = 1:6
        shimmer_labels_mod{1, (a-1)*6+l} = strcat(shimmer_labels(1,l),num2str(a));
    end
end

tbl = array2table(horzcat(timestamps', Synch_chair_data, Synch_shimmer_data{1, 1}, Synch_shimmer_data{1, 2},Synch_shimmer_data{1, 3}, Synch_shimmer_data{1, 4}, Synch_shimmer_data{1, 5}, Synch_shimmer_data{1, 6}));
names = [{'time'}, chair_labels(:)', shimmer_labels_mod(:)'];
tbl.Properties.VariableNames = string(names);

folder_raw = append(subject_str, '_raw');
    
if ~exist(folder_raw, 'dir')
   mkdir(folder_raw)
end
    
tbl_full_path  = fullfile( folder_raw , filename );
writetable(tbl, tbl_full_path, 'Delimiter',',')

disp('Raw data saved.')

close all 
