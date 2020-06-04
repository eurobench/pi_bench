%% Local acquiring of data via AD-Converter and saving it into csv file
% Acquiring the raw data of the chair consisting of:
%   - 2 arm rails:
%           - topic AR1 and AR2
%   - 2 force plates (not added yet): 
%           - topic FP1 and FP2
%   Raw data is saved in a csv file as well.
%
% GUIDE: enter the needed values in the section ENTER VALUES then run script;
%        if the acqusition should have a special duration, set iscont = 0,
%        type in duration and run the script
%        if the acqusition should be conitnous, set iscont = 1 and run the script; 
%        to stop the acquisition type any button while having the figure opened

clearvars -except num_session 
close all

%% ENTER VALUES
% ENTER SUBJECT NUMBER HERE
subject = 1;
% ENTER WHETHER RECORDING IS CONTINOUS OR TAKES A SPECIAL DURATION
iscont = 1;
duration =  2; %not necessary to be typed in when acquisition is continous
%% Initiation process
% sessions are counted after starting matlab
if exist('num_session', 'var')
    num_session = num_session + 1;
else
    num_session = 1;
end

if subject < 10
    subject_str = append('subject_0', num2str(subject));
else
    subject_str = append('subject_', num2str(subject));
end

if num_session < 10
    num_session_str = append('0', num2str(num_session));
else
    num_str = num2str(num_session);
end

%set up variables for acquiring data
devicename = 'Dev2'; % Dev1 real device, Dev2 simulated device
channels = (1:14); % when measuring 2 AR
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
%s.UserData.frames = frame;

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
% log file  
tbl = array2table(s.UserData.signals(:, 1:13));
tbl.Properties.VariableNames = {'time','F_x_ar1','F_y_ar1','F_z_ar1', 'T_x_ar1','T_y_ar1','T_z_ar1', 'F_x_ar2','F_y_ar2','F_z_ar2', 'T_x_ar2','T_y_ar2','T_z_ar2'};

writetable(tbl, filename, 'Delimiter',',')


delete(lh);
disp('Recording stopped and data saved.')
close all 
    
function addUserData(src,evt) 
    % collect available data
    data = [evt.TimeStamps, evt.Data]; % every 0.1s updated --> fsample/10 amount of data rows
    % save Data in Session
    src.UserData.signals = [src.UserData.signals;data];
end
