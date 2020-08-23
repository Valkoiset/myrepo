	// task 1

. use "/Users/valkoiset/Desktop/SGH/STATA/ISSP_2014_PL.dta"

	// task 2

gen emp = work == 1

	// task 3

gen male = sex == 1
gen female = sex == 2

gen primary = degree == 1
gen secondary = inrange(degree,2,4)
gen tertiary = inrange(degree,5,6)

gen workingPartner = inrange(partliv,1,2)

	// task 4

keep if age >= 25 & age <= 55

	// task 5

summarize age male female primary secondary tertiary workingPartner

	// task 6

reg emp age male female primary secondary tertiary workingPartner

probit emp age male female primary secondary tertiary workingPartner
	
