*************************************
//Vaccine Ad Campaign Simulation
//Author: Ruizhe(Ray) Wang
*************************************

capture log close
log using "vaccine.log", replace

clear all

*file location
cd "C:\Users\wangr\OneDrive\Desktop\Vaccine ads"



//1. Baseline survey dataset

set obs 5000
gen id = _n
set seed 20250411

*demographics (age, gender, location, education)
gen time = 0

*age (working pop ages 18-90)
gen age = floor(runiform()*73) + 18

*gender
gen gender = cond(runiform() <0.51, 1, 0) // 1 = female, 0 = male

*education
gen edu_lvl = runiform()
gen educ =.
replace educ = 1 if edu_lvl < 0.2
replace educ = 2 if edu_lvl >= 0.20 & edu_lvl < 0.50
replace educ = 3 if edu_lvl >= 0.50 & edu_lvl < 0.75
replace educ = 4 if edu_lvl >= 0.75
label define edu_lbl 1 "some_hs" 2 "hs grad" 3 "some_college" 4 "BA/higher"
label values educ edu_lbl
drop edu_lvl

gen hs = (educ == 2)
gen col = (educ == 3)
gen grad = (educ == 4)

*political lean
gen pol_random = runiform()
gen pol_lean = .
replace pol_lean = 1 if pol_random < 0.3
replace pol_lean = 2 if pol_random >= 0.3 & pol_random < 0.7
replace pol_lean = 3 if pol_random >= 0.7
label define pol_lbl 1 "Liberal" 2 "Moderate" 3 "Conservative"
label values pol_lean pol_lbl

gen liberal = (pol_lean == 1)
gen moderate = (pol_lean == 2)
gen conservative = (pol_lean == 3)

*vaccine confidence 1 (worst) - 5 (good)
gen vac_conf = round(runiform() * 4 + 1)


*vaccination status (liklihood of vaccination increases with higher vac confidence, more education, and liberal lean; more at risk age groups are more likely to take vaccine)
gen pre_vac = 0
replace pre_vac = 1 if runiform() < (vac_conf*0.1 + hs*0.05 + col*0.1 + grad*0.15 + liberal*0.2 - conservative*0.2 + age*0.001) 

save baseline.dta, replace

//2. Random Assignment
clear
set seed 2025  

set obs 5000
gen id = _n


gen rand = runiform()
gen group = .
replace group = 1 if rand < 1/3
replace group = 2 if rand >= 1/3 & rand < 2/3
replace group = 3 if rand >= 2/3
label define grouplbl 1 "Reason" 2 "Emotion" 3 "Control"
label values group grouplbl
drop rand

gen treat1 = (group == 1) // reason ad treatment indicator
gen treat2 = (group == 2) // emotion ad treatment indicator

keep id group treat1 treat2

save assign.dta, replace

//3. Endline Dataset
clear
set seed 0411

use baseline.dta
merge 1:1 id using assign.dta
drop _merge

replace time = 1

*randomly select 4500 respondents
gen rand = runiform()  
gsort rand 
gen selected = (_n <= 4500)  
drop rand  
keep if selected == 1


*post treatment vaccination status
gen post_vac = pre_vac 

gen vac_random = runiform() 
replace post_vac = 1 if vac_random < 0.5 & group == 1  
replace post_vac = 1 if vac_random < 0.8 & group == 2
replace post_vac = 0 if vac_random < 0.4 & group == 2 & pre_vac == 0

save endline.dta, replace


//4. Merge and append 
use baseline.dta, clear
merge 1:1 id using assign.dta
drop _merge

merge 1:1 id time using endline.dta
drop _merge

*combine pre & post vac

gen vac = pre_vac if time == 0
replace vac = post_vac if time == 1

gen treatment1 = treat1*time
gen treatment2 = treat2*time



//5. Ad Campaign Analysis

*DiD regression
xtset id time
xtreg vac treat1##time treat2##time age gender hs col grad liberal moderate conservative ,robust
outreg2 using Table1, word replace ctitle(Model 1) title(Table 1) bdec(4) se sdec(4) 

xtreg vac treat1 treat2 time treatment1 treatment2 age gender hs col grad liberal conservative ,robust
outreg2 using Table1, word replace ctitle(Model 1) title(Table 1) bdec(4) se sdec(4) 


*bar graph
graph bar vac, over(group) over(time) blabel(bar, size(small)) ///
	ytitle("Vaccination Uptake") title("Treatment Effects on Vaccination Pre- and Post- Ads") ///
    legend(label(1 "Treatment Group 1") label(2 "Treatment Group 2") label(3 "Control")) ///
	

log close
