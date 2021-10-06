function PI = computePI_30sts(csv_data_file, csv_calib_file, result_dir)
  
% computeOI_30sts.m
%
% Given a csv file and anthropomorphic yml file, computes seven PI for the
% assesment of sit-to-stand performance related to the 30sts protcol
%
%The input csv_data_file contains the data from a single trial
%The second csv input file is the one recored during the calibration
%
% The BENCH Team: Cristiano De Marchis, Leonardo Gizzi, Giacomo Severini
% November 2020

isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

    if isOctave
        disp('Using Octave')
        pkg load io
        pkg load signal
        pkg load mapping
        pkg load statistics
    else
        disp('Using Matlab')
    end

    % get the csv data and calculate kinematics
    
    calib = csv2cell(csv_calib_file);
    data = csv2cell(csv_data_file);
    header = data(1, :);
    
    calib = cell2mat(calib(2:end, :));
    data = cell2mat(data(2:end, :));
    
    fsamp = round((length(data(:,1))-1)/data(end,1));
    
    calib(1,:) = [];
    data(1, :) = [];
    
    delta_t = diff(data(:, 1));
    fsamp = 1.0/mean(delta_t);
    
    idx = [2:4 10:12];
    
    for i = 1:length(idx)
      data(:,idx(i)) = (data(:,idx(i))-mean(calib(:,idx(i))))/0.025;
    end
    
    
    calibration_params = calibration(calib,isOctave);
    [kinematics, kin_labels] = joint_kinematics(data,calibration_params, fsamp);
    
    [filepath, filename, ext] = fileparts(csv_data_file);
    

    protocol = false;

    
    
    %computes the PIs
    
    sts_metrics = calculate_sts_metrics(data, kinematics, fsamp, protocol);
    
    types = {"scalar\n", "array of scalars\n", "vector\n"};
      
    labels = strcat("",'\n');  
    filename = strcat(result_dir, "/", "30sSTS_repetitions", ".yaml")
    store_vector(filename, sts_metrics{1}, labels, types{1});

    labels = strcat("{Flexion Momentum, Momentum Transfer, Extension}",'\n');
    filename = strcat(result_dir, "/", "subphases_duration", ".yaml")
    store_vector(filename, sts_metrics{2}, labels, types{2});

    labels = strcat("",'\n');
    filename = strcat(result_dir, "/", "CoP_stability", ".yaml")
    store_vector(filename, sts_metrics{3}, labels, types{1});

    labels = strcat("",'\n');
    filename = strcat(result_dir, "/", "ult_time", ".yaml")
    store_vector(filename, sts_metrics{4}, labels, types{1});

    labels = strcat("{antero-posterior, medio-lateral}",'\n');
    filename = strcat(result_dir, "/", "ult_overshoot", ".yaml")
    store_vector(filename, sts_metrics{5}, labels, types{2});

    labels = strcat("{Ankle, Knee, Hip, Trunk}",'\n');
    filename = strcat(result_dir, "/", "kinematic_repeatability", ".yaml")
    store_vector(filename, sts_metrics{6}, labels, types{2});
    
    labels = strcat("",'\n');
    filename = strcat(result_dir, "/", "CoM_work", ".yaml")
    store_vector(filename, sts_metrics{7}, labels, types{1});
    
    
    PI = sts_metrics;
    
endfunction
