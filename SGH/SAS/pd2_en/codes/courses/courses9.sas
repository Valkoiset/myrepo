%let gender=F;
options symbolgen;
proc print data=sashelp.class;
where sex="&gender";
run;

%let gender='F';
proc print data=sashelp.class;
where sex=&gender;
run;

%let gender=F;
options symbolgen;
title "Report for gender &gender";
proc print data=sashelp.class;
where sex="&gender";
run;

/*different example*/
proc print data=sashelp.class;
where sex=&gender;
run;
/*<=>*/
proc print data=sashelp.class;
where sex=F;
run;


%let seniority=12;
proc print data=sashelp.class;
where age=&seniority;
run;


%let a=1;
%let b=2;
%let c=&a+&b;
%put &c;
%let c=%eval(&a+&b);
%put &c;

%let a=1.6;
%let b=2.6;
%let c=%sysevalf(&a+&b);
%put &c;

/*%substr()*/
/*%scan()*/
/*%index()*/

data w;
a='SAS#is#theBest';
b=scan(a,1,'#');
run;
%let a=SAS#is#theBest;
%let b=%scan(&a,1,#);
%put &b;

%let a=SAS is theBest;
%let b=%scan(&a,1,%str( ));
%put &b;

/*str, nrstr, nrbquote */

%let a=%sysfunc(today(),yymmdd10.);
%put &a;


%let dir=c:\reports\;
%let year=2014;
%let product=DIY;
%let path=&dir&year._&product..html;
%put &path;

%let lib=sashelp;
%let dataset=class;
proc print data=&lib..&dataset;
run;


%let p=proc;
%let r=run;
%let z=sashelp.class;
&p print data=&z; &r;

/*&& -> &*/

%let d1=sashelp.class;
%let d2=sashelp.air;
%let i=1;
/*%let dataset= d(i)*/
%let dataset=&&d&i;
%put &dataset;

%let a=b;
%let b=c;
%let c=d;
%let e=&&&&&&&a;
%put &e;

/*z³y przyk³ad*/
%symdel d;
%let dataset=&d&i;
%put &dataset;
/*if macro cannot be solved then is not changed*/

%let d=cos;
%let dataset=&d&i;
%put &dataset;

%let dataset=&&d&i;
%put &dataset;


data _null_;
set sashelp.class;
/*call symput('a','12');*/
call symput(name,trim(sex));
run;
/*%put &a;*/
%put &alfred;

%put _user_;
%put _automatic_;

data _null_;
set sashelp.class;
call symput('name'||put(_n_,best12.-L),
trim(name));
run;
%put &name1***&name2***&name19;
%let n=2;
%put &&name&n;
%put &&&&&&name&n;

/*&&&&&&name&n*/
/*&&&name2*/
/*&Alice*/

proc sql noprint;
select name into :name1-:name99999
from sashelp.class order by name;
quit;
%let n_name=&sqlobs;
%put &n_name;


%macro rap;
%do i=1 %to &n_name;
	proc print data=sashelp.class;
	where name="&&name&i";
	run;
%end;
%mend;
%rap;

/*study additional codes podzial*.sas*/
%podzial(sashelp.prdsale,product);


proc sql noprint;
select name into :names separated by '#'
from sashelp.class order by name;
quit;
%let n_name=&sqlobs;
%put &n_name***&names;

%macro report(a,b);
%if &a=12 %then %put Exists 12;
%else %do;
	%put Not exists 12;
%end;
%mend;
%report(12,34);

/*macro variable scope*/
%let a=20;
%macro docount;
%local a;
%let b=0;
%let a=22;
%put _user_;
%mend;
%docount;
%put &a***&b;
