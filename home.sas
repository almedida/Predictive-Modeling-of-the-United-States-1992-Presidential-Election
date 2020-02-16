%let persevere = quit;
&persevere;
libname home "\\client\c$\SAS\512\data\lab4";
proc contents data=home.homes;
run;
&persevere;

data myLab4;
	SET home.homes;
		
	if EXTERIOR = "Excellnt" then exter_num=2;
	else if EXTERIOR="Good" then exter_num=1;
	else exter_num=0;

	if garage="Garage" then gar_num=1;
	else gar_num=0;

	BATH_TOT = fullbath + (halfbath/2);

	HOMEVAL = totalval - landval;
	
	HOMEVAL = HOMEVAL/1000;

run;
&persevere;
proc print data =home.myLab4;
run;
quit;

*reduced and full model;

proc glm data=myLab4;
	model HOMEVAL = bedrooms rooms bath_tot exter_num gar_num;
run;
&persevere;


proc glm data=home.myLab4;
	model HOMEVAL = gar_num exter_num bath_tot rooms bedrooms;
run;
&persevere;


proc glm data=home.myLab4;
	model HOMEVAL = gar_num exter_num bath_tot rooms bedrooms;
run;
&persevere;

proc glm data=home.myLab4;
	model HOMEVAL = gar_num exter_num bath_tot rooms;
run;
&persevere;

proc glm data=home.myLab4;
	model HOMEVAL = gar_num bath_tot rooms;
run;
&persevere;
