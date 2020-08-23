/*statistics automation*/
/*(c) Karol Przanowski*/
/*kprzan@sgh.waw.pl*/
%let dir=d:\karol\oferta_zajec\pd2_en\statistics\automatic\;
libname outlib "&dir.data" compress=yes;

%include "&dir.dataSet.sas" / source2;

%let variables=x1-x20;
%let tar=y;


/*example*/
proc reg data=outlib.dataSet outest=e;
model y=x1-x20 / selection=rsquare adjrsq bic sbc cp rmse aic
best=30 start=4 stop=10 ;
run;
quit;




data outlib.train outlib.valid;
set outlib.dataSet;
if ranuni(1)<0.6 then output outlib.train;
else output outlib.valid;
keep &tar &variables;
run;

%include "&dir.model_calc.sas" / source2;
%include "&dir.model_assessment.sas" / source2;


/*outliers and influence observations*/
%let good_model=  x2 x3 x5 x10 x12 x15 x16 x17;
%let p=9;
%let n=5000;
/*ods trace on / listing;*/
/*ods trace off;*/
ods listing close;
ods output OutputStatistics=outlib.stat;
proc reg data=outlib.dataSet outest=e;
model y=&good_model / influence vif collin spec collinoint r cli clm p;
run;
quit;
ods output close;
ods listing;

data outlib.untypical;
set outlib.stat;
if
abs(RStudent)>3
or HatDiagonal>(2*&p/&n)
or CooksD > (4/&n)
or abs(DFFITS)> 2*sqrt(&p/&n)
or min(of DFB:) > 2/sqrt(&n)
or max(of DFB:) < -2/sqrt(&n)
or abs(CovRatio-1) > 3*&p/&n
;
run;

/*transformation*/
proc transreg data=outlib.dataSet ;
model boxcox(y / lambda=-2 to 2 by 0.05)=identity(&good_model);
run;
quit;

%let trans_var=x3;
/*%let trans_var=x2;*/
%let lambda=-2 to 2 by 0.05;
%let stat_test=Cramer-von Mises;
/*%let stat_test=Anderson-Darling;*/
/*%let stat_test=Kolmogorov-Smirnov;*/
%include "&dir.boxcox.sas" / source2;


/*partial correlation*/
proc corr data=outlib.dataSet rank pearson;
   with y;
   var x1-x20;
run;
proc corr data=outlib.dataSet rank pearson;
   with y;
   var x10 ;
   partial x1-x9 x11-x20;
run;
%include "&dir.partial.sas" / source2;


/*variable clustering*/
proc corr data=outlib.dataSet outp=outlib.corr_matrix noprint;
   var &variables;
run;

ods listing close;
ods output
ClusterQuality=ClusterQuality
RSquare(match_all)=RSquare2
ClusterSummary(match_all)=ClusterSummary1;
/*ods trace on / listing;*/
/*ods trace off;*/
proc varclus data=outlib.dataSet(keep=&variables) PROPORTION=0.8;
var &variables;
run;
ods output close;
ods listing;

data _null_;
set Clusterquality;
call symput('ncl',
trim(put(NumberOfClusters,best12.-L)));
run;
%put **&ncl**;

data outlib.clusters;
length cl cluster $ 20;
format cluster $20.;
retain cl;
set rsquare&ncl;
if not missing(Cluster) then cl=Cluster;
if missing(Cluster) then Cluster=cl;
cluster='Cluster '||put(input(compress(scan(cluster,-1,' ')),best12.),z3.);
keep Variable Cluster RSquareRatio;
run;

ods listing close;
ods output
Eigenvalues=outlib.Eigenvalues;
/*ods trace on / listing;*/
/*ods trace off;*/
proc princomp data=outlib.dataSet(keep=&variables);
var &variables;
run;
ods output close;
ods listing;


/*principal component analyses*/
proc princomp data=outlib.dataSet(keep= &tar &variables) out=outlib.prin n=12 noprint;
var &variables;
run;
proc reg data=outlib.prin outest=e;
model &tar=prin: / vif collin collinoint;
run;
quit;

ods listing close;
ods html path="&dir.reports" body='pls.html' style=statistical gpath="&dir.reports" image_dpi=300;
ods graphics on / imagefmt=png;
proc pls data=outlib.dataSet nfac=12 plot=(ParmProfiles VIP);
   model &tar = &variables;
run;
ods graphics off;
ods html close;
ods listing;



