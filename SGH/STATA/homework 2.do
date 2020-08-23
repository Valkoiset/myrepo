// . use "/Users/valkoiset/Desktop/SGH/STATA/ISSP_2014_PL.dta". use "/Users/valkoiset/Desktop/SGH/STATA/ISSP_2014_PL.dta"

gen workingPartner = spwork ==1 if spwork!=0 & spwork!=9
// 0: no partner
// 9: No answer

logit emp i.female i.educ i.married c.age##c.age i.hhtodd i.workingPartner if  to_use ==1
est store full1

logit emp i.female i.educ i.married c.age##c.age i.hhtodd if  to_use ==1
est store restricted1

// Task 1
lrtest full1 restricted1

// Task 2
estat classification

