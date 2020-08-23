
ods _all_ close;

ods html path="C:\Users\sasdemo\Desktop\ODS"
	body="raport.html";
ods pdf 
	file="C:\Users\sasdemo\Desktop\ODS\rap.pdf";

title ;
footnote;
title "Moj pierwszy raport";

title2 "SAShelp class";

proc print data=sashelp.class ;
	var Name Height;
run ;

proc sort data=sashelp.cars out=cars_sort;
	by type;
run;


data kom;
	zm = "To jest moj opis ...";

run;

proc print noobs;
run;

title;
/*title2 "Samochody w podziale na typ";*/
footnote "Raport wygenerowany przez Piotra R.";

proc print data=cars_sort noobs;
	by type ;
run cancel;

data kom;
	zm = "To jest moj opis ...";

run;

proc gchart data=sashelp.cars;

	vbar type ;
run;


ods html close;
ods pdf close;