options symbolgen mprint mlogic;
options nosymbolgen nomprint nomlogic;
%macro silnia(n);
%if &n eq 1 %then 1;
%else 
%sysevalf(&n*%silnia(%sysevalf(&n-1)));
%mend silnia;
%put %silnia(4);
