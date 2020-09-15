%% Main ROS subscriber suing ROS 
% node which is subscribing to topics from the chair sending data from:
%   - 2 arm rails:
%           - topic AR1 and AR2
%           - ROS message format: geometry_msgs/WrenchStamped
%           
%   - 2 force plates (not added yet): 
%           - topic FP1 and FP2
%           - ROS message format: still needs to be defined
%   Data is saved in seerate csv-files.
%
% GUIDE: type rosinit('<URI of the ROS Master>');
%        type in the amount of time you want your measured data to have in ENTER VALUES;
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
%% Initiation process

global reached 
reached = 0;

% defining global counting variables for topics AR1 and AR2
global n 
n = 1;

global m
m = 1;
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
    AR1_sub = rossubscriber("/AR1", "geometry_msgs/WrenchStamped");
    AR2_sub = rossubscriber("/AR2", "geometry_msgs/WrenchStamped");
    
    % defining the arrays for saving incoming data
    global data_m_ar1
    global data_m_ar2
    data_m_ar1 = arrayfun(@(~) rosmessage('geometry_msgs/WrenchStamped'),zeros(1,2));
    data_m_ar2 = arrayfun(@(~) rosmessage('geometry_msgs/WrenchStamped'),zeros(1,2));
    
    % defining callback of subscribers
    AR1_sub.NewMessageFcn = @saveAR1Message;
    AR2_sub.NewMessageFcn = @saveAR2Message;
    
    global active
    active = 1;
    disp('Connection to publisher established.')
end

% helping variable active keeps script running while Callbacks are executed
while active == 1
    start_n = n;
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
    clear AR1_sub
    clear AR2_sub
    
    num_session = data_m_ar1(1,1).Header.Seq;
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

    filename_ar1 = append(subject_str, '_ar1_', num_session_str, '.csv');
    filename_ar2 = append(subject_str, '_ar2_', num_session_str, '.csv');

    % check whether filenames already exists to not overwrite any data
    counter = 1;
    while exist(filename_ar1, 'file')==2
        filename_ar1 = append(subject_str, '_ar1_', num_session_str, '_0', num2str(counter), '.csv');
        counter = counter + 1;
    end

    counter = 1;
    while exist(filename_ar2, 'file')==2
        filename_ar2 = append(subject_str, '_ar1_', num_session_str, '_0', num2str(counter), '.csv');
        counter = counter + 1;
    end
    
    
    % preparing received data for saving it in a table
    header_ar1 = [data_m_ar1(1:end).Header];
    header_tbl_ar1 = ros1_header2table(header_ar1);
    wrench_ar1 = [data_m_ar1(1:end).Wrench];
    wrench_tbl_ar1 = ros1_wrench2table(wrench_ar1);
    
    header_ar2 = [data_m_ar2(1:end).Header];
    header_tbl_ar2 = ros1_header2table(header_ar2);
    wrench_ar2 = [data_m_ar2(1:end).Wrench];
    wrench_tbl_ar2 = ros1_wrench2table(wrench_ar2);
  
    temp_table_ar1 = horzcat (header_tbl_ar1, wrench_tbl_ar1);
    temp_table_ar2 = horzcat (header_tbl_ar2, wrench_tbl_ar2);
    
    % save tables as csv file
    writetable(temp_table_ar1, filename_ar1, 'Delimiter',',')
    writetable(temp_table_ar2, filename_ar2, 'Delimiter',',')

    disp('Data saved.')
    
    pause(0.5)

    close all
end



function saveAR1Message(~,msg)

    global data_m_ar1
    global n
    global duration
    global reached
    data_m_ar1(n) = [msg];
%     data_m_ar1 = [data_m_ar1; msg];
    n = n + 1;
    if data_m_ar1(1,1).Header.Stamp.Nsec < 10000000
        if (msg.Header.Stamp.Sec == (data_m_ar1(1,1).Header.Stamp.Sec + duration - 1)) && (msg.Header.Stamp.Nsec == data_m_ar1(1,1).Header.Stamp.Nsec + 990000000)
            reached = 1;
        end
    else
        if (msg.Header.Stamp.Sec == (data_m_ar1(1,1).Header.Stamp.Sec + duration)) && (msg.Header.Stamp.Nsec == data_m_ar1(1,1).Header.Stamp.Nsec - 10000000)
            reached = 1;
        end
       
    end
    if data_m_ar1(1,1).Header.Stamp.Nsec == msg.Header.Stamp.Nsec
       fprintf('%d seconds of data are collected.\n',msg.Header.Stamp.Sec)
    end
end


function saveAR2Message(~,msg)

    global data_m_ar2
    global m  
    global duration
    global reached
    data_m_ar2(m) = [msg];
%     data_m_ar2 = [data_m_ar2; msg];
    m = m + 1;
    if data_m_ar2(1,1).Header.Stamp.Nsec < 10000000
       if (msg.Header.Stamp.Sec == (data_m_ar2(1,1).Header.Stamp.Sec + duration - 1)) && (msg.Header.Stamp.Nsec == data_m_ar2(1,1).Header.Stamp.Nsec + 990000000)
            reached = 1;
       end
    else
       if (msg.Header.Stamp.Sec == (data_m_ar2(1,1).Header.Stamp.Sec + duration)) && (msg.Header.Stamp.Nsec == data_m_ar2(1,1).Header.Stamp.Nsec - 10000000)
            reached = 1;
       end

    end
   

end