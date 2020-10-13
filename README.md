﻿## Purposes

The given code is responsible for the data transmission in the Bench project with the help of matlab using ROS.
There exists a publisher which is responsible for acquiring and sending the data to a subscriber which is receiving the data as ROS messages to different topics.

## Installation

Installation of the following Matlab Toolboxes is necessary:

-	Data Acquisition Toolbox
-	ROS Toolbox

Installation of the following NI Software is necessary:

-	NI MAX App ([Link to Download])

[Link to Download]: https://www.ni.com/de-de/support/downloads/drivers/download.ni-daqmx.html#288283

## Usage

There exists a publisher and a subscriber on two different machines.

The Publisher needs to open the matlab file `AutomaticStop_ROS1_pub`  and follow these instructions:

-	create a Master ROS node:

	 ```console
	 rosinit
	 ```

-	enter the needed values in the section **ENTER VALUES**

	 ```console
	%% ENTER VALUES
		% ENTER SUBJECT NUMBER HERE
		subject = 1;
		% ENTER WHETHER RECORDING IS CONTINOUS OR TAKES A SPECIAL DURATION
		iscont = 0;
		duration =  5;
	 ```

-	 if the acquisition should have a special duration, set `iscont = 0`, type in duration and run the script
-	 if the acquisition should be continous, set `iscont = 1` and run the script
-	 to stop the acquisition type any button while having the figure opened
-	 close the ROS node:

	 ```console
	 rosshutdown
	 ```

 The Subscriber needs to open the matlab file `final_ROS1_sub` and follow these instructions:

-	 connect to the ROS Master

	 ```console
	 rosinit('<URI of the ROS Master>')
	 ```

	-	 type in the amount of time you want your measured data to have in **ENTER VALUES**

 ```console
	%%ENTER VALUES
	% ENTER SUBJECT NUMBER HERE
	subject = 1;
	% TYPE IN DURATION  YOU WANT TO RECEIVE DATA FROM
	global duration
	duration = 5;
 ```

-	 run script to start and stop streaming with the GUI
-	 close the ROS node:

	 ```console
	 rosshutdown
	 ```

## Acknowledgements
![Eurobench Logo](http://eurobench2020.eu/wp-content/uploads/2018/06/cropped-logoweb.png)
     

Supported by Eurobench - the European robotic platform for bipedal locomotion benchmarking.
More information: [Eurobench website][eurobench_website]

![EU Flag](http://eurobench2020.eu/wp-content/uploads/2018/02/euflag.png)

This project has received funding from the European Union’s Horizon 2020
research and innovation programme under grant agreement no. 779963.

The opinions and arguments expressed reflect only the author‘s view and
reflect in no way the European Commission‘s opinions.
The European Commission is not responsible for any use that may be made
of the information it contains.

[eurobench_logo]: http://eurobench2020.eu/wp-content/uploads/2018/06/cropped-logoweb.png
[eurobench_website]: http://eurobench2020.eu "Go to website"


