function PI = computePI(csv_data_file, csv_calib_file, result_dir)
  
% compute_sts_PI.m
%
% Given a csv file and anthropomorphic yml file, computes seven PI for the
% assesment of sit-to-stand performance
%
%The input csv_data_file contains a string indicating the current protocol, that
%can be either '5sts' or '30sts'. 
%
%The second csv input file is the one recored during the calibration
%
% The BENCH Team: Cristiano De Marchis, Leonardo Gizzi, Giacomo Severini
% November 2020

isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

    if isOctave
        disp('Using Octave')
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
    
    
    calibration_params = calibration(calib,isOctave);
    [kinematics, kin_labels] = joint_kinematics(data,calibration_params, fsamp);
    
    [filepath, filename, ext] = fileparts(csv_data_file);
    
    if length(strfind(filename,'5sts')) > 0
      protocol = true;
    else
      protocol = false;
    end
    
    
    %computes the PIs
    
    sts_metrics = calculate_sts_metrics(data, kinematics, fsamp, protocol);
    
    if protocol
      
    filename = strcat(result_dir, "/", "5STS_duration", ".yaml")
    
    else
    
    filename = strcat(result_dir, "/", "30sSTS_repetitions", ".yaml")
    
    end
 
    store_vector(filename, sts_metrics{1});

    filename = strcat(result_dir, "/", "subphases_duration", ".yaml")
    store_vector(filename, sts_metrics{2});

    filename = strcat(result_dir, "/", "sts_CoP_stability", ".yaml")
    store_vector(filename, sts_metrics{3});

    filename = strcat(result_dir, "/", "ult_time", ".yaml")
    store_vector(filename, sts_metrics{4});

    filename = strcat(result_dir, "/", "ult_overshoot", ".yaml")
    store_vector(filename, sts_metrics{5});

    filename = strcat(result_dir, "/", "kinematic_repeatability", ".yaml")
    store_vector(filename, sts_metrics{6});
    
    filename = strcat(result_dir, "/", "CoM_work", ".yaml")
    store_vector(filename, sts_metrics{7});
    
    PI = sts_metrics;
    
endfunction
