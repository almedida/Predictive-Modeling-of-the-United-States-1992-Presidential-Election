libname confound 'f:\wcu\sta512\datasets';

data ch11_1;
set confound.ch16q01;
run;

proc contents data=ch11_1;
run;

proc print data=ch11_1;
run;

*Question 1a;

proc reg;
model wgt=hgt age age2;
run;

*A model with the covariates age and age2 gives us our adjusted coefficient of .72369.  This adjusts for all
covariates of interest hence it is the "gold standard" we will compare all other models to.  It should be
noted that the associated standard error is .27696;

*Question 1b;

proc reg;
model wgt=hgt;
run;

*Our raw coefficient is 1.07223.  Using our 10% criteria this is "meaningfully" different than .72369.  Note that 
we should confirm this conclusion with a subject specialist as well.  This means that confounding does exist due to 
Age and/or Age2.

*Question 1c;

proc reg;
model wgt=hgt age;
run;

*Our coefficient is .72044.  Using our 10% rule this is not meaningfully different than .72369. Hence Age2 is not
needed to control for confounding;

*Question 1d and 1e;

*The associated standard error is .26081.  This is better than .27696 hence a model without Age2 is preferred to a
model with Age2 as it both controls for confounding and has a more precise estimate;

*Questions 1f and 1g;

proc reg;
model wgt=hgt age age2;
run;

proc glm;
model wgt = hgt age age2 hgt*age hgt*age2;
run;


*Test statistic to test for interaction is [(736.63-693.03)/2)]/25.27 = .863;

*Note that this has 2 and 6 df;

*To get its pvalue;

data pvalue;
pvalue = probf(.863,2,6);
run;

proc print data=pvalue;
run;

*Pvalue is .5316;

*Hence at the .05 signifiance level we would conclude that there does not appear significant interaction between
hgt and age as well as hgt and age2;









 







/*Question A - only X3 */
proc reg data=RHR.ch11q05;
	model y=x1;
	model y=x2;
	model y=x3;
run;

/*Question B */
proc reg data=RHR.ch11q05;
	model y=x1 x2 x3 ;
run;
quit;

/*Question C*/
data partC;
	set rhr.ch11q05;
	inter13=x1*x3;
	inter23=x2*x3;	
critval=finv(.95,2,36);
put critval;
run;

proc print data=partc;
run;

proc glm data=PARTC;
	model y=x1 x2 x3 inter13 inter23 ;
run;

/*Question D*/

proc glm data=RHR.ch11q05;
	model y=x1 x2 x3 ;
run;

/*Question E*/

proc reg data=RHR.ch11q05;
	model y=x3;
	model y=x3 x2;
	model y=x3 x1;
	model y=x3 x2 x1;
run;


	
