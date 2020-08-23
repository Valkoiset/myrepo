*-----------------------------------*
*		Introduction to Stata		*
*-----------------------------------*

* This file solves tasks from the first class.
* It also implements a few additional changes that help in the estimation and 
* make the analysis clearer.

* Stata settings
*---------------------------

* Folder where data are stored
* If you change this, it should work in your computers as well.

* Task 1
*------------
. use "/Users/valkoiset/Desktop/SGH/STATA/ISSP_2014_PL.dta"



* Task 2
*------------
gen emp = (work==1) if work!=9


* Task 3 
*------------
gen female =(sex==2)  // no missing values here

* New categorical variable for education. 
tab degree, sum(degree)
recode degree (0/1=1) (2/4=2) (5/6=3) (9=.), gen(educ)
label var educ "Highest education level - recoded"

gen emp_sp = spwork ==1 if spwork!=0 & spwork!=9
label var emp_sp "Working partner = 1"
* 0: no partner
* 9: No answer

gen married = partliv<3 if partliv!=9


*  Task 4 
*------------
gen prime_age = inrange(age, 25,55)

gen to_use = !missing(emp,educ,married,age) & prime_age 	// !!!


*  Task 5
*---------------------
tabstat age if to_use ==1, by(emp) stat(mean sd )
ttest age if  to_use ==1 , by(emp)

tabulate educ emp if to_use ==1, chi 

tabulate female emp if to_use ==1, chi 


*  Task 6
*--------------------------

reg emp i.female i.educ i.married c.age##c.age if  to_use ==1, vce(robust)
est store lpm

probit emp i.female i.educ i.married c.age##c.age if  to_use ==1
est store probit1

logit emp i.female i.educ i.married c.age##c.age if  to_use ==1
est store logit1

// outreg2 [lpm probit1 logit1] using my_first_regs, excel replace
