%let dir=d:\karol\oferta_zajec\pd2_en\pipe\data\;


%macro czyt;
filename f pipe "dir &dir.*.txt /w /a:-d /b";
data nazwy;
infile f;
input;
n=_infile_;
run;

proc sql noprint;
select n into :naz1-:naz&sysmaxlong
from nazwy;
quit;
%let ilosc=&sqlobs;

%do i=1 %to &ilosc;
data zb&i / view=zb&i;
infile "&dir.&&naz&i"  dlm=' ';
informat i 12. x numx.;
input i x;
run;
%end;

data dane;
set 
%do i=1 %to &ilosc;
zb&i
%end;
;
run;

%do i=1 %to &ilosc;
proc datasets lib=work nolist;
delete zb&i / mt=view;
quit;
%end;

%mend;
/*options nomprint;*/
%czyt;


