/*---------------------------------------------------------------------------------------------------------------------------*/
/*Reading data*/
/*---------------------------------------------------------------------------------------------------------------------------*/
/*Library*/
LIBNAME MISS "C:/Users/qn74bk/Downloads/class/4 semester/Advanced business analytics/Project 1/";
	proc import datafile = "C:/Users/qn74bk/Downloads/class/4 semester/Advanced business analytics/Project 1/rain.csv" 
	 	 out = miss.rain
	 	 dbms = CSV 
	 	 REPLACE; 
	 run; 

/*Generating dataset with full obs*/
	data rain_orig;
		set miss.rain;
		drop var1;
		retain id 0;
		id=id+1; /* key for comparing results*/
	run;	

	proc contents data=rain_orig;
	run;

/*Generating empty cases*/
	data rain_miss;
		set rain_orig;
		call streaminit(12345);
		Missing1=rand("Bernoulli",0.2); /*missing variable is 1  40% of the time*/
		Missing2=rand("Bernoulli",0.3); /*missing variable is 1  40% of the time*/
		if Missing1 then do; 
			Humidity9am=.;
			Humidity3pm=.;
		END;
		if Missing2 then do;  
			Pressure9am=.;
			Pressure3pm=.;
		END;
	run;	
	
/* Exploratory analysis */
	proc mi nimpute=0 simple data=rain_miss;
	run;

/*=================================================================================================================================*/
/* Case 1: MEAN IMPUTATION*/
/*=================================================================================================================================*/
proc stdize data=rain_miss out=rain_mean_imp
	oprefix=Miss_ /* prefix for original variables */
	reponly 
	method=MEAN; /* or MEDIAN, MINIMUM, MIDRANGE, etc. */
	var Humidity9am Humidity3pm Pressure9am Pressure3pm; /*  variables to impute */
run;
proc sql outobs=100;
	create table results_mean as
		select 
			A.id
			,A.Humidity9am AS Imputed_Humidity9am
			,B.Humidity9am	AS Original_Humidity9am
			,A.Humidity3pm AS Imputed_Humidity3pm
			,B.Humidity3pm	AS Original_Humidity3pm
			,A.Pressure9am AS Imputed_Pressure9am
			,B.Pressure9am	AS Original_Pressure9am
			,A.Pressure3pm AS Imputed_Pressure3pm
			,B.Pressure3pm	AS Original_Pressure3pm
		FROM rain_mean_imp A FULL JOIN rain_orig B
			ON A.id=B.id
		WHERE missing1=1 and missing2=1;
quit;
proc print data=results_mean;
run;

/*=================================================================================================================================*/
/* Case 2: HOT DECK IMPUTATION */
/*=================================================================================================================================*/
proc surveyimpute data=rain_miss method=hotdeck(selection=abb)
	seed=773269;
	var Humidity9am Humidity3pm Pressure9am Pressure3pm;
	output out=rain_hot_deck;
	cells Location; 
run;
proc sql outobs=100;
	create table results_mean as
		select 
			A.id
			,A.Humidity9am AS Imputed_Humidity9am
			,B.Humidity9am	AS Original_Humidity9am
			,A.Humidity3pm AS Imputed_Humidity3pm
			,B.Humidity3pm	AS Original_Humidity3pm
			,A.Pressure9am AS Imputed_Pressure9am
			,B.Pressure9am	AS Original_Pressure9am
			,A.Pressure3pm AS Imputed_Pressure3pm
			,B.Pressure3pm	AS Original_Pressure3pm
		FROM rain_hot_deck A FULL JOIN rain_orig B
			ON A.id=B.id
		WHERE missing1=1 and missing2=1;
quit;
proc print data=results_mean;
run;

/*=================================================================================================================================*/
/* Case 3: MULTIPLE IMPUTATION */
/*=================================================================================================================================*/
proc mi data=rain_miss nimpute=25 out=rain_multi seed=55555;
	class WindDir9am WindDir3pm WindGustDir;
	fcs reg;
	var MinTemp MaxTemp Rainfall WindGustDir WindGustSpeed WindDir9am WindDir3pm WindSpeed9am WindSpeed3pm 
									Humidity9am Humidity3pm Pressure9am Pressure3pm Temp9am Temp3pm RainToday;
run;
proc sql outobs=100;
	create table results_mean as
		select 
			A.id
			,A._Imputation_
			,A.Humidity9am AS Imputed_Humidity9am
			,B.Humidity9am	AS Original_Humidity9am
			,A.Humidity3pm AS Imputed_Humidity3pm
			,B.Humidity3pm	AS Original_Humidity3pm
			,A.Pressure9am AS Imputed_Pressure9am
			,B.Pressure9am	AS Original_Pressure9am
			,A.Pressure3pm AS Imputed_Pressure3pm
			,B.Pressure3pm	AS Original_Pressure3pm
		FROM rain_multi A FULL JOIN rain_orig B
			ON A.id=B.id
		WHERE missing1=1 and missing2=1;
quit;
proc print data=results_mean;
run;

proc means data=rain_multi;
	class _imputation_ missing1 missing2;
	var Humidity9am Humidity3pm Pressure9am Pressure3pm;
run;

/*---------------------------------------------------------------------------------------------------------------------------*/
/*Final comparison*/
/*---------------------------------------------------------------------------------------------------------------------------*/
/*original*/
proc logistic data=rain_orig;
	class WindDir9am WindDir3pm WindGustDir;
   	model RainTomorrow (event='1')= Humidity9am Humidity3pm Pressure9am Pressure3pm;
run;
/*mean*/
proc logistic data=rain_mean_imp;
	class WindDir9am WindDir3pm WindGustDir;
   	model RainTomorrow (event='1')= Humidity9am Humidity3pm Pressure9am Pressure3pm;
run;
/*hot*/
proc logistic data=rain_hot_deck;
	class WindDir9am WindDir3pm WindGustDir;
   	model RainTomorrow (event='1')=Humidity9am Humidity3pm Pressure9am Pressure3pm;
run;
/*MI*/
proc surveylogistic data=rain_multi;
	by _imputation_;
	class WindDir9am WindDir3pm WindGustDir  / param=ref;
	model RainTomorrow (event='1')= Humidity9am Humidity3pm Pressure9am Pressure3pm ;
	ods output parameterestimates=rain_multi_est;
run;
proc mianalyze parms(classvar=classval)=rain_multi_est edf=56;
	class WindDir9am WindDir3pm WindGustDir ;
	modeleffects intercept Humidity9am Humidity3pm Pressure9am Pressure3pm;
run;
