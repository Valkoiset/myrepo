


ods _all_ close;

ods tagsets.ExcelXP path="C:\Users\sasdemo\Desktop\ODS"
	body="raport.xls";

ods tagsets.ExcelXP options (doc="help");

ods tagsets.ExcelXP 
	options (sheet_name="Class");

proc print data=sashelp.class;
run;


ods tagsets.ExcelXP 
	options (sheet_name="cars");

proc print data=sashelp.cars;
run;


ods tagsets.excelxp close;




