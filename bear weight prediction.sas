* Set options, footnotes, form setting;
options ps=60 ls=78 nodate pageno=1;
data bears;
set "\\client\C:\SAS\512\data\bear.sas7bdat";
run;

proc print data=bears;
run;

data newBears;
set bears;
if sex=1 then gender=0;
else gender=1;

*inter=length*gender;
run;

proc print data=newBears;
run;
/*proc reg data=newBears;
model weight= length gender inter;
run;
Quit;
*/
proc reg data=newBears;
model weight= length gender;
run;
Quit;

data newBearsMale;
set bears;
if sex=1 then gender=0;
else gender=1;

*inter=length*gender;
run;
proc reg data=newBearsMale;
model weight= length gender;
run;
quit;

data newBearsMale;
set bears;
if sex=2 then gender=1;
else gender=0;

*inter=length*gender;
run;
proc reg data=newBearsFemale;
model weight= length gender;
run;
quit;

/* proc glm data=newBears;
model weight = length|gender|inter;
run;
*/

proc reg data=newBearsMale;
model weight= length gender inter;
run;
data newBearsFemale;
set bears;
if sex=2 then gender=1;
else gender=0;

*inter=length*gender;
run;
proc reg data=newBearsFemale;
model weight= length inter;
run;
*/

