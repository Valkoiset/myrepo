%let zbior=kurs.schedule;
%let zmienna=location;
proc sql noprint;
create table nazwy as
select distinct &zmienna
from &zbior;
quit;
data _null_;
length kod1 kod2 kod $ 32000;
retain kod1 kod2;
set nazwy end=k;
kod1=catx(' ',kod1,&zmienna);
kod2=cat(trim(kod2)," when('",trim(&zmienna),
"') output ",trim(&zmienna),";");
if k;
kod=catx(' ','data',kod1,
"; set &zbior;",
"select(&zmienna);",
kod2,"end;run;");
call execute(kod);
run;
