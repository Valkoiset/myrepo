option mprint nosymbolgen nomlogic;
%macro podzial(zbior,zmienna);
%local nazwy ilosc i;
proc sql noprint;
create table nazwy as
select distinct &zmienna 
from &zbior;
select count(*) into :ilosc
from nazwy;
select &zmienna into :nazwy 
separated by ' '
from nazwy;
quit;
%do i=1 %to &ilosc;
%local naz&i;
%end;
proc sql noprint;
%let ilosc=&ilosc;
select &zmienna 
into :naz1-:naz&ilosc
from nazwy;
quit;
data &nazwy;
set &zbior;
%do i=1 %to &ilosc;
if &zmienna="&&naz&i" 
then output &&naz&i;
%end;
run;
%mend podzial;
%podzial(sashelp.class,sex);
%put _user_;

