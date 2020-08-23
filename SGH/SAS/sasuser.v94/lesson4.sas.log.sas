data W;
do i=1 to 10 while (i<5);
	output;
end;
run;

data W;
do i=1 to 10 until (i>5);
	output;
end;
run;

data w;
amount=1000;
percent=0.04;
do year=1 to 5;
	do m=1 to 12;
		amount=amount*(1+percent/12);
		output;
	end;
end;
format amount nlnum12.2;
/*drop year m;*/
run;

data w ;
set sashelp.class;
keep /* keep shows which variables to keep */
drop /* shows which variables not to show in the final result (drop them) */
run;

data w;
set sashelp.class;
where age > 12 and name in ('Carol, Alfred');
run;

data w;
set sashelp.class;
where name like 'A%';
run;

data w;
set sashelp.class;
where name like '_1%'; /* "_" means any but only one */
run;

data w;
set sashelp.class;
where upcase(name) like '%A%';
run;

data w;
set sashelp.class;
age1=lag(age); 
age2=lag2(age); /* lag2 means show 2 last arguments */ 
age3=lag3(age);
run;
/*Each occurrence of a LAGn function */
/*in a program generates its own queue */
/*of values.*/

data w;
set sashelp.class;
if sex='F' then aaa=lag(name);
age1=lag(name);
age2=lag2(name);
age3=lag3(name);
run;

libname data '/Users/Valkoiset/Desktop/SGH/SAS/codes/courses/';

proc sort data=data.Transactions out=trans;
by date;
run;

proc sort data=data.Transactions
out.trans2 dupout=duplicates nodupkey;
by date;
run;

proc sort data=data.Transactions
out=trans;
by date;
run;
data change;
set trans; /* set means "read this table row by row" */
change=amount-lag(amount);
change_percent=dif(amount)/lag(amount); /* dif = amount - lag(amount) */
format change_percent nlpct12.2
amount change nlnum12.;
drop id_client;
run;

data w;
a=1; b=2; c=3;
array t(3) a b c;
t(1)=t(1)+1;
t(2)=t(2)+10;
t(3)=t(3)+100;
run;

data w;
array t(20) var1-var20; /* creating an array with 20 variables */
run;

data w;
array t(20) a1-a20;
t(3)=100;
name=vname(t(3));
run;

data w;
array t(20) _temporary_ (10*5,10*200); /* means that first 10 values = 5, next 10 values = 200 */
a=1;
b=t(1);
c=t(15);
put _all_;
run;

data w;
length name $ 200;
array t(2,2) _temporary_ (1,2,3,4);
do i=1 to 2;
	do j=1 to 2;
		name='t('||put(i,1.)||
		','||put(j,1.)||')='||
		put(t(i,j),best12.-L); /* best12.-L means "move all numbers to the left" */
		output;
	end;
end;
run;

data bal;
set data.bal_history;
array t(*) bal:;	/* create an array with all variables with prefics bal */
/*array t(*) _numeric_;*/
/*array t(*) bal_199806--bal_200609; double  -- shows a range of variables*/
do i=1 to dim(t);	/* dim means dimension */
	t(i)=t(i)*10;
end;
drop i;
run;

proc sort data=data.Transactions
out=trans;
by id_client date;
run;
data w;
set trans;
by id_client;
put _all_;
run;

/*homework: course4. from 1 to 67*/