option mprint nosymbolgen;
%macro podzial(zbior,zmienna);
proc sql noprint;
select distinct &zmienna into 
:naz1-:naz&sysmaxlong from &zbior;
%do i=1 %to &sqlobs;
create table &&naz&i as 
select * from &zbior where 
&zmienna="&&naz&i";
%end;
quit;
%mend podzial;

%podzial(kurs.march , dest);