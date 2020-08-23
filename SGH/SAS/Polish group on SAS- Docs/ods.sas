/*ODS*/
/******************************************************************************************************************/
ods listing close;
ods html close;
ods _all_ close;
ods html;
proc freq data=sashelp.class; table sex*age / missing norow nocol nopct; run;
ods html close;
ods trace on / listing;

/******************************************************************************************************************/

proc tabulate data=sashelp.prdsale out=tabul;
class country year product;
var actual;
table 
	product='' all,
	country='' all,
	sum=''*actual=''*(year='' all)*f=nlnum12.2 
	/ box=_page_;
run;
/******************************************************************************************************************/
data Scores;
   input Gender $ Score @@;
   datalines;
f 75  f 76  f 80  f 77  f 80  f 77  f 73
m 82  m 80  m 85  m 85  m 78  m 87  m 82
;
run;
/******************************************************************************************************************/
ods listing close;
ods html
path='sciezka'
	body='body.html'
style=statistical;
proc ttest data=Scores;
   class Gender;
   var Score;
run;
ods html close;
ods listing;
/******************************************************************************************************************/
ods listing close;
ods html
path='sciezka'
	frame='index.html'
	contents='cont.html'
	body='body.html'
style=banker;
proc ttest data=Scores;
   class Gender;
   var Score;
run;
ods html close;
ods listing;
/******************************************************************************************************************/
ods listing close;
ods html
path='sciezka'
	frame='index.html'
	page='page.html'
	contents='cont.html'
	body='body.html'
style=statistical;
title 'Mój test 1';
proc ttest data=Scores;
   class Gender;
   var Score;
run;
ods html close;
ods listing;
/******************************************************************************************************************/
ods listing close;
ods html
path='sciezka\' (url=none)
	frame='index.html'
	page='page.html'
	contents='cont.html'
	body='body.html'
style=statistical;
title 'Mój test 1';
proc ttest data=Scores;
   class Gender;
   var Score;
run;
title 'Mój test 2';
proc ttest;
   var Score;
run;
ods html close;
ods listing;
/******************************************************************************************************************/
title;
ods listing close;
ods pdf
file = 'sciezka\mój_raport.pdf'
style=banker;
proc ttest data=Scores;
   class Gender;
   var Score;
run;
ods pdf close;
ods listing;
/******************************************************************************************************************/
ods table Statistics=stats;
proc ttest data=Scores;
   class Gender;
   var Score;
run;
ods table close;
