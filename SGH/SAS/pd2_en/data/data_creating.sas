libname data '...';

data data.balance;
set sashelp.class;
id_client=_n_;
il=int(ranuni(1)*15)+2;
date=intnx('month',16000+int(ranuni(1)*600),0,'end');
bal=ranuni(1)*1000;
do i=1 to il;
id_account=id_client*1000+i;
date=intnx('month',date,1,'end');
bal=bal+ranuni(1)*500-ranuni(1)*500;
dpd=abs(int(rannor(1)*10));
output;
end;
format date yymmdd10.;
keep name sex id_client id_account date bal dpd;
run;

data bal;
set sashelp.class;
date=intnx('month',14000,0,'end');
do i=1 to 100;
date=intnx('month',date,1,'end');
bal=ranuni(1)*1000;
period=put(date,yymmn6.);
output;
end;
format date yymmdd10.;
keep name date bal period;
run;
proc sort data=bal;
by name period;
run;
proc sort data=bal out=data.bal_stamps(drop=period);
by name period;
run;

proc transpose data=bal out=data.bal_history(drop=_name_) prefix=bal_;
by name;
id period;
var bal;
run;


data data.clients;
set sashelp.class;
id_client=_n_;
salary=ranuni(1)*3000+1000;
birth_date=int(ranuni(1)*1000+11000);
format birth_date yymmdd10.;
keep name sex salary birth_date id_client;
run;

data data.transactions;
do id_client=1 to 19;
il=int(ranuni(1)*30)+2;
date=int(ranuni(1)*1000+16000);
do i=1 to il;
amount=ranuni(1)*1000+1;
date=date+int(ranuni(1)*20);
output;
end;
end;
format date yymmdd10.;
keep id_client date amount;
run;

data data.z1;
input id a b;
cards;
1 111 11
2 121 12
2 122 13
3 131 14
3 132 15
4 141 16
5 151 17
;
run;

data data.z2;
input id a c;
cards;
1 211 21
2 221 22
2 222 23
3 231 24
4 241 25
4 242 26
6 261 27
;
run;
