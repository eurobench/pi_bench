PURPOSE
The given code is reponsible for the data transmission in the Bench project with the help of matlab using ROS.
There exists a publisher which is responsible for acquiring and sending the data to a subscriber which is receiving the data as ROS messages.
One file being created is the raw data of the chair acquired by an AD-Converter running with a wished frequency (for the Publisher).
The sent data is saved in four files in total (for the subscriber).

PREREQUISITES
Installation of the following Software:
-Matlab Toolboxes:
	-Data Acquisition Toolbox
-	ROS Toolbox
- NI Software:
 	-NI MAX App
Necessary matlab files:
	-in the working directory of the publisher:
		- *AutomaticStop_ROS1_pub*
		- ROS_publish
	- in the working directory of the subscriber:
		- *final_ROS1_sub*
		- StartButton
		- StopButton
		- ros1_header2table
		- ros1_wrench2table

GUIDE FOR USAGE
(given as well in the manual and in the main matlab files)
Publisher:
- The Publisher needs to open the matlab file AutomaticStop_ROS1_pub and follow these instructions:
	- type rosinit, which is making the publisher node the master node	
       	- enter the needed values in the section ENTER VALUES then run script
       	- if the acqusition should have a special duration, set iscont = 0, type in duration and run the script
        - if the acqusition should be continous, set iscont = 1 and run the script
        - to stop the acquisition type any button while having the figure opened
        - to close ROS node, type rosshutdown
Subscriber:
- The Subscriber needs to open the matlab file final_ROS1_sub and follow these instrcutions:
	- type rosinit('<URI of the ROS Master>')
        - type in the amount of time you want your measured data to have in ENTER VALUES
        - run script to start and stop streaming with the GUI
        - to close ROS node, type rosshutdown

ACKNOWLEDGEMENT
