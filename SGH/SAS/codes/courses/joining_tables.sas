/*joining tables, various techniques*/
libname data 'd:\karol\oferta_zajec\pd2_en\data\';

/*classic sql*/
proc sql;
/*inner join more than two tables*/
create table ik as
select * from data.z1 as a, data.z2 as b
where a.id=b.id;

create table ik2 as
select a.id,a.a as a1,b.a as a2,b,c
from data.z1 as a, data.z2 as b
where a.id=b.id; 

/*left join or right*/
create table lj as
select a.id,a.a as a1,b.a as a2,b,c
from data.z1 as a left join data.z2 as b
on a.id=b.id; 

/*full join*/
create table fj as
select a.id,coalesce(a.id,b.id) as id2,
a.a as a1,b.a as a2,b,c
from data.z1 as a full join data.z2 as b
on a.id=b.id; 
quit;

/*joining in sas 4gl*/

/*merge - sorted tables are required
(in a proper order) or indexed*/
data mer;
merge data.z1(in=zz1) data.z2(in=zz2);
by id;
z1=zz1;
z2=zz2;
run;

/*index usage when big dataset is joined with a little one*/
data z2;
set data.z2;
keep id c;
run;
proc datasets lib=work nolist;
modify z2;
index delete _all_;
index create id;
*index create id / unique nomiss;
/*index create complex=(id a);*/
quit;

data final;
set data.z1;
set z2 key=id;
if _iorc_ ne 0 then do;
_error_=0;
c=.;
end;
run;

data final_unique;
set data.z1;
set z2 key=id / unique;
if _iorc_ ne 0 then do;
_error_=0;
c=.;
end;
run;

/*read some information about statement modify in datastep*/
/*and examples 6 and 7*/

/*joining by format*/
/*format has also his unique index*/
/*format can be created based on dataset, see example 5 in SAS help, procedure format*/
proc format;
value day
1='Mon'
2='Thu'
3='Wns'
other='Oth'
;
run;
data final_f;
set data.z1;
pol=put(id,day.);
run;
