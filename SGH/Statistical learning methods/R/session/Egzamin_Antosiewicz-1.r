KOLOKWIUM CWICZENIA

PIERWSZE KOLOKWIUM - ANTOSIEWICZ
1.1 - 20pkt 
1. Zgraj dane z neta ale musisz podmieñ znak "?" na NULL, w drugim przypadku musisz zgraæ z neta i zauwa¿yæ, ¿e separatorem nie jest spacja ani przecinek tylko trzeba wstawiæ sep = ""
www2<-"https://archive.ics.uci.edu/.../auto-mpg/auto-mpg.data
"
DATA_SET<-read.table(www2,header=F,sep="")
2. Zmieñ nazwy zmiennych. i zmieñ im nazwy.
3. Ile braków. Usuñ wiersze, gdzie s¹ braki
4. Zbiór by³ o autach. Podaj œrednie spalanie auta l¿ejszego ni¿ 15 kwartyl auta maj¹cego 8 cylindórów.
5. Narysuj histogram i liniê regresji dla 5 zmiennych ze zbiorku. Rysuj¹c wszystko na jednym diagramie.
6. Podziel zbiór na treningowy i testowy w jakikolwiek sposób. (w drugim by³o byæ podzieli³a ale w treningowym ma siê znaleŸæ równo 100 elementów).
7. Zrób model regresji liniowej.
8. Zrób 3 modele gam gdzie niektóre zmienne bêd¹ smooth spline, niektóre locacal regression a niektóre jeszcze co innego. (generalnie chodzi o te oznakowanie s, bs, ns, i)
9. Porównaj za pomoc¹ anova
10. Porównaj za pomoc¹ czegoœ tam jeszcze... nie wiem co to by³o ale czegoœ innego.

2.2 - 20 pkt 
www<-"https://archive.ics.uci.edu/.../machine.../wine/wine.data
"
1. ile braków.
2. wywal ze zbioru te wiersze gdzie V1 = 3
3. histogramik
4. podziel na testow i trningowy tak by w treningowym by³o 100 elementów w drugim reszta.
5. rpart.
6. logit.
7-9. Nie wyrobi³em siê. Jakieœ optymalizacje drzew i porównanie. Nie wiem. W ciul by³o tych zadanek... mo¿e nie trudnych ale du¿o.

