/*sas.exe shoul dbe configured in running*/
/* -memsize 1G -RLANG -set R_HOME "c:\Program Files\R\R-3.1.3\"*/
proc iml;
run ExportDataSetToR("sashelp.class","class");
submit / R;
class$Age = 100;
endsubmit;
call ImportDataSetToR("work.class","class");
run;
quit;

%put &sysvlong;
