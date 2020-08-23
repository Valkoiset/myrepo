/*%put  ERROR:To ja ;*/
%put _automatic_;
%put &SYSUSERID.;
%let moj_param = wartosc;
%put &moj_param.;
%let dsn = sashelp.class;
options mprint symbolgen;

data test;
	set &dsn.;
run;

%let lib=sashelp;
%let ds = cars;

data test;
	set &lib..&ds.;
run;