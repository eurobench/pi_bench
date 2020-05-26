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
% GUIDE: type rosinit, which is making the publisher node the master node;
%        enter the needed values in the section ENTER VALUES then run script;
%        if the acqusition should have a special duration, set iscont = 0,
%        type in duration and run the script;
%        if the acqusition should be conitnous, set iscont = 1 and run the script; 
%        to stop the acquisition type any button while having the figure
%        opened;
%        to close ROS node, type rosshutdown;

clearvars -except num_session 
close all

%% ENTER VALUES
% ENTER SUBJECT NUMBER HERE
subject = 2;
% ENTER WHETHER RECORDING IS CONTINOUS OR TAKES A SPECIAL DURATION
iscont = 0;
duration =  5; %not necessary to be typed in when acquisition is continous
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
channels = (1:14); % when measuring 2 AR, 2 FP
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


%% NI data acquisition 
if iscont
    s.startBackground;
    disp('press a key to stop acquisition')
    w = waitforbuttonpress;
    disp('Button pressed')
    s.stop
else
    disp('Data is sent...')
    s.startForeground;
end


% separates time reference from the actual data and creates an external
%log file
tbl = array2table(s.UserData.signals(:, 1:13));
tbl.Properties.VariableNames = {'time','F_x_ar1','F_y_ar1','F_z_ar1', 'T_x_ar1','T_y_ar1','T_z_ar1', 'F_x_ar2','F_y_ar2','F_z_ar2', 'T_x_ar2','T_y_ar2','T_z_ar2'};

writetable(tbl, filename, 'Delimiter',',')


delete(lh);
disp('Recording stopped.')
disp('Data sent.')
close all 
    
function addUserData(src,evt) 
    % get frame number
    frame = src.UserData.frames;
    % collect available data
    data = [evt.TimeStamps, evt.Data]; % every 0.1s updated --> fsample/10 amount of data rows
    % save Data in Session
    src.UserData.signals = [src.UserData.signals;data];
    
    % extract message from base workspace
    msg_AR1 = evalin('base', 'msg_AR1'); 
    msg_AR2 = evalin('base', 'msg_AR2');
    pub_AR1 = evalin('base', 'pub_AR1');
    pub_AR2 = evalin('base', 'pub_AR2');
    
    % publish the available data package
    for a = 1:size(data,1)
        
        % turn the frame number into a string to meet data type expectations of
        % ROS messages
        frame_id = num2str(frame);
        
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
        
        %increase frame number
        frame = frame + 1;
    end
    src.UserData.frames = frame;

end
