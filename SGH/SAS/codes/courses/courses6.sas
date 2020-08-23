/*libname data 'd:\karol\oferta_zajec\pd2_en\data\';*/


data zb1;
set data.Transactions;
period=put(date,yymmn6.);
label='Period '||put(date,yymm7.);
run;
proc sort data=zb1 nodupkey;
by id_client period;
run;
proc transpose data=zb1 out=t1(drop=_name_)
prefix=period_;
by id_client;
id period;
idlabel label;
var amount;
run;

proc transpose data=t1 
out=t2(rename=(col1=amount));
by id_client;
var period:;
run;

data t3;
set t2;
period=substr(_name_,7,6);
if not missing(amount);
drop _name_ _label_; 
run;

/*exercise*/
data zb1;
set data.Bal_stamps;
period=put(date,yymmn6.);
run;
proc sort data=zb1 nodupkey;
by Name period;
run;
proc transpose data=zb1 out=t1(drop=_name_)
prefix=bal_;
by Name;
id period;
var bal;
run;

/*formats*/
proc format;
picture percent_pl (round)
low- -0.005='00.000.000.009,99 %'
(decsep=',' 
dig3sep='.'
fill=' '
prefix='-')
-0.005-high='00.000.000.009,99 %'
(decsep=',' 
dig3sep='.'
fill=' ')
;
run;
data _null_;
do i=-0.02 to 0.02 by 0.0001;
put i 10.4 '  ' i percent_pl.;
end;
run;


/*proc format;*/
/*value amount*/
/*low -< 500 ='Small'*/
/*34,56,78 = 'Other'*/
/*500 - high = 'Big'*/
/*other='Missing'*/
/*;*/
/*value $am_text*/
/*'abc' = 'ABC'*/
/*'Mon' = 'Monday'*/
/*;*/
/*run;*/
/*format tekst $am_text.;*/

proc format;
value amount
low -< 500 ='Small'
500 - high = 'Big'
other='Missing'
;
run;
data test;
set data.Transactions;
amount2=amount;
format amount2 amount.;
run;
proc format cntlout=w;
run;
proc format cntlin=w;
run;

/*aggregation*/
proc freq data=sashelp.class;
table age;
run;
proc freq data=sashelp.class noprint;
table age / out=freq missing outcum;
run;
proc freq data=sashelp.class noprint;
table age*sex / out=freq missing;
run;
data w2;
a=1; output;
a=.; output;
run;
proc freq data=w2 noprint;
table a / out=freq1 outcum;
run;
proc freq data=w2 noprint;
table a / out=freq2 missing ;
run;
