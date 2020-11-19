## Instructions for using the testing dataset
The testing folder contains five .csv files, including data from 2 subjects:

-	Subject01_calib_chair_raw_01.csv – contains the data from the calibration procedure for subject01. It is used for calculating the calibration parameters for the subsequent estimation of the joint kinematics in the sagittal plane. 
-	Subject01_5sts_chair_raw_01.csv – contains the data from a single 5STS trial of subject01
-	Subject01_30sts_chair_raw_01.csv – contains the data from a single 30sSTS trial of subject01
-	Subject02_calib_chair_raw_01.csv – contains the data from the calibration procedure for subject02. It is used for calculating the calibration parameters for the subsequent estimation of the joint kinematics in the sagittal plane. 
-	Subject02_5sts_chair_raw_01.csv – contains the data from a single 5STS trial of subject02

These files have been generated at the end of a single trial with the BENCH apparatus, and they can be used for the calculation of the metrics in **Octave**. All the necessary pre-processing steps and metrics calculation are performed within the main.m script. 
The files are loaded trough a dialog window launching the main.m script. As the metrics calculation requires some mandatory pre-processing steps, the first file to be loaded is *Subject0X_calib_chair_raw_01.csv*. The script calculates the calibration parameters. 
Then, once the calibration parameters are stored in the Octave workspace, one of the files from *subject0X* can be loaded for metrics computation and graphical representation of the scores. 
The type of protocol (i.e. 5sts or 30sts) is automatically detected when the file is loaded, since it is indicated in the filename (it can be “calib”, “5sts” or “30sts”). 
Besides the testing .csv files, the testing folder contains the following files:
-	20201020_BENCH_PIs.xlsx – the excel file containing the list of the implemented PIs

-	Protocols.docx – a file containing a narrative description of the performance indicators

-	calibration.m – octave function of calculating the calibration parameters from the data contained in the Subject01_calib_chair_raw_01.csv file

-	joint_kinematics.m - octave function for calculating the ankle, knee, hip and trunk kinematics from a trial file


-	kinematic_repeatability.m - octave for calculating the PI6

-	main.m –octave script managing file loading, preprocessing, PIs calculation and graphical representation of the performance indicators


-	repetitions_30sSTS.m –octave function for calculating PI1 for the 30sts protocol

-	segment_sts.m - octave function for calculating PI2 in both protocols


-	sts_CoM.m - octave function recalled during the calculation of PI7 in both protocols

-	sts_CoP_stability.m - octave function for calculating PI3 in both protocols


-	sts_duration_5sts.m - octave function for calculating PI1 for the 5sts protocol

-	tot_mech_pwr.m - octave function for calculating PI7 in both protocols


-	unidirectional_load_transfer.m - octave function for calculating PI4 and PI5 in both protocols

-	labels.mat – a .mat file containing the labels of the 53 data channels


-	subject_01_5sts_PI_results.mat – a .mat file containing the results from the PI computation from the 5sts trial of subject01

-	subject_01_30sts_PI_results.mat – a .mat file containing the results from the PI computation from the 30sts trial of subject01


-	subject_02_5sts_PI_results.mat – a .mat file containing the results from the PI computation from the 5sts trial of subject02


The calculation of the Performance indicators via the main.m script will pop up 7 figures, organized from upper left to bottom right of the screen, and reporting the graphical representation of the seven calculated PIs for the current trial. 
The .csv files containing all the data recorded by the BENCH device are equal to those received via ROS by a subscriber when a recording trial is launched. In this testing dataset, they are considered as already transmitted and ready for the processing and PI calculation.



