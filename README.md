## Purposes

The given code is responsible for the data transmission in the Bench project with the help of matlab using ROS.
There exists a publisher which is responsible for acquiring and sending the data to a subscriber which is receiving the data as ROS messages to different topics.

## Installation

Installation of the following Matlab Toolboxes is necessary:

+ Data Acquisition Toolbox
+ ROS Toolbox

Installation of the following NI Software is necessary:

+ NI MAX App ([Link to Download])

[Link to Download]: https://www.ni.com/de-de/support/downloads/drivers/download.ni-daqmx.html#288283

## Usage

There exists a publisher and a subscriber on two different machines.

The Publisher needs to open the matlab file `Main_Publisher`  and follow these instructions:

+ create a Master ROS node:

			rosinit


+ enter the needed values in the section **ENTER VALUES**:


			% ENTER SUBJECT NUMBER HERE
			subject = 1;
			COMPORT = {'COM1', 'COM2'};

+ run the script

+ a figure will pop up indicating that the acquisition has started: to stop the acquisition type any button while having the figure opened

+ data will be sent and saved in an according folder named after the subject number

+ after the script stopped running automatially, close the ROS node:


			rosshutdown


 The Subscriber needs to open the matlab file `Main_Subscriber` and follow these instructions:

+ fill out the part **ENTER VALUES** with the subject number and the master's ip address or ROS URI of the master node to connect to the master


			% ENTER SUBJECT NUMBER HERE
			subject = 1;
			% TYPE IN IP ADDRESS FOR THE MASTER NODE
			ip_master = '192.168.1.1';


+ run script to start and stop streaming with the GUI

+ received data will be automaticlly saved in an according folder named after the subject number


Detailed instructions can be found in a manual located in the folder named Matlab Code. 

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


