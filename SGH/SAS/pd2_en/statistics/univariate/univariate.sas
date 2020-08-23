/*univariate*/
%let dir=d:\karol\oferta_zajec\pd2_en\statistics\univariate\;
libname libData "&dir" compress=yes;

/*data preparation*/
data libData.dataSet;
do id=1 to 3000;
	x=rannor(1);
	y=ranuni(1);
	z=rannor(1)*10+10;
	u=x; if id=100 then u=1000;
	v=rannor(1)*rannor(1)*rannor(1);
	stala=1;
	output;
end;
run;
/*data preparation*/


*listing;
proc print data=libData.dataSet(obs=10);
run;

*descriptive statistics;
proc means data=libData.dataSet maxdec=3;
var x y;
run;

*more statistics;
proc univariate data=libData.dataSet;
var x y z u;
id id;
run;

*percentile;
proc univariate data=libData.dataSet noprint;
var x y;
id id;
output out=centile pctlpre=Px_ Py_ pctlpts=1 to 100 by 1;
run;


*difference between two distributions: x and u?;
proc univariate data=libData.dataSet;
var x u;
id id;
run;

proc gchart data=libData.dataSet;
vbar3d x / levels=10;
vbar3d u / levels=10;
run;
quit;

/*distribution test, test of normality*/
proc univariate data=libData.dataSet;
var x u;
id id;
histogram  x u / normal;
inset normal(sigma mean) / position=ne;
run;

/*ods graphics*/
ods listing close;
ods html path="&dir" body='univariate.html' style=statistical gpath="&dir" image_dpi=300;
ods graphics on;
proc univariate data=libData.dataSet;
var x u;
id id;
ppplot;
cdfplot;
histogram  x u / normal;
probplot x u / normal;
qqplot x u / normal;
run;
ods graphics off;
ods html close;
ods listing;


/*probability plot*/
goptions reset=all;
symbol v=star;
%let zbior=libData.dataSet;
%let zm=x;
%let zm=v;
proc sort data=&zbior out=op;
by &zm;
run;
data w;
set op nobs=il;
Quantile=probit(_n_/(il+0.0001));
Normal=Quantile;
ProbabilityNormal=probnorm(&zm);
ProbabilityEmprirical=_n_/(il+0.0001);
d=abs(ProbabilityNormal-ProbabilityEmprirical);
run;
proc gplot data=w;
plot (&zm Normal)*Quantile / overlay legend;
plot (ProbabilityNormal ProbabilityEmprirical)*&zm / overlay legend;
run;
quit;

/*statistics D*/
proc univariate data=libData.dataSet;
var &zm;
id id;
histogram  &zm / normal;
inset normal(sigma mean) / position=ne;
run;
proc sql;
select max(d) from w;
quit;


*robust means;
proc univariate data=libData.dataSet trimmed=1 0.01 0.1  winsorized=1 0.01 0.1 ;
var x u;
id id;
run;

*untypical values;
proc means data=libData.dataSet noprint nway;
var u;
output out=obcinanie(drop=_type_ _freq_) p1()=p1 p99()=p99;
run;
proc sql noprint;
select put(p1,best12.-L),put(p99,best12.-L) into :p1,:p99 from obcinanie;
quit;
%put &p1***&p99;
proc gchart data=libData.dataSet;
vbar3d u / levels=10;
where u between &p1 and &p99;
run;
quit;



*statistical functions;
/*cv*/
/*kurtosis,mean,min,*/
/*max,missing,nmiss,*/
/*range,std*/
/*sum,uss*/
/*stderr*/
/*var*/
/*rannor*/
/*ranuni, ranpoi and rangam */
/*probt*/
/*probnorm*/
/*probit*/
/*tinv*/


*boxplots;
goptions reset=all;
symbol interpol=boxt10 /* box plot              */
       co=blue         /* box and whisker color */
       bwidth=4        /* box width             */
       value=square    /* plot symbol           */
       cv=red          /* plot symbol color     */
       height=2;       /* symbol height         */
proc gplot data=libData.dataSet;
plot x*stala;
run;
quit;


ods listing close;
ods html path="&dir" body='boxplot.html' style=statistical gpath="&dir" image_dpi=300;
ods graphics on;
proc boxplot data=libData.dataSet;
   plot x*stala /
      boxstyle = schematic
      nohlabel;
run;
proc sgplot data=libData.dataSet;
  vbox x / category=stala;
  yaxis grid;
  xaxis display=(nolabel);
run;
ods graphics off;
ods html close;
ods listing;


*for categorical variables is used proc freq;


