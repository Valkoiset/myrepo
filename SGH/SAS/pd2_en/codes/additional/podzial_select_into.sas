proc sql noprint;
select distinct 
'data '||trim(product)||
';set sashelp.prdsale; where product="'
||trim(product)||'"; run'
into :kod separated by ';'
from sashelp.prdsale;
quit;
&kod;
