/*wnioskowanie*/
%let dir=d:\karol\oferta_zajec\pd2_en\statistics\correlation\;
libname inlib "&dir" compress=yes;

/*data preparation*/
data inlib.dataSet;
do id=1 to 3000;
	x1=10*ranuni(1)+10;
	x2=10*ranuni(1)+10;
	y=2*x1+2*rannor(1);
	z=2*x1-3*x2+2*rannor(1);
	output;
end;
run;
/*data preparation*/



*regression;
*scatter plots;
goptions reset=all;
proc gplot data=inlib.dataSet;
plot y*x1;
where x1 between 12 and 13;
run;
quit;
proc gplot data=inlib.dataSet;
plot y*x1;
run;
quit;

symbol v=dot i=rlcli90 width=1 cv=blue ci=red co=green;
proc gplot data=inlib.dataSet;
plot y*x1 / regeqn;
run;
quit;


*correlation coeficient;
proc corr data=inlib.dataSet outp=pearson outs=spearman pearson spearman;
with y z;
var x1 x2;
run;

*corr matric;
proc corr data=inlib.dataSet;
var x1 x2 y z;
run;
proc corr data=inlib.dataSet;
var _numeric_;
run;

/*graphics*/
ods listing;
ods html path="&dir" body='corr.html' style=statistical gpath="&dir" image_dpi=300;
ods graphics on;
proc corr data=inlib.dataSet;
var _numeric_;
run;
ods graphics off;
ods html close;
ods listing;


*regression;
proc reg data=inlib.dataSet;
model y=x1;
run;
quit;


/*graphics*/
ods listing;
ods html path="&dir" body='reg.html' style=statistical gpath="&dir" image_dpi=300;
ods graphics on;
proc reg data=inlib.dataSet;
model y=x1;
run;
quit;
ods graphics off;
ods html close;
ods listing;

/*regression plane of two dimmentions*/
%macro rys(nazwa,zbior,z,x,y);
proc reg data=&zbior outest=b noprint;
model &z=&x &y;
run;
quit;
%local podzial; %let podzial=50;
proc means data=&zbior noprint nway;
var &x &y;
output out=s min()= range()= / autoname;
run;
data dataSet;
set s;
do i=0 to &podzial;
  do j=0 to &podzial;
    &x=&x._Min+&x._Range*i/&podzial;
	&y=&y._Min+&y._Range*j/&podzial;
	output;
  end;
end;
keep &x &y;
run;
proc score data=dataSet score=b out=score(rename=(model1=&z)) type=parms; 
var &x &y; 
run; 
data score;
length shape color $ 20;
set score(in=i) &zbior;
if i then do; shape='square'; color='blue'; end;
else do; shape='balloon'; color='red'; end;
keep &x &y &z shape color;
run;
ods listing close;
goptions device=activex;
ods html path="&dir" body="plaszczyzna_&nazwa..html" style=statistical;
proc g3d data=score;
scatter &y*&x=&z / shape=shape color=color noneedle;
run;
quit;
ods html close;
ods listing;
goptions device=win;
%mend;

%rys(random, inlib.dataSet, z, x1, x2);
%rys(class, sashelp.class, age, weight, height);


/*regression diagnostic*/
proc reg data=inlib.dataSet;
model y=x1 / spec;
output out=rests r=r;
plot r. * (p. y);
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;*rest normality test;
run;
quit;
proc univariate data=rests mu0=0 alpha=0.01;
var r;
run;


/*errors in regression and correlation deduction*/

/*example 1*/
data blad;
do id=1 to 3000;
	x=10*ranuni(1)+10;
	y=2*x+2*rannor(1);
	output;
end;
do id=3001 to 3010;
	x=20;
	y=2000+5*rannor(1);
	output;
end;
run;
proc corr data=blad pearson spearman;
with y;
var x;
run;
proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;
run;
quit;

proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;
where id<=3000;
run;
quit;
/*example 1*/


/*example 2*/
data blad;
do id=1 to 3000;
	x=10*ranuni(1)-5;
	y=(10*ranuni(1)-5)*((25-(x**2))**0.5);
	output;
end;
do id=3001 to 3010;
	x=5;
	y=2000+5*rannor(1);
	output;
end;
run;
proc corr data=blad pearson spearman;
with y;
var x;
run;
proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;
run;
quit;


proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;
where id<=3000;
run;
quit;
/*example 2*/



/*example 3*/
data blad;
do id=1 to 3000;
	x=10*ranuni(1)-5;
	y=sin(x);
	output;
end;
run;
proc corr data=blad pearson spearman;
with y;
var x;
run;
proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;
run;
quit;
/*example 3*/



/*example 4*/
data blad;
do id=1 to 3000;
	x=10*ranuni(1)-5;
	y=x*x;
	output;
end;
run;
proc corr data=blad pearson spearman;
with y;
var x;
run;
proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;
run;
quit;
/*example 4*/



/*example 5*/
data blad;
do id=1 to 3000;
	x=10*ranuni(1);
	y=x*x+5*rannor(1);
	output;
end;
run;
proc corr data=blad pearson spearman;
with y;
var x;
run;
proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;
run;
quit;
/*example 5*/

/*prediction*/
data dataSet;
set inlib.dataSet end=e;
output;
if e then do;
	y=.;
	x1=5; output;
	x1=100; output;
end;
keep y x1;
run;
proc reg data=dataSet;
model y=x1 / noint;
output out=regresja p=pred r=reszty lcl=dol ucl=gora lclm=dolsr
uclm=gorasr;
run;
quit;


*categorical analyses;
proc freq data=sashelp.class;
tables age sex*age / all;
run;


*association test;
proc freq data=sashelp.class;
tables sex*age /
chisq expected cellchi2 nocol nopercent;
run;

*exact p;
proc freq data=sashelp.class;
tables sex*age; 
exact pchi;
run;

/*Somers'D = Gini*/
proc logistic data=sashelp.class;
   model sex=age;
run;
proc freq data=sashelp.class;
tables sex*age;
exact SMDCR; 
run;



/*Somers'D own calc*/
data class1;
set sashelp.class;
rename age=age1 sex=sex1;
run;
proc sql noprint;
select count(*) into :n
from
sashelp.class,class1
where sex='F' and sex1='M';

select count(*) into :c
from
sashelp.class,class1
where sex='F' and sex1='M'
and age<age1;

select count(*) into :d
from
sashelp.class,class1
where sex='F' and sex1='M'
and age>age1;

select count(*) into :t
from
sashelp.class,class1
where sex='F' and sex1='M'
and age=age1;

quit;
%put ***&n***;
%put ***&c***;
%put ***&d***;
%put ***&t***;
data _null_;
c=&c/&n;
d=&d/&n;
t=&t/&n;
ds=c-d;
put _all_;
run;
