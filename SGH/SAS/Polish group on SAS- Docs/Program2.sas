

ods trace on;
ods output OneWayFreqs=type_freq;
proc freq data=sashelp.cars ; ;
	table type / nocum ;
run;

ods select ParameterEstimates;
ods output ParameterEstimates=bety;

proc reg data=sashelp.class;
	model height = weight ;

run;