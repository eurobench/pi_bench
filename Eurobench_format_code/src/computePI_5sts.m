function PI = computePI_5sts(csv_data_file, csv_calib_file, result_dir)
  
% computeOI_5sts.m
%
% Given a csv file and anthropomorphic yml file, computes seven PI for the
% assesment of sit-to-stand performance related to the 5sts protcol
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
        # pkg load mapping
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
    
    
    calibration_params = calibration(calib,isOctave);
    [kinematics, kin_labels] = joint_kinematics(data,calibration_params, fsamp);
    
    [filepath, filename, ext] = fileparts(csv_data_file);
    

    protocol = true;
    
    
    %computes the PIs
    
    sts_metrics = calculate_sts_metrics(data, kinematics, fsamp, protocol);
    
    types = {"scalar\n", "array of scalars\n", "vector\n"};
    
    filename = strcat(result_dir, "/", "5STS_duration", ".yaml")
    store_scalar(filename, sts_metrics{1});

    labels = "Flexion Momentum, Momentum Transfer, Extension";
    filename = strcat(result_dir, "/", "subphases_duration", ".yaml")
    store_vector(filename, sts_metrics{2}, labels);

    filename = strcat(result_dir, "/", "CoP_stability", ".yaml")
    store_scalar(filename, sts_metrics{3});

    filename = strcat(result_dir, "/", "ult_time", ".yaml")
    store_scalar(filename, sts_metrics{4});

    filename = strcat(result_dir, "/", "ult_overshoot", ".yaml")
    store_scalar(filename, sts_metrics{5});

    labels = "Ankle, Knee, Hip, Trunk";
    filename = strcat(result_dir, "/", "kinematic_repeatability", ".yaml")
    store_vector(filename, sts_metrics{6}, labels);
    
    labels = "";
    filename = strcat(result_dir, "/", "CoM_work", ".yaml")
    store_vector(filename, sts_metrics{7}, labels);

    PI = sts_metrics;
    
endfunction
