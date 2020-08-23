proc sql noprint;
select 'outlib.'||trim(memname) into :zbiory separated by ' '
from dictionary.tables where libname='OUTLIB'
and memname like 'MOD%';
quit;
%put &zbiory;

data outlib.models;
length variables $ 1000;
array zm(*) &variables;
set &zbiory;
variables='';
do i=1 to dim(zm);
	if not missing(zm(i)) then do;
		variables=trim(variables)||' '||vname(zm(i));
	end;
end;
drop i;
run;
proc sort data=outlib.models nodupkey;
by variables;
run;

data outlib.models_scores;
set outlib.models(obs=1);
Max_VIF_Train=0;
Max_Pearson_Train=0;
Max_Con_Index_Train=0;
Max_PValue_Train=0;
_RSQ_valid=0;
_RSQ_diff=0;
format _RSQ_diff nlpct12.2 Max_PValue_Train PVALUE6.4;
delete;
run;

data _null_;
set outlib.models(obs=1) nobs=nob;
call symput('n_ob',put(nob,best12.-L));
run;
%put &n_ob;

%macro ocen;
/*%let nobs=1;*/
%do nobs=1 %to &n_ob;

data scores;
set outlib.models(obs=&nobs firstobs=&nobs);
call symput('model',trim(variables));
run;
%put &model;

/*calc r2 on valid*/
proc score data=outlib.valid out=test score=outlib.models(obs=&nobs firstobs=&nobs) 
type=parms predict;
var &variables;
run;
data test;
set test;
r=model1-&tar;
run;
proc means data=test noprint nway;
var &tar r;
output out=css css(&tar)=&tar uss(r)=r;
run;
data r2;
set css;
r2=1-(r/&tar);
call symput('r2',put(r2,best12.-L));
run;
/*calc r2 on valid*/


ods listing close;
ods output ParameterEstimates(persist=proc)=p CollinDiag(persist=proc)=coll;
/*ods trace on / listing;*/
/*ods trace off;*/
proc reg data=outlib.train(keep=&tar &variables);
model &tar=&model / vif collin;
run;
quit;
ods output close;
ods listing;

proc sql noprint;
select max(VarianceInflation) into :vif from p 
where variable ne 'Intercept';
select max(Probt) into :pvalue from p 
where variable ne 'Intercept';
select max(ConditionIndex) into :conindex from coll;
quit;

proc corr data=outlib.train(keep=&model) outp=corr(where=(_TYPE_='CORR'))
noprint;
var &model;
run;

data _null_;
set corr end=e;
array t(*) _numeric_;
retain m 0;
do i=_n_+1 to dim(t);
m=max(m,abs(t(i)));
/*put i= t(i)=;*/
end;
if e then call symput('max_corr',put(m,best12.-L));
run;
/*%put &max_corr;*/

data scores;
set scores;
Max_VIF_Train=&vif;
Max_Pearson_Train=&max_corr;
Max_Con_Index_Train=&conindex;
Max_PValue_Train=&pvalue;
_RSQ_valid=&r2;
_RSQ_diff=(_RSQ_valid - _RSQ_)/_RSQ_;
format _RSQ_diff nlpct12.2 Max_PValue_Train PVALUE6.4;
run;


proc append base=outlib.models_scores data=scores;
run;

%end;
%mend;
%ocen;
