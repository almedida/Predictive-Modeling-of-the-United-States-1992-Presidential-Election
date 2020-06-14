data lab;
set "e:/sta512/datasets/bear.sas7bdat";
run;

*1);

proc reg data=lab;
model weight = neck chest age;
run;

*The correlation is the positive square root of 0.9425 which is 0.9708;
*R-squared says that 94.25% of the variability in bear weight is explained by its
regression relationship with neck, chest and age;

*R of .9708 simply says that there is a strong, linear relationship between a 
bear's weight and its predicted weight using neck, chest, and age;


*2);
proc reg data=lab;
model weight = neck chest age;
output out=output p=preds;
run;

proc print data=output;
run;

proc corr data=output;
var preds weight;
run;

*The correlation is 0.9708 as we knew it would be;

*3);

proc corr data=lab;
var weight chest;
partial neck;
run;

*The partial correlation is .6689;

