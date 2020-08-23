//	class 2

// do tasks solved
// get the number of kids
tab hhtodd

//doing a set test
logit emp i.female i.educ i.married c.age##c.age i.hhtodd if  to_use ==1
est store full

// test for several restrictions (WALD)
test i1.hhtodd i2.hhtodd i3.hhtodd

logit emp i.female i.educ i.married c.age##c.age if  to_use ==1
est store restricted

// LR TEST (likelihood ratio test)
lrtest full restricted 	// comparing 2 models

// quality of the model
estat classification

estat classification, cutoff(.75)

lroc	// roc curve

// H-l
estat gof, g(10) table 

// Marginal effects

logit emp i.female i.educ i.married c.age##c.age if  to_use ==1

margins , dydx(age) at (age=(30 40 50))
