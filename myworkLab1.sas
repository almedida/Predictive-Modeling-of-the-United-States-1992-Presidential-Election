libname mywork "\\client\c$\SAS\512\data\lab1";
title "Pre Valentine's Lab";
proc print data=mywork.Ch05q02;
run;

data mywork.graph;
	set mywork.Ch05q02;
	proc gplot data=mywork.graph;
		plot QUET*SBP;
		plot AGE*QUET;
		plot AGE*SBP;
	run;
*All three situations seem to have reasonably strong positive linear
relationships.  I might expect correlations of 0.4 or higher;

data mywork.correlation;
	set mywork.Ch05q02;
	title "Best Guess Based on Correlation";
	proc corr;
	var quet sbp age;
run;

*The correlation between QUET and SBP is 0.742;
*The correlation between QUET and AGE is 0.80725;
*The correlation between SBP and AGE is 0.7752;

data mywork.regression;
	set mywork.Ch05q02;
	title "Determining Actual Least Squares Regression";

	proc reg data=mywork.regression;
		title2 "QUET vs SBP";
		model sbp=quet;
	run;

*The y-intercept is 70.58.  The slope is 21.49.  When the quetelet
index is zero we expect a 40+ year old males sbp to be 70.58.  For
every one unit increase in the quetelet index we expect sbp to 
increase by 21.49 on average.;

	proc reg data=mywork.regression;
		title2 "QUET vs AGE";
		model quet=age;
	run;

*The y-intercept is 0.39.  The slope is 0.06.  When the age of a 
40+ year old man is zero (What the cut the?!!) we expect his quetelet
index to be 0.39.  For every one unit increase in age we expect a 
40+ year old man's quetelet index to increase by 0.06 on average;

	proc reg data=mywork.regression;
		title2 "AGE vs SBP";
		model sbp=age;
	run;
run;

*The y-intercept is 59.09.  The slope is 1.6.  When the age of a 
40+ year old man is zero (What the cut the?!!) we expect his sbp
index to be 59.09.  For every one unit increase in age we expect a 
40+ year old man's spb to increase by 1.6 on average;

data mywork.graphSymbol;
	set mywork.Ch05q02;
	proc gplot data=mywork.graphSymbol;
		title "SBP = Systolic Blood Pressure vs QUET = Bodysize";
		plot QUET*SBP;
		*symbol1 value = M;
		*symbol1 value = #;
		symbol1 value = circle;
	run;
run;

data expLove;
input x;
y=exp(x);
cards;
1
2
3
4
5
6
7
8
9
10
11
12
;	
	proc gplot data=expLove;
		title "Exponential Love Graph";
		plot y*x;
		symbol1 value = #;
run;
