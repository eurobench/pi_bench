%% Main ROS Publisher using ROS
% master node which is publishing the raw data of the chair consisting of:
%   - 2 arm rails:
%           - topic AR1 and AR2
%           - ROS message format: geometry_msgs/WrenchStamped
%   - 2 force plates (not added yet): 
%           - topic FP1 and FP2
%           - ROS message format: still needs to be defined
%   Raw data is saved in a csv file as well.
%
% GUIDE: type rosinit, which is making the publisher node the master node
%        enter the needed values in the section ENTER VALUES then run script
%        if the acqusition should have a special duration, set iscont = 0,
%        type in duration and run the script
%        if the acqusition should be continous, set iscont = 1 and run the script
%        to stop the acquisition type any button while having the figure
%        opened
%        to close ROS node, type rosshutdown

clearvars -except num_session 
close all

%% ENTER VALUES
% ENTER SUBJECT NUMBER HERE
subject = 2;
% ENTER WHETHER RECORDING IS CONTINOUS OR TAKES A SPECIAL DURATION
iscont = 1;
duration =  10; %not necessary to be typed in when acquisition is continous
%% Initiation process
% sessions are counted after starting matlab
if exist('num_session', 'var')
    num_session = num_session + 1;
else
    num_session = 1;
end

% create name of the file
if subject < 10
    subject_str = append('subject_0', num2str(subject));
else
    subject_str = append('subject_', num2str(subject));
end

if num_session < 10
    num_session_str = append('0', num2str(num_session));
else
    num_session_str = num2str(num_session);
end

%set up variables for acquiring data
devicename = 'Dev2'; % Dev1 real device, Dev2 simulated device
channels = (1:12); % when measuring 2 AR, with FP more channels needed
fsamp = 2000;
range = [-10,10];
filename = append(subject_str, '_chair_raw_', num_session_str, '.csv');

% check whether filename already exists to not overwrite any data
counter = 1;
while exist(filename, 'file')==2
    filename = append(subject_str, '_chair_raw_', num_session_str, '_0', num2str(counter), '.csv');
    counter = counter + 1;
end

%create txt file with all the information about raw data
fileID = fopen('raw_data.txt','w');
text = sprintf('Raw data of the chair acquired by an AD-Converter running with a frequency of %d Hz.\n 1st column: time in seconds.\n 2nd-7th column: force and torque armrail 1.\n 8th-13th column: force and torque armrail 2', fsamp);
fprintf(fileID,text);
fclose(fileID);

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
frame = 1; % numbers of packages
msg_AR1.Header.Seq = num_session;
msg_AR2.Header.Seq = num_session;
%% Creating session s for the NI instrument 

s = daq.createSession('ni');
s.Rate = fsamp;
s.addAnalogInputChannel(devicename,channels,'Voltage');
NChan = length(channels);

for i = 1:NChan
    s.Channels(i).Range = range;
    s.Channels(i).TerminalConfig = 'SingleEnded';
end

s.IsContinuous = iscont;

if iscont==0
    s.DurationInSeconds = duration;
end

% builds a signals sub-field within the field UserData of the current NI session.
s.UserData.signals = [];
s.UserData.frames = frame;

% a listener with a callback function to addUserData is used to append the data to the 
% structure s.UserData.signals each time data is available in the NI data
% stream and at the same time to publish the available data
lh = addlistener(s,'DataAvailable',@(src, evt) addUserData(src,evt));

% create timer funtion to stop the acquiring after 30 seconds automatically
t = timer('StartDelay', 30); %change 30 to higher values if measurements should be able to last longer than 30 seconds
t.TimerFcn = {@stop_automatically};
%% NI data acquisition 
if iscont
    s.startBackground;
    disp('Acquisition started...')
    disp('Press a key to stop acquisition.')
    start(t);
    w = waitforbuttonpress;
    disp('Button pressed. Acquisition is stopped.')
    s.stop
    stop(t)
    delete(t)
    close
else
    disp('Acquisition started...')
    s.startForeground;
    disp('Acquisition stopped.')
    % close
end

% send the collected data with function
disp('Sending data...')
ROS_publish(s.UserData.signals(:, 1:7), pub_AR1, msg_AR1); 
ROS_publish(horzcat(s.UserData.signals(:,1), s.UserData.signals(:,8:13)), pub_AR2, msg_AR2);
disp('Data successfully sent.')

% separates time reference from the actual data and creates an external
%log file
tbl = array2table(s.UserData.signals(:, 1:13));
tbl.Properties.VariableNames = {'time','F_x_ar1','F_y_ar1','F_z_ar1', 'T_x_ar1','T_y_ar1','T_z_ar1', 'F_x_ar2','F_y_ar2','F_z_ar2', 'T_x_ar2','T_y_ar2','T_z_ar2'};

writetable(tbl, filename, 'Delimiter',',')

disp('Raw data saved.')

delete(lh);
close all 
    
function addUserData(src,evt) 
    % collect available data
    data = [evt.TimeStamps, evt.Data]; % every 0.1s updated --> fsample/10 amount of data rows
    % save Data in Session
    src.UserData.signals = [src.UserData.signals;data];
end


function stop_automatically(~,~)
    robot = java.awt.Robot;

    robot.keyPress    (java.awt.event.KeyEvent.VK_ENTER);
    robot.keyRelease  (java.awt.event.KeyEvent.VK_ENTER);
    disp('Running out of time. Button pressed automatically.')
end