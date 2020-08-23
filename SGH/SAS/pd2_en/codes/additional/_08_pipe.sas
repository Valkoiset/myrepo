filename f pipe 'dir c:\ /w /a:-d /b';
data w;
infile f;
input;
/*input tempc $ 1-200;*/
/*put tempc=;*/
a=_infile_;
run;