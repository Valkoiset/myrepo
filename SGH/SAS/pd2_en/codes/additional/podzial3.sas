option nomprint nosymbolgen;
%macro podzial(zbior,zmienna);
%local nazwy warunek;
proc sql noprint;
select distinct &zmienna,
"when('"||&zmienna||"') output "||&zmienna
into 
:nazwy separated by ' ',
:warunek separated by ';'
from &zbior;
quit;
data &nazwy;
set &zbior;
select(&zmienna);
&warunek;
end;
run;
%mend podzial;
%podzial(perm.schedule,location);
