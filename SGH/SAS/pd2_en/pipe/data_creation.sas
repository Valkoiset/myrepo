%let dir=d:\karol\oferta_zajec\pd2_en\pipe\data\;

%macro rob;
%do i=1 %to 20;
data _null_;
file "&dir.file%sysfunc(sum(&i),z2.).txt";
do i=1 to 20;
x=ranuni(1)*100;
put i x;
format i 12. x numx12.2;
end;
run;
%end;
%mend;
%rob;
