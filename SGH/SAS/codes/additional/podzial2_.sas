options mprint nomlogic nodate nonumber;
%macro podzial(zbior,zmienna); 
%local ilosc nazwy nazwa i;
proc sql noprint;
select distinct &zmienna, 
count(distinct &zmienna)
into :nazwy separated by ' ', :ilosc
from &zbior;
quit;
data &nazwy;
	set &zbior;
	select(&zmienna);
		%do i=1 %to &ilosc;
		%let nazwa=%scan(&nazwy,&i);
		when("&nazwa") output &nazwa;
		%end;
		otherwise put "Z�a nazwa :" &zmienna;
	end;
run;
%mend podzial;
%podzial(perm.schedule,location);