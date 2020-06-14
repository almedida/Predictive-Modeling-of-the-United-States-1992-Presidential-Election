OPTIONS NODATE NONUMBER;

libname mywork "\\Client\C:\SAS\512\exam";

data exam;
set mywork.exam2;
run;
quit;

*model building;
*splitting data for training and holdout for the purpose of reliability testing;
data examSplit;
	set exam;
	ran_num = ranuni(2008);
run;
quit;

proc sort data=examSplit;
by ran_num;
run;
quit;

data examHoldout trainingData;
	set examSplit;
	counter=_N_;
	if counter le 316 then output examHoldout;
	else output trainingData;
run;
quit;

proc print data=trainingData;
run;
quit;
data training;
set trainingData;

interAF=age*female;
interSF=savings*female;
interIF=income*female;
interPF=poverty*female;
interVF=veterans*female;
interFPD=female*pop_density;
interFN=female*nursing;
interFC=female*crime;
interFD=female*dem;
run;
quit;

proc reg data=training;
model clinton=age savings income poverty veterans female pop_density nursing crime dem;
run;
quit;

proc reg data=training;
model clinton=age savings income poverty veterans female pop_density nursing crime dem interAF interSF interIF interPF interVF
interFPD interFN interFC interFD;
run;
quit;

proc corr data=training;
var clinton age savings income poverty veterans female pop_density nursing crime dem;
run;
quit;

proc print data=training;
run;
proc reg data=training;
MODEL CLINTON = age savings income poverty veterans female pop_density nursing crime dem interAF interSF interIF interPF interVF
interFPD interFN interFC interFD /SELECTION=RSQUARE CP MSE 
INCLUDE=10;
run;
quit;

*using ALL VARIABLES SELECTION for most significant variables;
proc reg data=training;
MODEL CLINTON = age savings income poverty veterans female pop_density nursing crime dem interAF interSF interIF interPF interVF
interFPD interFN interFC interFD /SELECTION=stepwise slentry=0.15 slstay=0.15 
INCLUDE=10;
run;
quit;

proc reg data=training;
MODEL CLINTON = age savings income poverty veterans female pop_density nursing crime dem interAF interSF interIF interPF interVF
interFPD interFN interFC interFD /SELECTION=forward slentry=0.50
INCLUDE=10;
run;
quit;

proc reg data=training;
MODEL CLINTON = age savings income poverty veterans female pop_density nursing crime dem interAF interSF interIF interPF interVF
interFPD interFN interFC interFD /SELECTION=backward slstay=0.10
INCLUDE=10;
run;
quit;

*signifcant data using stepwise;
data sigData;
set training;
interSF = savings*female;
interFN = female*nursing;
run;
quit;

*correlation between the predictors and response variable;
proc corr data=sigData;
var CLINTON Savings Poverty Veterans Female Pop_density Nursing interSF interFN;
run;
quit;

*inspecting collinearity and variance inflation factors;
proc reg data=sigData;
model CLINTON = Savings Poverty Veterans Female Pop_density Nursing interSF interFN /collinoint vif;
run;
quit;

*regression between CLINTON and predictors;
proc reg data=sigData;
model CLINTON = Savings Poverty Veterans Female Pop_density Nursing interSF interFN;
run;
quit;

*centering;
proc means data=sigData;
var Savings Nursing Female;
run;
quit;

data newSigData;
set sigData;
Savings_c = Savings - 92307.89;
Nursing_c = Nursing - 9.6986414;
Female_c = Female - 51.0345656;
inter_SF = Savings_c*Female_c;
inter_FN = Female_c*Nursing_c;
run;
quit;

*correlation after centering;
proc corr data=newSigData;
var CLINTON Savings_c Poverty Veterans Female_c Pop_density Nursing_c inter_SF inter_FN;
run;
quit;

*inspecting collinearity and variance inflation factors after centering;
proc reg data=newSigData;
model CLINTON = Savings_c Poverty Veterans Female_c Pop_density Nursing_c inter_SF inter_FN /collinoint vif;
run;
quit;

*regression after centering;
proc reg data=newSigData;
model CLINTON = Savings_c Poverty Veterans Female_c Pop_density Nursing_c inter_SF inter_FN;
run;
quit;


*diagnostics;
*jackknife residuals vs predicted value;
proc reg data=newSigData;
model CLINTON = Savings_c Poverty Veterans Female_c Pop_density Nursing_c inter_SF inter_FN;
plot rstudent.*p.;
OUTPUT out = diagTrainingData p=pred residual=ei stdr=s_ei rstudent=jackknife student=student;
TITLE 'Jackknife Vs Predicted Value';
run;
quit;


PROC UNIVARIATE data = diagTrainingData normal plot;
VAR jackknife;
PROBPLOT jackknife / normal;
RUN;
quit;

proc univariate data=diagTrainingData;
var jackknife;
run;
quit;

proc reg data=diagTrainingData;
model CLINTON = Savings_c Poverty Veterans Female_c Pop_density Nursing_c inter_SF inter_FN;
OUTPUT out = newDiagTrainingData
p=pred rstudent=jackknife cookd = cooksdistance h=leverage;
run;
quit;

*finding outliers for either Absolute value of Jackknife residual greater than 2 or cooksdistance > 1 OR leverage > 2(k+1)/n = 2(11+1)/633;

DATA outliersDiag;
SET newDiagTrainingData;
IF (abs(jackknife) > 2) OR
(cooksdistance > 1) OR
(leverage > 0.02844); 
RUN;
quit;

*inspecting variables that violate testing processes;
proc print data = outliersDiag;
var county CLINTON jackknife cooksdistance leverage;
run;
quit;

*jackknife;
DATA JOutliersDiag;
SET newDiagTrainingData;
IF (abs(jackknife) > 2);
RUN;
quit;

proc print data=JOutliersDiag;
var county jackknife;
run;
quit;

*outliers that violate ALL DIAGNOSTIC PROCESS;
data allOutliersDiag;
set newDiagTrainingData;
If (leverage > 0.02844);
if (abs(jackknife) > 2);
if (cooksdistance > 1);
run;
quit;

proc print data=allOutliersDiag;
var county CLINTON pred jackknife cooksdistance leverage;
run;
quit;

data COutliers;
set newDiagTrainingData;
IF (cooksdistance > 1);
run;
quit;

data LOutliers;
set newDiagTrainingData;
If (leverage > 0.02844);
run;
quit;


*data shrinkage for reliability;
data examHoldoutTest;
set examHoldout;
Savings_c = Savings - 92307.89;
Nursing_c = Nursing - 9.6986414;
Female_c = Female - 51.0345656;
inter_SF = Savings_c*Female_c;
inter_FN = Female_c*Nursing_c;
Y_hat_h = 23.26263-0.00004577*Savings_c +0.70826*Poverty+0.41096*Veterans+1.39725*Female_c +0.00202*Pop_density-0.06772*Nursing_c+0.00001827*inter_SF -0.09544*inter_FN;
run;
quit;

proc print data=examHoldoutTest;
run; 

proc corr data=examHoldoutTest;
var CLINTON Y_hat_h;
run;
quit;

data reliable;
shrinkage = 0.3991 - (0.55473**2);
run;
quit;

proc print data=reliable;
run;
quit;

data better;
set mywork.exam2;
Savings_c = Savings - 92307.89;
Nursing_c = Nursing - 9.6986414;
Female_c = Female - 51.0345656;
inter_SF = Savings_c*Female_c;
inter_FN = Female_c*Nursing_c;
Y_hat_h = 23.26263-0.00004577*Savings_c +0.70826*Poverty+0.41096*Veterans+1.39725*Female_c +0.00202*Pop_density-0.06772*Nursing_c+0.00001827*inter_SF -0.09544*inter_FN;
Residual=CLINTON - Y_hat_h;
if (Residual < 0);
run;
quit;

proc print data=better;
var County CLINTON Y_hat_h Residual;
run;
quit;

proc sgplot data=examHoldoutTest;      
  scatter x=Y_hat_h y=clinton;
  ellipse x=Y_hat_h y=clinton /
     alpha=.2
     name="eighty"
     legendlabel="80% Prediction";
  ellipse x=Y_hat_h y=clinton /
     alpha=.05
     name="ninetyfive"
     legendlabel="95% Prediction";
  keylegend "eighty" "ninetyfive";
  label x="Predicted" y="Actual";
run;
proc sgplot data=shrinkageTest;
scatter x=Y_hat_h y= clinton;
label x="Predicted" y="clinton";
run;
quit;

proc gplot data=examHoldoutTest;
plot clinton * Y_hat_h /vaxis=Actual haxis=Predicted;
symbol1 value=+;
run;

quit;
