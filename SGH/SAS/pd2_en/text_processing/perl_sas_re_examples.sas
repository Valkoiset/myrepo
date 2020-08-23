data test1;
street='Luebin, Ulilca Keopalniana 2 m 8';
pattern = "/\d+ m \d+/";
patternID = prxparse(pattern);
length match $80 ;
 call prxsubstr(patternID, street, position, length);
	if position ^= 0 then do;
      match = substr(street, position, length);
	  substr(street, position, length)='';
	end;
run;

data test2;
street='Luebin, Ulilca Keopalniana 2 m 8';
pattern = "/ Ulilca|ulica|ul  /";
patternID = prxparse(pattern);
length match $80 ;
 call prxsubstr(patternID, street, position, length);
   if position ^= 0 then
      match = substr(street, position, length);
run;

data test3;
street='Luebin, Ulilca Keopalniana 2 m 8';
pattern = "/ Ulilca \w+ /";
patternID = prxparse(pattern);
length match $80 ;
 call prxsubstr(patternID, street, position, length);
	if position ^= 0 then do;
      match = substr(street, position, length);
	  substr(street, position, length)='';
	end;
run;

data test4;
street='Luebin, Ulilca Keopalniana 2/8';
pattern = "/\d+\/\d+/";
patternID = prxparse(pattern);
length match $80 ;
 call prxsubstr(patternID, street, position, length);
	if position ^= 0 then do;
      match = substr(street, position, length);
	  substr(street, position, length)='';
	end;
run;

data test5;
street='Luebin, Ulilca Keopalniana 2/8';
pattern = "/\w+,/";
patternID = prxparse(pattern);
length match $80 ;
 call prxsubstr(patternID, street, position, length);
	if position ^= 0 then do;
      match = substr(street, position, length);
	  substr(street, position, length)='';
	end;
run;

/*telephone number detection*/
/*untypical values detection*/
data test6;
length phone $20;
input phone $20.;
pattern = "/\d{9}/";
patternID = prxparse(pattern);
call prxsubstr(patternID, phone, position, length);
if position = 0 then output;
cards;
a227335489
22733548
227335489
oto numer 22733548
podajê 501111222
; 
run;
