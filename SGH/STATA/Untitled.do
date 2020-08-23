gen Working =(work==1)
gen Gender = (sex==1)
gen Education =.
replace Education=1 if degree == 1
replace Education=2 if degree == 2
replace Education=3 if degree == 3
replace Education=4 if degree == 4
replace Education=5 if degree == 5
gen Partner =.
replace Partner =0 if spwork ==0
replace Partner =1 if spwork ==1
replace Partner =2 if spwork ==2
replace Partner =3 if spwork ==3
replace Partner =9 if spwork ==9

