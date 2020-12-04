## Purposes

The given code is responsible for the data transmission in the Bench project with the help of matlab using ROS.
There exists a publisher which is responsible for acquiring and sending the data to a subscriber which is receiving the data as ROS messages to different topics.

## Installation

Installation of the following Matlab Toolboxes is necessary:

+ Data Acquisition Toolbox
+ ROS Toolbox
+ Shimmer Matlab instrument Driver

Installation of the following NI Software is necessary:

+ [NI MAX App]

[NI MAX App]: https://www.ni.com/de-de/support/downloads/drivers/download.ni-daqmx.html#288283

Installation of the following software is necessary for Shimmer calibration:

+ Consensys
+ Shimmer calibration software

Installation of the following software is necessary for managing the communication between Shimmer sensors and Matlab:

+ [Realterm serial terminal]

[Realterm serial terminal]:(https://sourceforge.net/projects/realterm/files/Realterm/2.0.0.57/) 

## Usage

There exists a publisher and a subscriber on two different machines.

The Publisher needs to open the matlab file Main_Publisher while the subscriber needs to open the matlab file Main_Subscriber . These instructions need to be followed to transmit the data :

1. Create the Master ROS node for the publisher with the script Main_Publisher. Type rosinit in the command line. The ROS master name which is displayed in the command window can be used later for connecting the subscriber to the ROS master.

	![Pic1](https://bitbucket.org/sophiaanais/benchproject_code/raw/master/Images/Bild1.png)

2. Enter subject number into field ENTER VALUES. Moreover, add the com ports of the shimmer sensors as cells made from strings.

	![Pic2](https://bitbucket.org/sophiaanais/benchproject_code/raw/master/Images/Bild2.PNG)

3. For connecting the subscriber to the publisher open the script Main_Subscriber and enter the ip address or the name of the ROS master that was created above as a string into field **ENTER VALUES**. Further, add the subject number.

	![Pic3](https://bitbucket.org/sophiaanais/benchproject_code/raw/master/Images/Bild3.png)

4. Start running the script of the subscriber. This needs to be done before the data is published. A GUI will open.  Press the **Start Streaming** Button of the Subscriber. Do not close this window, it will be needed again!

	![Pic4](https://bitbucket.org/sophiaanais/benchproject_code/raw/master/Images/Bild4.png)
	
5. Then start running the script of the publisher for acquiring the necessary data. A figure window pops up as seen below. To stop the acquisition, click onto the window or push a key.

	![Pic5](https://bitbucket.org/sophiaanais/benchproject_code/raw/master/Images/Bild5.PNG)

6. The figure is then closed, and the acquisition is stopped as well. The data will be sent automatically and is finally saved as raw data in a folder containing the subject number.

	![Pic6](https://bitbucket.org/sophiaanais/benchproject_code/raw/master/Images/Bild6.PNG)
	
7. When successfully receiving the data, the subscriber gives information when reaching the last sensor by displaying how many seconds of data had been sent already. If no new seconds are added, everything is received, and the GUI can be used again to press **Stop Streaming**. The data is then saved in different files for each ROS topic in a folder with the subject number.

	![Pic7](https://bitbucket.org/sophiaanais/benchproject_code/raw/master/Images/Bild7.png)


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


