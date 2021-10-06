function sts_metrics = calculate_sts_metrics(data, kinematics, fsamp, protocol)
  
    if protocol
      duration_5sts = sts_duration_5sts(data, kinematics,fsamp);
      PI1 = duration_5sts;
    else
      ncycles = repetitions_30sSTS(kinematics, fsamp);
      PI1 = ncycles;
    end
    
    %computes all the other PIs, common to both protocols
    
    [subphases,points] = segment_sts(data, kinematics, fsamp);
    CoP_dist = sts_CoP_stability(data, points);
    [ult_os,ult_time] = unidirectional_load_transfer(data, points, fsamp);
    kinematic_reg = kinematic_repeatability(kinematics,fsamp);
    CoM_work = tot_mech_pwr(data,kinematics);
    
    sts_metrics = {[PI1],[subphases],[CoP_dist],[ult_time],[ult_os'],[kinematic_reg],[CoM_work]};
  
endfunction
