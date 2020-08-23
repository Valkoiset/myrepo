/*symulacja*/

data wej.klient;
do i=1 to &ile_klientow;
id_klient=&ile_klientow*1000+int(ranuni(1)*&ile_klientow)+1;

plec=(ranuni(1)>0.45);
plec_f=put(plec,plec.);

wiek=ranuni(1)*70+18;
wiek_f=put(wiek,wiek.);

wyk=int(ranuni(1)*3+0.5);
wyk_f=put(wyk,wyk.);

okreg=int(ranuni(1)*9+0.5);
okreg_f=put(okreg,okreg.);

/*miejscowosc=*/
output;
end;
/*format plec plec. wiek wiek. wyk wyk. okreg okreg.;*/
drop i;
run;

data wej.leki;
length grupa lek pora $ 15;
set wej.klient;
il_prod=int(ranuni(1)*&il_prod)+20;
do i=1 to il_prod;
data='01mar2009:00:00:00'dt-ranuni(1)*24*3600*900;
if hour(timepart(data))<5 then data=data+int(ranuni(1)*4*3600);
if hour(timepart(data))>22 then data=data-int(ranuni(1)*4*3600);
godzina=hour(timepart(data));
period=put(datepart(data),yymmn6.);
rok=year(datepart(data));
dzien=day(datepart(data));
dzient=weekday(datepart(data));
if 5=<godzina<8 then pora='Przed prac¹';
if 8=<godzina<=17 then pora='Czas pracy';
if 0=<godzina<5 or 22<godzina  then pora='Noc';
if 17<godzina<=20 then pora='Po pracy';
if 20<godzina<=22 then pora='Wieczór';


score=plec*10+wiek*5+wyk*20+100-okreg*10+200*ranuni(1);


grupa='Anty alergiczne';
if ranuni(1)>0.6 then do; lek='Zyrtek'; kwota=22.5; end;
else do; lek='Aleric'; kwota=7.5; end;

if score<640 then do;
grupa='Dzieciêce';
lek='Ibufen'; kwota=10.99;
lek='Eurespal'; kwota=24;
end;

if score<480 then do;
grupa='Kosmetyczne';
lek='Topialyse'; kwota=77;
end;

if score<400 then do;
grupa='Suplement diety';
r=ranuni(1);
lek='Radical'; kwota=20;
if r<0.6 then do; lek='Asparagin'; kwota=6.57; end;
if r<0.2 then do; lek='Spirulina'; kwota=89.59; end;
end;

if score<320 then do;
grupa='Dla mê¿czyzn';
lek='Clavin'; kwota=36;
end;

output;
end;
drop i r;
format data datetime.;
run;

/*Money*/
/*Education*/
/*Electronics*/
/*Science*/
/*Statdoc*/
/*Statistical*/
/*Astronomy*/
/*Festival*/
/*Seaside*/
/*Magnify*/
/*Meadow*/
/*Journal*/
/*Analysis*/
/*Torn*/
/*Watercolor*/
/*Sketch*/
/*Gears*/
/*Banker*/
/*D3d*/
/*Rsvp*/


/*proc gchart data=wej.leki;*/
/*vbar3d score / levels=20 type=percent;*/
/*vbar3d grupa / type=percent;*/
/*vbar3d lek / type=percent;*/
/*vbar3d period / type=percent;*/
/*vbar3d pora / type=percent;*/
/*vbar3d godzina / discrete type=percent;*/
/*run;*/
/*quit;*/
