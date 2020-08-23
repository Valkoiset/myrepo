libname data 'path to data' access=readonly;
libname b 'path to working directory';
option compress=binary;

proc sort data=data.transactions out=trans;
by aid cid product period;
quit;

data trans;
set trans;
by aid cid;
default=(due_installments>=3);
if due_installments>=3 then ttd=intck('month',input(fin_period,yymmn6.),input(period,yymmn6.));
run;

proc sql;
create table trans as
select distinct aid, cid, product, fin_period,
	   max(default) as default, 
	   case when min(leftn_installments)=0 and max(default)=0 then 0 
	        when min(leftn_installments)>0 and max(default)=0 and max(period)='200812' then 1 
            when max(default)=1 then 2 end as rc,
       min(case when ttd >= 0 then ttd end) as ttd,
       case when max(default)=0 then max(period) else min(case when default=1 then period end) end as max_period
  from trans
 group by aid, cid;
quit;

data trans;
set trans;
if ttd=. then ttd=intck('month',input(fin_period,yymmn6.),input(max_period,yymmn6.));
run;

proc sql;
create table b.dane as
select distinct t.*, p.*
  from data.production p
       left join trans t on t.aid=p.aid and t.cid=p.cid;
quit;
