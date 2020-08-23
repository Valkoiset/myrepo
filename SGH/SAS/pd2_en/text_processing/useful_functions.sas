
/*anyalpha*/
data _null_;    
   string='Next = _n_ + 12E3;';  
   j=0;  
   do until(j=0);  
      j=anyalpha(string,j+1);  
      if j=0 then put +3 "That's all";  
      else do;          
         c=substr(string,j,1);  
         put +3 j= c=;  
      end; 
   end;
run;


data test; 
do dec=0 to 255;
   byte=byte(dec);
   hex=put(dec,hex2.);
   anyalpha=anyalpha(byte);
   anydigit=anydigit(byte);
   notdigit=notdigit(byte);
   anyalnum=anyalnum(byte);
   anygraph=anygraph(byte);
   anycntrl=anycntrl(byte);
   anyupper=anyupper(byte);
   output;
 end;
run;

/*choosen choosenc, podobne do scan*/
data test;
   ItemNumber=choosen(5,100,50,3784,498,679);
   Rank=choosen(-2,1,2,3,4,5);
   Score=choosen(3,193,627,33,290,5);
   Value=choosen(-5,-37,82985,-991,3,1014,-325,3,54,-618);
   put ItemNumber= Rank= Score= Value=; 
run;

data testc;
   Fruit=choosec(1,'apple','orange','pear','fig');
   Color=choosec(3,'red','blue','green','yellow');
   Planet=choosec(2,'Mars','Mercury','Uranus');
   Sport=choosec(-3,'soccer','baseball','gymnastics','skiing');
   put Fruit= Color= Planet= Sport=;
run;

/*count*/
/*i ignores character case during the count. If this modifier is not specified, COUNT only counts character substrings with the same case as the characters in substring.*/
/*t trims trailing blanks from string and substring.*/


data test;
xyz='This is a thistle? Yes, this is a thistle.';
howmanythis=count(xyz,'this');
howmanythis2=count(xyz,'this','i');
howmanyis=count(xyz,'is');
run;
 
/*verify*/
data test;
   input Grade : $1. @@;
   check='abcdf';
   if verify(grade,check)>0 then 
      put @1 'INVALID ' grade=;
   datalines;
a b c b c d f a a q a b d d b
;
run;
