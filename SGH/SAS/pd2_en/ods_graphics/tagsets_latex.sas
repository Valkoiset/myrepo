/* Legacy LaTeX for ODS */
ods tagsets.latex file="legacy.tex";

/* Legacy LaTeX with color for ODS */
ods tagsets.colorlatex file="color.tex" stylesheet="sas.sty"(url="sas");

/* Simplified LaTeX output that uses plain LaTeX tables */
ods tagsets.simplelatex file="simple.tex" stylesheet="sas.sty"(url="sas");

/* Same as above, but only prints out tables (no titles, notes, etc.) */
/* Also, prints each table to a separate file */
ods tagsets.tablesonlylatex file="tablesonly.tex" (notop nobot) newfile=table;

proc reg data=sashelp.class;
   model Weight = Height Age;
run;quit;

ods tagsets.latex close;
ods tagsets.colorlatex close;
ods tagsets.tablesonlylatex close;
ods tagsets.simplelatex close;

/* Run each document twice since the longtable package requires it */
x pdflatex legacy.tex;
x pdflatex legacy.tex;
x pdflatex color.tex;
x pdflatex color.tex;
x pdflatex simple.tex;
x pdflatex simple.tex;
