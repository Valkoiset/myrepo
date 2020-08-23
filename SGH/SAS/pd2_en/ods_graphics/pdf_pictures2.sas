ods listing close;
ods listing 
/*latex path='c:\moje\sgh\ods_latex_graphics\' file='latex_test.tex' */
gpath='c:\moje\sgh\ods_latex_graphics\';
goptions device=pdf colors=(black) rotate=landscape;
ods graphics on;
ods graphics / imagefmt=pdf imagename='ob1' reset=index;
PROC SGPLOT DATA = sashelp.class;
 HISTOGRAM age;
RUN; 
ods graphics / imagefmt=pdf imagename='ob2' reset=index;
PROC Sgplot DATA = sashelp.class;
vline age;
RUN; 
ods graphics / imagefmt=pdf imagename='ob3' reset=index;
proc sgplot data=sashelp.class;
/*histogram age;*/
vbar age / stat=sum;
vline age / stat=sum;
/*reg x=age y=weight / group=sex; */
run;

proc template;
   define statgraph Panel;
      begingraph;
         entrytitle "Paneled Display of the Class Data Set";

         layout lattice / rows=2 columns=2 rowgutter=10 columngutter=10;

            layout overlay;
               scatterplot y=weight x=height;
               pbsplineplot y=weight x=height;
            endlayout;

            layout overlay / xaxisopts=(label='Weight');
               histogram weight;
            endlayout;

            layout overlay / yaxisopts=(label='Height');
               boxplot y=height;
            endlayout;

            layout overlay / xaxisopts=(offsetmin=0.1 offsetmax=0.1)
                             yaxisopts=(offsetmin=0.1 offsetmax=0.1);
               scatterplot  y=weight x=height / markercharacter=sex
                  name='color' markercolorgradient=age;
               continuouslegend 'color'/ title='Age';
            endlayout;

         endlayout;
      endgraph;
   end;
run;
ods graphics / imagefmt=pdf imagename='ob4' reset=index;
proc sgrender data=sashelp.class template=panel;
run;


ods graphics / imagefmt=pdf imagename='ob5' reset=index;
PROC TEMPLATE;
DEFINE STATGRAPH Panel;
BEGINGRAPH;
ENTRYTITLE "Paneled Display";
LAYOUT LATTICE / ROWS= 2 COLUMNS= 2 ROWGUTTER= 10 COLUMNGUTTER=10;
LAYOUT OVERLAY;
SCATTERPLOT Y = Weight X = Height;
REGRESSIONPLOT Y = Weight X = Height;
ENDLAYOUT;
LAYOUT OVERLAY / XAXISOPTS = (LABEL= 'Weight');
HISTOGRAM Weight;
ENDLAYOUT;
LAYOUT OVERLAY / YAXISOPTS = (LABEL= 'Height');
BOXPLOT Y = Height;
ENDLAYOUT;
LAYOUT OVERLAY;
SCATTERPLOT Y = weight X = height/ GROUP = sex NAME = "Scat";
DISCRETELEGEND "Scat" / TITLE = 'Sex';
ENDLAYOUT;
ENDLAYOUT;
ENDGRAPH;
END;
RUN;
PROC SGRENDER DATA = Sashelp.Class TEMPLATE = Panel;
RUN;


ods graphics off;

ods listing close;
/*ods latex close;*/
ods listing;


