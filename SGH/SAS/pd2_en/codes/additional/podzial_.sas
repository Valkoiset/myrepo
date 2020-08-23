options mprint nomlogic nodate nonumber;
%macro podzial(zbior,zmienna); 
proc sql noprint;
create table nazwy as
select distinct &zmienna
from &zbior;
quit;
%local i nazwy ilosc;
%let ilosc=&sqlobs;
%do i=1 %to &ilosc;
%local nazwa&i;
%end;
proc sql noprint;
select &zmienna, &zmienna
into :nazwa1-:nazwa&ilosc, :nazwy
separated by ' '
from nazwy;
quit;
data &nazwy;
	set &zbior;
	select(&zmienna);
		%do i=1 %to &ilosc;
		when("&&nazwa&i") output &&nazwa&i;
		%end;
		otherwise put "Z³a nazwa :" &zmienna;
	end;
run;
%mend podzial;
%podzial(perm.schedule,location);