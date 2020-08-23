/*estimation, deduction, estimation population parameters based on statistics on sample*/
%let dir=d:\karol\oferta_zajec\pd2_en\statistics\estimation\;
libname libData "&dir" compress=yes;

/*data preparation*/
data libData.dataSet;
do id=1 to 3000;
	x=rannor(1);
	grupa=int(id/1501);
	if grupa=0 then y=rannor(1)*10+20; else y=rannor(1)*10+21;
	z=rannor(1)*10+10;
	u=x; if id=100 then u=1000;
	v=rannor(1)*rannor(1)*rannor(1);
	stala=1;
	output;
end;
run;
/*data preparation*/


/*density functions*/
data density;
	do x = -4 to 4 by 0.1;
	   	pdf = PDF('NORMAL',x,0,1);
		cdf = CDF('NORMAL',x,0,1);
		output;
	end;     
run;
goptions reset=all;
symbol v=none i=join;
proc gplot data=density;
plot (pdf cdf)*x / overlay legend;
run;
quit;




*confidence limits for a mena;
proc means data=libData.dataSet
n mean clm maxdec=3 alpha=0.01;
var x;
run;

*test for a mena;
proc univariate data=libData.dataSet 
mu0=10 alpha=0.01;
var z;
run;

*test only for mu=0;
proc means data=libData.dataSet
n mean probt maxdec=3 alpha=0.01;
var x;
run;

data temp;
set libData.dataSet;
z=z-10;
keep z;
run;

proc means data=temp
n mean probt maxdec=3 alpha=0.01;
var z;
run;

/*constraints*/
/*sample has a norma distributions*/
/*sample is significant large e.g. >30obs*/


*tests onesiede and twosides;
%let m0=10;
proc means data=libData.dataSet noprint;
var z;
output out=m n=n mean=m stderr=b;
run;
data w;
set m;
t=(m-&m0)/b;
df=n-1;
prl=probt(t,df);
prp=1-prl;
pr=2*min(prl,prp);
put "H0: mu>=&m0 " prl pvalue7.4;
put "H0: mu<=&m0 " prp pvalue7.4;
put "H0: mu=&m0 " pr pvalue7.4;
run;

/*power of test and minimal sample size*/
proc power plotonly;
onesamplemeans test=t dist=normal
	alpha=0.01 0.05
	mean = 10
	stddev = 10
	ntotal = 5 to 60 by 5
	power = .;
plot x=n;
run;

proc power plotonly;
onesamplemeans test=t dist=normal
	alpha=0.01 0.05
	mean = 10
	stddev = 10
	ntotal = .
	power = 0.1 to 1 by 0.1;
plot x=power;
run;

proc power;
onesamplemeans test=t dist=normal
	alpha=0.01 0.05
	mean = 10
	stddev = 10
	ntotal = .
	power = 0.9;
run;



*test for two means;
proc sort data=libData.dataSet out=s;
by grupa;
run;
proc univariate data=s normal;
var y;
by grupa;
probplot y / normal 
(mu=est sigma=est w=1 color=blue);
run;
proc boxplot data=libData.dataSet;
   plot y*grupa /
      boxstyle = schematic
      nohlabel;
run;
proc ttest data=libData.dataSet;
class grupa;
var y;
run;

*test nonparametric;
proc npar1way data=libData.dataSet wilcoxon median;
class grupa;
var y;
*exact;
run;


/*central limit theorem in practice*/

/*method 1*/
%let rozklad=ranuni(1)*10;
%let n_prob=1000;
%let ile_srednich=40;
data libData.test;
array s(&ile_srednich) sr1-sr&ile_srednich;
do ile_prob=1 to &n_prob;
	do p=1 to &ile_srednich;
		s(p)=0;
		do n=1 to p;
			s(p)=s(p)+&rozklad;
		end;
		s(p)=s(p)/p;
	end;
	output;
end;
keep sr1-sr&ile_srednich;
run;
proc gchart data=libData.test;
vbar3d sr1-sr&ile_srednich / levels=15;
run;
quit;
/*method 1*/

/*method 2*/
%let n_populacji=3000;
%let ile_prob=100;
%let max_n=30;
data populacja;
do i=1 to &n_populacji;
	x=&rozklad;
	output;
end;
drop i;
run;
%macro rob_srednie;
%do n=5 %to &max_n;
	data n&n;
	length sr&n 8;
	delete;
	run;
	%do p=1 %to &ile_prob;
		proc surveyselect data=populacja n=&n noprint out=p&p;
		run;
		proc sql;
		insert into n&n select avg(x) from p&p;
		quit;
	%end;
%end;
%mend;
%rob_srednie;
data libData.test2;
set n5-n&max_n;
run;
proc gchart data=libData.test2;
vbar3d sr5-sr&max_n / levels=15;
run;
quit;
/*method 2*/
