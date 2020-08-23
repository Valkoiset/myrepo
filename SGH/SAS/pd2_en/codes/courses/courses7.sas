/*libname data 'd:\karol\oferta_zajec\pd2_en\data\';*/

/*syntax example*/
proc means data=dataset;
class categotica_variable;
var numerical_interval_variable;
/*weight weight_variable;*/
/*freq count_variable;*/
run;
/*syntax example*/


proc means data=sashelp.class n nmiss max;
class sex;
var age;
run;

proc means data=sashelp.class noprint;
class sex name;
var age;
output out=stat sum()=sum min()=min 
p25()=p25;
run;


proc means data=sashelp.class noprint nway;
class sex name;
var age;
output out=stat sum()=sum min()=min 
p25()=p25;
run;


proc means data=sashelp.class noprint;
types sex sex*name;
class sex name;
var age;
output out=stat sum()=sum min()=min 
p25()=p25;
run;


proc means data=sashelp.class noprint;
ways 1;
class sex name;
var age;
output out=stat sum()=sum min()=min 
p25()=p25;
run;


proc means data=sashelp.class noprint;
class sex name;
var age height;
output out=stat sum(age height)=suma sumh;
run;


proc means data=sashelp.class noprint;
class sex name;
var age height;
output out=stat sum()= n()= std()=
kurtosis()= skewness()= p50()=
/ autoname;
run;

/*aggregation based on format*/
proc format;
value wiek
low-13='Ma³y'
13-high='Du¿y'
;
run;
proc means data=sashelp.class noprint nway;
class age;
format age wiek.;
var height;
output out=stat mean()=;
run;

ods listing close;
ods pdf 
file='d:\karol\oferta_zajec\pd2_en\codes\courses\rap.pdf'
;
proc tabulate data=sashelp.prdsale;
class country;
var actual;
table country , actual;
run;
ods pdf close;
ods listing;


ods listing close;
ods rtf 
file='d:\karol\oferta_zajec\pd2_en\codes\courses\rap.rtf'
;
proc tabulate data=sashelp.prdsale;
class country;
var actual;
table country , actual;
run;
ods rtf close;
ods listing;


ods listing close;
ods html 
path='d:\karol\oferta_zajec\pd2_en\codes\courses\' (url=none)
frame='index.html'
page='page.html'
contents='cont.html'
body='body.html'
style=statistical
;
proc tabulate data=sashelp.prdsale;
class country;
var actual;
table country , actual;
run;
proc tabulate data=sashelp.prdsale;
class country;
var actual;
table country , actual;
run;
ods html close;
ods listing;

/*tabulate*/
proc tabulate data=sashelp.prdsale;
class country;
var actual;
table country*actual*sum*f=numx12.2;
run;

proc tabulate data=sashelp.prdsale;
class country;
var actual;
table sum*country*actual*f=numx12.2;
run;


proc tabulate data=sashelp.prdsale;
class country year;
var actual;
table sum*country*actual*year*f=numx12.2;
run;

