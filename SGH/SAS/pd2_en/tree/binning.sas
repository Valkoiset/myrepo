/*algorythm tree to make grouping, binning*/
/*(c) Karol Przanowski*/
/*kprzan@sgh.waw.pl*/

options compress=yes;

%let dir=d:\karol\oferta_zajec\pd2_en\tree\;
%let dir_projekt=d:\karol\oferta_zajec\pd2_en\project\data\;

libname input "&dir_projekt" compress=yes;
libname output "&dir.output" compress=yes;

%let zb=output.vin;
%let tar=vin3;

%let variables_int_ord=act_age app_income;
%let il_var=2;

%put ***&il_var***&variables_int_ord;




/*data preparation*/
data vin0;
set input.Transactions;
seniority=intck('month',input(fin_period,yymmn6.),input(period,yymmn6.));
vin3=(due_installments>=3);
output;
if status in ('B','C') and period<='200812' then do;
	n_steps=intck('month',input(period,yymmn6.),input('200812',yymmn6.));
	do i=1 to n_steps;
		period=put(intnx('month',input(period,yymmn6.),1,'end'),yymmn6.);
		seniority=intck('month',input(fin_period,yymmn6.),input(period,yymmn6.));
		output;
	end;
end;
where product='ins';
keep vin3 seniority aid;
run;
data vin12_sample(drop=seniority);
set vin0;
where seniority=12 and ranuni(1)<0.5;
run;
proc sort data=vin12_sample nodupkey;
by aid;
run;
proc sort data=input.Production(keep=aid &variables_int_ord) out=prod nodupkey;
by aid;
run;
data &zb;
merge vin12_sample(in=z) prod;
by aid;
if z;
run;
/*data preparation*/




/*maksimal number of splitting points*/
%let max_il_podz=5;
/*minimal percantage share in a sinngle category*/
%let min_percent=3;
%include "&dir.tree.sas" / source2;


/*result is in dataset:*/
/*output.splitting_int_nonmonotonic*/
