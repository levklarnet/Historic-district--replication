*** HIGHLY CONFIDENTIAL ***

****************************************************************************
* FULL SAMPLE REGRESSIONS
****************************************************************************

	use "$temp/reg_ready.dta", clear

	set matsize 500
*** RESIDENTIAL ONLY REGRESSIONS	
	* local control variables for residential
*	local control_res hd_buff_250f_ever hd_buff_250f_post lgba rooms bedrm bathrm hf_bathrm log_landarea fireplaces age age2 town_inside town_end sf multi semi_detached hardwood_floor metro_close *Dsale* stories kitchens Dcndtn*
	
	* Reg RESIDENTIAL OLS
*	reg lprice hd_ever post_desig `control_res' if source == "Residential", robust cluster(census_tract) 
	* Coefficients stored in locals _b[L.y], _b[x1], _b[x2]

	* Store estimates and statistics from regression
*	estimates save "$temp/residential_ols.ster", replace

	* local control variables for residential
	local control_res hd_buff_250f_ever hd_buff_250f_post lgba rooms bedrm bathrm hf_bathrm log_landarea fireplaces age age2 town_inside town_end sf multi semi_detached hardwood_floor metro_close *Dsale* stories kitchens Dcndtn*
	
	* Reg RESIDENTIAL NEIGHBORHOOD TRENDS
	reg lprice hd_ever post_desig post_desig_sf post_desig_multi post_desig_semi_detached post_desig_town_end post_desig_town_inside `control_res' i.census_tract##c.t if source == "Residential", robust cluster(census_tract)
	* Coefficients stored in locals _b[L.y], _b[x1], _b[x2]

	* Store estimates and statistics from regression
	estimates save "$temp/residential_nt.ster", replace

	*** RESIDENTIAL BUFFER ANALYSIS
	* local control variables for residential
	local control_res hd_buff_250f_ever hd_buff_250f_post post_buff_post_sf post_buff_post_multi post_buff_post_semi_detached post_buff_post_town_end post_buff_post_town_inside lgba rooms bedrm bathrm hf_bathrm log_landarea fireplaces age age2 town_inside town_end sf multi semi_detached hardwood_floor metro_close *Dsale* stories kitchens Dcndtn*
	
	* Reg RESIDENTIAL NEIGHBORHOOD TRENDS
	reg lprice hd_ever post_desig post_desig_sf post_desig_multi post_desig_semi_detached post_desig_town_end post_desig_town_inside `control_res' i.census_tract##c.t if source == "Residential", robust cluster(census_tract)
	* Coefficients stored in locals _b[L.y], _b[x1], _b[x2]

	* Store estimates and statistics from regression
	estimates save "$temp/residential_buf_nt.ster", replace

	
*** FULL SAMPLE REGRESSIONS
	
	* local control variables for full sample 
*	local control_fs hd_buff_250f_ever hd_buff_250f_post lgba rooms bedrm bathrm hf_bathrm log_landarea fireplaces age age2 condo town_inside town_end sf multi semi_detached hardwood_floor metro_close *Dsale* 
	* Reg FULL SAMPLE OLS
	
*	reg lprice hd_ever post_desig `control_fs', robust cluster(census_tract)
	* Coefficients stored in locals _b[L.y], _b[x1], _b[x2] 

	* Store estimates and statistics from regression
*	estimates save "$temp/full_sample_ols.ster", replace
	
	* Local control variables 
	local control_fs hd_buff_250f_ever hd_buff_250f_post lgba rooms bedrm bathrm hf_bathrm log_landarea fireplaces age age2 condo town_inside town_end sf multi semi_detached hardwood_floor metro_close *Dsale* 
	
	* Reg FULL SAMPLE NEIGHBORHOOD TRENDS
	reg lprice hd_ever post_desig post_desig_condo post_desig_sf post_desig_multi post_desig_semi_detached post_desig_town_end post_desig_town_inside `control_fs' i.census_tract##c.t, robust cluster(census_tract)
	* Coefficients stored in locals _b[L.y], _b[x1], _b[x2] 

	* Store estimates and statistics from regression
	estimates save "$temp/full_sample_nt.ster", replace
	
	*** FULL SAMPLE BUFFER ANALYSIS
	* Local control variables 
	local control_fs hd_buff_250f_ever hd_buff_250f_post post_buff_post_condo post_buff_post_sf post_buff_post_multi post_buff_post_semi_detached post_buff_post_town_end post_buff_post_town_inside lgba rooms bedrm bathrm hf_bathrm log_landarea fireplaces age age2 condo town_inside town_end sf multi semi_detached hardwood_floor metro_close *Dsale* 
	
	* Reg FULL SAMPLE NEIGHBORHOOD TRENDS
	reg lprice hd_ever post_desig post_desig_condo post_desig_sf post_desig_multi post_desig_semi_detached post_desig_town_end post_desig_town_inside `control_fs' i.census_tract##c.t, robust cluster(census_tract)
	* Coefficients stored in locals _b[L.y], _b[x1], _b[x2] 

	* Store estimates and statistics from regression
	estimates save "$temp/full_sample_buf_nt.ster", replace
	
****************************************************************************
*** REPEAT SALES REGRESSIONS
****************************************************************************

	use "$temp/repeatsales_reg_ready.dta", clear

*REPEAT SALES FIXED EFFECTS
	local repeat_sale_vars post_desig_i hd_chg hd_chg_condo hd_buff_250feet_i hd_buff_250f_chg saledate_chg spring_chg fall_chg summer_chg saleyear_92_chg saleyear_93_chg saleyear_94_chg saleyear_95_chg saleyear_96_chg saleyear_97_chg saleyear_98_chg saleyear_99_chg saleyear_00_chg saleyear_01_chg saleyear_02_chg saleyear_03_chg saleyear_04_chg saleyear_05_chg saleyear_06_chg saleyear_07_chg saleyear_08_chg saleyear_09_chg saleyear_10_chg saleyear_11_chg saleyear_12_chg saleyear_13_chg saleyear_14_chg saleyear_15_chg saleyear_16_chg saleyear_17_chg saleyear_18_chg saleyear_19_chg
	
	reg price_chg `repeat_sale_vars', robust cluster(census_tract)

	* Store estimates and statistics from regression
	estimates save "$temp/repeat_sales_ols.ster", replace

	* FIXED EFFECTS BUFFER ANALYSIS
*	local repeat_sale_vars post_desig_i hd_chg hd_chg_condo hd_chg_sf hd_chg_multi hd_chg_semi_detached hd_chg_town_end hd_chg_town_inside hd_buff_250feet_i hd_buff_250f_chg hd_buff_250f_chg_condo hd_buff_250f_chg_sf hd_buff_250f_chg_multi hd_buff_250f_chg_semi_detached hd_buff_250f_chg_town_end hd_buff_250f_chg_town_inside saledate_chg spring_chg fall_chg summer_chg saleyear_92_chg saleyear_93_chg saleyear_94_chg saleyear_95_chg saleyear_96_chg saleyear_97_chg saleyear_98_chg saleyear_99_chg saleyear_00_chg saleyear_01_chg saleyear_02_chg saleyear_03_chg saleyear_04_chg saleyear_05_chg saleyear_06_chg saleyear_07_chg saleyear_08_chg saleyear_09_chg saleyear_10_chg saleyear_11_chg saleyear_12_chg saleyear_13_chg saleyear_14_chg saleyear_15_chg saleyear_16_chg saleyear_17_chg saleyear_18_chg saleyear_19_chg
	
*	reg price_chg `repeat_sale_vars', robust cluster(census_tract)

	* Store estimates and statistics from regression
*	estimates save "$temp/repeat_sales_buf_ols.ster", replace

	
*REPEAT SALES NEIGHBORHOOD TRENDS
*hd_chg_sf hd_chg_multi hd_chg_semi_detached hd_chg_town_end hd_chg_town_inside
	local repeat_sale_vars post_desig_i hd_chg hd_chg_condo hd_chg_sf hd_chg_multi hd_chg_semi_detached hd_chg_town_end hd_chg_town_inside hd_buff_250feet_i hd_buff_250f_chg saledate_chg spring_chg fall_chg summer_chg saleyear_92_chg saleyear_93_chg saleyear_94_chg saleyear_95_chg saleyear_96_chg saleyear_97_chg saleyear_98_chg saleyear_99_chg saleyear_00_chg saleyear_01_chg saleyear_02_chg saleyear_03_chg saleyear_04_chg saleyear_05_chg saleyear_06_chg saleyear_07_chg saleyear_08_chg saleyear_09_chg saleyear_10_chg saleyear_11_chg saleyear_12_chg saleyear_13_chg saleyear_14_chg saleyear_15_chg saleyear_16_chg saleyear_17_chg saleyear_18_chg saleyear_19_chg
	
	reg price_chg `repeat_sale_vars' i.census_tract##c.t, robust cluster(census_tract)

	* Store estimates and statistics from regression
	estimates save "$temp/repeat_sales_nt.ster", replace

	* NEIGHBORHOOD TRENDS BUFFER ANALYSIS
	local repeat_sale_vars post_desig_i hd_chg hd_chg_condo hd_chg_sf hd_chg_multi hd_chg_semi_detached hd_chg_town_end hd_chg_town_inside hd_buff_250feet_i hd_buff_250f_chg hd_buff_250f_chg_condo hd_buff_250f_chg_sf hd_buff_250f_chg_multi hd_buff_250f_chg_semi_detached hd_buff_250f_chg_town_end hd_buff_250f_chg_town_inside saledate_chg spring_chg fall_chg summer_chg saleyear_92_chg saleyear_93_chg saleyear_94_chg saleyear_95_chg saleyear_96_chg saleyear_97_chg saleyear_98_chg saleyear_99_chg saleyear_00_chg saleyear_01_chg saleyear_02_chg saleyear_03_chg saleyear_04_chg saleyear_05_chg saleyear_06_chg saleyear_07_chg saleyear_08_chg saleyear_09_chg saleyear_10_chg saleyear_11_chg saleyear_12_chg saleyear_13_chg saleyear_14_chg saleyear_15_chg saleyear_16_chg saleyear_17_chg saleyear_18_chg saleyear_19_chg

	reg price_chg `repeat_sale_vars' i.census_tract##c.t, robust 

	* Store estimates and statistics from regression
	estimates save "$temp/repeat_sales_buf_nt.ster", replace


****************************************************************************
*** ACTIVIST ONLY REGRESSIONS
****************************************************************************

use "$temp/reg_ready_activist.dta", clear

*** RESIDENTIAL ONLY REGRESSIONS	
	* local control variables for residential
*	local control_res hd_buff_250f_ever hd_buff_250f_post lgba rooms bedrm bathrm hf_bathrm log_landarea fireplaces age age2 town_inside town_end sf multi semi_detached hardwood_floor metro_close *Dsale* stories kitchens Dcndtn*
	
	* Reg RESIDENTIAL OLS
*	reg lprice hd_ever post_desig `control_res' if source == "Residential", robust cluster(census_tract) 
	* Coefficients stored in locals _b[L.y], _b[x1], _b[x2]

	* Store estimates and statistics from regression
*	estimates save "$temp/act_residential_ols.ster", replace

	* local control variables for residential
	local control_res hd_buff_250f_ever hd_buff_250f_post lgba rooms bedrm bathrm hf_bathrm log_landarea fireplaces age age2 town_inside town_end sf multi semi_detached hardwood_floor metro_close *Dsale* stories kitchens Dcndtn*
	
	* Reg RESIDENTIAL NEIGHBORHOOD TRENDS
	reg lprice hd_ever post_desig post_desig_sf post_desig_multi post_desig_semi_detached post_desig_town_end post_desig_town_inside `control_res' i.census_tract##c.t if source == "Residential", robust cluster(census_tract)
	* Coefficients stored in locals _b[L.y], _b[x1], _b[x2]

	* Store estimates and statistics from regression
	estimates save "$temp/act_residential_nt.ster", replace

* ACTIVIST BUFFER ANALYSIS NEIGHBORHOOD TRENDS	
	* local control variables for residential
	local control_res hd_buff_250f_ever hd_buff_250f_post  post_buff_post_condo post_buff_post_sf post_buff_post_multi post_buff_post_semi_detached post_buff_post_town_end post_buff_post_town_inside lgba rooms bedrm bathrm hf_bathrm log_landarea fireplaces age age2 town_inside town_end sf multi semi_detached hardwood_floor metro_close *Dsale* stories kitchens Dcndtn*
	
	* Reg RESIDENTIAL NEIGHBORHOOD TRENDS
	reg lprice hd_ever post_desig post_desig_sf post_desig_multi post_desig_semi_detached post_desig_town_end post_desig_town_inside `control_res' i.census_tract##c.t if source == "Residential", robust cluster(census_tract)
	* Coefficients stored in locals _b[L.y], _b[x1], _b[x2]

	* Store estimates and statistics from regression
	estimates save "$temp/act_residential_buf_nt.ster", replace

*** FULL SAMPLE REGRESSIONS
	
	* local control variables for full sample 
*	local control_fs hd_buff_250f_ever hd_buff_250f_post lgba rooms bedrm bathrm hf_bathrm log_landarea fireplaces age age2 condo town_inside town_end sf multi semi_detached hardwood_floor metro_close *Dsale* 
	* Reg FULL SAMPLE OLS
	
*	reg lprice hd_ever post_desig post_desig_condo post_desig_sf post_desig_multi post_desig_semi_detached post_desig_town_end post_desig_town_inside `control_fs', robust cluster(census_tract)
	* Coefficients stored in locals _b[L.y], _b[x1], _b[x2] 

	* Store estimates and statistics from regression
*	estimates save "$temp/act_full_sample_ols.ster", replace
	
	* Local control variables 
	local control_fs hd_buff_250f_ever hd_buff_250f_post lgba rooms bedrm bathrm hf_bathrm log_landarea fireplaces age age2 condo town_inside town_end sf multi semi_detached hardwood_floor metro_close *Dsale* 

	* Reg FULL SAMPLE NEIGHBORHOOD TRENDS
	reg lprice hd_ever post_desig post_desig_condo post_desig_sf post_desig_multi post_desig_semi_detached post_desig_town_end post_desig_town_inside `control_fs' i.census_tract##c.t, robust
	* Coefficients stored in locals _b[L.y], _b[x1], _b[x2] 

	* Store estimates and statistics from regression
	estimates save "$temp/act_full_sample_nt.ster", replace

* ACTIVIST ONLY BUFFER ANALYSIS
	* Local control variables 
	local control_fs hd_buff_250f_ever hd_buff_250f_post post_buff_post_condo post_buff_post_sf post_buff_post_multi post_buff_post_semi_detached post_buff_post_town_end post_buff_post_town_inside lgba rooms bedrm bathrm hf_bathrm log_landarea fireplaces age age2 condo town_inside town_end sf multi semi_detached hardwood_floor metro_close *Dsale* 

	* Reg FULL SAMPLE NEIGHBORHOOD TRENDS
	reg lprice hd_ever post_desig post_desig_condo post_desig_sf post_desig_multi post_desig_semi_detached post_desig_town_end post_desig_town_inside `control_fs' i.census_tract##c.t, robust 
	* Coefficients stored in locals _b[L.y], _b[x1], _b[x2] 

	* Store estimates and statistics from regression
	estimates save "$temp/act_full_sample_buf_nt.ster", replace

****************************************************************************
*** ACTIVIST ONLY REPEAT SALES REGRESSIONS
****************************************************************************

use "$temp/reg_ready_rs_activist.dta", clear

	*REPEAT SALES OLS
	local repeat_sale_vars post_desig_i hd_chg hd_chg_condo hd_buff_250feet_i hd_buff_250f_chg saledate_chg spring_chg fall_chg summer_chg saleyear_92_chg saleyear_93_chg saleyear_94_chg saleyear_95_chg saleyear_96_chg saleyear_97_chg saleyear_98_chg saleyear_99_chg saleyear_00_chg saleyear_01_chg saleyear_02_chg saleyear_03_chg saleyear_04_chg saleyear_05_chg saleyear_06_chg saleyear_07_chg saleyear_08_chg saleyear_09_chg saleyear_10_chg saleyear_11_chg saleyear_12_chg saleyear_13_chg saleyear_14_chg saleyear_15_chg saleyear_16_chg saleyear_17_chg saleyear_18_chg saleyear_19_chg
	
	reg price_chg `repeat_sale_vars', robust cluster(census_tract)

	* Store estimates and statistics from regression
	estimates save "$temp/act_repeat_sales_ols.ster", replace

	* FIXED EFFECTS BUFFER ANALYSIS
*	local repeat_sale_vars post_desig_i hd_chg hd_chg_condo hd_chg_sf hd_chg_multi hd_chg_semi_detached hd_chg_town_end hd_chg_town_inside hd_buff_250feet_i hd_buff_250f_chg hd_buff_250f_chg_condo hd_buff_250f_chg_sf hd_buff_250f_chg_multi hd_buff_250f_chg_semi_detached hd_buff_250f_chg_town_end hd_buff_250f_chg_town_inside saledate_chg spring_chg fall_chg summer_chg saleyear_92_chg saleyear_93_chg saleyear_94_chg saleyear_95_chg saleyear_96_chg saleyear_97_chg saleyear_98_chg saleyear_99_chg saleyear_00_chg saleyear_01_chg saleyear_02_chg saleyear_03_chg saleyear_04_chg saleyear_05_chg saleyear_06_chg saleyear_07_chg saleyear_08_chg saleyear_09_chg saleyear_10_chg saleyear_11_chg saleyear_12_chg saleyear_13_chg saleyear_14_chg saleyear_15_chg saleyear_16_chg saleyear_17_chg saleyear_18_chg saleyear_19_chg
	
*	reg price_chg `repeat_sale_vars', robust cluster(census_tract)

	* Store estimates and statistics from regression
*	estimates save "$temp/act_repeat_sales_buf_ols.ster", replace

	
	*REPEAT SALES NEIGHBORHOOD TRENDS
	 
	local repeat_sale_vars post_desig_i hd_chg hd_chg_condo hd_chg_sf hd_chg_multi hd_chg_semi_detached hd_chg_town_end hd_chg_town_inside hd_buff_250feet_i hd_buff_250f_chg saledate_chg spring_chg fall_chg summer_chg saleyear_92_chg saleyear_93_chg saleyear_94_chg saleyear_95_chg saleyear_96_chg saleyear_97_chg saleyear_98_chg saleyear_99_chg saleyear_00_chg saleyear_01_chg saleyear_02_chg saleyear_03_chg saleyear_04_chg saleyear_05_chg saleyear_06_chg saleyear_07_chg saleyear_08_chg saleyear_09_chg saleyear_10_chg saleyear_11_chg saleyear_12_chg saleyear_13_chg saleyear_14_chg saleyear_15_chg saleyear_16_chg saleyear_17_chg saleyear_18_chg saleyear_19_chg
	
	reg price_chg `repeat_sale_vars' i.census_tract##c.t, robust cluster(census_tract)

	* Store estimates and statistics from regression
	estimates save "$temp/act_repeat_sales_nt.ster", replace

	
	* NEIGHBORHOOD TRENDS BUFFER ANALYSIS
	local repeat_sale_vars post_desig_i hd_chg hd_chg_condo hd_chg_sf hd_chg_multi hd_chg_semi_detached hd_chg_town_end hd_chg_town_inside hd_buff_250feet_i hd_buff_250f_chg hd_buff_250f_chg_condo hd_buff_250f_chg_sf hd_buff_250f_chg_multi hd_buff_250f_chg_semi_detached hd_buff_250f_chg_town_end hd_buff_250f_chg_town_inside saledate_chg spring_chg fall_chg summer_chg saleyear_92_chg saleyear_93_chg saleyear_94_chg saleyear_95_chg saleyear_96_chg saleyear_97_chg saleyear_98_chg saleyear_99_chg saleyear_00_chg saleyear_01_chg saleyear_02_chg saleyear_03_chg saleyear_04_chg saleyear_05_chg saleyear_06_chg saleyear_07_chg saleyear_08_chg saleyear_09_chg saleyear_10_chg saleyear_11_chg saleyear_12_chg saleyear_13_chg saleyear_14_chg saleyear_15_chg saleyear_16_chg saleyear_17_chg saleyear_18_chg saleyear_19_chg

	reg price_chg `repeat_sale_vars' i.census_tract##c.t, robust 

	* Store estimates and statistics from regression
	estimates save "$temp/act_repeat_sales_buf_nt.ster", replace


*** EOF ***


