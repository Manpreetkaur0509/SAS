/* Importing data from an Excel file */
/* Set up the parameters for importing an Excel file. Specify the file location, output dataset name, file type, and replacement setting. */
proc import 
		datafile='/home/u63861998/Flight dataset/FAA1.xls' /* Path to the Excel file */
		out=FAA1     /* Name of the output SAS dataset */
		dbms=xls     /* Type of file to import (Excel) */
		replace;
	/* Replace the dataset if it already exists */
run;

/* Printing the dataset */
/* Display the newly imported dataset to check its contents and ensure the import was successful. */
proc print data=FAA1;
run;

proc import datafile='/home/u63861998/Flight dataset/FAA2.xls' out=FAA2 
		dbms=xls replace;
run;

proc print data=FAA2;
run;

/* Combining data sets FAA1 FAA2 */
DATA COMBINED;
	SET FAA2 FAA1;
run;

proc print data=combined;
run;

/*Checking for missing values in the combined data*/
proc means data=COMBINED nmiss N;
run;

/*Univariate statistics for the combined data */
PROC SORT DATA=COMBINED;
	BY aircraft;
RUN;

proc univariate data=COMBINED;
	Title "Descriptive statistics for COMBINED data";
	VAR NO_PASG SPEED_AIR SPEED_GROUND HEIGHT PITCH DISTANCE;
	by aircraft;
run;

/* Identifying duplicate records*/
proc sort data=COMBINED NODUPKEY OUT=COMBINED_NODUPS nodup;
	by _all_;
run;

/* Purpose of the Code */
/* Outlier Detection: */
/* Histograms help in identifying outliers by showing  */
/* data points that lie far from the main cluster of data.  */
/* Outliers will appear as isolated bars on the edge of the histogram. */
/*  */
/* Assessment of Distribution: */
/*  The normal curve overlay is particularly useful for assessing  */
/* how closely the data follows a normal distribution.  */
/* Deviations from the normal curve suggest skewness, kurtosis, or other anomalies in data distribution. */
/* Outlier check */
PROC UNIVARIATE DATA=combined;
	VAR Duration Distance speed_air speed_ground height pitch;
	histogram Distance / normal;
	histogram Duration / normal;
	histogram speed_air / normal;
	histogram speed_ground / normal;
	histogram height / normal;
	histogram pitch / normal;
run;

/* Box plots */
PROC SGPANEL DATA=COMBINED;
	PANELBY AIRCRAFT;
	VBOX DISTANCE;
run;

/*Checking for missing values in the combined data*/
proc means data=COMBINED nmiss N;
run;

/*Univariate statistics for the combined data */
PROC SORT DATA=COMBINED;
	BY aircraft;
RUN;

/* Checking for abnormality of values based on the data specs */
TITLE 'Is Duration less than 40 minutes?';

DATA DURATION_TEST;
	set COMBINED;

	if DURATION <40;
run;

proc print data=DURATION_TEST;
	where DURATION is not null;
run;

TITLE 'Speed_ground not between 30 and 140 MPH';

DATA SPEED_GROUND_TEST;
	SET COMBINED;

	if speed_ground is < 30 or speed_ground > 140;
run;

proc print data=SPEED_GROUND_TEST;
	where speed_ground is not null;
run;

TITLE 'air _speed not between 30 and 140 MPH';

DATA SPEED_AIR_TEST;
	SET COMBINED;

	if speed_air<30 or speed_air>140;
run;

proc print data=SPEED_AIR_TEST;
	where speed_air is not null;
run;

TITLE 'Distance is more than 6000';

DATA DISTANCE_TEST;
SET COMBINED;

IF distance >6000;
run;

proc print data=distance_test;
where distance is not null;
run;


Title 'Height is less than 6';
data Height_test;
set combined;
if height < 6 ;
run;


proc print data=height_test;
where height is not null;
run;  