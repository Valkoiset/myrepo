options orientation=landscape;
ods pdf path='c:\karol\oferta_zajec\pd2\kody\ods_graphics_latex\' (url=none)
file='ex_reg_genmod.pdf';
goptions reset=all device=pdf colors=(black) rotate=landscape;
ods graphics on;
proc genmod data=sashelp.class plots=all;
model sex=age weight height;
run;
proc reg data=sashelp.class plots=all;
model age=weight height;
run;
quit;
ods graphics off;
ods pdf close;

