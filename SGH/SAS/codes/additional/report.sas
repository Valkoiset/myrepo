proc report data=rap.sprzedaz nowd;
column nazwisko kod liczba liczba2 text suma;
define nazwisko / group;
define kod / group format=$10. 'Region';
define liczba / analysis sum;
define liczba2 / computed;
define text / computed;
define suma / computed;
compute after nazwisko;
*compute after;
length opis $20;
line 57*'-';
line  '***' _c3_ 10.2 '****';
line  '***' liczba.sum 10.2 '****';
if _c3_>30 then opis='Wi�ksze od 30';
else opis='Mniejsze od 30';
line ' ';
line @5 opis $20.;
endcomp;
compute liczba2;
liczba2=_c3_+2;
endcomp;
compute text;
if _c3_>5 then text=100;
else text=0;
czba2=_c3_+2;
endcomp;
compute suma;
suma=liczba.sum+liczba2+text;
endcomp;
rbreak after / ol summarize;
break before nazwisko / ul ol summarize;
run;