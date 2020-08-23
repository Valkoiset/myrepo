
%macro calc_models(method,zbior);
proc reg data=outlib.train outest=&zbior noprint;
model &tar=&variables / rsquare adjrsq bic sbc cp rmse 
selection=&method;
run;
quit;
data &zbior;
length method $ 200;
set &zbior;
method="&method";
run;
%mend;

%calc_models(FORWARD best=10 start=1 stop=10 slstay=0.05 slentry=0.05,outlib.mod1);
%calc_models(FORWARD best=10 start=1 stop=10 slstay=0.1 slentry=0.1,outlib.mod2);

%calc_models(BACKWARD best=10 start=1 stop=10 slstay=0.05 slentry=0.05,outlib.mod3);
%calc_models(STEPWISE best=10 start=1 stop=10 slstay=0.05 slentry=0.05,outlib.mod4);

%calc_models(MAXR best=10 start=1 stop=10 slstay=0.05 slentry=0.05,outlib.mod5);
%calc_models(MINR best=10 start=1 stop=10 slstay=0.05 slentry=0.05,outlib.mod6);
%calc_models(RSQUARE best=10 start=1 stop=10 slstay=0.05 slentry=0.05,outlib.mod7);
%calc_models(ADJRSQ best=10 start=1 stop=10 slstay=0.05 slentry=0.05,outlib.mod8);
%calc_models(CP best=10 start=1 stop=10 slstay=0.05 slentry=0.05,outlib.mod9);
