libname data 'd:\karol\oferta_zajec\pd2_en\data\';
proc sort data=data.Transactions
out=trans;
by date;
run;

proc sort data=data.Transactions
out=trans2 dupout=duplicates nodupkey;
by date;
run;

proc sort data=data.Transactions
out=trans2 dupout=duplicates nodupkey;
by date descending id_client;
run;

proc sort data=data.Transactions
out=trans;
by date;
run;
data change;
set trans;
change=amount-lag(amount);
change_percent=dif(amount)/lag(amount);
format change_percent nlpct12.2
amount change nlnum12.;
drop id_client;
run;


data w;
a=1; b=2; c=3;
array t(3) a b c;
t(1)=t(1)+1;
t(2)=t(2)+1;
t(3)=t(3)+1;
run;

data w;
a=1; b=2; c=3;
array t(3) a b c;
t(1)=t(1)+1;
t(2)=t(2)+1;
t(3)=t(3)+1;
run;

data w;
a=1; b=2; c=3;
array t(3) a b c;
do i=1 to 3;
	t(i)=t(i)+1;
end;
run;

data w;
a=1; b=2; c=3;
array t(*) _numeric_;
array x{1:5,1:3} score1-score15;
d=dim(t);
run;

data w;
array t(20);
run;

data w;
array t(20) a1-a20;
t(3)=100;
run;

data w;
array t(20) a1-a20;
t(3)=100;
name=vname(t(3));
run;

data w;
array t(20) _temporary_ (10*5,10*200);
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
		put(t(i,j),best12.-L);
		output;
	end;
end;
run;

data bal;
set data.bal_history;
array t(*) bal:;
/*array t(*) _numeric_;*/
/*array t(*) bal_199806--bal_200609;*/
do i=1 to dim(t);
	t(i)=t(i)*10;
end;
drop i;
run;

data bal;
length name $ 32;
set data.bal_history;
array t(*) bal:;
do i=dim(t) to 1 by -1;
	if t(i)>700 then name=vname(t(i));
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
data w;
set trans;
by id_client;
if last.id_client;
/*if last.id_client=1 then output;*/
run;

