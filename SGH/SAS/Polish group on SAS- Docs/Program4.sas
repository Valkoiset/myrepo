



%let imie = Piotr;
%let d = ala;
title 'Raport R&D';

proc  print data=sashelp.class;
run;






%macro sort(d1, d2, by);
	proc sort data=&d1. out=&d2.;
		by &by ;
	run;
	%do i=1 %to 100;
		data a&i.;
			set &d1.;
		run;
	%end;



%mend ;




%sort(sashelp.cars, work.cars_s, msrp);
%sort(sashelp.class, work.class_s, age);
