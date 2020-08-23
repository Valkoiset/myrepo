/*SAS/ACCESS*/
libname sql odbc dsn=baza schema=dbo BULKLOAD=YES DBCOMMIT=0;

data sql.dane;
set sashelp.class;
run;

data dane;
set sql.dane;
run;

libname mydblib teradata user=testuser pw=testpass schema=otheruser;
libname mydblib oracle user=testuser password=testpass path='hrdept_002' schema=john;
libname arkusz excel 'c:\dane\d.xlsx';
