%% Main ROS subscriber using ROS 
% node which is subscribing to topics from the chair sending data from:
%   - 2 force plates 
%           - topic FP_seat and FP_feet
%           - ROS message format: WrenchStamped
%   - 2 CoP Points
%           - topic CoP_seat and CoP_feet
%           - ROS message format: PointStamped
%   - 6 shimmer sensors
%           - topic SH1-SH6
%           - ROS message format: WrenchStamped
%   Data is saved in seperate csv-files.
%
% GUIDE: type in the amount of time you want your measured data to have in ENTER VALUES;
%        run script to start and stop streaming with the GUI
%        to close ROS node type rosshutdown;

clearvars 
close all

%% ENTER VALUES
% ENTER SUBJECT NUMBER HERE
subject = 1;
% TYPE IN DURATION  YOU WANT TO RECEIVE DATA FROM
global duration
duration = 5; 
ip_master = '192.168.178.74';
disp("Registering subscribers...")
sub1 = ros.Node("Sub1", ip_master);
sub2 = ros.Node("Sub2", ip_master);
sub3 = ros.Node("Sub3", ip_master);
sub4 = ros.Node("Sub4", ip_master);
sub5 = ros.Node("Sub5", ip_master);
sub6 = ros.Node("Sub6", ip_master);
sub7 = ros.Node("Sub7", ip_master);
sub8 = ros.Node("Sub8", ip_master);
sub9 = ros.Node("Sub9", ip_master);
sub10 = ros.Node("Sub10", ip_master);
disp("Succesfully registered.")
%% Initiation process
global active
global reached 
reached = 0;
% defining global counting variables for topics AR1 and AR2
global a 
global b
global c
global d
global e
global f
global g
global h
global i
global j
a = 1; b = 1; c= 1; d= 1; e =1; f= 1; g= 1; h = 1; i = 1; j =1;

% defining global storages
global data_m_fp1
global data_m_fp2
global data_m_CoP1
global data_m_CoP2
global data_m_sh1
global data_m_sh2
global data_m_sh3
global data_m_sh4
global data_m_sh5
global data_m_sh6
%% set up GUI for controlling the streaming process
 
% variable streaming can be adjusted via GUI
global streaming; 
streaming = 0;

uf = figure;
uf.Name = 'Streaming of gathered data';
uf.Position = [500 300 400 275];

% start streaming button
uicontrol('Style', 'pushbutton', 'Position', [50 175 125 50], 'String', 'Start Streaming', 'Callback', @StartButton);
% stop streaming button
uicontrol('Style', 'pushbutton', 'Position', [225 175 125 50], 'String', 'Stop Streaming', 'Callback', @StopButton);


%% Streaming process 
% wait until streaming is started
while streaming == 0 
    pause(0.01)
end

% after start button was pressed, data is streamed --> streaming = 1
if streaming ==1 
    % defining subscribers to prefered topics
    sub_FP_seat = ros.Subscriber(sub1, "/FP_seat", "geometry_msgs/WrenchStamped", "BufferSize", 100);
    sub_FP_feet = ros.Subscriber(sub2, "/FP_feet", "geometry_msgs/WrenchStamped", "BufferSize", 100);
    sub_CoP_seat = ros.Subscriber(sub3, "/CoP_seat", "geometry_msgs/PointStamped", "BufferSize", 100);
    sub_CoP_feet = ros.Subscriber(sub4, "/CoP_feet", "geometry_msgs/PointStamped", "BufferSize", 100);
    sub_SH1 = ros.Subscriber(sub5, "/SH1", "geometry_msgs/WrenchStamped", "BufferSize", 100);
    sub_SH2 = ros.Subscriber(sub6, "/SH2", "geometry_msgs/WrenchStamped", "BufferSize", 100);
    sub_SH3 = ros.Subscriber(sub7, "/SH3", "geometry_msgs/WrenchStamped", "BufferSize", 100);
    sub_SH4 = ros.Subscriber(sub8, "/SH4", "geometry_msgs/WrenchStamped", "BufferSize", 100);
    sub_SH5 = ros.Subscriber(sub9, "/SH5", "geometry_msgs/WrenchStamped", "BufferSize", 100);
    sub_SH6 = ros.Subscriber(sub10, "/SH6", "geometry_msgs/WrenchStamped", "BufferSize", 100);
    
    
    % defining the arrays for saving incoming data
    
    
    data_m_fp1 = arrayfun(@(~) rosmessage('geometry_msgs/WrenchStamped'),zeros(1,2));
    data_m_fp2 = arrayfun(@(~) rosmessage('geometry_msgs/WrenchStamped'),zeros(1,2));
    data_m_CoP1 = arrayfun(@(~) rosmessage('geometry_msgs/PointStamped'),zeros(1,2));
    data_m_CoP2 = arrayfun(@(~) rosmessage('geometry_msgs/PointStamped'),zeros(1,2));
    data_m_sh1 = arrayfun(@(~) rosmessage('geometry_msgs/WrenchStamped'),zeros(1,2));
    data_m_sh2 = arrayfun(@(~) rosmessage('geometry_msgs/WrenchStamped'),zeros(1,2));
    data_m_sh3 = arrayfun(@(~) rosmessage('geometry_msgs/WrenchStamped'),zeros(1,2));
    data_m_sh4 = arrayfun(@(~) rosmessage('geometry_msgs/WrenchStamped'),zeros(1,2));
    data_m_sh5 = arrayfun(@(~) rosmessage('geometry_msgs/WrenchStamped'),zeros(1,2));
    data_m_sh6 = arrayfun(@(~) rosmessage('geometry_msgs/WrenchStamped'),zeros(1,2));

    % defining callback of subscribers
    sub_FP_seat.NewMessageFcn = @saveFP1Message;
    sub_FP_feet.NewMessageFcn = @saveFP2Message;
    sub_CoP_feet.NewMessageFcn = @saveCoP1Message;
    sub_CoP_seat.NewMessageFcn = @saveCoP2Message;
    sub_SH1.NewMessageFcn = @saveSH1Message;
    sub_SH2.NewMessageFcn = @saveSH2Message;
    sub_SH3.NewMessageFcn = @saveSH3Message;
    sub_SH4.NewMessageFcn = @saveSH4Message;
    sub_SH5.NewMessageFcn = @saveSH5Message;
    sub_SH6.NewMessageFcn = @saveSH6Message;
    
    
    active = 1;
    disp('Connection to publisher established.')
end

% helping variable active keeps script running while Callbacks are executed
while active == 1
    start_n = a;
    pause(0.01) 
    if reached
        disp('The wished amount of data is received now.')
        pause(2)
    end
end 

% when stop button was pressed, data is saved --> streaming = 2, active = 0 
if (streaming == 2 || (active == 0))
    disp('Streaming stopped.')
    disp('Saving data...')
    for a = 1:10
        clear (horzcat('sub', num2str(a)))
    end
    
    num_session = data_m_fp1(1,1).Header.Seq;
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

    filename_fp1 = append(subject_str, '_FP1_', num_session_str, '.csv');
    filename_fp2 = append(subject_str, '_FP2_', num_session_str, '.csv');
    filename_CoP1 = append(subject_str, '_CoP1_', num_session_str, '.csv');
    filename_CoP2 = append(subject_str, '_CoP2_', num_session_str, '.csv');
    filename_sh1 = append(subject_str, '_SH1_', num_session_str, '.csv');
    filename_sh2 = append(subject_str, '_SH2_', num_session_str, '.csv');
    filename_sh3 = append(subject_str, '_SH3_', num_session_str, '.csv');
    filename_sh4 = append(subject_str, '_SH4_', num_session_str, '.csv');
    filename_sh5 = append(subject_str, '_SH5_', num_session_str, '.csv');
    filename_sh6 = append(subject_str, '_SH6_', num_session_str, '.csv');

    % check whether filenames already exists to not overwrite any data
    counter = 1;
    while exist(filename_fp1, 'file')==2
        filename_fp1 = append(subject_str, '_fp1_', num_session_str, '_0', num2str(counter), '.csv');
        pause(0.5)
        counter = counter + 1;
    end
    
    
    counter = 1;
    while exist(filename_fp2, 'file')==2
        filename_fp2 = append(subject_str, '_fp2_', num_session_str, '_0', num2str(counter), '.csv');
        counter = counter + 1;
    end
    
    labels_FP = {'F_x', 'F_y', 'F_z', 'M_x', 'M_y', 'M_z'};
    labels_SH = {'A_x', 'A_y', 'A_z', 'G_x', 'G_y', 'G_z'};
    
    % saving received data in table
    make_table_wrench(data_m_fp1,filename_fp1, labels_FP);
    make_table_wrench(data_m_fp2,filename_fp2, labels_FP);
    make_table_point(data_m_CoP1,filename_CoP1);
    make_table_point(data_m_CoP2,filename_CoP2);
    make_table_wrench(data_m_sh1,filename_sh1, labels_SH);
    make_table_wrench(data_m_sh2,filename_sh2, labels_SH);
    make_table_wrench(data_m_sh3,filename_sh3, labels_SH);
    make_table_wrench(data_m_sh4,filename_sh4, labels_SH);
    make_table_wrench(data_m_sh5,filename_sh5, labels_SH);
    make_table_wrench(data_m_sh6,filename_sh6, labels_SH);

    disp('Data saved.')
    
    pause(0.5)

    close all
end



function saveFP1Message(~,msg)

    global data_m_fp1
    global a
%     global duration
%     global reached
    data_m_fp1(a) = [msg];
    a = a + 1;
%     if data_m_fp1(1,1).Header.Stamp.Nsec < 10000000
%         if (msg.Header.Stamp.Sec == (data_m_fp1(1,1).Header.Stamp.Sec + duration - 1)) && (msg.Header.Stamp.Nsec == data_m_fp1(1,1).Header.Stamp.Nsec + 990000000)
%             reached = 1;
%         end
%     else
%         if (msg.Header.Stamp.Sec == (data_m_fp1(1,1).Header.Stamp.Sec + duration)) && (msg.Header.Stamp.Nsec == data_m_fp1(1,1).Header.Stamp.Nsec - 10000000)
%             reached = 1;
%         end
%        
%     end
end


function saveFP2Message(~,msg)

    global data_m_fp2
    global b  
%     global duration
%     global reached
    data_m_fp2(b) = [msg];
    b = b + 1;
%     if data_m_fp2(1,1).Header.Stamp.Nsec < 10000000
%        if (msg.Header.Stamp.Sec == (data_m_fp2(1,1).Header.Stamp.Sec + duration - 1)) && (msg.Header.Stamp.Nsec == data_m_fp2(1,1).Header.Stamp.Nsec + 990000000)
%             reached = 1;
%        end
%     else
%        if (msg.Header.Stamp.Sec == (data_m_fp2(1,1).Header.Stamp.Sec + duration)) && (msg.Header.Stamp.Nsec == data_m_fp2(1,1).Header.Stamp.Nsec - 10000000)
%             reached = 1;
%        end
% 
%     end
   
end

function saveCoP1Message(~,msg)
    global data_m_CoP1
    global c  
    data_m_CoP1(c) = [msg];
    c =c+1;
end 
function saveCoP2Message(~,msg)
    global data_m_CoP2
    global d  
    data_m_CoP2(d) = [msg];
    d = d+1;
end 

function saveSH1Message(~,msg)
    global data_m_sh1
    global e  
    data_m_sh1(e) = [msg];
    e = e+1;
end
function saveSH2Message(~,msg)
    global data_m_sh2
    global f  
    data_m_sh2(f) = [msg];
    f = f+1;
end
function saveSH3Message(~,msg)
    global data_m_sh3
    global g  
    data_m_sh3(g) = [msg];
    g = g+1;
end
function saveSH4Message(~,msg)
    global data_m_sh4
    global h  
    data_m_sh4(h) = [msg];
    h = h+1;
end
function saveSH5Message(~,msg)
    global data_m_sh5
    global i  
    data_m_sh5(i) = [msg];
    i = i+1;
end
function saveSH6Message(~,msg)
    global data_m_sh6
    global j  
    data_m_sh6(j) = [msg];
    j = j+1;
    if (abs(data_m_sh6(1,1).Header.Stamp.Nsec - msg.Header.Stamp.Nsec) < 10000000)
       fprintf('%d seconds of data are collected.\n',msg.Header.Stamp.Sec)
    end
    disp(msg)
end
    
