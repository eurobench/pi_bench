# Instruction for using the testing dataset

## test data
The testing input folder contains five .csv files, including data from 2 subjects:

- `Subject01_calib_chair_raw_01.csv` – contains the data from the calibration procedure for subject01.
  It is used for calculating the calibration parameters for the subsequent estimation of the joint kinematics in the sagittal plane.
- `Subject01_5sts_chair_raw_01.csv` – contains the data from a single 5STS trial of subject01
- `Subject01_30sts_chair_raw_01.csv` – contains the data from a single 30sSTS trial of subject01
- `Subject02_calib_chair_raw_01.csv` – contains the data from the calibration procedure for subject02. It is used for calculating the calibration parameters for the subsequent estimation of the joint kinematics in the sagittal plane.
- `Subject02_5sts_chair_raw_01.csv` – contains the data from a single 5STS trial of subject02

These files have been generated at the end of a single trial with the BENCH apparatus, and they can be used for the calculation of the metrics in Octave (or Matlab).
All the necessary pre-processing steps and metrics calculation is performed within the computePI.m function.
This function takes as input a .csv file containing the raw data from a single sts trial, a .csv file containing the raw data from the calibration procedure, and the path of an output folder for saving the .yaml files of the seven calculated PIs.

## command

From an Octave environment, from the `src` folder, assuming the folder `../out` has been previously created:

```term
# for the 5sts protocol
computePI_5sts("../test/input/subject_01_5sts_chair_raw_01.csv", "../test/input/subject_01_calib_chair_raw_01.csv", "../out/")
# for the 30sts protocol
computePI_30sts("../test/input/subject_01_30sts_chair_raw_01.csv", "../test/input/subject_01_calib_chair_raw_01.csv", "../out/")
```

From a Linux terminal, from the `Eurobench_format_code` folder:

```term
# for the 5sts protocol
./run_bench_5sts_pi test/input/subject_01_5sts_chair_raw_01.csv test/input/subject_01_calib_chair_raw_01.csv out
# for the 30sts protocol
./run_bench_30sts_pi test/input/subject_01_30sts_chair_raw_01.csv test/input/subject_01_calib_chair_raw_01.csv out
```

## Docker image

_(only tested under linux)_

Run the following command in order to create the docker image:

```console
docker build . -t pi_bench
```

Assuming data files have standardized names (see above), and folder `out` is already created (to contain output file):

```shell
docker run --rm -v $PWD/test/input:/in -v $PWD/out:/out pi_bench ./run_bench_5sts_pi /in/subject_01_5sts_chair_raw_01.csv /in/subject_01_calib_chair_raw_01.csv /out
# for the 30sts protocol
docker run --rm -v $PWD/test/input:/in -v $PWD/out:/out pi_bench ./run_bench_30sts_pi /in/subject_01_30sts_chair_raw_01.csv /in/subject_01_calib_chair_raw_01.csv /out
```
