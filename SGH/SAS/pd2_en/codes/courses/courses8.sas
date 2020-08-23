ods listing close;
ods html path="d:\karol\oferta_zajec\pd2_en\codes\courses\"
body='raport.html' style=statistical;

proc tabulate data=sashelp.prdsale;
class country year;
var actual predict;
table sum*country*(actual predict)
	*year*f=numx12.2;
run;

proc tabulate data=sashelp.prdsale;
class country year;
var actual predict;
table sum*country*actual
	*year*f=numx12.2
sum*country*predict
	*year*f=numx12.2;
run;
ods html close;
ods listing;


ods listing close;
ods html path="d:\karol\oferta_zajec\pd2_en\codes\courses\"
body='raport.html' style=statistical;
title 'Actual sale';
proc tabulate data=sashelp.prdsale;
class country year;
var actual;
table country='' all, sum=''*actual=''
	*(year='' all)*f=nlnum12.2 
/ box='Actual sum';
run;
proc tabulate data=sashelp.prdsale;
class country year;
var actual;
table country='' all, mean=''*actual=''
	*(year='' all)*f=nlnum12.2 
/ box='Actual mean';
run;
ods html close;
ods listing;


ods listing close;
ods html path="d:\karol\oferta_zajec\pd2_en\codes\courses\"
body='raport.html' style=statistical;
title 'Actual sale';
proc tabulate data=sashelp.prdsale;
class country year product;
var actual;
table 
product='' all,
country='' all, sum=''*actual=''
	*(year='' all)*f=nlnum12.2 
/ box=_page_;
run;
ods html close;
ods listing;


proc format;
picture percent_pl (round)
low- -0.005='00.000.000.009,99%'
(decsep=',' 
dig3sep='.'
fill=' '
prefix='-')
-0.005-high='00.000.000.009,99%'
(decsep=',' 
dig3sep='.'
fill=' ')
;
run;



ods listing close;
ods html path="d:\karol\oferta_zajec\pd2_en\codes\courses\"
body='raport.html' style=statistical;
title 'Actual sale';
proc tabulate data=sashelp.prdsale;
class country year;
var actual;
table 
country='' all, 
/*pctn colpctn rowpctn*/
(sum*f=nlnum12.2 (pctsum colpctsum rowpctsum)*f=percent_pl.)
*actual=''*(year='' all) 
/ box='Sale';
run;
ods html close;
ods listing;


ods listing close;
ods html path="d:\karol\oferta_zajec\pd2_en\codes\courses\"
body='raport.html' style=statistical;
title 'Actual sale';
proc tabulate data=sashelp.prdsale;
class country product year;
var actual;
table 
country=''*(product='' all) all, 
(sum*f=nlnum14.2 
pctsum<product all>*f=percent_pl.)
*actual=''*(year='' all) 
/ box='Sale';
run;
ods html close;
ods listing;

/*class sex / order=data preloadfmt;*/
/**/
/*code:*/
/*\pd2_en\drill\*/









