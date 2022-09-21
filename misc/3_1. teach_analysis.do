/*******************************************************************************
*		Project: TEACH
********************************************************************************
Title: 					Analysis Teach Data
Author:					Alice Danon, World Bank (adanon@worldbank.org)
Last Modified by:		Vitor Pereira, vitpereira@gmail.com
All other contributors: Ezequiel Molina, World Bank (molina@worldbank.org)
Date Created: 			October 2, 2018
Last Modified: 			Feb 23rd, 2022 */

* Description: 			
//{
/** PURPOSE: 	The goal of this do-file is to produce graphs and tables
				to analyze Teach data
									
** REQUIRES: 	Dataset produced by the do-file "1b. teach_clean.do" ('CountryYear'_teach_clean.dta)		
				Adofile: distinct.ado
				Adofile: svmat2.ado

					
** CREATES:		Graphs in png
				Excel file to produce the same graphs as above but in Excel format
				and to fill the Teach at a Glance table

** OUTLINE:		1. Export Excel 
					1.a. Descriptive statistics
					1.b. Time on task
					1.c. Distributions elements and behaviors
					1.d. Distributions areas and elements (total, by rural/sample, by grade)
				2. Export Graphs 
					Figures 3_1 to 3_15

** HOW TO USE:  The goal of this do-file is to produce the graphs and tables
				analyzing the Teach data you collected. These graphs and tables
				can be used with the template report. All graphs are produced
				in png format as well as Excel format.
				You just have to indicate the path of the Teach folder on your 
				computer, the name of the country you collected the data in,
				the year you collected the data and then you can just run the do-file. 
				There is no modification to be made. You can however modify
				the do-file as you like to include your own analysis.
				
				IMPORTANT: For this do-file to run, you need to install the .ado 
				files distinct and svmat2.ado. These do-files are found in the same 
				folder as this do-file. To install, an '.ado' file,	you need to save 
				the file in a folder where Stata can find it. To 
				see which directories Stata looks in for '.ado' files, types
				sysdir. You should always use you 'personal' directory for
				storing these files.

*** CONTACT: 	If you have any questions regarding the use of this do-file,
*				contact the teach team at teach@worlbank.org
******************************************************************************/
//}
	
*==============================
*PART 0. - SET DEFAULT SETTINGS 
*==============================
//{
* initialize Stata
clear all
set more off

**************************************************
****** Global and locals you need to modify ******
**************************************************
* Here you need to indicate the path where you replicated the folder structure on your own computer
global folder "D:\Dropbox (Personal)\Angola\Dados e analise\5_TEACH\Supervisao"

* Here you need to indicate the name of the country/province you collected the data in
global country "Angola"

* Here you need to indicate the year you collected the data
global year "2022"

**************************************************************
****** From now on, there is no mandatory modifications ******
**************************************************************

* This is the path where you saved the final dataset produced by this do-file
* (no need to change it if you respected the folder structure provided)
* (has to match the name from the do-file 1b. teach_clean.do")
global cleandata "$folder/output"

global TMPDIR 	"$folder/tmp"

* This is the path where you want to save the Excel file produced by this do-file
* (no need to change it if you respected the folder structure provided)
* (has to match the name from the do-file 1b. teach_clean.do")
global output "$folder/output/tables"

* This is the path where you want to save the graphs in png by this do-file
* (no need to change it if you respected the folder structure provided)
global graphs "$folder/output/graphs"

* This is the name you gave to the final Stata dataset
* (no need to change it)
* (has to match the name from the do-file 1b. teach_clean.do")
global cleandtafile "${country}_${year}_teach_clean.dta"
//}

*==========================
*PART 1. - EXPORT TO EXCEL
*==========================
//{
use "$cleandata/$cleandtafile", clear
//{
tab province
//keep if province=="Luanda"

* precisa limpar melhor

gsort school_name_fixid grade_fixid classletter_fixid  -end
by school_name_fixid grade_fixid classletter_fixid , sort: gen n=_n
keep if n==1 // fico com a mais recente, no caso de duplicadas
drop n

isid school_name_fixid grade_fixid classletter_fixid 
count // 153

/*
* Generate a unique classroom identifier
egen class_unique=group(school_id teacher_id  subject grade date)
label variable class_unique "Unique class identifier"
note class_unique: group(school_id teacher_id  subject grade date)

* We keep one observation per classroom
sort class_unique coder_id unique_id
bys class_unique: keep if _n==1

*/

gen class_unique=_n

* Generate a class size variable equal to the sum of the number of boys and number of girls variables
egen class_size=rowtotal(nb_boys nb_girls)
//}

************************************
**** 1.a. Descriptive statistics****
************************************
//{
**** We export descriptive stats to the Excel file "Tables"
putexcel set "$output/Tables", sheet("Analysis") replace

**** We save the numbers we want to export to Excel
** Number of schools
	** Count the number of distinct values of school_id
distinct school_id 
	** Save this number in a local named N_school
local N_school=`r(ndistinct)' 
** Proportion of rural schools
	** Count the number of distinct values of school_id if the school is in rural area
	** [Careful that if there are missing values in the school_loc variable, this computation is misleading]
gen school_loc = locality==1
distinct school_id if school_loc==1
	** Save this number in a local name prop_rural
local prop_rural=`r(ndistinct)'/`N_school'*100
** Number of teachers and proportion of female teachers
	** Summarize the teacher sex
sum teacher_sex

	** Save the number of teachers in a local named N_teacher
local N_teacher=`r(N)' 
	** Save the proportion of female teachers in a local named teacher_sex
local teacher_sex=`r(mean)'*100
** Average class size
	** Summarze the class_size variable
sum class_size
	** Save the average class size in a local named class_size
local class_size=`r(mean)'
** Total number of students
	** Generate a variable counting the total number of students
egen tot_stud=total(class_size)
sum tot_stud
	** Save the total number of students in a local named nb_students
local nb_students=`r(mean)'
** Proportion of girls among students
	** Generate a variable counting the total number of girls
egen tot_girls=total(nb_girls)
	** Generate a variable for the proportion of girls among students
gen prop_girls=tot_girls/tot_stud*100
sum prop_girls
	** Saving the proportion of girls in a local named prop_girls
local prop_girls=`r(mean)'

**** Reshape ****

**** Now we reshape the dataset to have each segment considered as one observation
reshape long segment_time s@_0_1_1  s@_0_1_2 s@_0_2_1 s@_0_2_2 s@_0_3_1 s@_0_3_2 s@_a1_1 s@_a1_2 s@_a1_3 s@_a1_4 s@_a1 ///
s@_a2_1 s@_a2_2 s@_a2_3 s@_a2 s@_b3_1 s@_b3_2 s@_b3_3 s@_b3_4 s@_b3 s@_b4_1 s@_b4_2 s@_b4_3 s@_b4 s@_b5_1 s@_b5_2 s@_b5 s@_b6_1 ///
s@_b6_2 s@_b6_3 s@_b6 s@_c7_1 s@_c7_2 s@_c7_3 s@_c7 s@_c8_1 s@_c8_2 s@_c8_3 s@_c8 s@_c9_1 s@_c9_2 s@_c9_3 s@_c9, i(class_unique) j(segment)

** Number of teach observations
	** Count the number of observations
count
	** Save the number of teach observations in a local named nb_teachobs
local nb_teachobs=`r(N)'

**** We export these numbers to Excel
putexcel A1=("Número de escolas")
putexcel B1=(`N_school')
putexcel A2=("Proporção de escolas rurais")
putexcel B2=(`prop_rural')
putexcel A3=("Número de professores")
putexcel B3=(`N_teacher')
putexcel A4=("Professores do sexo feminino")
putexcel B4=(`teacher_sex')
putexcel A5=("Número de observações do TEACH")
putexcel B5=(`nb_teachobs')
putexcel A6=("Tamanho médio da sala")
putexcel B6=(`class_size')
putexcel A7=("Número de alunos")
putexcel B7=(`nb_students')
putexcel A8=("Proporção de raparigas")
putexcel B8=(`prop_girls')

** Saving and Exporting to Excel the proportion of the sample in each grade
forv i = 4(2)6{
		** Counting the number of observations for each grade
	count if grade==`i' 
		** Diving the number of observations per the number of total observations to get the proportion and exporting it to excel
	putexcel E`i'=(`r(N)'/`nb_teachobs'*100)
	putexcel D`i'= ("Grade `i'")
}
//putexcel D6= ("Multigrade")

** Saving and Exporting to Excel the proportion of the sample in each subject
forval i=1/4{
		** Counting the number of observations for each subject
	count if subject_`i' 
		** Diving the number of observations per the number of total observations to get the proportion and exporting it to excel
	putexcel H`i'=(`r(N)'/`nb_teachobs'*100)
}
count if subject_99
** Diving the number of observations per the number of total observations to get the proportion and exporting it to excel
putexcel H5=(`r(N)'/`nb_teachobs'*100)

putexcel G1=("Matemática")
putexcel G2=("Português") 
putexcel G3=("Ciências Naturais")
putexcel G4=("Ciências Sociais")
putexcel G5=("Outra")

** Exporting the country/province name to Excel
putexcel J1=("Localização")
putexcel K1=("$country")


** Saving and Exporting to Excel the proportion of the sample in each province
gsort province
encode province, gen(cod_prov)

forval i=1/18{
		** Counting the number of observations for each subject
	count if cod_prov==`i'
		local j = `i' + 50
		** Diving the number of observations per the number of total observations to get the proportion and exporting it to excel
	putexcel B`j'=(`r(N)'/`nb_teachobs'*100)
}


**** Generate useful variables***

	** Time on task - First measure (Yes/No on "Teacher provides learning activites to most students")
		** Generate a variable computing the proportion of times each teacher for each segment is providing a learning activity to students
		** We are only taking into account teachers for which we have at least 2 snapshots observed
egen nb_tt1=rownonmiss(s_0_1_1 s_0_2_1 s_0_3_1)
egen timeontask1=rowmean(s_0_1_1 s_0_2_1 s_0_3_1) if nb_tt1>=2

foreach var in  s_0_1_1 s_0_2_1 s_0_3_1{
	gen `var'_yes=(`var'==1)  if `var'!=.
	gen `var'_no=(`var'==0)  if `var'!=.
}
egen tt_yes=rowmean(s_0_1_1_yes s_0_2_1_yes s_0_3_1_yes) if nb_tt1>=2
replace tt_yes=tt_yes*100
egen tt_no=rowmean(s_0_1_1_no s_0_2_1_no s_0_3_1_no) if nb_tt1>=2
replace tt_no=tt_no*100

	** Time on task - Second measure
		** Proportion of classes where a low number of students are on task, a medium number of students are on task
foreach var in  s_0_1_2 s_0_2_2 s_0_3_2{
	gen `var'_low=(`var'==1)
	gen `var'_med=(`var'==3)
	gen `var'_high=(`var'==5)	
}

	** We count the number of snapshots observed (in case the observation lasted less than 15 minutes) and for which the teacher was providing 
	** a learning activity
egen nb_tt2=rownonmiss(s_0_1_2 s_0_2_2 s_0_3_2) 

	** For each of the variables "Low", "Medium" and "High", we create our own mean (in case the observation lasted less than 15 minutes or teacher
	** was not providing a learning activity)
	** We are only taking into account teachers for which we have at least 2 snapshots observed
egen tt_low=rowtotal(s_0_1_2_low s_0_2_2_low s_0_3_2_low) if nb_tt1>=2
replace tt_low=tt_low/nb_tt2*100
egen tt_medium=rowtotal(s_0_1_2_med s_0_2_2_med s_0_3_2_med) if nb_tt1>=2
replace tt_medium=tt_medium/nb_tt2*100
egen tt_high=rowtotal(s_0_1_2_high s_0_2_2_high s_0_3_2_high) if nb_tt1>=2
replace tt_high=tt_high/nb_tt2*100

	** We drop the variables we used for computations
drop nb_tt2 s_0_1_2_low s_0_2_2_low s_0_3_2_low s_0_1_2_med s_0_2_2_med s_0_3_2_med s_0_1_2_high s_0_2_2_high s_0_3_2_high nb_tt1
 
	** Behaviors  - Proportions of low, mediumm, high and N/A
	
		** All the elements have at least two behaviors, so we create the variables for the first two behaviors here
foreach element in s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9{
	forval behav=1/2{
		gen `element'_`behav'_low=(`element'_`behav'==1)*100
		gen `element'_`behav'_med=(`element'_`behav'==3)*100
		gen `element'_`behav'_high=(`element'_`behav'==5)*100
		gen `element'_`behav'_na=(`element'_`behav'==0)*100
	}
}
		** We create the variables for the elements that have a third behavior
foreach element in s_a1 s_a2 s_b3 s_b4 s_b6 s_c7 s_c8 s_c9{
		gen `element'_3_low=(`element'_3==1)*100
		gen `element'_3_med=(`element'_3==3)*100
		gen `element'_3_high=(`element'_3==5)*100
		gen `element'_3_na=(`element'_3==0)*100
	}

		** We create the variables for the elements that have a fourth behavior
foreach element in s_a1 s_b3  {
		gen `element'_4_low=(`element'_4==1)*100
		gen `element'_4_med=(`element'_4==3)*100
		gen `element'_4_high=(`element'_4==5)*100
		gen `element'_4_na=(`element'_4==0)*100
	}
	
	** Elements - Proportions of 1, 2, 3, 4 and 5
foreach element in s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9{
	gen `element'_cat1=(`element'==1)*100
	gen `element'_cat2=(`element'==2)*100
	gen `element'_cat3=(`element'==3)*100
	gen `element'_cat4=(`element'==4)*100
	gen `element'_cat5=(`element'==5)*100
}

	** Areas - Mean of areas
egen classculture = rowmean(s_a1 s_a2 )
egen instruction= rowmean(s_b3  s_b4  s_b5  s_b6)
egen socioemo= rowmean(s_c7 s_c8 s_c9)
egen teachglobal=rowmean(classculture instruction socioemo)

/*
egen classculture_sd = rowsd(s_a1 s_a2 )
egen instruction_sd= rowsd(s_b3  s_b4  s_b5  s_b6)
egen socioemo_sd= rowsd(s_c7 s_c8 s_c9)
egen teachglobal_sd=rowsd(s_a1 s_a2 s_b3  s_b4  s_b5  s_b6 s_c7 s_c8 s_c9)

exit
*/	

	** Areas - Proportion of Low (under 2.5), Medium (between 2.5 and 3.5), Medium High (between 3.5 and 4.5), and High (above 4.5)

foreach var in classculture instruction socioemo teachglobal{
	gen `var'_1=(`var'<2)*100
	gen `var'_2=(`var'>=2 & `var'<3)*100
	gen `var'_3=(`var'>=3 & `var'<4)*100
	gen `var'_4=(`var'>=4)*100
}

//}


********************************************
**** 1.b. Export the Excel: Time on task****
********************************************
//{
	** Here, we indicate that we want to export the results to the Excel file "Tables" in the sheet named "Analysis"
putexcel set "$output/Tables", sheet("Analysis") modify

	** Save the mean propotion of times teachers provide learning activity to most students
sum timeontask
local tt_yes=`r(mean)'*100
local tt_no=(1-`r(mean)')*100
	** Save the mean proportion of times a low number of students are on task
sum tt_low
local tt_low=`r(mean)'
	** Save the mean proportion of times a medium number of students are on task
sum tt_medium 
local tt_medium=`r(mean)'
	** Save the mean proportion of times a high number of students are on task
sum tt_high
local tt_high=`r(mean)'

	** Export these numbers to Excel (file "Tables" in the sheet named "Analysis")
putexcel A11=("A professora promove uma atividade de aprendizagem para a maioria dos alunos")
putexcel B10=("Sim")
putexcel C10=("Não")
putexcel B11=(`tt_yes')
putexcel C11=(`tt_no')
putexcel A13=("Os alunos estão envolvidos na tarefa")
putexcel B12=("Baixa")
putexcel C12=("Média")
putexcel D12=("Alta")
putexcel B13=(`tt_low')
putexcel C13=(`tt_medium')
putexcel D13=(`tt_high')
//}


********************************************
*** Distributions elements and behaviors ***
********************************************
//{
	** Here, we indicate that we want to export the results to the Excel file "Tables" in the sheet named "Analysis"
putexcel set "$output/Tables", sheet("Analysis") modify

local row=16
foreach element in s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9{
	forval behav=1/4{
			** Here we confirm that the variable named `element'_`behav exists (s_a1_1 if this is the first sequence of the loops so that element 
			** is s_a1 and behav is 1). This is because for some elements, there are less behaviors than others
		capture confirm variable `element'_`behav'
			if !_rc {
					** We computer the proportion of times the behavior is equal to low, to medium, to high and the not applicable
				tabstat `element'_`behav'_low `element'_`behav'_med `element'_`behav'_high `element'_`behav'_na, stat(mean) save
					** We export these proportions to Excel to row equal to the value of the local row (starting row 16)
				putexcel B`row'=matrix(r(StatTotal))
				putexcel A`row'=("`element'_`behav'")  
					** We go to the next row 
				local row=`row'+1
				}
	}
}

*exit
*preserve
*keep school_name_fixid grade_fixid classletter_fixid s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9 classculture instruction socioemo teachglobal
*save teachscores.dta
*restore

	** We write to Excel the "Low", "Medium", "High" and "N/A" headers
putexcel B15=("Baixa")
putexcel C15=("Média")
putexcel D15=("Alta")
putexcel E15=("NA")

local row=11
foreach element in s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9{
		** For each element, we export the proportion of times the element is equal to 1, to 2, to 3, to 4 and to 5
	tabstat `element'_cat1 `element'_cat2 `element'_cat3 `element'_cat4 `element'_cat5, stat(mean) save
		** We export these proportions to Excel to row equal to the value of the local row
	putexcel H`row'=matrix(r(StatTotal))
	putexcel G`row'=("`element'") 
	local row=`row'+1
}

	** We write to Excel the "1", "2", "3", "4" and "5" headers
putexcel H10=("1")
putexcel I10=("2")
putexcel J10=("3")
putexcel K10=("4")
putexcel L10=("5")
//}

************************************
*** Distributions areas and elements
************************************

	** Here, we indicate that we want to export the results to the Excel file "Tables" in the sheet named "Analysis"
putexcel set "$output/Tables", sheet("Analysis") modify

recode locality (0=2), gen(school_location)

	** We export to Excel the mean of the area and behaviors for the entire sample
tabstat classculture s_a1   s_a2   instruction s_b3 s_b4 s_b5  s_b6 socioemo s_c7 s_c8  s_c9 ,stat(mean) save  
putexcel H22=matrix(r(StatTotal)')
	** We export to Excel the mean of the area and behaviors if the school is rural (the cap is there so that the do-file does not break/stop if 
	** there is no rural school in the sample)
cap tabstat classculture s_a1   s_a2   instruction s_b3 s_b4 s_b5  s_b6 socioemo s_c7 s_c8  s_c9 if school_location ==1 ,stat(mean) save  
cap putexcel I22=matrix(r(StatTotal)')
	** We export to Excel the mean of the area and behaviors if the school is urban (the cap is there so that the do-file does not break/stop if 
	** there is no urban school in the sample)
cap tabstat classculture s_a1   s_a2   instruction s_b3 s_b4 s_b5  s_b6 socioemo s_c7 s_c8  s_c9 if school_location ==2 ,stat(mean) save  
cap putexcel J22=matrix(r(StatTotal)')
	** We export to Excel the mean of the area and behaviors if the class is  grade 1 (the cap is there so that the do-file does not break/stop if 
	** there is no grade 1 classes in the sample)
cap tabstat classculture s_a1   s_a2   instruction s_b3 s_b4 s_b5  s_b6 socioemo s_c7 s_c8  s_c9 if grade ==1 ,stat(mean) save  
cap putexcel K22=matrix(r(StatTotal)')
	** We export to Excel the mean of the area and behaviors if the class is  grade 2 (the cap is there so that the do-file does not break/stop if 
	** there is no grade 2 classes in the sample)
cap tabstat classculture s_a1   s_a2   instruction s_b3 s_b4 s_b5  s_b6 socioemo s_c7 s_c8  s_c9 if grade ==2 ,stat(mean) save  
cap putexcel L22=matrix(r(StatTotal)')
	** We export to Excel the mean of the area and behaviors if the class is  grade 3 (the cap is there so that the do-file does not break/stop if 
	** there is no grade 3 classes in the sample)
cap tabstat classculture s_a1   s_a2   instruction s_b3 s_b4 s_b5  s_b6 socioemo s_c7 s_c8  s_c9 if grade ==3 ,stat(mean) save  
cap putexcel M22=matrix(r(StatTotal)')
	** We export to Excel the mean of the area and behaviors if the class is  grade 4 (the cap is there so that the do-file does not break/stop if 
	** there is no grade 4 classes in the sample)
cap tabstat classculture s_a1   s_a2   instruction s_b3 s_b4 s_b5  s_b6 socioemo s_c7 s_c8  s_c9 if grade ==4 ,stat(mean) save  
cap putexcel N22=matrix(r(StatTotal)')
	** We export to Excel the mean of the area and behaviors if the class is  grade 5 (the cap is there so that the do-file does not break/stop if 
	** there is no grade 5 classes in the sample)
cap tabstat classculture s_a1   s_a2   instruction s_b3 s_b4 s_b5  s_b6 socioemo s_c7 s_c8  s_c9 if grade ==5 ,stat(mean) save  
cap putexcel O22=matrix(r(StatTotal)')
	** We export to Excel the mean of the area and behaviors if the class is multigrade (the cap is there so that the do-file does not break/stop if 
	** there is no multigrade classes in the sample)
cap tabstat classculture s_a1   s_a2   instruction s_b3 s_b4 s_b5  s_b6 socioemo s_c7 s_c8  s_c9 if grade ==6 ,stat(mean) save  
cap putexcel P22=matrix(r(StatTotal)')
	** We export to Excel the proportion of times each area is Low (under 2.5), medium low (2.5-3.5), medium high (3.5-4.5) and high (4.5-5)
local row=36
foreach area in classculture instruction socioemo teachglobal{
			tabstat `area'_1 `area'_2 `area'_3 `area'_4 , stat(mean) save
			putexcel H`row'=matrix(r(StatTotal))
			local row=`row'+1				
	
}

	** We export the Excel headers
putexcel H21=("Média Total")
putexcel I21=("Média Rural")
putexcel J21=("Média Urbana")
putexcel K21=("Média 1a classe")
putexcel L21=("Média 2a classe")
putexcel M21=("Média 3a classe")
putexcel N21=("Média 4a classe")
putexcel O21=("Média 5a classe")
putexcel P21=("Média 6a classe")

putexcel G22=("CULTURA DA SALA DE AULA") 
putexcel G23=("s_a1") 
putexcel G24=("s_a2") 
putexcel G25=("INSTRUÇÃO") 
putexcel G26=("s_b3") 
putexcel G27=("s_b4") 
putexcel G28=("s_b5") 
putexcel G29=("s_b6") 
putexcel G30=("CAPACIDADES SOCIOEMOCIONAIS") 
putexcel G31=("s_c7") 
putexcel G32=("s_c8") 
putexcel G33=("s_c9") 

putexcel H35=("1-2")
putexcel I35=("2-3")
putexcel J35=("3-4")
putexcel K35=("4-5")

putexcel G36=("classculture")
putexcel G37=("instruction")
putexcel G38=("socioemo")
putexcel G39=("global teach score")

//}

*==========================
*PART 2. - GRAPHS (PNG)
*==========================
//{
*** Figure 3.1. Distribution of Average Area score and overall Teach score
graph bar classculture_1 classculture_2 classculture_3 classculture_4,   graphregion(color(white)) title("Cultura da sala de aula", size(medium) color(black)) ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(midgreen)) ylab(,nogrid)  ///
 b1title("Distribuição dos escores", size(small) color(black)) showyvars yvaroptions(relabel(1 "1-2" 2 "2-3" 3 "3-4" 4 "4-5")) saving("$graphs/graphclassculture.gph", replace)


graph bar instruction_1 instruction_2 instruction_3 instruction_4,   graphregion(color(white)) title("Instrução", size(medium) color(black)) ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(midgreen)) ylab(,nogrid) ///
b1title("Distribuição dos escores", size(small) color(black)) showyvars yvaroptions(relabel(1 "1-2" 2 "2-3" 3 "3-4" 4 "4-5"))  saving("$graphs/graphinstruction.gph", replace)

graph bar socioemo_1 socioemo_2 socioemo_3 socioemo_4,  ylab(,nogrid) graphregion(color(white)) title("Capacidades socioemocionais", size(medium) color(black)) ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(midgreen)) ///
b1title("Distribuição dos escores", size(small) color(black)) showyvars yvaroptions(relabel(1 "1-2" 2 "2-3" 3 "3-4" 4 "4-5")) saving("$graphs/graphsocioemo.gph", replace)

graph bar teachglobal_1 teachglobal_2 teachglobal_3 teachglobal_4,   graphregion(color(white)) title("Score global do TEACH", size(medium) color(black)) ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(midgreen)) ylab(,nogrid) ///
b1title("Distribuição dos escores", size(small) color(black)) showyvars yvaroptions(relabel(1 "1-2" 2 "2-3" 3 "3-4" 4 "4-5")) saving("$graphs/graphteachglobal.gph", replace)

graph combine "$graphs/graphclassculture.gph" "$graphs/graphinstruction.gph" "$graphs/graphsocioemo.gph" "$graphs/graphteachglobal.gph" ,graphregion(color(white))   imargin(0 0 0 0)
graph export "$graphs/Figure3_1.png", replace  

*** Figure 3.2. Distribution of Time on Task
graph bar  tt_no tt_yes , blabel(bar,format(%9.0f)  position(outside)  )   bar(1, col(red)) bar(2, col(orange))  ///
   graphregion(color(white))   ylabel(0(25)100) ylab(,nogrid) title("0.1. A professora promove uma atividade de aprendizagem para a maioria dos alunos", size(medium) color(black)) ///
legend(label(1 "Não") label(2 "Sim"))  legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) ///
saving("$graphs/tt1.gph", replace)

graph bar tt_low tt_medium tt_high, blabel(bar,format(%9.0f)  position(outside)  )   bar(1, col(orange)) bar(2, col(yellow))  bar(3 , col(midgreen)) ///
   graphregion(color(white))   ylabel(0(25)100) ylab(,nogrid) title("0.2.  Os alunos estão envolvidos na tarefa", size(medium) color(black)) ///
legend(label(1 "L: 6 ou mais alunos estão fora da tarefa") label(2 "M: 2 a 5 alunos estão fora da tarefa") label( 3 "H: 0 ou 1 aluno está fora da tarefa")) ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none)))  saving("$graphs/tt2.gph", replace)

graph combine "$graphs/tt1.gph" "$graphs/tt2.gph",graphregion(color(white))  col(1)  imargin(0 0 0 0)
graph export "$graphs/Figure3_2.png", replace  


*** Figure 3.3. Distribution of Average Teach Score by Element
graph hbar s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9 , ///
blabel(bar,format(%9.1f)  position(outside)  ) bargap(50) yla(1(1)5) exclude0 bar(1, col(lime*0.6)) bar(2, col(lime*0.6)) bar(3,col(cranberry*0.8)) ///
bar(4, color(cranberry*0.8)) bar(5, color(cranberry*0.8)) bar(6, color(cranberry*0.8)) bar(7, color(orange*0.7)) bar(8, color(orange*0.7))  ///
bar(9, color(orange*0.8)) showyvars yvar(relabel(1 "1.Ambiente de apoio à aprendizagem" 2 "2.Expetativas Comportamentais Positivas" 3 "3.Clarificação da Lição" ///
4 "4.Verificação da compreensão" 5 "5.Comentários construtivos" 6 "6.Raciocínio crítico " 7 "7.Autonomia" 8 "8.Perseverança" 9 "9.Capacidades sociais e colaborativas") ///
label(labsize(small))) graphregion(color(white)) legend(off)  
graph export "$graphs/Figure3_3.png", replace
window manage close graph

*** Figure 3.4. Supportive Learning Environment

	** Upper panel
graph bar s_a1_1_low s_a1_1_med s_a1_1_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph1", replace) graphregion(color(white)) ///
legend(label(1 "B: Não trata todos de forma respeitosa") label(2 "M: Trata a todos com um pouco de respeito") label( 3 "A: Trata todos respeitosamente ")) ///
bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen)) ylabel(0(25)100) ylab(,nogrid) title("1.1. Trata todos com respeito", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_a1_2_low s_a1_2_med s_a1_2_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph2", replace) graphregion(color(white)) ///
legend(label(1 "B: Não usa linguagem positiva") label(2 "M: Usa um pouco de linguagem positiva") label( 3 "H: Consistentemente usa linguagem positiva")) ///
bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))  ylabel(0(25)100) ylab(,nogrid) title("1.2. Usa uma linguagem positiva com os alunos", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_a1_3_low s_a1_3_med s_a1_3_high s_a1_3_na,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph3", replace) graphregion(color(white)) ///
legend(label(1 "B: Não percebe ou não responde às necessidades") label(2 "M: Responde mas não resolve o problema") label( 3 "A: Responde e resolve o problema") ///
label( 4 "N/A")) bar(1, col(red)) bar(2, col(yellow))  bar(3,col(midgreen))  bar(4,col(gs9))  ylabel(0(25)100) ylab(,nogrid)   ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) title("1.3. Corresponde às necessidades dos alunos", size(medium) color(black))
 
graph bar s_a1_4_low s_a1_4_med s_a1_4_high s_a1_4_na,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph4", replace) graphregion(color(white)) ///
legend(label(1 "B: Exibe viés e reforça os estereótipos") label(2 "M: Não exibe viés, mas não questiona os estereótipos") label( 3 "A: Não apresenta preconceitos de género e rejeita estereótipos") label( 4 "N/A"))   ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen)) bar(4 , col(gs9)) ylabel(0(25)100)  ylab(,nogrid) ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) title("1.4. Viés de gênero e estereótipos", size(medium) color(black)) 

graph combine  "$graphs/graph1.gph" "$graphs/graph2.gph" "$graphs/graph3.gph" "$graphs/graph4.gph", col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_4a.png", replace 


	** Lower panel
forval i=1/5{
	label var s_a1_cat`i' "`i'"
}

graph bar s_a1_cat1 s_a1_cat2 s_a1_cat3 s_a1_cat4 s_a1_cat5,  ylab(,nogrid) graphregion(color(white)) ytitle("% Proporção das professoras") ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(lime*0.6)) ///
bar(5, color(dkgreen*0.8)) b1title(Distribuição dos escores) showyvars yvaroptions(relabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5")) saving("$graphs/Figure3_4b.gph", replace)
graph export "$graphs/Figure3_4b.png", replace 

graph combine "$graphs/graph1.gph" "$graphs/graph2.gph" "$graphs/graph3.gph" "$graphs/graph4.gph" "$graphs/Figure3_4b.gph", col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_4.png", replace




*** Figure 3.5. Positive Behavioral Expectations

	** Upper panel
graph bar s_a2_1_low s_a2_1_med s_a2_1_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph1", replace) graphregion(color(white)) ///
legend(label(1 "L: Não define claramente as expetativas comportamentais") label(2 "M: Define as expetativas comportamentais de forma imprecisa") label( 3 "H: Define de uma forma clara as expetativas ")) ///
bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen)) ylabel(0(25)100) ylab(,nogrid) title("2.1. Expectativas de comportamento claras", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_a2_2_low s_a2_2_med s_a2_2_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph2", replace) graphregion(color(white)) ///
legend(label(1 "L: Não reconhece o comportamento do aluno ") label(2 "M: Reconhece o comportamento de alguns alunos") label( 3 "H: Reconhece o comportamento positivo dos alunos")) ///
bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))  ylabel(0(25)100) ylab(,nogrid) title("2.2.  Reconhece o comportamento positivo ", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_a2_3_low s_a2_3_med s_a2_3_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph3", replace) graphregion(color(white)) ///
legend(label(1 "L: Redirecionamento do mau comportamento é ineficaz ") label(2 "M: Redirecionamento é eficaz, mas não se concentra no comportamento esperado") label( 3 "H: Redirecionamento é eficaz") ///
label( 4 "N/A")) bar(1, col(red)) bar(2, col(yellow))  bar(3,col(midgreen))  bar(4,col(gs9))  ylabel(0(25)100) ylab(,nogrid)   ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) title("2.3.  Redireciona o mau comportamento", size(medium) color(black))

graph combine  "$graphs/graph1.gph"  "$graphs/graph2" "$graphs/graph3" , col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_5a.png", replace
window manage close graph

	** Lower panel
forval i=1/5{
	label var s_a2_cat`i' "`i'"
}

graph bar s_a2_cat1 s_a2_cat2 s_a2_cat3 s_a2_cat4 s_a2_cat5,  ylab(,nogrid) graphregion(color(white)) ytitle("% Proporção das professoras") ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(lime*0.6)) ///
bar(5, color(dkgreen*0.8)) b1title(Distribuição dos escores) showyvars yvaroptions(relabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5")) saving("$graphs/Figure3_5b.gph", replace)
graph export "$graphs/Figure3_5b.png", replace
window manage close graph

graph combine "$graphs/graph1.gph" "$graphs/graph2.gph" "$graphs/graph3.gph"  "$graphs/Figure3_5b.gph", col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_5.png", replace




*** Figure 3.7.Lesson facilitation

	** Upper panel
graph bar s_b3_1_low s_b3_1_med s_b3_1_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph1", replace) graphregion(color(white)) ///
legend(label(1 "L: Não refere o(s) objetivo(s) da aula") label(2 "M: Refere a objetivos gerais ou não é clarpo") label( 3 "H: Refere explicitamente o objetivo da aula ")) ///
bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen)) ylabel(0(25)100) ylab(,nogrid) title("3.1. Articula explicitamente os objetivos da aula", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_b3_2_low s_b3_2_med s_b3_2_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph2", replace) graphregion(color(white)) ///
legend(label(1 "L: Confuso ou sem explicação") label(2 "M: As explicações são mais ou menos claras") label( 3 "H: Explicações são claras e fáceis de entender")) ///
bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))  ylabel(0(25)100) ylab(,nogrid) title("3.2. A explicação sobre o conteúdo é clara", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none)))

graph bar s_b3_3_low s_b3_3_med s_b3_3_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph3", replace) graphregion(color(white)) ///
legend(label(1 "L: Não relaciona com outro conteúdo ") label(2 "M: Conexões são superficiais, confusas ou pouco claras") label( 3 "H: Relaciona significativamente com outros conteúdos")) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3,col(midgreen))  bar(4,col(gs9))  ylabel(0(25)100) ylab(,nogrid)   ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) ///
title("3.3. Estabelece conexões com outros conteúdos", size(medium) color(black))

graph bar s_b3_4_low s_b3_4_med s_b3_4_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph4", replace) graphregion(color(white)) ///
legend(label(1 "L: Não exemplifica a atividade ") label(2 "M: Exemplifica parcialmente ") label( 3 "H: Exemplifica completamente")) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3,col(midgreen))  bar(4,col(gs9))  ylabel(0(25)100) ylab(,nogrid)   ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) title("3.4. Exemplifica demonstrando ou pensando em voz alta", size(medium) color(black))


graph combine  "$graphs/graph1.gph"  "$graphs/graph2" "$graphs/graph3" "$graphs/graph4.gph", col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_7a.png", replace
window manage close graph


	** Lower panel
forval i=1/5{
	label var s_b3_cat`i' "`i'"
}

graph bar s_b3_cat1 s_b3_cat2 s_b3_cat3 s_b3_cat4 s_b3_cat5,  ylab(,nogrid) graphregion(color(white)) ytitle("% Proporção das professoras") ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(lime*0.6)) ///
bar(5, color(dkgreen*0.8)) b1title(Distribuição dos escores) showyvars yvaroptions(relabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5")) saving("$graphs/Figure3_7b.gph", replace)
graph export "$graphs/Figure3_7b.png", replace
window manage close graph

graph combine "$graphs/graph1.gph" "$graphs/graph2.gph" "$graphs/graph3.gph" "$graphs/graph4.gph" "$graphs/Figure3_7b.gph", col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_7.png", replace





*** Figure 3.8.Checks for understanding

	** Upper panel
graph bar s_b4_1_low s_b4_1_med s_b4_1_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph1", replace) graphregion(color(white)) ///
legend(label(1 "L: Não faz perguntas nem motiva os alunos ") label(2 "M: Pergunta apenas a alguns alunos.") label( 3 "H: Pergunta a quase todos os slunos")) ///
bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen)) ylabel(0(25)100) ylab(,nogrid) title("4.1. Faz perguntas ou dá pistas", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_b4_2_low s_b4_2_med s_b4_2_high s_b4_2_na,   blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph2", replace) graphregion(color(white)) ///
legend(label(1 "L: Não monitora os alunos") label(2 "M: monitora alguns alunos") label( 3 "H: Sistematicamente monitora a maioria dos alunos") label( 4 "N/A")) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))  bar(4,col(gs9))  ylabel(0(25)100) ylab(,nogrid) title("4.2. Monitoriza a maioria dos alunos durante o trabalho", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_b4_3_low s_b4_3_med s_b4_3_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph3", replace) graphregion(color(white)) ///
legend(label(1 "L: Não ajusta o ensino aos alunos") label(2 "M: Faz ajustes breves e superficiais. ") label( 3 "H: Ajusta substancialmente")) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3,col(midgreen))   ylabel(0(25)100) ylab(,nogrid)   ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) title("4.3. Ajusta o ensino ao nível dos alunos", size(medium) color(black))


graph combine  "$graphs/graph1.gph"  "$graphs/graph2" "$graphs/graph3" , col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_8a.png", replace

	** Lower panel
forval i=1/5{
	label var s_b4_cat`i' "`i'"
}

graph bar s_b4_cat1 s_b4_cat2 s_b4_cat3 s_b4_cat4 s_b4_cat5,  ylab(,nogrid) graphregion(color(white)) ytitle("% Proporção das professoras") ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(lime*0.6)) ///
bar(5, color(dkgreen*0.8)) b1title(Distribuição dos escores) showyvars yvaroptions(relabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5")) saving("$graphs/Figure3_8b.gph", replace)
graph export "$graphs/Figure3_8b.png", replace


graph combine "$graphs/graph1.gph" "$graphs/graph2.gph" "$graphs/graph3.gph"  "$graphs/Figure3_8b.gph", col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_8.png", replace



*** Figure 3.9.Feedback

	** Upper panel
graph bar s_b5_1_low s_b5_1_med s_b5_1_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph1", replace) graphregion(color(white)) ///
legend(label(1 "L: Não faz comentários nem dá pistas ") label(2 "M: Faz comentários gerais ou superficiais") ///
label( 3 "H: Faz comentários específicos ou dá pistas ")) bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen)) ylabel(0(25)100) ///
ylab(,nogrid) title("5.1. Faz comentários ou dá pistas para esclarecer", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_b5_2_low s_b5_2_med s_b5_2_high,   blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph2", replace) graphregion(color(white)) ///
legend(label(1 "L: Não faz comentários nem dá pistas") label(2 "M: Faz comentários gerais ou superficiais") ///
label( 3 "H: Faz comentários ou dá pistas para esclarecer")) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))   ylabel(0(25)100) ylab(,nogrid) ///
 title("5.2. Ajuda os alunos a identificarem seus sucessos", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph combine  "$graphs/graph1.gph"  "$graphs/graph2.gph", col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_9a.png", replace

	** Lower panel
forval i=1/5{
	label var s_b5_cat`i' "`i'"
}

graph bar s_b5_cat1 s_b5_cat2 s_b5_cat3 s_b5_cat4 s_b5_cat5,  ylab(,nogrid) graphregion(color(white)) ytitle("% Proporção das professoras") ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(lime*0.6)) ///
bar(5, color(dkgreen*0.8)) b1title(Distribuição dos escores) showyvars yvaroptions(relabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5")) saving("$graphs/Figure3_9b.gph", replace)
graph export "$graphs/Figure3_9b.png", replace

graph combine "$graphs/graph1.gph" "$graphs/graph2.gph" "$graphs/Figure3_9b.gph", col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_9.png", replace


*** Figure 3.9.Critical thinking

	** Upper panel
graph bar s_b6_1_low s_b6_1_med s_b6_1_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph1", replace) graphregion(color(white)) ///
legend(label(1 "L: Não faz perguntas de resposta aberta") label(2 "M: Faz pelo menos 2 perguntas de resposta aberta aos alunos") ///
label( 3 "H: Faz 3 ou mais perguntas de resposta aberta aos alunos")) bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen)) ylabel(0(25)100) ///
ylab(,nogrid) title("6.1. Faz perguntas de resposta aberta", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_b6_2_low s_b6_2_med s_b6_2_high,   blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph2", replace) graphregion(color(white)) ///
legend(label(1 "L: Não propõe atividades de raciocínio") label(2 "M: Propõe atividades superficiais") ///
label( 3 "H: Propõe atividades intensas de raciocínio") ) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))   ylabel(0(25)100) ylab(,nogrid) ///
 title("6.2. Propõe atividades de raciocínio", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_b6_3_low s_b6_3_med s_b6_3_high,   blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph3", replace) graphregion(color(white)) ///
legend(label(1 "L: Os alunos não fazem perguntas de resposta aberta ") label(2 "M: Alunos desenvolvem atividades superficiais de raciocínio") ///
label( 3 "H: Os alunos fazem perguntas de resposta aberta.") ) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))   ylabel(0(25)100) ylab(,nogrid) ///
 title("6.3. Os alunos fazem perguntas de resposta aberta e/ou desenvolvem atividades de raciocínio", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph combine  "$graphs/graph1.gph"  "$graphs/graph2" "$graphs/graph3" , col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_10a.png", replace

	** Lower panel
forval i=1/5{
	label var s_b6_cat`i' "`i'"
}

graph bar s_b6_cat1 s_b6_cat2 s_b6_cat3 s_b6_cat4 s_b6_cat5,  ylab(,nogrid) graphregion(color(white)) ytitle("% Proporção das professoras") ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(lime*0.6)) ///
bar(5, color(dkgreen*0.8)) b1title(Distribuição dos escores) showyvars yvaroptions(relabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5")) saving("$graphs/Figure3_10b.gph", replace)
graph export "$graphs/Figure3_10b.png", replace

graph combine "$graphs/graph1.gph" "$graphs/graph2.gph" "$graphs/graph3.gph" "$graphs/Figure3_10b.gph", col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_10.png", replace



*** Figure 3.12.Autonomy

	** Upper panel
graph bar s_c7_1_low s_c7_1_med s_c7_1_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph1", replace) graphregion(color(white)) ///
legend(label(1 "L: Não proporciona oportunidades de escolhas aos alunos") label(2 "M: Proporciona aos alunos pelo menos 1 escolha superficial") ///
label( 3 "H: Proporciona pelo menos 1 escolha significativa")) bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen)) ylabel(0(25)100) ///
ylab(,nogrid) title("7.1. Proporciona escolhas aos alunos", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_c7_2_low s_c7_2_med s_c7_2_high,   blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph2", replace) graphregion(color(white)) ///
legend(label(1 "L: Não proporciona oportunidades") label(2 "M: Proporciona oportunidades para assumirem algumas funções ") ///
label( 3 "H: Proporciona oportunidades para assumirem funções significativos ") ) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))   ylabel(0(25)100) ylab(,nogrid) ///
 title("7.2. Oferece oportunidades aos alunos para assumirem papéis na sala de aula", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_c7_3_low s_c7_3_med s_c7_3_high,   blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph3", replace) graphregion(color(white)) ///
legend(label(1 "L: Os alunos não se voluntariam para participar ") label(2 "M: Apenas alguns alunos se voluntariam para participar") ///
label( 3 "H: A maioria dos alunos voluntaria-se para participar") ) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))   ylabel(0(25)100) ylab(,nogrid) ///
 title("7.3.  Os alunos voluntariam-se para participar na aula", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph combine  "$graphs/graph1.gph"  "$graphs/graph2" "$graphs/graph3" , col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_12a.png", replace


	** Lower panel
forval i=1/5{
	label var s_c7_cat`i' "`i'"
}

graph bar s_c7_cat1 s_c7_cat2 s_c7_cat3 s_c7_cat4 s_c7_cat5,  ylab(,nogrid) graphregion(color(white)) ytitle("% Proporção das professoras") ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(lime*0.6)) ///
bar(5, color(dkgreen*0.8)) b1title(Distribuição dos escores) showyvars yvaroptions(relabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5")) saving("$graphs/Figure3_12b.gph", replace)
graph export "$graphs/Figure3_12b.png", replace


graph combine "$graphs/graph1.gph" "$graphs/graph2.gph" "$graphs/graph3.gph" "$graphs/Figure3_12b.gph", col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_12.png", replace

*** Figure 3.13.Perseverance

	** Upper panel
graph bar s_c8_1_low s_c8_1_med s_c8_1_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph1", replace) graphregion(color(white)) ///
legend(label(1 "L: Não reconhece os esforços dos alunos") label(2 "M: A maioria dos elogios está centrada nos resultados") ///
label( 3 "H: Reconhece frequentemente o esforço dos alunos")) bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen)) ylabel(0(25)100) ///
ylab(,nogrid) title("8.1. Reconhece o esforço dos alunos", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_c8_2_low s_c8_2_med s_c8_2_high,   blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph2", replace) graphregion(color(white)) ///
legend(label(1 "L: Tem uma atitude negativa") label(2 "M: Tem uma atitude neutra") label( 3 "H: Tem uma atitude positiva") ) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))   ylabel(0(25)100) ylab(,nogrid) ///
 title("8.2. Tem uma atitude positiva em relação aos desafios dos alunos", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_c8_3_low s_c8_3_med s_c8_3_high,   blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph3", replace) graphregion(color(white)) ///
legend(label(1 "L: Não incentiva os alunos a definirem metas de aprendizagem") label(2 "M: Incentiva os alunos a definirem objetivos") ///
label( 3 "H: Incentiva os alunos a estabelecerem objetivos de curto E longo prazo") ) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))   ylabel(0(25)100) ylab(,nogrid) ///
 title("8.3. Incentiva a definição de objetivos", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 


	** Lower panel
forval i=1/5{
	label var s_c8_cat`i' "`i'"
}

graph bar s_c8_cat1 s_c8_cat2 s_c8_cat3 s_c8_cat4 s_c8_cat5,  ylab(,nogrid) graphregion(color(white)) ytitle("% Proporção das professoras") ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(lime*0.6)) ///
bar(5, color(dkgreen*0.8)) b1title(Distribuição dos escores) showyvars yvaroptions(relabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5")) saving("$graphs/Figure3_13b.gph", replace)
graph export "$graphs/Figure3_13b.png", replace

graph combine "$graphs/graph1.gph" "$graphs/graph2.gph" "$graphs/graph3.gph" "$graphs/Figure3_13b.gph", col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_13.png", replace




*** Figure 3.13.Social and collaborative skills

	** Upper panel
graph bar s_c9_1_low s_c9_1_med s_c9_1_high,  blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph1", replace) graphregion(color(white)) ///
legend(label(1 "L: Não estimula a colaboração entre os alunos") label(2 "M: Estimula uma colaboração superficial entre os alunos") ///
label( 3 "H: Estimula a colaboração intensa ")) bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen)) ylabel(0(25)100) ///
ylab(,nogrid) title("9.1. Promove a colaboração entre alunos", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_c9_2_low s_c9_2_med s_c9_2_high,   blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph2", replace) graphregion(color(white)) ///
legend(label(1 "L: Não estimula as habilidades interpessoais") label(2 "M: Estimula de forma breve ou superficial") ///
label( 3 "H: Estimula as habilidades interpessoais dos aluno") ) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))   ylabel(0(25)100) ylab(,nogrid) ///
 title("9.2. Promove as capacidades interpessoais dos alunos", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph bar s_c9_3_low s_c9_3_med s_c9_3_high,   blabel(bar, position(outside) format(%9.0f)) saving("$graphs/graph3", replace) graphregion(color(white)) ///
legend(label(1 "L: Os alunos não colaboram") label(2 "M: Colaboram superficialmente") label( 3 "H: Colaboram uns com os outros")) ///
 bar(1, col(red)) bar(2, col(yellow))  bar(3 , col(midgreen))   ylabel(0(25)100) ylab(,nogrid) ///
 title("9.3. Colaboram uns com os outros através da interação entre eles", size(medium) color(black))  ///
legend(on   size(small)   region(lwidth(none)) cols(1) region(lcolor(white)) region(style(none))) 

graph combine  "$graphs/graph1.gph"  "$graphs/graph2" "$graphs/graph3" , col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_14a.png", replace


	** Lower panel
forval i=1/5{
	label var s_c9_cat`i' "`i'"
}

graph bar s_c9_cat1 s_c9_cat2 s_c9_cat3 s_c9_cat4 s_c9_cat5,  ylab(,nogrid) graphregion(color(white)) ytitle("% Proporção das professoras") ///
ylabel(0(25)100) blabel(bar,format(%9.0f)) legend(off) bar(1, col(red)) bar(2, col(orange*0.7))  bar(3 , col(yellow)) bar(4, color(lime*0.6)) ///
bar(5, color(dkgreen*0.8)) b1title(Distribuição dos escores) showyvars yvaroptions(relabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5")) saving("$graphs/Figure3_14b.gph", replace)
graph export "$graphs/Figure3_14b.png", replace
window manage close graph

graph combine "$graphs/graph1.gph" "$graphs/graph2.gph" "$graphs/graph3.gph" "$graphs/Figure3_14b.gph", col(2) graphregion(color(white))   imargin(0 0 0 0) ycommon
graph export "$graphs/Figure3_14.png", replace


cap erase graph1.gph
cap erase graph2.gph
cap erase "$graphs/graph3" 
cap erase graph4.gph

save "$TMPDIR/tmp.dta", replace
//}

*** Figure 3.6, 3.11, 3.15 - Panel 1
* Mexe na base
//{
use  "$TMPDIR/tmp.dta", replace


// We need to reproduce this table. Please oh god always use mean and collapse so we don't 
//  lose important statistical indicators such as the standard deviation or the mean
mean s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9
mean s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9, over(school_loc)


 
// Ok. I followed the tortured structure of the data, but follow the example of schools instead. Use a simple 'collapse' and 'graph bar'

gen isrural = school_loc==1

foreach var in s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9{
		gen `var'_rural=`var' if isrural
		gen `var'_urban=`var' if !isrural
	}


collapse (mean) s_a1_rural s_a2_rural s_b3_rural s_b4_rural s_b5_rural s_b6_rural s_c7_rural s_c8_rural s_c9_rural ///
	s_a1_urban s_a2_urban s_b3_urban s_b4_urban s_b5_urban s_b6_urban s_c7_urban s_c8_urban s_c9_urban ///
(semean) s_a1_rural_sem=s_a1_rural s_a2_rural_sem=s_a2_rural s_b3_rural_sem=s_b3_rural ///
	s_b4_rural_sem=s_b4_rural s_b5_rural_sem=s_b5_rural s_b6_rural_sem=s_b6_rural ///
	s_c7_rural_sem=s_c7_rural s_c8_rural_sem=s_c8_rural s_c9_rural_sem=s_c9 ///
	s_a1_urban_sem=s_a1_urban s_a2_urban_sem=s_a2_urban s_b3_urban_sem=s_b3_urban ///
	s_b4_urban_sem=s_b4_urban s_b5_urban_sem=s_b5_urban s_b6_urban_sem=s_b6_urban ///
	s_c7_urban_sem=s_c7_urban s_c8_urban_sem=s_c8_urban s_c9_urban_sem=s_c9

rename s_a1_rural-s_c9_urban =_mean
gen id=1

reshape long ///
	s_a1_rural_ s_a2_rural_ s_b3_rural_ s_b4_rural_ s_b5_rural_ s_b6_rural_ s_c7_rural_ s_c8_rural_ s_c9_rural_ ///
	s_a1_urban_ s_a2_urban_ s_b3_urban_ s_b4_urban_ s_b5_urban_ s_b6_urban_ s_c7_urban_ s_c8_urban_ s_c9_urban_ ///
, i(id) j(stat) string

sxpose, clear force // dude!
drop if _n==1 | _n ==2
rename _var1 construct
rename _var2 semean

destring *, replace


gen id = _n
replace id = (id-9) + 0.5 if id > 9
sort id
drop id

gen semean_min = construct - 1.96*semean
gen semean_max = construct + 1.96*semean


*** Figure 3.6, 3.11, 3.15 - Panel 1
/*
//preserve
	foreach var in s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9{
		sum `var' if school_loc==1
		gen `var'_rural=`r(mean)'
		sum `var' if school_loc!=1
		gen `var'_urban=`r(mean)'	
	}
	tabstat s_a1_rural s_a1_urban s_a2_rural s_a2_urban s_b3_rural s_b3_urban s_b4_rural s_b4_urban s_b5_rural s_b5_urban ///
	s_b6_rural s_b6_urban s_c7_rural s_c7_urban s_c8_rural s_c8_urban s_c9_rural s_c9_urban, stat(mean) save
	mat fig13=matrix(r(StatTotal)')

	drop _all
	svmat2 fig13, names(construct) full
*/	

gen name=    "1. Ambiente de apoio à aprendizagem" 		if _n==1 |_n==2
replace name="2. Expetativas Comportamentais Positivas"	if _n==3 |_n==4
replace name="3. Clarificação da Lição"					if _n==5 |_n==6
replace name="4. Verificação da Compreensão " 			if _n==7 |_n==8
replace name="5. Comentários Construtivos"				if _n==9 |_n==10
replace name="6. Raciocínio Crítico" 					if _n==11|_n==12
replace name="7. Autonomia" 							if _n==13|_n==14
replace name="8. Perseverança" 							if _n==15|_n==16
replace name="9. Capacidades sociais e colaborativas" 	if _n==17|_n==18

gen order=_n
gen school_loc=""
foreach n in 1 3 5 7 9 11 13 15 17 {
	replace school_loc="Rural" if _n==`n'
}
foreach n in 2 4 6 8 10 12 14 16 18 {
	replace school_loc="Urban" if _n==`n'
}
gen reverse=1 if school_loc=="Urban"
replace reverse=2 if school_loc=="Rural"

encode school_loc, gen(isrural)

save "$TMPDIR/tmp2.dta", replace
//}

* Figura
//{
preserve

keep if order < 5
encode name, gen(category)

replace isrural = 0 if isrural == 2
replace isrural = isrural + 1


gen categoryrural = isrural if category==1
replace categoryrural = isrural + 3 if category==2

sort categoryrural
list categoryrural category isrural, sepby(category)
sort reverse

gen var= semean_max+0.1
gen var2= round(construct,0.1)

twoway (bar construct categoryrural if isrural==1, col(purple)) ///
	(bar construct categoryrural if isrural==2, col(midgreen*0.7)) ///
	(rcap semean_max semean_min categoryrural, col(red)) ///
	(scatter var categoryrural, ///
		msymbol(none) mlabel(var2) mlabpos(12) mlabcolor(black) mlabsize(small)) ///
	, yscale(range(1 5)) ylabel(1(1)5) graphregion(color(white)) xscale(range(0 6)) ytitle("") xtitle("") ///
	plotregion(margin(zero)) ///
	legend(label(1 "Urbano") label(2 "Rural") order(1 2) size(small) region(lwidth(none))region(lcolor(white)) region(style(none))) ///
	xlabel(1.5 "Ambiente de apoio à aprendizagem" 4.5 "Expetativas Comportamentais Positivas", noticks labsize(small))
graph export "$graphs/Figure3_6_panel1.png", replace

/*
graph bar construct if order<5, over(school_loc, sort(reverse)) over(name, sort(order) label(labsize(small)))  blabel(bar,format(%9.1f)  position(outside)) exclude0 ///
graphregion(color(white)) yla(1(1)5)  bargap(0) asyvars bar(1, col(midgreen*0.7))  bar(2, col(purple))  ytitle("") ///
legend(label(2 "Urban") label(1 "Rural") order(2 1) size(small) region(lwidth(none)) region(lcolor(white)) region(style(none)))
graph export "$graphs/Figure3_6_panel1.png", replace
*/

restore
//}
	
* Figura
//{
preserve
keep if order >= 5 & order <13
encode name, gen(category)

replace isrural = 0 if isrural == 2
replace isrural = isrural + 1


gen categoryrural = isrural if category==1
replace categoryrural = isrural + 3 if category==2
replace categoryrural = isrural + 6 if category==3
replace categoryrural = isrural + 9 if category==4

sort categoryrural
list categoryrural category isrural, sepby(category)
sort reverse

gen var= semean_max+0.1
gen var2= round(construct,0.1)

twoway (bar construct categoryrural if isrural==1, col(purple)) ///
	(bar construct categoryrural if isrural==2, col(midgreen*0.7)) ///
	(rcap semean_max semean_min categoryrural, col(red)) ///
	(scatter var categoryrural, ///
		msymbol(none) mlabel(var2) mlabpos(12) mlabcolor(black) mlabsize(small)) ///
	, yscale(range(1 5)) ylabel(1(1)5) graphregion(color(white)) xscale(range(0 12)) ytitle("") xtitle("") ///
	plotregion(margin(zero)) ///
	legend(label(1 "Urbana") label(2 "Rural") order(1 2) size(small) region(lwidth(none))region(lcolor(white)) region(style(none))) ///
	xlabel(1.4 "Clarificação da Lição" 4.5 "Verificação da Compreensão" 7.45 "Comentários Construtivos" 10.45 "Raciocínio Crítico", noticks labsize(small))
	
	
graph export "$graphs/Figure3_11_panel1.png", replace


/*
graph bar construct if order>=5 & order<13, over(school_loc, sort(reverse)) over(name, sort(order) label(labsize(small)))  blabel(bar,format(%9.1f)  position(outside)) exclude0 ///
graphregion(color(white)) yla(1(1)5)  bargap(0) asyvars bar(1, col(midgreen*0.7))  bar(2, col(purple)) ytitle("") ///
legend( label(2 "Urban") label(1 "Rural") order(2 1) size(small) region(lwidth(none)) region(lcolor(white)) region(style(none)))
graph export "$graphs/Figure3_11_panel1.png", replace
*/
restore
//}	

* Figura
//{	
preserve
keep if order >= 13
encode name, gen(category)

replace isrural = 0 if isrural == 2
replace isrural = isrural + 1


gen categoryrural = isrural if category==1
replace categoryrural = isrural + 3 if category==2
replace categoryrural = isrural + 6 if category==3


sort categoryrural
list categoryrural category isrural, sepby(category)
sort reverse

gen var= semean_max+0.1
gen var2= round(construct,0.1)

twoway (bar construct categoryrural if isrural==1, col(purple)) ///
	(bar construct categoryrural if isrural==2, col(midgreen*0.7)) ///
	(rcap semean_max semean_min categoryrural, col(red)) ///
	(scatter var categoryrural, ///
		msymbol(none) mlabel(var2) mlabpos(12) mlabcolor(black) mlabsize(small)) ///
	, yscale(range(1 5)) ylabel(1(1)5) graphregion(color(white)) xscale(range(0 9)) ytitle("") xtitle("") ///
	plotregion(margin(zero)) ///
	legend(label(1 "Urban") label(2 "Rural") order(1 2) size(small) region(lwidth(none))region(lcolor(white)) region(style(none))) ///
	xlabel(1.5 "Autonomia" 4.5 "Perseverança" 7.45 "Capacidades sociais e colaborativas", noticks labsize(small))

	
/*
graph bar construct if order>=13, over(school_loc, sort(reverse)) over(name, sort(order) label(labsize(small)))  blabel(bar,format(%9.1f)  position(outside)) exclude0 ///
graphregion(color(white)) yla(1(1)5)  bargap(0) asyvars bar(1, col(midgreen*0.7))  bar(2, col(purple)) ytitle("") ///
legend( label(2 "Urban") label(1 "Rural") order(2 1) size(small) region(lwidth(none)) region(lcolor(white)) region(style(none)))
*/
	
	

graph export "$graphs/Figure3_15_panel1.png", replace	
window manage close graph

restore
//}

* Figura
//{
use "$TMPDIR/tmp.dta", replace
preserve
// This is actually the proper way. Clean the Urban Rural when you have time :-)
// These are the means and their semean

forvalues i = 1 / 6 {
	qui count if grade==`i'
	if `r(N)' == 0 {
		local tocreate = _N+1
		set obs `tocreate'
		qui replace grade=`i' if grade==.
	}
}


mean s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9, over(grade)

//make a first collapse
collapse (mean) s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9 ///
	(semean) s_a1_sem=s_a1 s_a2_sem=s_a2 s_b3_sem=s_b3 ///
		s_b4_sem=s_b4 s_b5_sem=s_b5 s_b6_sem=s_b6 ///
		s_c7_sem=s_c7 s_c8_sem=s_c8 s_c9_sem=s_c9 ///
	, by(grade)
	
// Some cleanup	
drop if grade==.


// Then reshape into one line per indicator
rename s_a1-s_c9 =_mean	
reshape long @mean @sem, i(grade) j(name) string


// Clean up the names
replace name="1. Ambiente de apoio à aprendizagem" 		if name=="s_a1"
replace name="2. Expetativas Comportamentais Positivas"	if name=="s_a2"
replace name="3. Clarificação da Lição"					if name=="s_b3"
replace name="4. Verificação da Compreensão " 			if name=="s_b4"
replace name="5. Comentários Construtivos"				if name=="s_b5"
replace name="6. Raciocínio Crítico" 					if name=="s_b6"
replace name="7. Autonomia" 							if name=="s_c7"
replace name="8. Perseverança" 							if name=="s_c8"
replace name="9. Capacidades sociais e colaborativas" 	if name=="s_c9"


// Make a x axis anchor for the bar with a gap of 1 between the grades
sort name grade
gen namegrade = _n

local N = _N
forvalues i = 2/`N' {
	replace namegrade = namegrade+1 if _n >= `i' & mod(`i',6)==1
}

list namegrade name grade, sepby(name)


// Make the rcap for the semean
gen semean_min = mean - 1.96*sem
gen semean_max = mean + 1.96*sem


// Make the value labels to position over the bars
gen var= semean_max+0.1
gen var2= round(mean,0.1)


//Make the graphs using twoway bar
twoway  (bar mean namegrade if grade==1 & namegrade <=13, col(orange_red*0.3)) ///
	(bar mean namegrade if grade==2 & namegrade <=13, col(maroon*0.4)) ///
	(bar mean namegrade if grade==3 & namegrade <=13, col(maroon*0.6)) ///
	(bar mean namegrade if grade==4 & namegrade <=13, col(maroon*0.8)) ///
	(bar mean namegrade if grade==5 & namegrade <=13, col(maroon*1)) ///
	(bar mean namegrade if grade==6 & namegrade <=13, col(maroon*1.2)) ///
	(rcap semean_max semean_min namegrade if namegrade <=13, col(gs8)) ///
	(scatter var namegrade if namegrade <=13, ///
		msymbol(none) mlabel(var2) mlabpos(12) mlabcolor(black) mlabsize(small)) ///
	, yscale(range(1 5)) ylabel(1(1)5) graphregion(color(white)) xscale(range(0 6)) ytitle("") xtitle("") ///
	plotregion(margin(zero)) ///
	legend(label(1 "Grade 1") label(2 "Grade 2") label(3 "Grade 3") label(4 "Grade 4") label(5 "Grade 5") label(6 "Grade 6") order(1 2 3 4 5 6) ///
	 size(small) region(lwidth(none))region(lcolor(white)) region(style(none))) ///
	xlabel(3.5 "Ambiente de apoio à aprendizagem" 10.5 "Expetativas Comportamentais Positivas", noticks labsize(small))

	
	/*
	graph bar construct if order<=`row'*2, over(grade, sort(reverse)) over(name, sort(order) label(labsize(small)))  blabel(bar,format(%9.1f)  position(outside)) exclude0 ///
	graphregion(color(white)) yla(1(1)5)  bargap(0) asyvars ytitle("")  bar(1, col(orange_red*0.3))  bar(2, col(maroon*0.4))   bar(3, col(maroon*0.6))  ///
	 bar(4, col(maroon*0.8))   bar(5, col(maroon*1))   bar(6, col(maroon*1.2)) 
	*/
	
graph export "$graphs/Figure3_6_panel2.png", replace


twoway  (bar mean namegrade if grade==1 & namegrade >13 & namegrade <=41, col(orange_red*0.3)) ///
	(bar mean namegrade if grade==2 & namegrade >13 & namegrade <=41, col(maroon*0.4)) ///
	(bar mean namegrade if grade==3 & namegrade >13 & namegrade <=41, col(maroon*0.6)) ///
	(bar mean namegrade if grade==4 & namegrade >13 & namegrade <=41, col(maroon*0.8)) ///
	(bar mean namegrade if grade==5 & namegrade >13 & namegrade <=41, col(maroon*1)) ///
	(bar mean namegrade if grade==6 & namegrade >13 & namegrade <=41, col(maroon*1.2)) ///
	(rcap semean_max semean_min namegrade if namegrade >13 & namegrade <=41, col(gs8)) ///
	(scatter var namegrade if namegrade >13 & namegrade <=41, ///
		msymbol(none) mlabel(var2) mlabpos(12) mlabcolor(black) mlabsize(small)) ///
	, yscale(range(1 5)) ylabel(1(1)5) graphregion(color(white)) xscale(range(14 41)) ytitle("") xtitle("") ///
	plotregion(margin(zero)) ///
	legend(label(1 "Grade 1") label(2 "Grade 2") label(3 "Grade 3") label(4 "Grade 4") label(5 "Grade 5") label(6 "Grade 6") order(1 2 3 4 5 6) ///
	 size(small) region(lwidth(none))region(lcolor(white)) region(style(none))) ///
	xlabel(17 "Clarificação da Lição" 24.5 "Verificação da Compreensão" 31.5 "Comentários Construtivos" 38.5 "Raciocínio Crítico", noticks labsize(small))


	/*
	graph bar construct if order>`row'*2 & order<=`row'*6, over(grade, sort(reverse)) over(name, sort(order) label(labsize(small)))  blabel(bar,format(%9.1f)  position(outside)) exclude0 ///
	graphregion(color(white)) yla(1(1)5)  bargap(0) asyvars  ytitle("")  bar(1, col(orange_red*0.3))  bar(2, col(maroon*0.4))   bar(3, col(maroon*0.6))  ///
	 bar(4, col(maroon*0.8))   bar(5, col(maroon*1))   bar(6, col(maroon*1.2)) 
	*/	
	
graph export "$graphs/Figure3_11_panel2.png", replace


twoway  (bar mean namegrade if grade==1 & namegrade >42, col(orange_red*0.3)) ///
	(bar mean namegrade if grade==2 & namegrade >42, col(maroon*0.4)) ///
	(bar mean namegrade if grade==3 & namegrade >42, col(maroon*0.6)) ///
	(bar mean namegrade if grade==4 & namegrade >42, col(maroon*0.8)) ///
	(bar mean namegrade if grade==5 & namegrade >42, col(maroon*1)) ///
	(bar mean namegrade if grade==6 & namegrade >42, col(maroon*1.2)) ///
	(rcap semean_max semean_min namegrade if namegrade >42, col(gs8)) ///
	(scatter var namegrade if namegrade >42, ///
		msymbol(none) mlabel(var2) mlabpos(12) mlabcolor(black) mlabsize(small)) ///
	, yscale(range(1 5)) ylabel(1(1)5) graphregion(color(white)) xscale(range(42 63)) ytitle("") xtitle("") ///
	plotregion(margin(zero)) ///
	legend(label(1 "Grade 1") label(2 "Grade 2") label(3 "Grade 3") label(4 "Grade 4") label(5 "Grade 5") label(6 "Grade 6") order(1 2 3 4 5 6) ///
	 size(small) region(lwidth(none))region(lcolor(white)) region(style(none))) ///
	xlabel(45.5 "Autonomia" 52.5 "Perseverança" 59.5 "Capacidades sociais e colaborativas", noticks labsize(small))


	/*
	graph bar construct if order>`row'*6, over(grade, sort(reverse)) over(name, sort(order) label(labsize(small)))  blabel(bar,format(%9.1f)  position(outside)) exclude0 ///
	graphregion(color(white)) yla(1(1)5)  bargap(0) asyvars ytitle("") bar(1, col(orange_red*0.3))  bar(2, col(maroon*0.4))   bar(3, col(maroon*0.6))  ///
	 bar(4, col(maroon*0.8))   bar(5, col(maroon*1))   bar(6, col(maroon*1.2)) 
	*/
	
graph export "$graphs/Figure3_15_panel2.png", replace	
window manage close graph

restore
//}

exit
 
 
/*
 
*** Figure 3.6, 3.11, 3.15 - Panel 2
levelsof grade, local(grades)

preserve
	foreach var in s_a1 s_a2 s_b3 s_b4 s_b5 s_b6 s_c7 s_c8 s_c9{
		cap sum `var' if grade==1
		cap gen `var'_grade1=`r(mean)'
		cap sum `var' if grade==2
		cap gen `var'_grade2=`r(mean)'	
		cap sum `var' if grade==3
		cap gen `var'_grade3=`r(mean)'
		cap sum `var' if grade==4
		cap gen `var'_grade4=`r(mean)'
		cap sum `var' if grade==5
		cap gen `var'_grade5=`r(mean)'
		cap sum `var' if grade==6
		cap  gen `var'_grade6=`r(mean)'		
	}
	
	ds s_*grade*
	local n: word count `r(varlist)'
	dis "`n'"
	tabstat `r(varlist)', stat(mean) save
	mat fig14=matrix(r(StatTotal)')
	
	if `n'==54{
		local row=6
	}
	if `n'==45{
		local row=5
	}
	if `n'==36{
		local row=4
	}
	if `n'==27{
		local row=3
	}
	if `n'==28{
		local row=2
	}

	drop _all
	svmat2 fig14, names(construct) full
	
	gen name=""
	replace name="Supportive learning environment" if _n>=1 & _n<=`row'
	replace name="Positive Behavioral Expectations" if _n>`row' & _n<=2*`row' 
	replace name="Lesson facilitation" if  _n>2*`row' & _n<=3*`row' 
	replace name="Checks for Understanding" if _n>3*`row' & _n<=4*`row' 
	replace name="Feedback" if _n>4*`row' & _n<=5*`row' 
	replace name="Critical Thinking" if _n>5*`row' & _n<=6*`row'  
	replace name="Autonomy" if _n>6*`row' & _n<=7*`row' 
	replace name="Perseverance" if _n>7*`row' & _n<=8*`row' 
	replace name="Social and Collaborative Skills" if _n>8*`row' & _n<=9*`row' 

	gen order=_n
	gen grade=""
	gen reverse=.

	local num=1
	local beg=1
	
	foreach i in  `grades' {
	local num=`beg'
		while `num'<54 {
			replace grade="Grade `i'" if _n==`num'
				if `i'==7{
			replace grade="Multigrade" if _n==`num'
				}
			replace reverse=`beg' if _n==`num'
			local num=`num'+`row'
			dis "`num'"
		}
	local beg=`beg'+1
	dis "`beg'"
	}

	graph bar construct if order<=`row'*2, over(grade, sort(reverse)) over(name, sort(order) label(labsize(small)))  blabel(bar,format(%9.1f)  position(outside)) exclude0 ///
	graphregion(color(white)) yla(1(1)5)  bargap(0) asyvars ytitle("")  bar(1, col(orange_red*0.3))  bar(2, col(maroon*0.4))   bar(3, col(maroon*0.6))  ///
	 bar(4, col(maroon*0.8))   bar(5, col(maroon*1))   bar(6, col(maroon*1.2)) 
	graph export "$graphs/Figure3_6_panel2.png", replace
	
	graph bar construct if order>`row'*2 & order<=`row'*6, over(grade, sort(reverse)) over(name, sort(order) label(labsize(small)))  blabel(bar,format(%9.1f)  position(outside)) exclude0 ///
	graphregion(color(white)) yla(1(1)5)  bargap(0) asyvars  ytitle("")  bar(1, col(orange_red*0.3))  bar(2, col(maroon*0.4))   bar(3, col(maroon*0.6))  ///
	 bar(4, col(maroon*0.8))   bar(5, col(maroon*1))   bar(6, col(maroon*1.2)) 
	graph export "$graphs/Figure3_11_panel2.png", replace

	graph bar construct if order>`row'*6, over(grade, sort(reverse)) over(name, sort(order) label(labsize(small)))  blabel(bar,format(%9.1f)  position(outside)) exclude0 ///
	graphregion(color(white)) yla(1(1)5)  bargap(0) asyvars ytitle("") bar(1, col(orange_red*0.3))  bar(2, col(maroon*0.4))   bar(3, col(maroon*0.6))  ///
	 bar(4, col(maroon*0.8))   bar(5, col(maroon*1))   bar(6, col(maroon*1.2)) 
	graph export "$graphs/Figure3_15_panel2.png", replace	
	window manage close graph
	
restore

*/

