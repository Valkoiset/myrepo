/*compress*/
/*translate*/
/*cat*/
/*trim*/
/*left*/

data w;
a='SAS has a power';
b0=compress(a);
b=compress(a,'a ');
run;

data w;
a='SAS has a power';
b=translate(a,'sa','SA');
run;

data w;
length a b $10 c $100;
a='SAS';
b=a||'has a power';
c='***'||a||'has a power'||'***';
run;

data w;
length a b $10 c $100;
a='SAS';
b=trim(a)||'has a power';
c='***'||trim(a)||'has a power'||'***';
run;

data w;
length a b $10 c $100;
a='  SA S  ';
b=trim(left(a))||'has a power';
c='***'||trim(left(a))||'has a power'||'***';
run;
/**/
/*CAT(OF X1-X4)*/
/* X1||X2||X3||X4*/
/* */
/*CATS(OF X1-X4)*/
/* TRIM(LEFT(X1))||TRIM(LEFT(X2))||TRIM(LEFT(X3))||*/
/*TRIM(LEFT(X4))*/
/* */
/*CATT(OF X1-X4)*/
/* TRIM(X1)||TRIM(X2)||TRIM(X3)||TRIM(X4)*/
/* */
/*CATX(SP, OF X1-X4)*/
/* TRIM(LEFT(X1))||SP||TRIM(LEFT(X2))||SP||*/
/*TRIM(LEFT(X3))||SP||TRIM(LEFT(X4))*/
 
data w;
if (a=1 or b>0) and c<0 then do
	a=2;
	b=3;
	output;
end; else do;
	c=8;
	b=y;
	output;
end; 
run;

data w;
if (a=1 or b>0) and c<0 then a=2;
else c=8;
run;

data w;
if (a=1 or b>0) and c<0 then a=2;
run;

data w;
do i=1 to 10;
	output;
end;
	output;
run;

data w;
do i=1 to 10 by 3;
	output;
end;
	output;
run;

data w;
do imie='Karol','Mark','John';
	output;
end;
output;
run;

/*
These iterative DO statements use a list of items for the value of start: 

do month='JAN','FEB','MAR';
do count=2,3,5,7,11,13,17;
do i=5;
do i=var1, var2, var3;
do i='01JAN2001'd,'25FEB2001'd,'18APR2001'd;
These iterative DO statements use the start TO stop syntax: 

do i=1 to 10;
do i=1 to exit;
do i=1 to x-5;
do i=1 to k-1, k+1 to n;
do i=k+1 to n-1;
These iterative DO statements use the BY increment syntax: 

do i=n to 1 by -1;
do i=.1 to .9 by .1, 1 to 10 by 1,
   20 to 100 by 10;
do count=2 to 8 by 2;
These iterative DO statements use WHILE and UNTIL clauses: 

do i=1 to 10 while(x<y);
do i=2 to 20 by 2 until((x/3)>y);
do i=10 to 0 by -1 while(month='JAN');
In this example, the DO loop is executed when I=1 and I=2; the WHILE condition is evaluated when I=3, and the DO loop is executed if the WHILE condition is true. 

DO I=1,2,3 WHILE (condition);
*/


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

data w;
set sashelp.class;
age1=lag(age);
age2=lag2(age);
age3=lag3(age);
run;

data w;
set sashelp.class;
if sex='F' then aaa=lag(age);
age1=lag(age);
age2=lag2(age);
age3=lag3(age);
run;

/*Each occurrence of a LAGn function */
/*in a program generates its own queue */
/*of values.*/

