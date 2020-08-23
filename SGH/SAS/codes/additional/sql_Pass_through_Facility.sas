libname wyj 'F:\sas_users2\karol\szkolenie\do samodzielnego studiowania' compress=yes;
proc sql;
	connect to odbc as sql (dsn=finplus);
	create table wyj.logo as
	select *
	from connection to sql
	(
		SELECT * FROM finplus.dbo.t_logo_dict 			
	);
		
	disconnect from sql;
quit;

proc sql;
	connect to odbc as sql (dsn=finplus);
	execute
	(
		SELECT * 
		into risk.dbo.szkol_temp_logo
		FROM finplus.dbo.t_logo_dict 
	) by sql;

	execute
	( 
		CREATE INDEX logo ON risk.dbo.szkol_temp_logo(logo)
	) by sql;

	execute
	( 
		drop table risk.dbo.szkol_temp_logo
	) by sql;
	disconnect from sql;
quit;
