options mprint nomlogic nodate nonumber;
%macro podzial(zbior,zmienna); 
%local ilosc nazwy nazwa i;
proc sql noprint;
select distinct &zmienna 
into :nazwy separated by ' ' 
from &zbior;
quit;
%let ilosc=&sqlobs;
data &nazwy;
	set &zbior;
	select(&zmienna);
		%do i=1 %to &ilosc;
		%let nazwa=%scan(&nazwy,&i);
		when("&nazwa") output &nazwa;
		%end;
		otherwise put "Z³a nazwa :" &zmienna;
	end;
run;
%mend podzial;
%podzial(kurs.schedule,location);
