/*liner progamming*/
/*problem:*/
/*	x1+x2<=10, x1>=0 with maximization of x1*/
/*can be transformed into:*/
/*x1+x2=10 i x1-x3=0*/
proc iml;
   /* the problem data */
/*	x1+x2<=10, x1>=0 and we try to maximize x1*/
    obj={1 0}; 
    coef={1 1}; 
    b={0, 10}; 
  
       /* embed the objective function */ 
       /* in the coefficient matrix    */ 
    a=obj//coef; /*vertical concatenation*/
    a=a||{-1, 0}; /*horizontal concatenation*/
  
       /* solve the problem */ 
/*	a*x=b x>=0 i maksymalizujemy kombinacjê x*/
    call lp(rc,x,dual,a,b);
	print rc x dual a b;
/*	print x;*/
/*	print a;*/
/*	print b;*/
quit;



proc iml;
    /*  Subroutine to solve Linear Programs                      */ 
    /*  names:    names of the decision variables                */ 
    /*  obj:      coefficients of the objective function         */ 
    /*  maxormin: the value 'MAX' or 'MIN', upper or lowercase   */ 
    /*  coef:     coefficients of the constraints                */ 
    /*  rel:      character array of values: '<=' or '>=' or '=' */ 
    /*  rhs:      right-hand side of constraints                 */ 
    /*  activity: returns the optimal value of decision variables*/ 
    /*                                                           */ 
  

start linprog( names, obj, maxormin, coef, rel, rhs, activity); 
  
       bound=1.0e10; 
       m=nrow(coef); 
       n=ncol(coef); 
  
          /* Convert to maximization */ 
       if upcase(maxormin)='MIN' then o=-1; 
       else o=1; 
  
          /* Build logical variables */ 
       rev=(rhs<0); 
       adj=(-1*rev)+^ rev; 
       ge =(( rel = '>=' ) & ^rev) | (( rel = '<=' ) & rev); 
       eq=(rel='='); 
       if max(ge)=1 then 
       do; 
          sr=I(m); 
          logicals=-sr[,loc(ge)]||I(m); 
          artobj=repeat(0,1,ncol(logicals)-m)|(eq+ge)`; 
       end; 
       else do; 
          logicals=I(m); 
          artobj=eq`; 
       end; 
       nl=ncol(logicals); 
       nv=n+nl+2;
 

  
          /* Build coef matrix */ 
       a=((o*obj)||repeat(0,1,nl)||{ -1 0 })// 
         (repeat(0,1,n)||-artobj||{ 0 -1 })// 
         ((adj#coef)||logicals||repeat(0,m,2)); 
  
          /* rhs, lower bounds, and basis */ 
       b={0,0}//(adj#rhs); 
       L=repeat(0,1,nv-2)||-bound||-bound; 
       basis=nv-(0:nv-1); 
  
          /* Phase 1 - primal feasibility */ 
       call lp(rc,x,y,a,b,nv,,l,basis); 
       print ( { ' ', 
               '**********Primal infeasible problem************', 
               ' ', 
               '*********Numerically unstable problem**********', 
               '*********Singular basis encountered************', 
               '*******Solution is numerically unstable********', 
               '***Subroutine could not obtain enough memory***', 
               '**********Number of iterations exceeded********' 
               }[rc+1]); 
       if x[nv] ^=0 then 
       do; 
          print '**********Primal infeasible problem************'; 
          stop; 
       end; 
       if rc>0 then stop; 
  
          /* phase 2 - dual feasibility */ 
       u=repeat(.,1,nv-2)||{ . 0 }; 
       L=repeat(0,1,nv-2)||-bound||0; 
       call lp(rc,x,y,a,b,nv-1,u,l,basis); 
  
          /* Report the solution */ 
       print ( { '*************Solution is optimal***************', 
                 '*********Numerically unstable problem**********', 
                 '**************Unbounded problem****************', 
                 '*******Solution is numerically unstable********', 
                 '*********Singular basis encountered************', 
                 '*******Solution is numerically unstable********', 
                 '***Subroutine could not obtain enough memory***', 
                 '**********Number of iterations exceeded********' 
                }[rc+1]); 
       value=o*x  [nv-1]; 
       print ,'Objective Value ' value; 
       activity= x [1:n] ; 
       print ,'Decision Variables ' activity[r=names]; 
       lhs=coef*x[1:n]; 
       dual=y[3:m+2]; 
       print ,'Constraints ' lhs rel rhs dual, 
              '***********************************************'; 
  
    finish;

/*  names={'product 1' 'product 2' 'product 3' 'product 4'}; */
/*    profit={ 5.24 7.30 8.34 4.18}; */
/*    tech={ 1.5 1 2.4 1 , */
/*           1 5 1 3.5 , */
/*           1.5 3 3.5 1 }; */
/*    time={ 2000, 8000, 5000}; */
/*    rel={ '<=', '<=', '<=' }; */
/*    run linprog(names,profit,'max',tech,rel,time,products);*/
/**/
/*example 1	*/
/*	x1+x2<=10, x1>=0 with maximization x1*/
/*	tech * names <= time*/
names={'x1' 'x2'}; 
    profit={ 1 0}; 
    tech={ 1 1 , 
           -1 0 }; 
    time={ 10, 0}; 
    rel={ '<=', '<='}; 
    run linprog(names,profit,'max',tech,rel,time,products);
/*example 1	*/
quit;
/*liner progamming*/

/*nonliner progamming*/


proc iml; 
       title 'Test of NLPCG subroutine: No Derivatives'; 
       start F_BETTS(x); 
          f = .01 * x[1] * x[1] + x[2] * x[2] - 100.; 
          return(f); 
       finish F_BETTS; 
  
       con = {  2. -50.  .   ., 
               50.  50.  .   ., 
               10.  -1. 1. 10.}; 
       x = {-1. -1.}; 
       optn = {0 2}; 
       call nlpcg(rc,xres,"F_BETTS",x,optn,con); 
       quit;

proc iml;
start F_BETTS(x); 
       f = .01 * x[1] * x[1] + x[2] * x[2] - 100.; 
       return(f); 
    finish F_BETTS; 
  
    con = {  2. -50.  .   ., 
            50.  50.  .   ., 
            10.  -1. 1. 10.}; 
    x = {-1. -1.}; 
    optn = {0 2}; 
    call nlpnra(rc,xres,"F_BETTS",x,optn,con); 
    quit;

/*nonliner progamming*/
