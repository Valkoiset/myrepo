/*ods output*/
/*ods trace on / listing;*/
/*ods trace off;*/

ods listing close;
ods output Association=gini
ParameterEstimates=bety;
proc logistic data=sashelp.class;
model sex=age height weight;
run;
ods output close;
ods listing;


/*txt files*/
filename plik 'c:\katalog\';
data result;
infile plik('dane.txt');
input a b c;
run;

data _null_;
file plik('result.txt');
set sashelp.class;
put age weight height;
run;

/*reading by delimiter*/
data result;
infile cards dlm=' ';
input a b c;
cards;
1 2 3
3 4 5
;
run;

data result;
infile cards dlm=',' dsd;
input a b c;
cards;
1,2,3
3,,5
;
run;

data result;
length a $ 20;
infile cards dlm=' ';
input a b c;
cards;
1vbmbvmnmnbv 2 3
3gfdsgds 4 5
;
run;

/*reading by informats*/
data result;
informat a best12. b numx. c yymmdd10.;
format a b nlnum12.2 c yymmdd10.;
infile cards dlm=' ';
input a b c;
cards;
1.23 1,656 2014-01-23
8.73 1,456 2014-01-23
;
run;

/*examples*/
data sales;
   infile file-specification;
   input item $10. +5 jan comma5. +5 feb comma5. 
         +5 mar comma5.;
run;
/*by columns*/
input name $ 1-10 pulse 11-13 waist 14-15
      gender $ 16;

/*by @*/
input @10 a;
input a @; input b; input a / b;
input znak @@;
/*by names*/
data list;
   input name=$ age= gender=$;
   datalines;
name=John age=34 gender=M
age=23 name=rty
name=tyu age=56
;
run;

