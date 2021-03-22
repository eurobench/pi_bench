function connectshimmer(sh, fsamp_sh, synch_flag)


sh.connect;
pause(2);
sh.setsamplingrate(fsamp_sh);
pause(2);
sh.enabletimestampunix(1);
pause(2);

SensorMacros = SetEnabledSensorsMacrosClass;


if synch_flag == 1
    
    sh.setinternalboard('EMG');
    pause(1);
    sh.setenabledsensors('LowNoiseAccel',1,'Gyro',1,'Mag',0,'WideRangeAccel',0,'EMG',1);
else
    sh.setenabledsensors('LowNoiseAccel',1,'Gyro',1,'WideRangeAccel',0,'Mag',0);
end

pause(3);

