/*zmienne numerowane*/
/*wszedzie tam gdzie nie ma dwuznacznosci,*/
/*glownie wtedy gdzie nie spodziewamy sie*/
/*wyrazenia arytmetycznego gdzie minus bedzie minusem*/
/*nie mozna tez uzywaz takiej konwencji w numerowaniu*/
/*zbirow danych*/
data w;
attrib u1-u200 label='etyk' length=8;
array t(*) u1-u20;
retain r1-r45 1234.56;
length z1-z20$ 10;
format r1-r45 commax12.2;
informat r1-r45 numx.;
put r1-r10;
a=sum(of r1-r20);
rename z1-z10=nazwa1-nazwa10;
keep z1-z3;
input (n1-n3) (1.,+2);
put n1-n3;
cards;
1##2##3
;
run;
/*w sql nie ma mozliwosci, bo zawsze */
/*minus bedzie minusem*/
/*ale to juz makra a nie zmienne*/
proc sql noprint;
select name
into :a1-:a19 from sashelp.class;
quit;
%put _user_;