%% Main ROS subscriber
% node which is subscribing to topics from the chair sending data from:
%   - 2 arm rails:
%           - topic AR1 and AR2
%           - ROS message format: geometry_msgs/WrenchStamped
%   - 2 force plates: 
%           - topic FP1 and FP2
%           - ROS message format: still needs to be defined
% GUIDE: run script to start and stop streaming with the GUI

clearvars -except num_session
close all

% definitions and set up of the ros subscribers
if exist('num_session', 'var')
    num_session = num_session + 1;
else
    num_session = 1;
end
 
filename_ar1 = sprintf('AR1_%d.csv', num_session);
filename_ar2 = sprintf('AR2_%d.csv', num_session);
n = 1;

sub_node = ros2node("/processing_node");

% subscribe to certain topics
AR1_sub = ros2subscriber(sub_node, "/AR1");
AR2_sub = ros2subscriber(sub_node, "/AR2");
% FP1_sub = ros2subscriber(sub_node, "/FP1");
% FP2_sub = ros2subscriber(sub_node, "/FP2");

%% set up GUI for controlling the streaming process
 
global streaming; %can be adjusted via GUI
streaming = 0;

uf = figure;
uf.Name = 'Streaming of gathered data';
uf.Position = [500 300 400 275];

% start streaming button
uicontrol('Style', 'pushbutton', 'Position', [50 175 125 50], 'String', 'Start Streaming', 'Callback', @StartButton);
% stop streaming button
uicontrol('Style', 'pushbutton', 'Position', [225 175 125 50], 'String', 'Stop Streaming', 'Callback', @StopButton);
% % exit button 
% uicontrol('Style', 'pushbutton', 'Position', [150 75 100 50], 'String', 'EXIT', 'Callback', @ExitButton);

%% Streaming process 
% wait until streaming is started
while streaming == 0 
    pause(0.1)
end


% after start button was pressed stream data
while streaming ==1
    
    data_ar1 = receive(AR1_sub, 5);
    data_m_ar1(n) = data_ar1;
    
    data_ar2 = receive(AR2_sub, 5);
    data_m_ar2(n) = data_ar2;
    
%     data_fp1 = receive(FP1_sub, 5);
%     data_m_fp1(n) = data_fp1;
%     
%     data_fp2 = receive(FP2_sub, 5);
%     data_m_fp2(n) = data_fp2;
    
    n = n+1;

end

% when stop button was pressed save data
if streaming == 2 
    disp('Streaming stopped.')
    
    % saving messages in table
    % preparing data AR1
    header_ar1 = [data_m_ar1(1:end).header];
    header_tbl_ar1 = header2table(header_ar1);
    wrench_ar1 = [data_m_ar1(1:end).wrench];
    wrench_tbl_ar1 = wrench2table(wrench_ar1);
    
    % preparing data AR2
    header_ar2 = [data_m_ar2(1:end).header];
    header_tbl_ar2 = header2table(header_ar2);
    wrench_ar2 = [data_m_ar2(1:end).wrench];
    wrench_tbl_ar2 = wrench2table(wrench_ar2);
    
    temp_table_ar1 = horzcat (header_tbl_ar1, wrench_tbl_ar1);
    temp_table_ar2 = horzcat (header_tbl_ar2, wrench_tbl_ar2);
    
    % save tables as csv file
    writetable(temp_table_ar1, filename_ar1, 'Delimiter',',')
    writetable(temp_table_ar2, filename_ar2, 'Delimiter',',')
    disp('Data saved.')
    
    pause(0.5)

    close all
end

