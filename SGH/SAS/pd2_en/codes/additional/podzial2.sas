option nosymbolgen mprint;
%macro podzial2(zbior, zmienna);
%local kod nazwy i;
proc sql noprint;
select distinct &zmienna 
into :nazwy separated by ' '
from &zbior;
quit;
data &nazwy;
set &zbior;
%let i=1;
%let kod=%scan(&nazwy,&i);
%do %until(&kod=);
if &zmienna="&kod" then output &kod;
%let i=%eval(&i+1);
%let kod=%scan(&nazwy,&i);
%end;
run;
%mend podzial2;

%podzial2(kurs.march,dest);