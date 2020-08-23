/*Levenshtein distance*/
/*modifiers */
/*specifies a character string that can modify the action of the COMPLEV function. You can use one or more of the following characters as a valid modifier: */
/*i or I ignores the case in string-1 and string-2.*/
/*l or L removes leading blanks in string-1 and string-2 before comparing the values.*/
/*n or N removes quotation marks from any argument that is an n-literal and ignores the case of string-1 and string-2.*/
/*: (colon) truncates the longer of string-1 or string-2 to the length of the shorter string, or to one, whichever is greater. */
 

data test;
   infile datalines missover;
   input string1 $char8. string2 $char8. modifiers $char8.;
   result=complev(string1, string2, modifiers);
   datalines;
1234567812345678
abc     abxc
ac      abc
aXc     abc
aXbZc   abc
aXYZc   abc
WaXbYcZ abc
XYZ     abcdef
aBc     abc
aBc     AbC      i
  abc   abc
  abc   abc      l
AxC     'abc'n
AxC     'abc'n   n
£Ûdü    Lodz
Lodz    Lozd
;
run;

/*function compare*/

data test;
   infile datalines missover;
   input string1 $char8. string2 $char8. modifiers $char8.;
   result=compare(string1, string2, modifiers);
   datalines;
1234567812345678
123     abc
abc     abx
xyz     abcdef
aBc     abc
aBc     AbC     i
   abc  abc
   abc  abc     l
 abc       abx
 abc       abx  l 
ABC     'abc'n
ABC     'abc'n  n 
 '$12'n $12     n
 '$12'n $12     nl
 '$12'n $12     ln
;
run;

/*function compgen*/

data test;
   infile datalines missover;
   input String1 $char8. +1 String2 $char8. +1 Operation $40.;
   GED=compged(string1, string2);
   datalines;
baboon   baboon   match
baXboon  baboon   insert
baoon    baboon   delete
baXoon   baboon   replace
baboonX  baboon   append
baboo    baboon   truncate
babboon  baboon   double
babon    baboon   single
baobon   baboon   swap
bab oon  baboon   blank
bab,oon  baboon   punctuation
bXaoon   baboon   insert+delete
bXaYoon  baboon   insert+replace
bXoon    baboon   delete+replace
Xbaboon  baboon   finsert
aboon    baboon   trick question: swap+delete
Xaboon   baboon   freplace
axoon    baboon   fdelete+replace
axoo     baboon   fdelete+replace+truncate
axon     baboon   fdelete+replace+single
baby     baboon   replace+truncate*2
balloon  baboon   replace+insert
;
run;

data test1;
   length String $8 Operation $40;
   if _n_ = 1 then call compcost('insert=',10,'DEL=',11,'r=', 12);
   input String Operation;
   GED=compged(string, 'baboon');
   datalines;
baboon  match
xbaboon insert
babon   delete
baXoon  replace
;
run;

data test2;
   length String $8 Operation $40;
/*   if _n_ = 1 then call compcost('insert=',10,'DEL=',11,'r=', 12);*/
   input String Operation;
   GED=compged(string, 'baboon');
   datalines;
baboon  match
xbaboon insert
babon   delete
baXoon  replace
;
run;
