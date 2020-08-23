%let kat_template=d:\karol\oferta_zajec\pd2_en\dde_excel\;
%let kat_out=&kat_template.out\;

%macro insert(x1,x2,x3,name);
data _null_;
  length file $300;
  filename ddedata dde 
    'excel|system'; 
  file ddedata; 
  file='[open("'||"&kat_template"||'template.xlsx")]';
  put file;
run;
  
data w; 
  filename ddedata dde 
    'excel|input!w4k2:w6k2'; 
  file ddedata; 
  x=sleep(2);
  format x numx15.4;
  x = &x1; 
  put x;
  x = &x2; 
  put x;
  x = &x3; 
  put x;
run; 

data _null_;
  length file $300;
  filename ddedata dde 
    'excel|system'; 
  file ddedata; 
  file='[save.as("'||"&kat_out"||"&name"||'")]';
  put file;
  put '[close()]';
run;
%mend;

data rap;
infile "&kat_template.reports.txt" dlm=' ';
length x1 x2 x3 8 name $30;
informat x1 x2 x3 best.;
input x1 x2 x3 name;
run;
data _null_;
set rap(obs=1) nobs=il;
call symput('ilr',put(il,best12.-L));
run;
%put &ilr;

options noxwait noxsync;
filename sas2xl dde 'excel|system';
data _null_;
length fid rc start stop time 8;
fid=fopen('sas2xl','s');
if (fid le 0) then do;
rc=system('start excel');
start=datetime();
stop=start+10;
do while (fid le 0);
fid=fopen('sas2xl','s');
time=datetime();
if (time ge stop) then fid=1;
end;
end;
rc=fclose(fid);
run;



%macro laduj;
%do i=1 %to &ilr;
/*%do i=1 %to 1;*/
data _null_;
set rap(firstobs=&i obs=&i);
call symput('x1',put(x1,best12.-L));
call symput('x2',put(x2,best12.-L));
call symput('x3',put(x3,best12.-L));
call symput('name',trim(name));
run;
%insert(&x1,&x2,&x3,&name);
%end;
%mend;
%laduj;

data _null_;
  length file $300;
  filename ddedata dde 
    'excel|system'; 
  file ddedata; 
  put '[quit()]';
run;
