proc iml;
x={1,2,3};
y={1 2 3, 1 2 3, 1 2 3};
z1=y*x;
z2=y*y;
print z1;
print z2;
quit;

/*example 1*/
PROC IML; 
 
 /*-----CORRELATION-----*/ 
START CORR; 
   N=NROW(X);                 /* DIMENSION OF X */ 
   SUM=X[+,];                 /* COLUMN SUMS BY REDUCING ROWS */ 
   XPX=X`*X-SUM`*SUM/N;       /* CROSSPRODUCTS CORRECTED FOR MEAN*/ 
   S=DIAG(1/SQRT(VECDIAG(XPX))); /* SCALING MATRIX*/ 
   CORR=S*XPX*S;              /* CORRELATION MATRIX*/ 
   PRINT "Correlation Matrix",,CORR[ROWNAME=NM COLNAME=NM]; 
FINISH; 
 
 /*-----STANDARDIZATION-----*/ 
START STD; 
   MEAN=X[+,]/N;                 /* MEANS FOR COLUMNS          */ 
   X=X-REPEAT(MEAN,N,1);         /* CENTER X TO MEAN ZERO      */ 
   SS=X[##,];                    /* SUM OF SQUARES FOR COLUMNS */ 
   STD=SQRT(SS/(N-1));           /* STANDARD DEVIATION ESTIMATE*/ 
   X=X*DIAG(1/STD);              /* SCALING TO STD DEV 1       */ 
   PRINT ,"Standardized Data",, X[COLNAME=NM]; 
FINISH; 
 
 
 /*-----SAMPLE RUN-----*/ 
x = { 1  2  3, 
      3  2  1, 
      4  2  1, 
      0  4  1, 
     24  1  0, 
      1  3  8}; 
NM={AGE WEIGHT HEIGHT}; 
RUN CORR; 
RUN STD; 
 
quit;


/*example 2*/

 /****************************************************************/ 
 /*          S A S   S A M P L E   L I B R A R Y                 */ 
 /*                                                              */ 
 /*    NAME: IMLGEX2                                             */ 
 /*   TITLE: SCATTERPLOT MATRIX                                  */ 
 /* PRODUCT: IML                                                 */ 
 /*  SYSTEM: ALL                                                 */ 
 /*    KEYS: GRAPHICS SUGI6                                      */ 
 /*   PROCS: IML                                                 */ 
 /*    DATA:                                                     */ 
 /*                                                              */ 
 /* SUPPORT: LWB                         UPDATE: 14dec1988.lwb   */ 
 /*     REF:                                                     */ 
 /*    MISC:                                                     */ 
 /*                                                              */ 
 /****************************************************************/ 
 
 /*--------------------------------------------------------------- 
   This program generates a data set and uses IML graphics 
   subsystem to draw a scatterplot matrix. 
   --------------------------------------------------------------*/ 
 
 
DATA FACTORY; 
  INPUT RECNO PROD TEMP A DEFECT MON; 
  CARDS; 
       1   1.82675    71.124   1.12404   1.79845         2 
       2   1.67179   70.9245  0.924523   1.05246         3 
       3   2.22397    71.507   1.50696   2.36035         4 
       4   2.39049   74.8912   4.89122   1.93917         5 
       5   2.45503   73.5338   3.53382    2.0664         6 
       6   1.68758   71.6764   1.67642   1.90495         7 
       7   1.98233   72.4222   2.42221   1.65469         8 
       8   1.17144   74.0884   4.08839   1.91366         9 
       9   1.32697   71.7609   1.76087   1.21824        10 
      10   1.86376   70.3978  0.397753   1.21775        11 
      11   1.25541    74.888   4.88795   1.87875        12 
      12   1.17617   73.3528   3.35277   1.15393         1 
      13   2.38103   77.1762   7.17619   2.26703         2 
      14   1.13669   73.0157   3.01566         1         3 
      15   1.01569   70.4645  0.464485         1         4 
      16   2.36641   74.1699   4.16991   1.73009         5 
      17   2.27131   73.1005   3.10048   1.79657         6 
      18   1.80597   72.6299   2.62986    1.8497         7 
      19   2.41142   81.1973   11.1973     2.137         8 
      20   1.69218   71.4521   1.45212   1.47894         9 
      21   1.95271   74.8427    4.8427   1.93493        10 
      22   1.28452   76.7901   6.79008   2.09208        11 
      23   1.51663   83.4782   13.4782   1.81162        12 
      24   1.34177   73.4237   3.42369   1.57054         1 
      25   1.4309   70.7504  0.750369   1.22444         2 
      26   1.84851   72.9226   2.92256   2.04468         3 
      27   2.08114   78.4248   8.42476   1.78175         4 
      28   1.99175   71.0635   1.06346   1.25951         5 
      29   2.01235   72.2634    2.2634   1.36943         6 
      30   2.38742   74.2037   4.20372   1.82846         7 
      31   1.28055   71.2495   1.24953    1.8286         8 
      32   2.05698   76.0557   6.05571   2.03548         9 
      33   1.05429    77.721   7.72096   1.57831        10 
      34   2.15398   70.8861  0.886068    2.1353        11 
      35   2.46624   70.9682  0.968163   2.26856        12 
      36   1.4406   73.5243   3.52429   1.72608         1 
      37   1.71475    71.527   1.52703   1.72932         2 
      38   1.51423   78.5824    8.5824   1.97685         3 
      39   2.41538   73.7909   3.79093   2.07129         4 
      40   2.28402    71.131   1.13101   2.25293         5 
      41   1.70251   72.3616   2.36156   2.04926         6 
      42   1.19747   72.3894    2.3894         1         7 
      43   1.08089   71.1729   1.17288         1         8 
      44   2.21695   72.5905   2.59049   1.50915         9 
      45   1.52717   71.1402   1.14023   1.88717        10 
      46   1.5463   74.6696   4.66958   1.25725        11 
      47   2.34151        90        20   3.57864        12 
      48   1.10737   71.1989   1.19893   1.62447         1 
      49   2.2491   76.6415   6.64147   2.50868         2 
      50   1.76659   71.7038   1.70377     1.231         3 
      51   1.25174   76.9657   6.96572   1.99521         4 
      52   1.81153   73.0722   3.07225   2.15915         5 
      53   1.72942   71.9639   1.96392   1.86142         6 
      54   2.17748   78.1207   8.12068   2.54388         7 
      55   1.29186   77.0589   7.05886   1.82777         8 
      56   1.92399   72.6126   2.61256   1.32816         9 
      57   1.38008   70.8872  0.887228   1.37826        10 
      58   1.96143   73.8529   3.85289   1.87809        11 
      59   1.61795   74.6957   4.69565   1.65806        12 
      60   2.02756   75.7877   5.78773   1.72684         1 
      61   2.41378   75.9826   5.98255   2.76309         2 
      62   1.41413   71.3419   1.34194   1.75285         3 
      63   2.31185   72.5469   2.54685   2.27947         4 
      64   1.94336   71.5592   1.55922   1.96157         5 
      65   2.094   74.7338   4.73385   2.07885         6 
      66   1.19458    72.233   2.23301         1         7 
      67   2.13118   79.1225    9.1225   1.84193         8 
      68   1.48076   87.0511   17.0511   2.94927         9 
      69   1.98502   79.0913   9.09131   2.47104        10 
      70   2.25937   73.8232   3.82322   2.49798        12 
      71   1.18744   70.6821  0.682067    1.2848         1 
      72   1.20189   70.7053  0.705311   1.33293         2 
      73   1.69115   73.9781    3.9781   1.87517         3 
      74   1.0556   73.2146   3.21459         1         4 
      75   1.59936   71.4165   1.41653   1.29695         5 
      76   1.66044   70.7151  0.715145   1.22362         6 
      77   1.79167   74.8072   4.80722   1.86081         7 
      78   2.30484   71.5028   1.50285   1.60626         8 
      79   2.49073   71.5908   1.59084   1.80815         9 
      80   1.32729   70.9077  0.907698   1.12889        10 
      81   2.48874   83.0079   13.0079   2.59237        11 
      82   2.46786   84.1806   14.1806   3.35518        12 
      83   2.12407   73.5826   3.58261   1.98482         1 
      84   2.46982   76.6556   6.65559   2.48936         2 
      85   1.00777   70.2504  0.250364         1         3 
      86   1.93118   73.9276   3.92763   1.84407         4 
      87   1.00017   72.6359   2.63594    1.3882         5 
      88   1.90622    71.047     1.047    1.7595         6 
      89   2.43744    72.321   2.32097   1.67244         7 
      90   1.25712        90        20   2.63949         8 
      91   1.10811   71.8299   1.82987         1         9 
      92   2.25545   71.8849    1.8849   1.94247        10 
      93   2.47971   73.4697    3.4697   1.87842        11 
      94   1.93378   74.2952    4.2952   1.52478        12 
      95   2.17525   73.0547   3.05466   2.23563         1 
      96   2.18723   70.8299  0.829929   1.75177         2 
      97   1.69984   72.0026   2.00263   1.45564         3 
      98   1.12504   70.4229  0.422904   1.06042         4 
      99   2.41723   73.7324   3.73238   2.18307         5 
; 
 
 /*-- need extra work space, modules take quite a bit of space --*/ 
PROC IML WORKSIZE=100; 
 
 /*-- load graphics --*/ 
CALL GSTART; 
 
 
 /*--------------------*/ 
 /*-- define modules --*/ 
 /*--------------------*/ 
 
 /*-- MODULE : compute contours --*/ 
START CONTOUR(C,X,Y,NPOINTS,PVALUES); 
 
    /*-- this routine computes contours for a scatter plot --------*/ 
    /*-- c returns the contours as consecutive pairs of columns ---*/ 
    /*-- x and y are the x and y coordinates of the points --------*/ 
    /*-- npoints is the number of points in a contour -------------*/ 
    /*-- pvalues is a column vector of contour probabilities ------*/ 
    /*--  the number of contours is controled by the ncol(pvalue) -*/ 
 
    XX=X||Y; N=NROW(X); 
    /* CORRECT FOR THE MEAN */ 
    MEAN=XX[+,]/N; 
    XX=XX-MEAN@J(N,1,1); 
 
    /* find principle axes of ellipses */ 
    XX=XX`*XX/N; 
    CALL EIGEN(V,E,XX); 
 
    /* set contour levels */ 
    C=-2*LOG(1-PVALUES); 
    A=SQRT(C*V[1]); B=SQRT(C*V[2]); 
 
    /* parameterize the ellipse by angle */ 
    T=( (1:NPOINTS) - {1})#ATAN(1)#8/(NPOINTS-1); 
    S=SIN(T); T=COS(T); 
    S=S`*A; T=T`*B; 
 
    /* form contour points */ 
    S =((E*(SHAPE(S,1)//SHAPE(T,1)))+MEAN`@J(1,NPOINTS*NCOL(C),1) )`; 
    C=SHAPE( S , NPOINTS ) ; 
 
    /* returned as ncol pairs of columns for contours */ 
FINISH; 
 
 /*-- MODULE : draw contour curves --*/ 
START GCONTOUR(T1, T2); 
    RUN CONTOUR(T12, T1, T2, 30, {.5 .8 .9}); 
    WINDOW=( MIN(T12[ ,{1 3}],T1 ) || MIN(T12[ ,{2 4}],T2 )) // 
          ( MAX(T12[ ,{1 3}],T1 ) || MAX(T12[ ,{2 4}],T2 )); 
    CALL GWINDOW(WINDOW); 
    CALL GDRAW(T12[,1],T12[,2],,'BLUE'); 
    CALL GDRAW(T12[,3],T12[,4],,'BLUE'); 
    CALL GDRAW(T12[,5],T12[,6],,'BLUE'); 
    CALL GPOINT(T1,T2,,'RED'); 
FINISH; 
 
 
 /*-- MODULE : find median, quartiles for box and whisker plot --*/ 
START BOXWHSKR(X, U, Q2, M, Q1, L); 
 
  RX=RANK(X); S=X; 
  S[RX,] = X; 
  N = NROW(X); 
 
  /*-- median --*/ 
  M=FLOOR( ((N+1)/2) || ((N+2)/2) ); 
  M=(S[M,])[+,]/2; 
 
  /*-- compute quartiles --*/ 
  Q1=FLOOR( ((N+3)/4) || ((N+6)/4) ); 
  Q1=(S[Q1,])[+,]/2; 
  Q2=CEIL( ((3*N+1)/4) || ((3*N-2)/4) ); 
  Q2=(S[Q2,])[+,]/2; 
  H=1.5*(Q2-Q1);          /*-- step=1.5*(interquartile range) --*/ 
  U=Q2+H; 
  L=Q1-H; 
  U=(U>S)[+,]; U=S[U,];   /*-- adjacent values -----------------*/ 
  L=(L>S)[+,]; L=S[L+1,]; 
 
FINISH; 
 
 
 /*-- box and whisker plot --*/ 
START GBXWHSKR(T, HT); 
 
      RUN BOXWHSKR(T, UP, Q2,MED, Q1, LO); 
 
      *---adjust screen viewport and data window---; 
      Y =  MIN(T) // MAX(T); 
      CALL GWINDOW({0, 100} || Y); 
 
      MID  = 50;    WLEN = 20; 
 
      *-- add whiskers --; 
      WSTART=MID - (WLEN / 2); 
      FROM = (WSTART || UP) // (WSTART || LO); 
      TO   = ((WSTART // WSTART) + WLEN) || FROM[,2]; 
 
      *-- add box --; 
      LEN = 50; 
      WSTART=MID - (LEN / 2); 
      WSTOP=WSTART + LEN; 
      FROM= FROM // (WSTART || Q2) // (WSTART || Q1) // 
           (WSTART || Q2) // (WSTOP || Q2); 
      TO = TO // (WSTOP || Q2) // (WSTOP || Q1) // 
                 (WSTART || Q1) // (WSTOP || Q1); 
 
      *---add median line---; 
      FROM = FROM // (WSTART || MED); 
      TO   = TO   // (WSTOP  || MED); 
 
      *---attach whiskers to box---; 
      FROM = FROM // (MID || UP) // (MID || LO); 
      TO   = TO   // (MID || Q2) // (MID || Q1); 
 
      *-- draw box and whiskers ---; 
      CALL GDRAWL(FROM, TO,,'RED'); 
 
      *---add minimum and maximum data points---; 
      CALL GPOINT(MID, Y ,3,'RED'); 
 
      *---label min, max, and mean---; 
      Y = MED // Y; 
      s = {'MED' 'MIN' 'MAX'}; 
      CALL GSET("FONT","SIMPLEX"); 
      CALL GSET('HEIGHT',13); 
      CALL GSCRIPT(WSTOP+HT, Y, CHAR(Y,5,2),,,,,'BLUE'); 
      CALL GSTRLEN(LEN, S); 
      CALL GSCRIPT(WSTART-LEN-HT,Y,S,,,,,'BLUE'); 
      CALL GSET('HEIGHT'); 
FINISH; 
 
 
 /*-- MODULE : do scatterplot matrix --*/ 
START GSCATMAT(DATA, VNAME); 
   CALL GOPEN('SCATTER'); 
   NV      = NCOL(VNAME); 
   IF (NV = 1) THEN NV = NROW(VNAME); 
   CELLWID = INT(90/NV); 
   DIST = 0.1 * CELLWID; 
   WIDTH = CELLWID - 2*DIST; 
   XSTART = INT((90 -CELLWID * NV)/2) + 5; 
   XGRID = ((0:NV)#CELLWID + XSTART)`; 
 
   /*-- delineate cells --*/ 
   CELL1 = XGRID; 
   CELL1 = CELL1 || (CELL1[NV+1] // CELL1[NV+1-(0:NV-1)]); 
   CELL2 = J(NV+1, 1, XSTART); 
   CELL2 = CELL1[,1] || CELL2; 
   CALL GDRAWL(CELL1, CELL2); 
   CALL GDRAWL(CELL1[,{2 1}], CELL2[,{2 1}]); 
 
 
   XSTART = XSTART + DIST;  YSTART = XGRID[NV] + DIST; 
 
   /*-- label variables ---*/ 
   CALL GSET("HEIGHT", 5); 
   CALL GSET("FONT","TRIPLEX"); 
   CALL GSTRLEN(LEN, VNAME); 
   WHERE = XGRID[1:NV] + (CELLWID-LEN)/2; 
   CALL GSCRIPT(WHERE, 0, VNAME) ; 
   LEN = LEN[NV-(0:NV-1)]; 
   WHERE = XGRID[1:NV] + (CELLWID-LEN)/2; 
   CALL GSCRIPT(4,WHERE, VNAME[NV - (0:NV-1)],90); 
 
   /*-- First viewport --*/ 
   VP = (XSTART || YSTART) // ((XSTART || YSTART) + WIDTH) ; 
 
   /*-- Since the characters are scaled to the viewport (which 
        is inversely porportional to the number of variables), 
        enlarge it proportional to the number of variables --*/ 
   HT = 2*NV;  CALL GSET("HEIGHT", HT); 
 
   DO I=1 TO NV; 
      DO J=1 TO I; 
         CALL GPORTSTK(VP); 
         IF (I=J) THEN RUN GBXWHSKR(DATA[,I], HT); 
         ELSE RUN GCONTOUR(DATA[,J], DATA[,I]); 
         /*-- onto the next viewport --*/ 
         VP[,1] = VP[,1] + CELLWID; 
         CALL GPORTPOP; 
      END; 
      VP =  (XSTART // XSTART + WIDTH) || (VP[,2] - CELLWID); 
   END; 
   title1 = 'SAS/IML'; 
   title2 = 'R'; 
   title3 = 'SOFTWARE'; 
   call gwindow ({0 0 100 100}); 
   call gstrlen(t1len,title1,6,'italic',{0 0 100 100}); 
   call gstrlen(t3len,title3,6,'italic',{0 0 100 100}); 
   call gset('color','yellow'); 
   call gscript(92-t1len,90,title1,,,6,'italic'); 
   call gscript(92,93,title2,,,6,'special'); 
   call gscript(95-t3len,80,title3,,,6,'italic'); 
   call gset('color'); 
   CALL GSHOW; 
FINISH; 
 
 
 /*-- Placement of text are based on the character height. The 
     IML modules defined here assume percent as the unit of 
     character height for device independent control. --*/ 
GOPTIONS GUNIT=PCT CBACK=BLACK; 
 
USE FACTORY; 
VNAME = {PROD, TEMP, DEFECT}; 
READ ALL VAR VNAME INTO XYZ; 
RUN GSCATMAT(XYZ, VNAME[1:2]);   /*-- 2 x 2 scatterplot matrix --*/ 
RUN GSCATMAT(XYZ, VNAME);        /*-- 3 x 3 scatterplot matrix --*/ 
QUIT; 
 
GOPTIONS GUNIT=CELL CBACK=;             /*-- reset back to default --*/ 
 

/*example 3*/

/****************************************************************/ 
 /*          S A S   S A M P L E   L I B R A R Y                 */ 
 /*                                                              */ 
 /*    NAME: STATDEMO                                            */ 
 /*   TITLE: STATISTICAL EXAMPLE                                 */ 
 /* PRODUCT: IML                                                 */ 
 /*  SYSTEM: ALL                                                 */ 
 /*    KEYS: MATRIX                                              */ 
 /*   PROCS: IML                                                 */ 
 /*    DATA:                                                     */ 
 /*                                                              */ 
 /* SUPPORT: RHD                         UPDATE:                 */ 
 /*     REF:                                                     */ 
 /*    MISC:                                                     */ 
 /*                                                              */ 
 /****************************************************************/ 
 
proc iml; 
reset print; 
 
x = {1 1 1 , 1 2 4 , 1 3 9 , 1 4 16, 1 5 25}; 
y = {1,5,9,23,36}; 
b = inv(x`*x)*x`*y; 
yhat = x*b; 
r = y-yhat; 
sse =ssq(r); 
 
start reg(x,y); 
  xpxi=inv(x`*x); 
  beta = xpxi*(x`*y); 
  yhat = x*beta; 
  resid = y-yhat; 
  sse = ssq(resid); 
  n = nrow(x); 
  dfe = n-ncol(x); 
  mse = sse/dfe; 
  cssy = ssq(y-y[+]/n); 
  rsquare = (cssy-sse)/cssy; 
  print , "Regression Results" , , sse dfe mse rsquare; 
  stdb = sqrt(vecdiag(xpxi)*mse); 
  tratio = beta/stdb; 
  prob = 1-probf(tratio#tratio,1,dfe); 
  print , "Parameter Estimates" , , beta stdb tratio prob; 
  print , y yhat resid; 
 finish; 
 
reset noprint; 
run reg(x,y); 
quit;
