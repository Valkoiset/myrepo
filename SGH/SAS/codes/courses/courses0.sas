/*courses PD2_en*/

libname bib 'path' compress=yes access=readonly;
libname bib ('path1' 'path2');
libname bib (work);
libname bib clear;

libname bib excel 'path\report.xlsx';
libname bib odbc dsn=database;
libname bib oracle, teradata itp.

/*sequence of code compilation*/
/*0 - macro compilation*/
/*1 - syntax analysis SAS 4GL*/
/*2 - headline of dataset and PDV*/
/*3 - final compilation and runing*/

/*step 1 can stop the program*/
/*d w;*/
/*s sashelp.class;*/
/*run;*/
/*log:*/
/*ERROR 180-322: Statement is not valid or it is used out of proper order.*/

/*step 3 does not stop, only output PDV into log.*/
data w;
a=0;
b=1/a;
run;
/*log:*/
/*NOTE: Division by zero detected at line 6 column 4.*/
/*a=0 b=. _ERROR_=1 _N_=1*/
/*NOTE: Mathematical operations could not be performed at the following places. The results of the*/
/*      operations have been set to missing values.*/
/*      Each place is given by: (Number of times) at (Line):(Column).*/
/*      1 at 6:4*/
/*NOTE: The data set WORK.W has 1 observations and 2 variables.*/
/*NOTE: DATA statement used (Total process time):*/
/*      real time           0.48 seconds*/
/*      cpu time            0.01 seconds*/


data w;
length event $ 100 iterationnumber 8;
iterationnumber=_n_;
event='start'; output;
age1=1; age=1;
iterationnumber=_n_;
event='after 1 change'; output;
set sashelp.class;
iterationnumber=_n_;
event='after set'; output;
age2=1; age=1;
iterationnumber=_n_;
event='after 2 change'; output;
run;
/* the loop is ending inside after 1 change*/

data w;
length event $ 100 iterationnumber 8;
iterationnumber=_n_;
event='start before loop'; output;
do i=1 to 3;
	age1=1; age=1;
	iterationnumber=_n_;
	event='after 1 change'; output;
	set sashelp.class;
	iterationnumber=_n_;
	event='after set'; output;
	age2=1; age=1;
	iterationnumber=_n_;
	event='after 2 change'; output;
end;
iterationnumber=_n_;
event='after loop'; output;
run;

data w;
length event $ 100 iterationnumber nnn 8;
nnn=n_obs;
iterationnumber=_n_;
event='before loop'; output;
do i=1 to n_obs;
	wiek1=1; age=1;
	iterationnumber=_n_;
	event='after 1 change'; output;
	set sashelp.class nobs=n_obs;
	iterationnumber=_n_;
	event='after set'; output;
	wiek2=1; age=1;
	iterationnumber=_n_;
	event='after 2 change'; output;
end;
iterationnumber=_n_;
event='after loop'; output;
run;

/*typical codes*/
data w;
do i=1 to n_obs;
	set sashelp.class nobs=n_obs;
	age2=1; age=1;
	output;
end;
run;

data w;
set sashelp.class;
age2=1; age=1;
run;

/*variable attributes*/
/*what attributes are assigned in the following lines?*/
data w;
a=1;
a='1';
run;


data w;
a='123';
a='Helen has a cat';
run;

/*hidden conversion*/
data w;
a=1;
b=substr(a,1,1);
run;

/*unhidden conversion*/
data w;
a=1;
b=substr(a,12,1);
run;
data w;
a=1;
b=substr(put(a,best12.-L),1,1);
run;

data w;
do i=1 to 8;
n=CONSTANT('EXACTINT',i);
output;
end;
format n 30.;
run;


/*formats with a dot - digital separator*/
/*best12.*/
/*12.2*/
/*comma12.2*/
/*percent12.2*/
/*formats with a comma - digital separator*/
/*numx12.2*/
/*nlnum12.2*/
/*commax12.2*/
/*nlpct12.2*/
/*useful format*/
/*z12.*/
/*date formats*/
/*datetime.*/
/*time.*/
/*date.*/
/*yymmdd10.*/
/*ddmmyy10.*/
/*POLDFDWN.*/

/*functions should be known*/
dim
byte
cat, catx, catt
compress
compare
index, indexw
length
missing
upcase, propcase, lowcase
rank
repeat
reverse
scan
substr
translate, tranwrd
datepart
day, weekday, year, month, mdy itp.
intck, intnx
sum, nmiss, n, std, itp.
ordinal
constant
ranuni, rannor
inputc, inputn, putc, putn
int, round, floor
vname, vlength



