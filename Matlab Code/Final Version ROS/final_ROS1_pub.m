  %% Main ROS Publisher using ROS
% master node which is publishing the raw data of the chair consisting of:
%   - 2 arm rails:
%           - topic AR1 and AR2
%           - ROS message format: geometry_msgs/WrenchStamped
%   - 2 force plates (not added yet): 
%           - topic FP1 and FP2
%           - ROS message format: still needs to be defined
% GUIDE: type rosinit, which is making the publisher node the master node, then run script to start publishing;
%        to close ROS node type rosshutdown

%% Initiation process
clearvars -except num_session 
close all

% ENTER SUBJECT NUMBER HERE
subject = 1;

% sessions are counted after starting matlab
if exist('num_session', 'var')
    num_session = num_session + 1;
else
    num_session = 1;
end

%set up variables for acquiring data
devicename = 'Dev2'; % Dev1 real device, Dev2 simulated device
channels = (1:14); % when measuring 2 AR, 2 FP
iscont = true; 
duration =  2; %not necessary to be typed in when acquisition is continous
fsamp = 2000;
range = [-10,10];
global filename 
filename = sprintf('RawData_subj%d_%d.csv', subject, num_session);

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

% this file is created and opened in write mode for the final logging of the recorded data
fid1 = fopen(filename,'w');

% a listener with a callback function to addUserData is used to append the data to the 
% structure s.UserData.signals each time data is available in the NI data
% stream and at the same time to publish the available data

lh = addlistener(s,'DataAvailable',@(src, evt) addUserData(src,evt));


%% NI data acquisition 
if iscont
    s.startBackground;
    disp('press a key to stop acquisition')
    w = waitforbuttonpress;
    s.stop
else
    s.startForeground;
end


% separates time reference from the actual data and creates an external
%log file
% 
%     time = s.UserData.signals(:,1);
%     data = s.UserData.signals(:,2:end);
%     fwrite(fid1,[time,data],'double');


fclose(fid1);
delete(lh);

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
