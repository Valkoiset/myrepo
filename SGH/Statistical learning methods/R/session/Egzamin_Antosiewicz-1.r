KOLOKWIUM CWICZENIA

PIERWSZE KOLOKWIUM - ANTOSIEWICZ
1.1 - 20pkt 
1. Zgraj dane z neta ale musisz podmie� znak "?" na NULL, w drugim przypadku musisz zgra� z neta i zauwa�y�, �e separatorem nie jest spacja ani przecinek tylko trzeba wstawi� sep = ""
www2<-"https://archive.ics.uci.edu/.../auto-mpg/auto-mpg.data
"
DATA_SET<-read.table(www2,header=F,sep="")
2. Zmie� nazwy zmiennych. i zmie� im nazwy.
3. Ile brak�w. Usu� wiersze, gdzie s� braki
4. Zbi�r by� o autach. Podaj �rednie spalanie auta l�ejszego ni� 15 kwartyl auta maj�cego 8 cylind�r�w.
5. Narysuj histogram i lini� regresji dla 5 zmiennych ze zbiorku. Rysuj�c wszystko na jednym diagramie.
6. Podziel zbi�r na treningowy i testowy w jakikolwiek spos�b. (w drugim by�o by� podzieli�a ale w treningowym ma si� znale�� r�wno 100 element�w).
7. Zr�b model regresji liniowej.
8. Zr�b 3 modele gam gdzie niekt�re zmienne b�d� smooth spline, niekt�re locacal regression a niekt�re jeszcze co innego. (generalnie chodzi o te oznakowanie s, bs, ns, i)
9. Por�wnaj za pomoc� anova
10. Por�wnaj za pomoc� czego� tam jeszcze... nie wiem co to by�o ale czego� innego.

2.2 - 20 pkt 
www<-"https://archive.ics.uci.edu/.../machine.../wine/wine.data
"
1. ile brak�w.
2. wywal ze zbioru te wiersze gdzie V1 = 3
3. histogramik
4. podziel na testow i trningowy tak by w treningowym by�o 100 element�w w drugim reszta.
5. rpart.
6. logit.
7-9. Nie wyrobi�em si�. Jakie� optymalizacje drzew i por�wnanie. Nie wiem. W ciul by�o tych zadanek... mo�e nie trudnych ale du�o.

