proc means data=sashelp.class ;
class sex age;
var weight height;
/*output out=stat5 sum(weight height)=suma_w suma_h;*/
run;
/*Agregowanie*/
/******************************************************************************************************************/
/*freq*/
proc freq data=sashelp.class;
table age;
run;
*podstawowe wykorzystanie;
/******************************************************************************************************************/
proc freq data=sashelp.class noprint;
table age / out=freq;
run;
*output do tabeli SAS;
/******************************************************************************************************************/
proc freq data=sashelp.class noprint;
table age / out=freq2 outcum;
run;
*output do tabeli SAS z wartoœciami skumulowanymi;
/******************************************************************************************************************/
data w; set sashelp.class; if name = 'Alice' then age = .; if name='William' then age=.a; run;
proc freq data=w;
table age/ missing;
run;
proc freq data=w noprint;
table age / out=freq3 outcum missing;
run;
*wartoœci missingowe;
/******************************************************************************************************************/
proc sort data = sashelp.class out=w; by sex; run;
proc freq data=w;
table age / out=freq4 outcum missing;
by sex;
run;
*przetwarzanie w grupach;
/******************************************************************************************************************/
proc freq data=sashelp.class;
table sex*age / missing norow nocol nopct nofreq;
run;
*dodatkowe opcje;
/******************************************************************************************************************/
proc freq data=w;
table age*sex / missing ;
weight height;
run;
*wa¿enie obserwacji;

OPTIONS FORMCHAR="|----|+|---+=|-/\<>*";

ods html;
ods html close;
ods _all_ close;


ods listing;
proc freq data=sashelp.class;
table sex*age / missing norow nocol nopct;
run;
/*
    Sex       Age

                        Frequency|      11|      12|      13|      14|      15|      16|  Total
                        ---------+--------+--------+--------+--------+--------+--------+
                        F        |      1 |      2 |      2 |      2 |      2 |      0 |      9
                        ---------+--------+--------+--------+--------+--------+--------+
                        M        |      1 |      3 |      1 |      2 |      2 |      1 |     10
                        ---------+--------+--------+--------+--------+--------+--------+
                        Total           2        5        3        4        4        1       19
*/






/******************************************************************************************************************/
/*means*/

proc means data=sashelp.class;
var age;
run;
*obliczanie statystyk;
/******************************************************************************************************************/
proc means data=sashelp.class 
CLM	NMISS
CSS	RANGE
CV	SKEWNESS
KURTOSIS	STD
LCLM	STDERR
MAX	SUM
MEAN	SUMWGT
MIN	UCLM
MODE	USS
N	VAR
MEDIAN	Q3
P1	P90
P5	P95
P10	P99
Q1	QRANGE
;
var age;
run;
*dostêpne statystyki;
/******************************************************************************************************************/
data w;
set sashelp.class;
num = round(10*ranuni(1),1);
run;
proc means data=w n min mean max var vardef=wgt;
var age;
class sex;
weight num;
/*freq num;*/
run;
*instrukje;
*vardef=wgt;
/******************************************************************************************************************/

proc means data=sashelp.class noprint;
class sex age;
var height;
output out=stat sum()=sum min()=min p25()=asd;
run;
*klasy i output;
/******************************************************************************************************************/

proc means data=sashelp.class noprint nway;
class sex age;
var height;
output out=stat2 sum()=sum min()=min p25()=p25;
run;
*nway;
/******************************************************************************************************************/
proc means data=sashelp.class noprint;
types sex sex*age;
class sex age;
var height;
output out=stat3 sum()=sum min()=min p25()=p25;
run;
*types - ¿¹dam interakcji explicite;
/******************************************************************************************************************/
proc means data=sashelp.class noprint;
ways 0 2;
class sex age;
var height;
output out=stat4 sum()=sum min()=min p25()=p25;
run;
*ways - ile zmiennych ma wchodziæ do interakcji;
/******************************************************************************************************************/

proc means data=sashelp.class noprint;
class sex age;
var weight height;
output out=stat5 sum(weight height)=suma_w suma_h;
run;
*obróbka wiêcej ni¿ 1 zmiennej;
/******************************************************************************************************************/

proc means data=sashelp.class noprint;
class sex age;
var weight height;
output out=stat6 sum()= n()= std()= kurtosis()= skewness()= p50()= / autoname;
run;
*automatyczne nazwy kolumn zagregowanych;
/******************************************************************************************************************/
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
output out=stat7 mean()=;
run;
*agregowanie z wykorzystaniem formatu;
/******************************************************************************************************************/
/******************************************************************************************************************/
/******************************************************************************************************************/
/******************************************************************************************************************/

*ODS;

ods listing close;
ods html close;
ods _all_ close;
ods html;
proc freq data=sashelp.class; table sex*age / missing norow nocol nopct; run;
ods html close;
/******************************************************************************************************************/
ods _all_ close;

ods pdf 
	file='C:\Users\Wojtek\Desktop\SGH_SAS\Niestacjonarne\biblioteka2\rap.pdf'
	style=banker;
proc freq data=sashelp.class; table sex*age / missing norow nocol nopct; run;
ods pdf close;
/******************************************************************************************************************/
ods html;
proc reg data=sashelp.class plots=all;
model age = height;
run;
ods trace on / listing;
ods table OneWayFreqs=asd;
proc freq data=sashelp.class; table sex; run;
ods trace off;
/******************************************************************************************************************/
/******************************************************************************************************************/
/******************************************************************************************************************/
/******************************************************************************************************************/
*tabulate;
ods _all_ close;
ods html;
proc tabulate data=sashelp.prdsale;
class country;
var actual;
table country , actual;
run;
/******************************************************************************************************************/

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

