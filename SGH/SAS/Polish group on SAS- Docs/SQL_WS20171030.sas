/*SQL*/

proc sql;
select name, weight
from sashelp.class;
quit;

proc sql;
select *
from sashelp.class;
quit;

proc sql;
select distinct age
from sashelp.class;
quit;

proc sql;
select sum(age) as sum_age
from sashelp.class;
quit;

proc sql;
select count(*)
from sashelp.class;
quit;

proc sql;
select count(distinct age)
from sashelp.class;
quit;

/*proc sql; select top 5 * from sashelp.class; quit;*/
/*proc sql; select * from sashelp.class limit 5; quit;*/
proc sql; select * from sashelp.class where rownum<=5; quit;

proc sql;
select *
from sashelp.class;
quit;

proc sql noprint;
create table w as
select 
	name,
	age as wiek,
	weight
from sashelp.class
where sex = 'F';
quit;

proc sql noprint;
create table w as
select *
from sashelp.class
order by age, height;
quit;

proc sql noprint;
create table w as
select *
from sashelp.class
order by name descending;
quit;

proc sql noprint;
insert into w
values ('Tomasz', 'M', 20, 55, 100);
quit;

proc sql noprint;
insert into w (name, age, height, weight)
values ('Tomasz', 20, 55, 100);
quit;

proc sql noprint;
insert into w (kolumna)
values (999);
quit;

data q;
set sashelp.class;
if name='Alice' then age = .;
if name='William' then age = .a;
run;

proc sql noprint;
create table w as
select *
from q
where age is null;
/*where missing(age);*/
quit;

data w; set sashelp.class; run;

proc sql noprint;
update w
set age=999, height=111
where sex='F';
quit;

proc sql noprint;
delete from w
where sex='F';
quit;

proc sql noprint;
create table w as
select * from sashelp.class where sex='F'
union
select * from sashelp.class where age=12;
quit;

proc sql noprint;
create table w2 as
select * from sashelp.class where sex='F'
union all
select * from sashelp.class where age=12;
quit;

proc sql noprint;
create table w as
select 
	name, age, height, weight,
	sum(height, weight) as col1,
	calculated col1/2 as col2
from sashelp.class;
quit;


proc sql noprint;
create table w as
select 
	name, age, height, weight,
	sum(height, weight) as col1,
	calculated col1/2 as col2
from sashelp.class
where calculated col1 gt 150;
quit;

proc sql noprint;
create table w as
select 
	sex,
	mean(age) as mean_age
from sashelp.class
group by sex;
quit;

data w;
set sashelp.class;
do i=1 to 3;
	jablka=round(10*ranuni(1),1);
	gruszki=round(5*ranuni(2),1);
output;
end;
drop i;
run;

proc sql noprint;
create table w2 as
select 
	name,
	sum(jablka) as suma_jablek,
	sum(gruszki) as suma_gruszek
from w
group by name;
quit;

proc sql noprint;
create table w3 as
select 
	name, 
	sum(jablka, gruszki) as liczba_owocow
from w
group by name;
quit;

proc sql noprint;
create table w4 as
select 
	name, 
	sum(sum(jablka), sum(gruszki)) as liczba_owocow
from w
group by name;
quit;

proc sql noprint;
create table w5 as
select 
	name, 
	sum(sum(jablka, gruszki)) as liczba_owocow
from w
group by name;
quit;

proc sql noprint;
create table w6 as
select 
	name, jablka, gruszki,
	sum(jablka) as suma_jablek,
	sum(gruszki) as suma_gruszek
from w
group by name;
quit;

proc sql noprint;
create table w7 as
select 
	name, jablka, gruszki,
	sum(jablka) as suma_jablek,
	sum(gruszki) as suma_gruszek
from w
where jablka ge 5
group by name;
quit;

proc sql noprint;
create table w8 as
select 
	name, jablka, gruszki,
	sum(jablka) as suma_jablek,
	sum(gruszki) as suma_gruszek
from w
where calculated suma_jablek ge 15
group by name;
quit;

proc sql noprint;
create table w8 as
select 
	name, jablka, gruszki,
	sum(jablka) as suma_jablek,
	sum(gruszki) as suma_gruszek
from w
group by name
having suma_jablek ge 15;
quit;

proc sql noprint;
create table w9 as
select 
	name, jablka, gruszki,
	sum(jablka) as suma_jablek,
	sum(gruszki) as suma_gruszek
from w
where jablka ge 5
group by name
having suma_jablek ge 15;
quit;

proc sql noprint;
create table w as
select 
	*,
	case when sex = 'F' then 'kobieta' else 'mezczyzna' end as plec_PL
from sashelp.class;
quit;

proc sql noprint;

create table wynik as
select * 
from sashelp.class
where weight gt 90;

create table wynik2 as
select 
	age as wiek label='Wiek klienta' format=nlnum12.
from sashelp.class;

quit;

proc sql noprint;
create table w as
select *
from sashelp.class
where name in (
	select name from wynik);
quit;


