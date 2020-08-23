libname inlib 'd:\karol\oferta_zajec\pd2_en\project\data\';
data vin;
set inlib.Transactions;
seniority=intck('month',input(fin_period,yymmn6.),input(period,yymmn6.));
vin3=(due_installments>=3);
output;
if status in ('B','C') and period<='200812' then do;
	n_steps=intck('month',input(period,yymmn6.),input('200812',yymmn6.));
	do i=1 to n_steps;
		period=put(intnx('month',input(period,yymmn6.),1,'end'),yymmn6.);
		seniority=intck('month',input(fin_period,yymmn6.),input(period,yymmn6.));
		output;
	end;
end;
where product='ins';
keep fin_period vin3 seniority;
run;
proc means data=vin noprint nway;
class fin_period seniority;
var vin3;
output out=vintagr(drop=_freq_ _type_) n()=production mean()=vintage3;
format vintage3 nlpct12.2;
run;
proc means data=vin noprint nway;
class fin_period;
var vin3;
output out=production(drop=_freq_ _type_) n()=production;
where seniority=0;
run;
proc transpose data=vintagr out=vintage prefix=months_after_;
by fin_period;
var vintage3;
id seniority;
run;

data prod;
set Vintagr;
where seniority=0;
keep production fin_period;
run;

data vin_prod;
merge prod vintage(drop=_NAME_);
by fin_period;
run;



%let dir=d:\karol\oferta_zajec\pd2_en\project\example\;


ods listing close;
goptions reset=all device=activex;
ods html path="&dir" body='Vintage.html' style=statistical;


symbol1 i=join c=red line=1 v=dot h=0.5 w=2;
symbol2 i=join c=green line=1 v=dot h=0.5 w=2;
symbol3 i=join c=blue line=1  v=dot h=0.5 w=2;
symbol4 i=join c=black line=1 v=dot h=0.5 w=2;
symbol5 i=join c=yellow line=1 v=dot h=0.5 w=2;
symbol6 i=join c=cyan line=1 v=dot h=0.5 w=2;
symbol7 i=join c=brown line=1 v=dot h=0.5 w=2;
symbol8 i=join c=blue line=2 v=dot h=0.5 w=2;
symbol9 i=join c=green line=2 v=dot h=0.5 w=2;
symbol10 i=join c=red line=2 v=dot h=0.5 w=2;


LEGEND1
FRAME
LABEL=(FONT='Calibri' HEIGHT=10pt )
VALUE=(FONT='Calibri' HEIGHT=10pt )
;
LEGEND2
FRAME
LABEL=(FONT='Calibri' HEIGHT=10pt )
VALUE=(FONT='Calibri' HEIGHT=10pt )
;

title 'Vintage 3+ in numbers - evolution';
PROC GBARLINE DATA=vin_prod;
	BAR	 fin_period / discrete
    SUMVAR=production
	COUTLINE=LTGRAY
	LEGEND=LEGEND;
	PLOT / SUMVAR=months_after_3 TYPE=mean LEGEND=LEGEND2;
	PLOT / SUMVAR=months_after_6 TYPE=mean LEGEND=LEGEND2;
	PLOT / SUMVAR=months_after_9 TYPE=mean LEGEND=LEGEND2;
	PLOT / SUMVAR=months_after_12 TYPE=mean LEGEND=LEGEND2;
	label fin_period='Month' production='Production' 
	months_after_3='3'
	months_after_6='6'
	months_after_9='9'
	months_after_12='12'
	;
	format production comma14.1 months: percent12.1;
RUN;
quit;
ods html close;
ods listing;
goptions reset=all device=win;



ods listing close;
goptions hsize=9in vsize=6in dev=ACTXIMG;
goptions reset=all;
ods powerPoint file="&dir.vintage.ppt" dpi=300;
ods powerpoint layout=_null_; 


symbol1 i=join c=red line=1 v=dot h=0.5 w=2;
symbol2 i=join c=green line=1 v=dot h=0.5 w=2;
symbol3 i=join c=blue line=1  v=dot h=0.5 w=2;
symbol4 i=join c=black line=1 v=dot h=0.5 w=2;
symbol5 i=join c=yellow line=1 v=dot h=0.5 w=2;
symbol6 i=join c=cyan line=1 v=dot h=0.5 w=2;
symbol7 i=join c=brown line=1 v=dot h=0.5 w=2;
symbol8 i=join c=blue line=2 v=dot h=0.5 w=2;
symbol9 i=join c=green line=2 v=dot h=0.5 w=2;
symbol10 i=join c=red line=2 v=dot h=0.5 w=2;


LEGEND1
FRAME
LABEL=(FONT='Calibri' HEIGHT=10pt )
VALUE=(FONT='Calibri' HEIGHT=10pt )
;
LEGEND2
FRAME
LABEL=(FONT='Calibri' HEIGHT=10pt )
VALUE=(FONT='Calibri' HEIGHT=10pt )
;

title 'Vintage 3+ in numbers - evolution';
PROC GBARLINE DATA=vin_prod;
	BAR	 fin_period / discrete
    SUMVAR=production
	COUTLINE=LTGRAY
	LEGEND=LEGEND;
	PLOT / SUMVAR=months_after_3 TYPE=mean LEGEND=LEGEND2;
	PLOT / SUMVAR=months_after_6 TYPE=mean LEGEND=LEGEND2;
	PLOT / SUMVAR=months_after_9 TYPE=mean LEGEND=LEGEND2;
	PLOT / SUMVAR=months_after_12 TYPE=mean LEGEND=LEGEND2;
	label fin_period='Month' production='Production' 
	months_after_3='3'
	months_after_6='6'
	months_after_9='9'
	months_after_12='12'
	;
	format production comma14.1 months: percent12.1;
RUN;
quit;
ods powerPoint close;
ods listing;
goptions reset=all device=win;
