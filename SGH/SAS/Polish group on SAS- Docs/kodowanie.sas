

data wyj.test;
set wyj.podzialy_int_niem (obs=3);
war2=catx('','if ',war,' then ',catt(zmienna,'_kat='),grp);
run;

proc sql noprint;
select war2 into :war1-:war999
from wyj.test;
quit;
%put &war1;
%put &war2;
%put &war3; 

data _null_;
	set wyj.podzialy_int_niem(obs=1) nobs=il;
	call symput('liczba',il);
run;
%put &liczba;

data dane;
set dane;
&war1;
&war2;
&war3; 
run;

data dane;
set dane;
if not missing(ACT_AGE) and ACT_AGE <= 77 then ACT_AGE_kat= 1;
if 88 < ACT_AGE then ACT_AGE_kat= 3;
if not missing(ACT_AGE) and ACT_AGE <= 77 then ACT_AGE_kat= 1;
run;

%let i=1;
%put &&war&i;

%macro kodowanie;
data dane;
set dane;
%do i=1 %to &liczba;
&&war&i;
%end;
run;
%mend;
