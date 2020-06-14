libname bearLab "\\client\C:\SAS\512\lab5";
data bearLabWork;
set bearLab.bear;
run;

proc contents data=bearLabWork;
run;

proc print data=bearLabWork;
run;

/** 1)   Run a model using neck girth, chest girth, and age to predict weight. 
Based on your Proc Reg output alone what is the multiple correlation coefficient? **/

proc reg data=bearLabWork;
model weight = neck chest age;
run;
/** R-squared is 0.9425. mutiple correlation (squared root of R-squared is 0.9708) 

R-squared says that 94.25% of the variability in bear weight is explained by its
regression relationship with neck, chest and age;

Multiple correlation explains that there is a strong positive linear relationship between bear's weight  and neck, chest, age.
**/

/** 2)  Now use the output statement in proc reg to output the observed values of y and the predicted values of y.  
If you are not sure how to do this, use SAS help files.  
What should be the correlation between these two variables?  Verify that by using Proc Corr.
**/

proc reg data=bearLabWork;
model weight = neck chest age;
output out=output p=predictiveValues;
run;


proc print data=output;
run;

proc corr data=output;
var preds weight;
run;

/** the correlation is 0.97081 
weight is the Y, predicted values is Yhat
**/

/** 
3)  Use Proc Corr to find the first order partial correlation between weight 
and chest after controlling for neck.  
**/

proc corr data=bearLabWork;
var weight chest;
partial neck;
run;

*The partial correlation is .66888;
