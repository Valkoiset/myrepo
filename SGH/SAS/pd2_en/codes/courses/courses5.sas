/*see file joining_tables.sas*/

/*dataset a has a variable id*/
/*dataset b has a variable id2*/
data mer;
merge a b(rename=(id2=id));
by id;
run;


data viewkb / view=viewkb;
set b;
id=input(id2,best12.);
run;
data mer;
merge a viewkb;
by id;
run;

proc sql;
create view a as 
select * from sashelp.class;
quit;

proc datasets nolist lib=work kill;
quit;
proc delete data=a;
run;
/*obs=100*/
proc copy in=libin out=libout;
/*select a b c;*/
run;

data d;
do i=1 to 10000;
	x=ranuni(1);
	output;
end;
run;
data d2;
set d;
where x<0.01;
run;
proc datasets lib=work nolist;
modify d;
index delete _all_;
index create x;
quit;
options msglevel=i; 
data d2;
set d;
where x<0.01;
/*where x<0.9;*/
run;
data d2;
set d(idxwhere=yes);
where x<0.9;
run;
data d2;
set d(idxname=x);
where x<0.9;
run;

data final;
err=0;
set data.z1;
set z2 key=id;
if _iorc_ ne 0 then do;
/*_error_=0;*/
/*c=.; */
err=1;
end;
run;

data final;
err=0;
set data.z1;
set z2 key=id;
if _iorc_ ne 0 then do;
_error_=0;
c=.; 
err=1;
end;
run;

proc format;
value seniority
low-<12 = 'Small'
12<-14 = 'Average'
14-high='Big'
other='Other'
/*11,12,13,14='text'*/
;
run;
data w;
sen=12;
put sen seniority.;
run;
data w;
set sashelp.class;
format age seniority.;
run;
options nofmterr;
