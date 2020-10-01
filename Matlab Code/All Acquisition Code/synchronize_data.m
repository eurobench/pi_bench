function [Synch_chair_data, Synch_shimmer_data, chair_labels, shimmer_labels] = synchronize_data(chair_data, data_sh,fsamp_sh)

%[Synch_chair_data, Synch_shimmer_data] = synchronize_data(chair_data, data_sh,fsamp_sh)
%
%INPUTS:
%
%chair_data: raw data from the force plates (the first output of synch_acq.m)
%
%data_sh: raw data from the shimmer sensors (the second output of synch_acq.m)
%
%fsamp_sh: sampling frequency of the shimmer sensors
%
%OUTPUTS:
%
%Synch_chair_data: a matrix containing data from the two force plates.
%
%Synch_shimmer_data: a cell array containing data from the shimmer sensors
%in each cell. The last shimmer is only for synchronization purposes
%
%chair_labels: label for each column of the Synch_chair_data matrix
%
%shimmer_labels: label for each column of each cell within the
%Synch_chair_data cell array
%
%Cristiano De Marchis, BENCH Project, July 2020


for i = 1:length(data_sh)
    data_sh{i}(:,2) = linspace((data_sh{i}(end,2)/1000-length(data_sh{i})/fsamp_sh),data_sh{i}(end,2)/1000,length(data_sh{i}));
end

tinit = cell2mat(cellfun(@(x) x(1,2),data_sh,'uniformoutput',false));
tend = cell2mat(cellfun(@(x) x(end,2),data_sh,'uniformoutput',false));

[mm,idx_init] = max(tinit);
 tref_init = data_sh{idx_init}(:,2);
[mm,idx_end] = min(tend);
 tref_end = data_sh{idx_end}(:,2);

for i = 1:length(data_sh)
    [mm,idx_cut] = min(abs(data_sh{i}(:,2)-tref_init(1)));
    data_sh{i} = data_sh{i}(idx_cut:end,:);
end

for i = 1:length(data_sh)
    [mm,idx_cut] = min(abs(data_sh{i}(:,2)-tref_end(end)));
    data_sh{i} = data_sh{i}(1:idx_cut,:);
end


%synchronize shimmer sensors with ni daq usign triger signal

trigger_ni = chair_data(:,1)-mean(chair_data(:,1));
trigger_ni = abs(trigger_ni)./max(abs(trigger_ni));
trigger_sh = data_sh{end}(:,end-1)-mean(data_sh{end}(:,end-1));
trigger_sh = abs(trigger_sh)./max(abs(trigger_sh));

init_ni = min(find(diff(trigger_ni)<-0.3));
stop_ni = max(find(diff(trigger_ni)>0.3));

init_sh = min(find(diff(trigger_sh)<-0.3));
stop_sh = max(find(diff(trigger_sh)>0.3));

Synch_chair_data = chair_data(init_ni:stop_ni,2:end);
Synch_shimmer_data = cellfun(@(x) x(init_sh:stop_sh,3:8),data_sh,'uniformoutput',false);

chair_labels = {'Fx_seat','Fy_seat','Fz_seat','Mx_seat','My_seat','Mz_seat','CoPx_seat','CoPy_seat','Fx_feet','Fy_feet','Fz_feet','Mx_feet','My_feet','Mz_feet','CoPx_feet','CoPy_feet'};
shimmer_labels = {'Ax','Ay','Az','Gx','Gy','Gz'};

