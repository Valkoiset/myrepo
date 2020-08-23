 /*-------------------------
		My first dofile
 ---------------------------*/

sysuse auto // opens a new database

browse // explores the data

* cTRL+D EXECUTES SELECTED LINE
* ctrl+shift+d
* ctrl+d (no selected lines) executes everything



*--------------------------------------*
* Commands to describe the database
*--------------------------------------*

describe

codebook

labelbook


*-----------------------------------*
*	Commands to describe data		*
*-----------------------------------*

summarize price mpg , detail

help summarize

tabulate foreign

summarize price if foreign == 0

* What is the average price of cars with 18 <= mpg  <= 25?

summarize price if mpg>=18 & mpg<=25 

summarize price if inrange(mpg,18,25)

* What is the average price of cars with mpg < 18 or mpg > 25?

summarize price if mpg<18 | mpg>25 

summarize price if !inrange(mpg,18,25)

summarize price if foreign != 0


* What is the average price of foreign & domestic cars?
tabulate foreign, sum(price)

	

*---------------------------------------*
*	Commands to modifty the data
*----------------------------------------*

gen myfirstvar = 1
gen l_price = log(price) // ln(price) has same result
gen price2 = price^2

gen dummy_foreign = (foreign==1 & mpg>24)*price

egen avg_price = mean(price) , by(foreign)

* help egen
*drop myfirstvar
*keep l_price
*clear

*-------------------------------------------*
*		Running my first regression			*
*-------------------------------------------*

/* Can we distinguish between foreign and  domestic 
cars based only on other features (price, mpg, rep78)?*/

* Linear regression (OLS)
reg foreign price mpg rep78

reg foreign price mpg i.rep78

reg foreign l_price mpg i.rep78
estimates store reg1

* Non-linear models: probit - logit

probit foreign l_price mpg i.rep78
estimates store probit

*-------------------------------------------*
*		Getting values back from Stata		*
*-------------------------------------------*

sum price
* the mean is 6165.257 
return list

gen means1 = . 
replace means1 = r(mean) if _n==1
drop means1
















