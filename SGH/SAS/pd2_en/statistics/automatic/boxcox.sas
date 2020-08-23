data lambdy;
do l=&lambda;
	lambda=round(l,0.00001);
	output;
end;
keep lambda;
run;

proc sql noprint;
select put(lambda,best12.-L) into :lambdy separated by ' '
from lambdy;
quit;
%let il=&sqlobs;
%put &il***&lambdy;

data outlib.TestsForNormality;
delete;
run;

%macro licz;
%do i=1 %to &il;
/*%let i=1;*/
%let l=%scan(&lambdy,&i,%str( ));
data test;
set outlib.dataSet;
nowa=.;
lambda=&l;
if lambda=0 then nowa=log(&trans_var);
if lambda ne 0 then nowa=((&trans_var**lambda)-1)/lambda;
keep &trans_var nowa;
run;
ods listing close;
ods output TestsForNormality=norm;
proc univariate data=test NORMALTEST ;
var nowa;
run;
ods output close;
ods listing;
data n;
set norm;
lambda=&l;
where Test="&stat_test";
keep lambda Stat pValue;
run;
data outlib.TestsForNormality;
set outlib.TestsForNormality n;
run;
%end;
%mend;
%licz;

proc sort data=outlib.TestsForNormality;
by descending pValue;
run;
