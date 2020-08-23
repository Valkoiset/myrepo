proc corr data=outlib.dataSet  outp=outlib.pearson noprint;
   with &tar;
   var &variables;
run;

proc sql noprint;
select name into :naz1-:naz&sysmaxlong
from dictionary.columns where libname='OUTLIB' 
and memname='PEARSON' and name not in ('_TYPE_','_NAME_');
quit;
%let il=&sqlobs;
%put &il***&naz1**&&naz&il;

data outlib.PEARSON_Partial;
_type_='CORR';
delete;
run;

%macro licz;
%do i=1 %to &il;
proc corr data=outlib.dataSet noprint outp=p;
   with &tar;
   var &&naz&i ;
   partial 
%do j=1 %to &il;
	%if &j ne &i %then %do;
		&&naz&j
	%end;
%end;
;
run;
data outlib.PEARSON_Partial;
merge outlib.PEARSON_Partial p(where=(_type_='CORR'));
by _type_;
run;
%end;
%mend;
%licz;

