/*diagnostyka regresji*/
%let dir=G:\WS\diagnostyka_regresji\;
libname wej 'G:\WS\diagnostyka_regresji' compress=yes;

/*przygotowanie danych*/
data wej.dane;
do id=1 to 3000;
	x1=10*ranuni(1)+10;
	x2=10*ranuni(1)+10;
	y=2*x1+2*rannor(1);
	z=5+2*x1-3*x2+2*rannor(1);
	output;
end;
run;
/*przygotowanie danych*/



*regresja;
*wykresy rozrzutu;
goptions reset=all;
proc gplot data=wej.dane;
plot y*x1;
where x1 between 12 and 13;
run;
quit;
proc gplot data=wej.dane;
plot y*x1;
run;
quit;

symbol v=point i=rlcli90 width=1 cv=blue ci=red co=green;
proc gplot data=wej.dane;
plot y*x1 / regeqn;/*regeqn - dodaje równanie regresji*/
run;
quit;


*wspolczynni korelacji;
proc corr data=wej.dane outp=pearson outs=spearman /*pearson spearman*/;
with y z;
var x1 x2;
run;

*macierz;
proc corr data=wej.dane;
var x1 x2 y z;
run;
proc corr data=wej.dane;
var _numeric_;
run;

/*graphics*/
ods listing close;
ods html path="&dir" body='corr.html' style=statistical gpath="&dir" image_dpi=300;
ods graphics on;
proc corr data=wej.dane;
var _numeric_;
run;
ods graphics off;
ods html;



*regresja;
proc reg data=wej.dane;
model y=x1;
run;
quit;


/*graphics*/
ods listing;
ods html path="&dir" body='reg.html' style=statistical gpath="&dir" image_dpi=300;
ods graphics on;
proc reg data=wej.dane;
model y=x1;
run;
quit;
ods graphics off;
ods html close;
ods listing;

/*p³aszczyzna regresji dwuzmiennowej*/
%macro rys(nazwa,zbior,z,x,y);
proc reg data=&zbior outest=b noprint;
model &z=&x &y;
run;
quit;
%local podzial; %let podzial=50;
proc means data=&zbior noprint nway;
var &x &y;
output out=s min()= range()= / autoname;
run;
data dane;
set s;
do i=0 to &podzial;
  do j=0 to &podzial;
    &x=&x._Min+&x._Range*i/&podzial;
	&y=&y._Min+&y._Range*j/&podzial;
	output;
  end;
end;
keep &x &y;
run;
proc score data=dane score=b out=score(rename=(model1=&z)) type=parms; 
var &x &y; 
run; 
data score;
length shape color $ 20;
set score(in=i) &zbior;
if i then do; shape='square'; color='blue'; end;
else do; shape='balloon'; color='red'; end;
keep &x &y &z shape color;
run;
ods listing close;
goptions device=activex;
ods html path="&dir" body="plaszczyzna_&nazwa..html" style=statistical;
proc g3d data=score;
scatter &y*&x=&z / shape=shape color=color noneedle;
run;
quit;
ods html close;
ods listing;
goptions device=win;
%mend;

%rys(losowe, wej.dane, z, x1, x2);
%rys(klasa, sashelp.class, age, weight, height);


/*Podstawowa diagnostyka*/
proc reg data=wej.dane;
model y=x1 / spec;/*White - heteroskedastycznoœæ*/
output out=reszty r=r;
plot r. * (p. y);*dwa rodzaje wykresu reszt;/*reszty*(predykcja wartoœci)*/
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;/*reszty/odch std * nr obs*/
plot nqq. * student.;*normalnosc reszt; /*normal quantile-quantile plot * reszty/odch std*/
run;
quit;
proc univariate data=reszty mu0=0 alpha=0.01;
var r;
run;


/*B³êdy wnioskowania korelacji i regresji*/

/*b³¹d 1*/
data blad;
do id=1 to 3000;
	x=10*ranuni(1)+10;
	y=2*x+2*rannor(1);
	output;
end;
do id=3001 to 3010;
	x=20;
	y=2000+5*rannor(1);
	output;
end;
run;
symbol v=circle i=rlcli90 width=1 cv=blue ci=red co=green;
proc gplot data=blad;
plot y*x / regeqn;/*regeqn - dodaje równanie regresji*/
run;
quit;

symbol v=circle i=rlcli90 width=1 cv=blue ci=red co=green;
proc gplot data=blad;
plot y*x / regeqn;/*regeqn - dodaje równanie regresji*/
where id le 3000;
run;
quit;


proc corr data=blad pearson spearman;
with y;
var x;
run;
proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);*dwa rodzaje wykresu reszt;
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;*normalnosc reszt;
run;
quit;

proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);*dwa rodzaje wykresu reszt;
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;*normalnosc reszt;
where id<=3000;
run;
quit;
/*b³¹d 1*/


/*b³¹d 2*/
data blad;
do id=1 to 3000;
	x=10*ranuni(1)-5;
	y=(10*ranuni(1)-5)*((25-(x**2))**0.5);
	output;
end;
do id=3001 to 3010;
	x=5;
	y=2000+5*rannor(1);
	output;
end;
run;
symbol v=circle i=rlcli90 width=1 cv=blue ci=red co=green;
proc gplot data=blad;
plot y*x / regeqn;/*regeqn - dodaje równanie regresji*/
where id le 3000;
run;
quit;
proc corr data=blad pearson spearman;
with y;
var x;
run;
proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);*dwa rodzaje wykresu reszt;
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;*normalnosc reszt;
run;
quit;


proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);*dwa rodzaje wykresu reszt;
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;*normalnosc reszt;
where id<=3000;
run;
quit;
/*b³¹d 2*/



/*b³¹d 3*/
data blad;
do id=1 to 3000;
	x=10*ranuni(1)-5;
	y=sin(x);
	output;
end;
run;
symbol v=circle i=rlcli90 width=1 cv=blue ci=red co=green;
proc gplot data=blad;
plot y*x / regeqn;/*regeqn - dodaje równanie regresji*/
run;
quit;
proc corr data=blad pearson spearman;
with y;
var x;
run;
proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);*dwa rodzaje wykresu reszt;
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;*normalnosc reszt;
run;
quit;
/*b³¹d 3*/



/*b³¹d 4*/
data blad;
do id=1 to 3000;
	x=10*ranuni(1)-5;
	y=x*x;
	output;
end;
run;
symbol v=circle i=rlcli90 width=1 cv=blue ci=red co=green;
proc gplot data=blad;
plot y*x / regeqn;/*regeqn - dodaje równanie regresji*/
run;
quit;
proc corr data=blad pearson spearman;
with y;
var x;
run;
proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);*dwa rodzaje wykresu reszt;
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;*normalnosc reszt;
run;
quit;

proc autoreg data=blad;
model y=x/reset;
run;
proc reg data=blad;
model y=x / spec dwprob;
run;quit;
/*b³¹d 4*/



/*b³¹d 5*/
data blad;
do id=1 to 3000;
	x=10*ranuni(1);
	y=x*x+5*rannor(1);
	output;
end;
run;
symbol v=circle i=rlcli90 width=1 cv=blue ci=red co=green;
proc gplot data=blad;
plot y*x / regeqn;/*regeqn - dodaje równanie regresji*/
where id le 3000;
run;
quit;
proc corr data=blad pearson spearman;
with y;
var x;
run;
proc reg data=blad;
model y=x / spec;
plot (y p.)*x / overlay;
plot r. * (p. y);*dwa rodzaje wykresu reszt;
plot student. * obs. / vref=3 2 -2 -3 vaxis=-4 to 4 by 1;
plot nqq. * student.;*normalnosc reszt;
run;
quit;
/*b³¹d 5*/
/*B³êdy wnioskowania korelacji i regresji*/

/*predykcja*/
data dane;
set wej.dane end=e;
output;
if e then do;
	y=.;
	x1=5; output;
	x1=100; output;
end;
keep y x1;
run;
proc reg data=dane;
model y=x1 / noint;
output out=regresja p=pred r=reszty lcl=dol ucl=gora lclm=dolsr
uclm=gorasr;
run;
quit;

proc reg data=sashelp.cars;
model invoice = EngineSize Horsepower Weight / 
	 collin tol vif;
run;quit;

