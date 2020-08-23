%let zb=wej.leki;
/*%let zb=wej.leki(obs=1000);*/
%let kat=E:\moje\loyalty\raporty\;
%let style=Banker;
/*Banker*/
/*Rsvp*/
ods _all_ close;
proc tabulate data=&zb out=wyn;
class grupa wiek;
format wiek wiekn.;
var kwota;
table wiek='' all='Razem', (grupa=
'<a href="raporty\drill_leki.html">Grupa lekÛw</a>'
all='Razem') 
* kwota='' * (sum='Suma'*f=kwota. colpctsum='Procent'*f=procent.)
 / box='Grupa wiekowa';
run;
ods listing;

ods listing close;
goptions reset=all device=activex;
ods html path="&kat" (url=none)
body='Drill_down_index.html'
style=&style;


title 'Raporty OLAP - Drill-Down - Poziom UP - przyk≥ady';
data v / view=v;
length grupa $ 200;
set &zb;
grupa=
'<a href="raporty\drill_'||compress(grupa,' πÍúÊøü• å∆Øè≥£')||'.html">'||trim(grupa)||'</a>';
run;
proc tabulate data=v;
class grupa wiek;
format wiek wiekn.;
var kwota;
table wiek='' all='Razem', (grupa=
'<a href="raporty\drill_leki.html">Grupa lekÛw</a>'
all='Razem') 
* kwota='' * (sum='Suma'*f=kwota. colpctsum='Procent'*f=procent.)
 / box='Grupa wiekowa';
run;
proc gchart data=wyn(where=(_type_='11'));
block wiek / discrete group=grupa sumvar=kwota_PctSum_10 type=sum
patternid=group subgroup=kwota_Sum;
label kwota_PctSum_10='Procent w grupie lekowej'
grupa='Grupa lekÛw' wiek='Grupa wiekowa' kwota_Sum='Kwota';
format kwota_PctSum_10 procent. kwota_Sum kwota.;
run;
quit;
ods html close;
ods listing;
goptions reset=all device=win;



ods listing close;
goptions reset=all device=activex;
ods html path="&kat.raporty\" (url=none)
body='drill_leki.html'
style=&style;
/*Banker*/
/*Rsvp*/

title 'Raporty OLAP - Drill-Down - Poziom Down - przyk≥ady';
proc tabulate data=&zb out=wyn;
class lek wiek;
format wiek wiekn.;
var kwota;
table wiek='' all='Razem', (lek='Nazwa leku'
all='Razem') 
* kwota='' * (sum='Suma'*f=kwota. colpctsum='Procent'*f=procent.)
 / box='Grupa wiekowa';
run;
proc gchart data=wyn(where=(_type_='11'));
block wiek / discrete group=lek sumvar=kwota_PctSum_10 type=sum
patternid=group subgroup=kwota_Sum;
label kwota_PctSum_10='Procent dla leku' kwota_Sum='Kwota'
lek='Nazwa leku' wiek='Grupa wiekowa';
format kwota_PctSum_10 procent. kwota_Sum kwota.;
run;
quit;
ods html close;
ods listing;
goptions reset=all device=win;

%macro poziomy;
proc sql noprint;
select distinct grupa, 
compress(grupa,' πÍúÊøü• å∆Øè≥£')
into :gr1-:gr&sysmaxlong, :naz1-:naz&sysmaxlong
from &zb;
quit;
%let il=&sqlobs;
%put &il;
%put &gr1***&naz1;

/*%let i=1;*/
%do i=1 %to &il;

ods listing close;
goptions reset=all device=activex;
ods html path="&kat.raporty\" (url=none)
body="drill_&&naz&i...html"
style=&style;
/*Banker*/
/*Rsvp*/

title "Raporty OLAP - Drill-Down - Poziom grupy &&gr&i - przyk≥ady";
proc tabulate data=&zb out=wyn;
class lek wiek;
format wiek wiekn.;
var kwota;
table wiek='' all='Razem', (lek='Nazwa leku'
all='Razem') 
* kwota='' * (sum='Suma'*f=kwota. colpctsum='Procent'*f=procent.)
 / box='Grupa wiekowa';
where grupa="&&gr&i";
run;
proc gchart data=wyn;
block wiek / discrete group=lek sumvar=kwota_PctSum_10 type=sum
patternid=group subgroup=kwota_Sum;
label kwota_PctSum_10='Procent dla leku' kwota_Sum='Kwota'
lek='Nazwa leku' wiek='Grupa wiekowa';
format kwota_PctSum_10 procent. kwota_Sum kwota.;
where _type_='11';
run;
quit;
ods html close;
ods listing;
goptions reset=all device=win;
%end;
%mend;
%poziomy;
