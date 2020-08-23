/*(c) Karol Przanowski*/
/*kprzan@sgh.waw.pl*/


/*every hierarchy variable must be a character type*/
data prdsale;
length CYEAR CQUARTER CMONTH $4;
set sashelp.prdsale;
CYEAR    =put(YEAR   ,4.-L);
CQUARTER =put(QUARTER,4.-L);
CMONTH= put(MONTH,MONNAME3.);
drop YEAR QUARTER MONTH;
run;


%let dir=c:\karol\oferta_zajec\pd2\kody\drill_down\;
%let subdir=reports\;

%let dataset=prdsale;

%let v_hierarchy=COUNTRY:REGION:DIVISION;
%let v_nlevels=3;

%let h_hierarchy=CYEAR:CQUARTER:CMONTH;
%let h_nlevels=3;

%let var_analyzed=ACTUAL;
%let analyzed=%str(ACTUAL=''*sum=''*f=nlnum14.2);

%let style=statistical;

%macro rob_formaty(dim);
%do i=1 %to &&&dim._nlevels;
	%global &dim.c_n_&i;
	%global c&dim.&i;
	%let c&dim.&i=0;
	/*format on categorical variable*/
	proc sql;
	create table uni as
	select distinct %scan(&&&dim._hierarchy,&i,:) as start
	from &dataset;
	quit;
	%let &dim.c_n_&i=&sqlobs;
/*	%put &&hc_n_&h;*/
	data uni1;
	set uni;
	fmtname="&dim.c_&i._f";
	type='C';
	label+1;
	end=start;
	run;
	data uni2;
	set uni(rename=(start=label));
	fmtname="&dim.c_&i._finv";
	type='N';
	start+1;
	end=start;
	run;
	proc format cntlin=uni1;
	run;
	proc format cntlin=uni2;
	run;
%end;
/*data test;*/
/*set &dataset;*/
/*tt=put(%scan(&h_hierarchy,&h,:),$hc_&h._f.);*/
/*run;*/
/*format on categorical variable*/
/*proc format cntlout=w;*/
/*run;*/
%mend;
%rob_formaty(h);
%rob_formaty(v);

/*%put &cv1;*/

/*initial report*/
%let v=1;
%let h=1;
data _null_;
length v_all h_all $1000;
if &v<&v_nlevels then do;
	v_all="'"||'<a href="'||"&subdir.r_h"||"&h"||'_v'||"%eval(&v+1)_ch";
	do i=1 to &h_nlevels-1;
		v_all=trim(v_all)||'_l'||compress(put(i,12.-L))||'_'||
		compress(symget('ch'||compress(put(i,12.-L))));
	end;
	v_all=trim(v_all)||'_cv';
	do i=1 to &v_nlevels-1;
		v_all=trim(v_all)||'_l'||compress(put(i,12.-L))||'_'||
		compress(symget('cv'||compress(put(i,12.-L))));
	end;
	v_all=trim(v_all)||'.html"> All >> </a>'||"'";
end; else 
	v_all="'"||'All'||"'";

if &h<&h_nlevels then do;
	h_all="'"||'<a href="'||"&subdir.r_h"||"%eval(&h+1)"||'_v'||"&v._ch";
	do i=1 to &h_nlevels-1;
		h_all=trim(h_all)||'_l'||compress(put(i,12.-L))||'_'||
		compress(symget('ch'||compress(put(i,12.-L))));
	end;
	h_all=trim(h_all)||'_cv';
	do i=1 to &v_nlevels-1;
		h_all=trim(h_all)||'_l'||compress(put(i,12.-L))||'_'||
		compress(symget('cv'||compress(put(i,12.-L))));
	end;
	h_all=trim(h_all)||'.html"> All >> </a>'||"'";
end; else 
	h_all="'"||'All'||"'";
call symput('v_all',trim(v_all));
call symput('h_all',trim(h_all));
run;
/*%put &v_all;*/
/*%put &h_all;*/
data dataset;
length vvar hvar $1000;
set &dataset;
if &v<&v_nlevels then do;
	vvar='<a href="'||"&subdir.r_h"||"&h"||'_v'||"%eval(&v+1)_ch";
	do i=1 to &h_nlevels-1;
		vvar=trim(vvar)||'_l'||compress(put(i,12.-L))||'_'||
		compress(symget('ch'||compress(put(i,12.-L))));
	end;
	vvar=trim(vvar)||'_cv';
	do i=1 to &v_nlevels-1;
		if i=&v then
			vvar=trim(vvar)||'_l'||compress(put(i,12.-L))||'_'||
			put(%scan(&v_hierarchy,&v,:),$vc_&v._f.);
		else
			vvar=trim(vvar)||'_l'||compress(put(i,12.-L))||'_'||
			compress(symget('cv'||compress(put(i,12.-L))));
	end;
	vvar=trim(vvar)||'.html"> '||%scan(&v_hierarchy,&v,:)||'</a>';
end; else
	vvar=%scan(&v_hierarchy,&v,:);


if &h<&h_nlevels then do;
	hvar='<a href="'||"&subdir.r_h"||"%eval(&h+1)"||'_v'||"&v._ch";
	do i=1 to &h_nlevels-1;
		if i=&h then
			hvar=trim(hvar)||'_l'||compress(put(i,12.-L))||'_'||
			put(%scan(&h_hierarchy,&h,:),$hc_&h._f.);
		else
			hvar=trim(hvar)||'_l'||compress(put(i,12.-L))||'_'||
			compress(symget('ch'||compress(put(i,12.-L))));
	end;
	hvar=trim(hvar)||'_cv';
	do i=1 to &v_nlevels-1;
		hvar=trim(hvar)||'_l'||compress(put(i,12.-L))||'_'||
		compress(symget('cv'||compress(put(i,12.-L))));
	end;
	hvar=trim(hvar)||'.html"> '||%scan(&h_hierarchy,&h,:)||'</a>';
end; else
	hvar=%scan(&h_hierarchy,&h,:);
keep vvar hvar &var_analyzed;
run;
ods listing close;
ods html path="&dir" (url=none) body='index.html' style=&style;
title "OLAP report";
title2 "Top level";
title3;
proc tabulate data=dataset;
class vvar hvar;
var &var_analyzed;
table vvar='' all=&v_all
, (hvar='' all=&h_all)
*(&analyzed);
run;
ods html close;
ods listing;
/*initial report*/





%macro drill_report;
/*drill report*/
/*%let v=1;*/
/*%let h=2;*/
/**/
/*%let ch1=1;*/
/*%let cv1=0;*/


data _null_;
length v_all h_all $1000;
if &v<&v_nlevels then do;
	v_all="'"||'<a href="r_h'||"&h"||'_v'||"%eval(&v+1)_ch";
	do i=1 to &h_nlevels-1;
		v_all=trim(v_all)||'_l'||compress(put(i,12.-L))||'_'||
		compress(symget('ch'||compress(put(i,12.-L))));
	end;
	v_all=trim(v_all)||'_cv';
	do i=1 to &v_nlevels-1;
		v_all=trim(v_all)||'_l'||compress(put(i,12.-L))||'_'||
		compress(symget('cv'||compress(put(i,12.-L))));
	end;
	v_all=trim(v_all)||'.html"> All >> </a>'||"'";
end; else 
	v_all="'"||'All'||"'";

if &h<&h_nlevels then do;
	h_all="'"||'<a href="r_h'||"%eval(&h+1)"||'_v'||"&v._ch";
	do i=1 to &h_nlevels-1;
		h_all=trim(h_all)||'_l'||compress(put(i,12.-L))||'_'||
		compress(symget('ch'||compress(put(i,12.-L))));
	end;
	h_all=trim(h_all)||'_cv';
	do i=1 to &v_nlevels-1;
		h_all=trim(h_all)||'_l'||compress(put(i,12.-L))||'_'||
		compress(symget('cv'||compress(put(i,12.-L))));
	end;
	h_all=trim(h_all)||'.html"> All >> </a>'||"'";
end; else 
	h_all="'"||'All'||"'";
call symput('v_all',trim(v_all));
call symput('h_all',trim(h_all));
run;
/*%put &v_all;*/
/*%put &h_all;*/
data dataset;
length vvar hvar $1000;
set &dataset;
if &v<&v_nlevels then do;
	vvar='<a href="r_h'||"&h"||'_v'||"%eval(&v+1)_ch";
	do i=1 to &h_nlevels-1;
		vvar=trim(vvar)||'_l'||compress(put(i,12.-L))||'_'||
		compress(symget('ch'||compress(put(i,12.-L))));
	end;
	vvar=trim(vvar)||'_cv';
	do i=1 to &v_nlevels-1;
		if i=&v then
			vvar=trim(vvar)||'_l'||compress(put(i,12.-L))||'_'||
			put(%scan(&v_hierarchy,&v,:),$vc_&v._f.);
		else
			vvar=trim(vvar)||'_l'||compress(put(i,12.-L))||'_'||
			compress(symget('cv'||compress(put(i,12.-L))));
	end;
	vvar=trim(vvar)||'.html"> '||%scan(&v_hierarchy,&v,:)||'</a>';
end; else
	vvar=%scan(&v_hierarchy,&v,:);


if &h<&h_nlevels then do;
	hvar='<a href="r_h'||"%eval(&h+1)"||'_v'||"&v._ch";
	do i=1 to &h_nlevels-1;
		if i=&h then
			hvar=trim(hvar)||'_l'||compress(put(i,12.-L))||'_'||
			put(%scan(&h_hierarchy,&h,:),$hc_&h._f.);
		else
			hvar=trim(hvar)||'_l'||compress(put(i,12.-L))||'_'||
			compress(symget('ch'||compress(put(i,12.-L))));
	end;
	hvar=trim(hvar)||'_cv';
	do i=1 to &v_nlevels-1;
		hvar=trim(hvar)||'_l'||compress(put(i,12.-L))||'_'||
		compress(symget('cv'||compress(put(i,12.-L))));
	end;
	hvar=trim(hvar)||'.html"> '||%scan(&h_hierarchy,&h,:)||'</a>';
end; else
	hvar=%scan(&h_hierarchy,&h,:);
keep vvar hvar &var_analyzed;
where 1=1 
%do wh=1 %to &h_nlevels;
	%if &&ch&wh>0 %then %do;
		and compress(put(%scan(&h_hierarchy,&wh,:),$hc_&wh._f.))=compress("&&ch&wh")
	%end;
%end;
%do wv=1 %to &v_nlevels;
	%if &&cv&wv>0 %then %do;
		and compress(put(%scan(&v_hierarchy,&wv,:),$vc_&wv._f.))=compress("&&cv&wv")
	%end;
%end;
;
run;



data _null_;
length nazwa $1000;
nazwa="r_h&h._v&v._ch";

do i=1 to &h_nlevels-1;
	nazwa=trim(nazwa)||'_l'||compress(put(i,12.-L))||'_'||
	compress(symget('ch'||compress(put(i,12.-L))));
end;
nazwa=trim(nazwa)||'_cv';
do i=1 to &v_nlevels-1;
	nazwa=trim(nazwa)||'_l'||compress(put(i,12.-L))||'_'||
	compress(symget('cv'||compress(put(i,12.-L))));
end;
nazwa=trim(nazwa)||'.html';
call symput('nazwa',trim(nazwa));
run;
%put &nazwa;

data _null_;
length vwar hwar $3000;
vwar='';
%do wv=1 %to &v_nlevels;
	%if &&cv&wv>0 %then %do;
		vwar=trim(vwar)||" %scan(&v_hierarchy,&wv,:)="
		||compress(put(&&cv&wv,vc_&wv._finv.));
	%end;
%end;
hwar='';
%do wh=1 %to &h_nlevels;
	%if &&ch&wh>0 %then %do;
		hwar=trim(hwar)||" %scan(&h_hierarchy,&wh,:)="
		||compress(put(&&ch&wh,hc_&wh._finv.));
	%end;
%end;
call symput('vwar',trim(vwar));
call symput('hwar',trim(hwar));
run;

ods listing close;
ods html path="&dir.&subdir" (url=none) body="&nazwa" style=&style;
title "OLAP report";
title2 "&vwar";
title3 "&hwar";
proc tabulate data=dataset;
class vvar hvar;
var &var_analyzed;
table vvar='' all=&v_all
, (hvar='' all=&h_all)
*(&analyzed);
run;
ods html close;
ods listing;
/*drill report*/
%mend;

data _null_;
length zm $300;
file "&dir.kod.sas";
put '%macro licz;';
do v=1 to &v_nlevels;
	do h=1 to &h_nlevels;
		if (v > 1 or h > 1) then do;
			zm='%let v='||compress(put(v,12.-L))||';';	put zm;
			zm='%let h='||compress(put(h,12.-L))||';';	put zm;
			
			do lv=1 to &v_nlevels;
				zm='%let cv'||compress(put(lv,12.-L))||'=0;'; put zm;
			end;
			do lh=1 to &h_nlevels;
				zm='%let ch'||compress(put(lh,12.-L))||'=0;'; put zm;
			end;

			do lv=1 to v-1;
				zm='%do cv'||compress(put(lv,12.-L))||'=0 %to &vc_n_'||compress(put(lv,12.-L))||';'; 	put zm;
			end;
			do lh=1 to h-1;
				zm='%do ch'||compress(put(lh,12.-L))||'=0 %to &hc_n_'||compress(put(lh,12.-L))||';'; 	put zm;
			end;
			put '%drill_report;';
			do lv=1 to v-1;
				put '%end;';
			end;
			do lh=1 to h-1;
				put '%end;';
			end;
		end;
	end;
end;
put '%mend;';
put '%licz;';
run;

%include "&dir.kod.sas" / source2;



