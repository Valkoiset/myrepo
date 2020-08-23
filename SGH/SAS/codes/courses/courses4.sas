/*processing in groups mechanism */
libname data 'd:\karol\oferta_zajec\pd2_en\data\';

proc sort data=data.Transactions
out=s;
by id_client date;
run;
data result;
set s;
by id_client;
if first.id_client then sum=0;
sum+amount;
if last.id_client;
format sum nlnum12.;
keep id_client sum;
run;
data result;
retain sum;
set s;
by id_client;
if first.id_client then sum=0;
sum=sum+amount;
if last.id_client;
format sum nlnum12.;
keep id_client sum;
run;

data result;
retain sum;
set s;
by id_client;
if first.id_client then sum=0;
sum=sum(sum,amount);
if last.id_client;
format sum nlnum12.;
keep id_client sum;
run;

/*
retain sum 0;
sum=sum(sum,amount);
||
sum+amount;
*/

data result;
do i=1 to n_obs;
	set s nobs=n_obs;
	by id_client;
	if first.id_client then sum=0;
	sum=sum(sum,amount);
	if last.id_client then output;
end;
format sum nlnum12.;
keep id_client sum;
run;

data result;
retain begin;
set s;
by id_client;
if first.id_client then begin=amount;
if last.id_client;
dynamism=(amount-begin)/begin;
format dynamism nlpct12.2;
keep id_client dynamism;
run;
/*processing in groups mechanism */

/*options obs=10;*/
/*9223372036854775807*/
data result;
set sashelp.class(obs=5);
run;
data result;
set sashelp.class(firstobs=2 obs=5);
run;


/*proc sql outobs=3;*/
proc sql;
create table result as
select * from sashelp.class;
create table result2 as
select age as seniority
label='Customer seniority' format=nlnum12.
from sashelp.class;
quit;
/*code joining_tables.sas*/

data join left right;
merge data.z1(in=z1) data.z2(in=z2);
by id;
if z1 and z2 then output join;
if z1 and not z2 then output left;
if not z1 and z2 then output right;
run;
