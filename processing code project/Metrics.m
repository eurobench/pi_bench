% -----------------------------------------------------------------------------------------------------------------------------------
%In this file, FP1 is the one on the ground!


%preliminary declarations
Fs = 100; %Sampling freuquency %check if the assumption is correct and/or if we can read it from the file

%--------------------------------------------------------------------------
%read data files
function [anthropometrics] = read_anthropometrics(subject_file) %how is the anthropometrics data arranged?
%read the anthropometric features of the subject from the record file where
%they are stored. 

anthropometrics = [];
fprintf('we need to read anthropometric data, but the fucntion is not ready yet!');
%what is the format of anthropometric data?
end


function [FP1, FP2, handrail_L, handrail_R,back_sensor, accel] = read_sensor_data(data_file) %how is the sensor data arranged?
%Preliminary indexing
ind_plate_1 = 1:6;
ind_plate_2 = 7:13;
ind_handrail_L = 14; %made up
ind_handrail_L = 15; %made up

ind_back  = 51; %MADE UP!!!
ind_acc = 20:40; %MADE UP!!!!

%load .CSV
temp_data = importdataI(data_file);

%parse data
FP1 = temp_data(:,ind_plate_1);
FP2= temp_data(:,ind_plate_2);
handrail_L  = temp_data(:,ind_handrail_L);
handrail_R  = temp_data(:,ind_handrail_R);
back_sensor = temp_data(:, ind_back);
accel = temp_data(:,ind_acc);
end




function [start,stop] = segmentation(FP1, FP2,duration, Fs) %incomplete
%provides the start and stopping frame of the current session
%input data are the forces from the plates
%the output are the starting and stopping frame of the current session

switch nargin %create default values if the inputs are not complete
    case 2
        duration = 10; Fs  = 100;
    case 3
        Fs = 100;
end

%calculate coop coordinates
CoP_coords = mean(compute_CoP(FP1),compute_CoP(FP2)); %CHECK if the formula is correct

%Identifies the starting frame at least 10s before the first functional 
%movement on the chair (to guarantee the calculation of sit stability). 
%The first functional movement is identified based on a significant 
%deflection from the baseline, by using the FP on the seat


%Identifies the stopping frame at least 10s after the last functional movement on the chair (to guarantee the calculation of the stand stability). The last functional movement is identified based on a standing force plateau on the feet FP. 
end
%--------------------------------------------------------------------------------------------------------------------------------


%Implementation: seat stability is the distance traveled by the CoP on a 10s period after start, (normalized by the subject's height?). Stand stability is the same, in standing position, before stop.

% -----------------------------------------------------------------------------------------------------------------------------------
function [joint_angles] = kinematics(IMUs_markers, start,stop) %to be done
joint_angles = [];
fprintf('The subphases have not been computed yet')

%!!!!!!!!!!!!!!!!!!! Do we need anthropometrics, here?!!!!!!!!!!!!!!!!!!!!
%calculates joint kinematics. Joint angles is a matrix containing the ankle plantar-flexion angle, knee flexion-extension angle, hip flexion extension angle, and trunk angle
%input data are the signals from accelerometers and gyros (or the markers trajectories in case of stereophotogrammetric measurement), together with the start and stop frames of the trial
%Implementation: gyro integration strategy +  correction. 
end

% -----------------------------------------------------------------------------------------------------------------------------------
function [subphases] = segment_STS(start,stop,joint_angles,FPs) %to be done
subphases = [];
fprintf('The subphases have not been computed yet')

%determines the single subphases of the sts task starting from the force FPs signals and IMU measurements, and based on Carhuters et al. (from Shekeman et al 1990). Subphases is a 4byN matrix, in which 4 are the starting frames of each subphases (events), and N is the number of identified repetitions in the trial
% Implementation: four events need to be determined
% 1: t0: in each sts cycle, the start can be determined by the seat FP COP, or by the initial trunk bending
% 2: lift-off: easily detected when the COP vertical force of the seat FP goes to 0
% 3: maximum ankle dorsiflexion: corresponds to the point at which the shank bends over the foot, generating a maximum ankle dorsiflexion. Needs the previous calculation of the kinematics
% 4: full hip extension: need the previous calculation of the kinematics. When the hip is fully extended, the sit-to-stand cycle ends. A subsequent beginning of the hip flexion identifies the beginning of the stand-to-sit cycle
end

% -----------------------------------------------------------------------------------------------------------------------------------
 function [time] = sts_duration(start,stop,subphases) %to be done
%determines the duration for the 5STS protocol
% Starting from the identified subphases, calculates the time elapsed between the t0 of the first sit-to-stand and the end of the 5th stand-to-seat (technically this should correspond, in 5sts literature, to the buttocks contact with the chair, and not the complete seat stabilization)
 end
 
% -----------------------------------------------------------------------------------------------------------------------------------
function [number_of_sts] = sts_counter(initial_frame, last_frame, subphases) %to be done
%counts the number of completed sts cycles between the two input frames. In the case of the 30s STS, only the initial_frame is needed, and it correspond to the â€œgoâ€? signal. Last frame will be initial_frame+30s
% Implementation: simply counts the number of completed cycles.
end

% -----------------------------------------------------------------------------------------------------------------------------------
function [load_transf] = load_transfer(FP1, FP2) %to be done
% Unidirectional Load transfer time 
%definition: the time betwee the beginning of the movement and the moment
%the body touches or leaves the seat plate
load_transf = [];
fprintf('This function computes the load transfer and is not implemented yet')

end
% -----------------------------------------------------------------------------------------------------------------------------------
 function [os] = overshoot(AP, start_ind, CoPx) %to be tested
 %definition: the overshoot is defined as the distance travelled by the
 %CoP after it has passed the vertical stance, and until it starts coming back
 %to the vertical stance
 %vertical stance is defined as the position of CoP when AP == 0 (where AP 
 %is the force in the the antero-posterior)
 
 %start_ind is inherited from phases segmentation?

 %ignore anything that happened before the start
 AP(1:start_ind) = NaN; 

 %find AP == 0 for the first time --> index of vertical stance
 t = find(AP==0);
 vert_ind = t(1); clear (t)
%ignore anything that happened before verd_ind
 AP(1:vert_ind) = NaN; 
 
 
 %find diff(AP) = 0 --> index of direction change
 t = diff(AP); inv = find(t==0); 
 first_inversion = inv(1); %find the first inversion
 os =abs( CoPx(vert_ind)- CoPx(first_inversion));
 fprintf('This function computes the overshoot and is not implemented yet')
 end
% -----------------------------------------------------------------------------------------------------------------------------------
 function [joint_moments] = inverse_dynamics(IMU, kinematics,FPs, start, stop)
 end
% -----------------------------------------------------------------------------------------------------------------------------------
function time_br = compute_backrest(start, stop, back_sensor, Fs)
%the signal from the back rest sensor is supposed to be 0 when there is no
%contact, 1 when there is contact. 
    temp = back_sensor(start:stop); %segment the data
    time_br = count(temp(temp>0))/Fs; %compute the time of resting
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% ACCESSORY FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
function CoP_coords = compute_CoP(FP) %UPDATE FORMULA
%calculate the CoP coordinates for a single FP, each FP signal is expected 
%to come in the format Fx Fy Fz, Mx My Mz (the order is assumed)
Fx = FP(1,:);
Fy = FP(2,:);
Fz = FP(3,:);
Mx = FP(4,:);
My = FP(5,:);
Mz = FP(6,:);v

dx = 600; dy = 400; %flip if appropriate
COPx = (My-Fx*dx)/Fz;
COPy = (Mx-Fy*dy)/Fz;
CoP_coords = [COPx, COPy];
end


function [stability] = compute_stability(FP1, FP2,start,stop)
%provides the stability values. The same function is called once for each
%subphases of each cycle.
%input data are the forces from the plates and the start/stop frames from the segmentation function
%the outputs is the stability value, calculated as the CoP travel distance normalized by height 
stability = [];
fprintf('The stability has not been computed yet')
end

