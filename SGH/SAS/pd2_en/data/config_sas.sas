F11 gsubmit 'proc catalog cat=work.gseg kill; quit;';
F12 clear log; clear output; odsresults; clear; explorer 1; wpgm;

zmienne spacja:
gsubmit 'proc sql noprint; select name into :zm9999 
separated by " " from dictionary.columns where libname=upcase("%8b") 
and memname=upcase("%32b"); quit; filename _temp_ clipbrd; 
data _null_; file _temp_; a="&zm9999"; put a; run;'
