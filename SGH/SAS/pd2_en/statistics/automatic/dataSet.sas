/*data preparation*/
data outlib.dataSet;
array x(20) x1-x20;
do n=1 to 5000;
	x1=ranuni(1)*100+200;
	x2=rannor(1)*5+70;
	x3=rangam(1,5)*7+10;
	x4=x1*6+x2*3+rannor(1)*5;
	x5=x1*2+rannor(1)*2;
	x6=x3*2+x4*3+rannor(1)*6;
	x7=x5+rannor(1)*20+50;
	x8=ranuni(1)*200+6;
	x9=ranuni(1)*rannor(1)*50+7;
	x10=x8+x9+rannor(1);
	x11=x2+x3+x4*9+rannor(1)*30+6;
	x12=ranuni(1)*5+1000;
	x13=rannor(1)+300;
	x14=x12+2*x13+rannor(1)*90+1000;
	x15=ranuni(1)*4-300;
	x16=rannor(1)-200;
	x17=x10+x16*100+rannor(1)*200;
	x18=x11+x12+ranuni(1)*100;
	x19=x10*2+rannor(1)*2;
	x20=ranuni(1);
	y=x1+2*x2+3*x3+5*x10+6*x12+7*x13-8*x16+rannor(1)*200+20;
	output;
end;
run;
/*data preparation*/

