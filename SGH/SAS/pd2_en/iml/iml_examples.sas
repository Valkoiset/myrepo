/*iml examples*/

proc iml; 
A = {1 2 3, 
     4 5 6, 
     7 8 9};
quit;


data libdata.dataset;
input x1 x2 x3;
cards;
10 11 12
13 14 15
16 17 18
;
proc iml; 
use libdata.dataset; 
read all var {x1 x2 x3} into B;
quit;

proc iml; 
A = {1 2 3, 
     4 5 6, 
     7 8 9};
create te from A;
quit;



proc iml; 
reset print; 
A = {1 2 3, 
     4 5 6, 
     7 8 9};
quit;

proc iml; 
A = {1 2 3, 
     4 5 6, 
     7 8 9};
print A; 
quit;


proc iml; 
reset noprint;
A = {1 2 3, 
     4 5 6, 
     7 8 9};
B = 2 # A;  
print A; print B [format=5.2 label="Mno¿enie"];
quit;


proc iml; 
reset print; 
N ='Kowalska, Nowak';
I="Ala, Ola";
quit;

proc iml; 
N ='Kowalska, Nowak';
I="Ala, Ola";
print N; print I;
quit;

proc iml; 
N ={'Kowalska'  'Nowak'};
I={Ala  Ola};
print N; print I;
quit;


proc iml; 
a = 1; 
b = {1, 2, 3};
c = {1 2 3}; 
D = {1 2 3, 4 5 6, 7 8 9}; 
print a; print b; print c; print D;
quit;

proc iml;
A = I(3);
B = J(3,3,0);  
C = J(3,1); 
D=diag({1 2 3}); 
print A; print B; print C; print D; 
quit;


proc iml; 
reset print;
A ={1 4, 9 16}; 
B ={1 0,-1 0};
summarization = A+B;  
substracking = A-B; 
multiplication = A*B; 
mul = 2*A;
C = -A; 
absolute = abs(B); 
square_root = sqrt(A); 
maxvalue = max(A); 
minvalue = min(A); 
quit;


proc iml;
reset print;
A ={1 2,3 4};
tanspose = t(A);
determinant = det(A);
inversematrix = inv(A);
traceofmatrix = trace(A);
quit;


