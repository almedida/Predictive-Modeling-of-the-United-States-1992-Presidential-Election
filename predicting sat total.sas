libname hwSchool "\\client\c$\SAS\512\data\hw1";
proc contents data=hwSchool.schools;
run;
*TASK #1

We are concerned with predicting total SAT scores based upon other factors. Follow the criteria below to fit what you think is the "best model".  For all of the models, total SAT will be your dependent variable.

1.	FOR THIS WEEK ONLY (AND NEVER AGAIN!), YOU MAY FIT YOUR MODELS WITHOUT WORRYING ABOUT IF THEY VIOLATE THE ASSUMPTIONS OF THE LINEAR MODEL.  You need not consider this as a factor in choosing your best model.
2.	Your model may only consist only of linear terms. You may not use squared, cubed, interacted, or other transformed terms.
3.	Consider the following 3 factors equally in selecting your best model:
a)	the degree of overall correlation (R-Squared)
b)	The overall F-test result
c)	The simplicity of the model.

;

*to get CI for a slope;

data school;
Title "Predicting Total Scores based on some factors";
 set hwSchool.schools;
 sat_tot = satm + satv;
run;
proc print data=school;
run;
quit;

 *we want tpo find one variable that has the greatest correlation with sat_tot;
proc corr data=school;
	var sat_total enroll cost salary satpart GMCASEng GMCASMth S_TRatio S_CounselRatio DropoutRate College TwoYrPub FourYrPub TwoYrPri FourYrPri Military Work Other;
run;
quit;

*we found GMCASMth and GMCASEng to have highest correlation with sat_total;
proc reg data=school;
model sat_total =GMCASEng GMCASMth;
run;
quit; 

proc reg data=school;
	model sat_total= college dropoutrate fouryrpri fouryrpub gmcaseng gmcasmth military other S_CounselRatio S_TRatio twoyrpri twoyrpub work cost enroll salary   / selection=rsquare stop=3;
run;
quit;

proc reg data=school;
	model sat_Total= GMCASMth TwoYrPub;
run;
quit;

