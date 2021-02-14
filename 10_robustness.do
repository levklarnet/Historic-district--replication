* Tests for endogeniety 

* import csv
import excel using "$input/HD_source_nomyear.xlsx", firstrow clear
drop if ext == 1 | mi(UNIQUEID)
rename UNIQUEID uniqueid_clean
*gen near_hd_id_clean = uniqueid
save "$temp/HD_souce.dta",replace

use "$temp/reg_ready.dta", clear
gen uniqueid_clean = near_hd_id_clean + uniqueid
replace uniqueid_clean = trim(uniqueid_clean)

merge m:1 uniqueid_clean using "$temp/HD_souce.dta"
drop if _m == 2
drop _m

replace app_activist = 0 if mi(app_activist) 
replace app_government = 0 if mi(app_government) 
replace app_neighborhood = 0 if mi(app_neighborhood) 

* keep only activist hds
drop if hd_ever == 1 & app_neighborhood == 1
drop if hd_ever == 1 & app_government == 1
* keep only activist buffers 
drop if hd_buff_250f_ever == 1 & app_neighborhood == 1
drop if hd_buff_250f_ever == 1 & app_government == 1


save "$temp/reg_ready_activist.dta", replace

* get activist only repeat sales data
use "$temp/repeatsales_reg_ready.dta", clear
gen uniqueid_clean = near_hd_id_clean + uniqueid
replace uniqueid_clean = trim(uniqueid_clean)

merge m:1 uniqueid_clean using "$temp/HD_souce.dta"

drop if _m == 2
drop _m

replace app_activist = 0 if mi(app_activist) 
replace app_government = 0 if mi(app_government) 
replace app_neighborhood = 0 if mi(app_neighborhood) 

* keep only activist hds
drop if post_desig_i == 1 & app_neighborhood == 1
drop if hd_chg == 1 & app_neighborhood == 1

*drop if post_desig_i == 1 & app_government == 1
*drop if hd_chg == 1 & app_government == 1

* keep only activist buffers 
drop if hd_buff_250feet_i == 1 & app_neighborhood == 1
drop if hd_buff_250f_chg == 1 & app_neighborhood == 1

*drop if hd_buff_250feet_i == 1 & app_government == 1
*drop if hd_buff_250f_chg == 1 & app_government == 1


save "$temp/reg_ready_rs_activist.dta", replace


