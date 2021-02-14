* Replication materials for Preserving History or Property Values: *
* Historic Preservation and Housing Prices in Washington, DC 	   *
* Author: Lev Klarnet 						   *
* Date: May 8, 2019				                   *
********************************************************************

* In this script, I create the datasets limited to activist nominated historic districts. Models that rely on these data
* omit endogeniety that arises if neighborhood or government groups nominate historic districts in response to rising
* housing prices.

************************************************************************************************************************
* Script table of contents:
*
* 1: Prepare data on nominating party
* 2: Limit full sample to activist nominated HDs
* 3: Limit repeat sales sample to activist nominated HDs
************************************************************************************************************************
clear
set more off
set type double

***************************************
* 1: Prepare data on nominating party *
***************************************

	* Import data on nominating party
	import excel using "${INPUT}/HD_source_nomyear.xlsx", firstrow clear

	* Drop rows refering to historic district extentions and the one row missing uniqueid
	drop if ext == 1 | mi(UNIQUEID)

	* Rename for merge
	rename UNIQUEID uniqueid_clean

	* Confirm unique on uniqueid_clean
	isid uniqueid_clean

	* Save out
	compress
	save "${TEMP}/HD_souce.dta",replace

**************************************************
* 2: Limit full sample to activist nominated HDs *
**************************************************

	* Import the processed full sample data
	use "${TEMP}/All_sales_reg_ready.dta", clear

	* Create a variable to identify the historic district
	gen uniqueid_clean = near_hd_id_clean + uniqueid
	replace uniqueid_clean = trim(uniqueid_clean)
	assert !mi(uniqueid_clean)

	* Merge on nominating party data
	merge m:1 uniqueid_clean using "${TEMP}/HD_souce.dta"

	* There are 7 historic districts that do not appear in the sales data
	count if _m == 2
	assert r(N) == 7
	drop if _m == 2
	drop _m

	* Fill in sources as 0 if missing, these refer to instances nowhere near historic districts
	replace app_activist = 0 if mi(app_activist) 
	replace app_government = 0 if mi(app_government) 
	replace app_neighborhood = 0 if mi(app_neighborhood) 

	* Keep only activist hds
	drop if hd_ever == 1 & app_neighborhood == 1
	drop if hd_ever == 1 & app_government == 1
	
	* Keep only activist buffers 
	drop if hd_buff_250f_ever == 1 & app_neighborhood == 1
	drop if hd_buff_250f_ever == 1 & app_government == 1

	* Save out
	compress
	save "${TEMP}/All_act_reg_ready.dta", replace

**********************************************************
* 3: Limit repeat sales sample to activist nominated HDs *
**********************************************************

	* Import processed repeat sales data
	use "${TEMP}/Repeat_sales_reg_ready.dta", clear
	
	* Create common ID for merge 
	gen uniqueid_clean = near_hd_id_clean + uniqueid
	replace uniqueid_clean = trim(uniqueid_clean)
	assert !mi(uniqueid_clean)

	* Merge on nominating party data
	merge m:1 uniqueid_clean using "${TEMP}/HD_souce.dta"

	* There are 78historic districts that do not appear in the sales data
	count if _m == 2
	assert r(N) == 8
	drop if _m == 2
	drop _m

	* Fill in sources as 0 if missing, these refer to instances nowhere near historic districts
	replace app_activist = 0 if mi(app_activist) 
	replace app_government = 0 if mi(app_government) 
	replace app_neighborhood = 0 if mi(app_neighborhood) 

	* keep only activist hds
	drop if post_desig_i == 1 & app_neighborhood == 1
	drop if hd_chg == 1 & app_neighborhood == 1

	drop if post_desig_i == 1 & app_government == 1
	drop if hd_chg == 1 & app_government == 1

	* keep only activist buffers 
	drop if hd_buff_250feet_i == 1 & app_neighborhood == 1
	drop if hd_buff_250f_chg == 1 & app_neighborhood == 1

	drop if hd_buff_250feet_i == 1 & app_government == 1
	drop if hd_buff_250f_chg == 1 & app_government == 1

	* Save out
	compress
	save "${TEMP}/Repeat_act_reg_ready.dta", replace

*** EOF ***
