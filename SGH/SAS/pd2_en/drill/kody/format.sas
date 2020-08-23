libname wej 'E:\moje\loyalty\dane\';

%let ile_klientow=100000;
%let il_prod=50;
proc format;
value plec
0 = 'Mê¿czyzna'
1 = 'Kobieta'
;
value wiek
 low -24 = 'g1 18-24'
 24<- 29 = 'g2 25-29'
 29<- 39 = 'g3 30-39'
 39<- 49 = 'g4 40-49'
 49<- 59 = 'g5 50-59'
 59<-high= 'g6 60 i wiêcej'
;
value wiekn
 low -24 = '18-24'
 24<- 29 = '25-29'
 29<- 39 = '30-39'
 39<- 49 = '40-49'
 49<- 59 = '50-59'
 59<-high= '60 i wiêcej'
;
value wyk
0='Podstawowe'
1='Œrednie'
2='Zawodowe'
3='Wy¿sze'
;
value okreg
0 = 'okrêg warszawski' 
1 = 'okrêg olsztyñski' 
2 = 'okrêg lubelski' 
3 = 'okrêg krakowski' 
4 = 'okrêg katowicki' 
5 = 'okrêg wroc³awski' 
6 = 'okrêg poznañski' 
7 = 'okrêg szczeciñski' 
8 = 'okrêg gdañski' 
9 = 'okrêg ³ódzki' 
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
2 = 'Poniedzia³ek'
3 = 'Wtorek'
4 = 'Œroda'
5 = 'Czwartek'
6 = 'Pi¹tek'
7 = 'Sobota'
;
run;
