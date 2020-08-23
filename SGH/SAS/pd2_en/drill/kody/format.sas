libname wej 'E:\moje\loyalty\dane\';

%let ile_klientow=100000;
%let il_prod=50;
proc format;
value plec
0 = 'M�czyzna'
1 = 'Kobieta'
;
value wiek
 low -24 = 'g1 18-24'
 24<- 29 = 'g2 25-29'
 29<- 39 = 'g3 30-39'
 39<- 49 = 'g4 40-49'
 49<- 59 = 'g5 50-59'
 59<-high= 'g6 60 i wi�cej'
;
value wiekn
 low -24 = '18-24'
 24<- 29 = '25-29'
 29<- 39 = '30-39'
 39<- 49 = '40-49'
 49<- 59 = '50-59'
 59<-high= '60 i wi�cej'
;
value wyk
0='Podstawowe'
1='�rednie'
2='Zawodowe'
3='Wy�sze'
;
value okreg
0 = 'okr�g warszawski' 
1 = 'okr�g olszty�ski' 
2 = 'okr�g lubelski' 
3 = 'okr�g krakowski' 
4 = 'okr�g katowicki' 
5 = 'okr�g wroc�awski' 
6 = 'okr�g pozna�ski' 
7 = 'okr�g szczeci�ski' 
8 = 'okr�g gda�ski' 
9 = 'okr�g ��dzki' 
;
run;
proc format;
picture procent (round)
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
picture kwota (round)
low- -0.005='00.000.000.009,99 PLN'
(decsep=',' 
dig3sep='.'
fill=' '
prefix='-')
-0.005-high='00.000.000.009,99 PLN'
(decsep=',' 
dig3sep='.'
fill=' ')
;
run;
proc format;
value dzient
1 = 'Niedziela'
2 = 'Poniedzia�ek'
3 = 'Wtorek'
4 = '�roda'
5 = 'Czwartek'
6 = 'Pi�tek'
7 = 'Sobota'
;
run;
