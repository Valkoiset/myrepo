/*courses PD2_en*/

data w;
retain a 0;
put _all_;
run;

data w;
retain a1-a20 (5*0,5*1,5*2,5*3);
put _all_;
run;

data w;
a=-1; /*1959-12-31*/
a=0;  /*1960-01-01*/
format a yymmdd10.;
run;

data w;
length d1 d2 d3 t1 t2 t3 dt1 dt2 8;
d1=today();
d2='01jan2014'd;
d3=0;
t1='12:34:56't;
t2=0;
t3=time();
dt1='01jan2014:12:34:56'dt;
dt2=datetime();
format d1 yymmdd10. d2 ddmmyy10. d3 date.
t1 t2 t3 time. dt1 dt2 datetime.;
run;
/*where data > '01mar2013'd;*/

data w;
length d1 d2 d3 t1 t2 t3 dt1 dt2 8;
dt1='01jan2014:12:34:56'dt;
d1=datepart(dt1);
d2='01jan2014'd;
d3=0;
t1='12:34:56't;
t2=timepart(dt1);
t3=time();
dt2=d2*24*3600+t1;
format d1 yymmdd10. d2 ddmmyy10. d3 date.
t1 t2 t3 time. dt1 dt2 datetime.;
run;

data w;
t='elen has a cat';
t2=substr(t,6,3);
t3=scan(t,2,' a');
run;

data w;
t='elen has a cat';
i=index(t,'elen');
i2=index(t,'Elen');
t3=scan(t,-1,' ');
run;

data w;
t='elen has a cat';
i=index(t,'elen');
i2=index(upcase(t),'ELEN');
t3=scan(t,-1,' ');
run;


data w;
a=.;
b=.a;
c=0;
t='    ';
ma=missing(a);
mb=missing(b);
mc=missing(c);
mt=missing(t);
run;

data w;
t='elen';
substr(t,1,2)='Te';
run;

/*day(), year(), month(), qtr(),*/
/*week(), weekday(), hms(), mdy()*/
/*intck() i intnx()*/

data w;
wiek=yrdif('12jan1980'd, date(), 'ACT/ACT');
run;

data w;
retain a1-a100 1;
s=sum(a1,a2,a3);
ss=sum(of a1-a100);
sss=sum(of a:);
run;

data w;
a=1; b=.;
s=sum(a,b);
s2=a+b;
s3=mean(a,b);
run;

data w;
do i=1 to 1000;
	x=ranuni(1);
	output;
end;
run;

data w;
length a 5;
l=vlength(a);
run;

data w;
a=12;
put a z10.;
run;
