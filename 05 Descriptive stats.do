********************************************************************
* Replication materials for Preserving History or Property Values: *
* Historic Preservation and Housing Prices in Washington, DC 	   *
* Author: Lev Klarnet 											   *
* Date: May 8, 2019									               *
********************************************************************

* In this script, I save out the descriptive statistics for the full sample of property sales, as well as the repeats
* sales.
************************************************************************************************************************
* Script table of contents:
*
* 1: Full sales descriptive statistics
* 2: Repeat sales descriptive statistics
************************************************************************************************************************
clear
set more off
set type double

****************************************
* 1: Full sales descriptive statistics *
****************************************

	use "${TEMP}/All_sales_reg_ready.dta", clear

	* Install estout to export descriptive statistics
	ssc install estout, replace

	* Variables for RESIDENTIAL ONLY
	local residential_vars stories kitchens Dcndt*

	* Output descriptive Statistics for residential only
	estpost tabstat `residential_vars', by(hd_ever) statistics(count mean sd min max median) columns(statistics) listwise
	esttab using "${OUTPUT}/raw_descriptive_stat_residential.csv", replace cells("count mean sd min max p50")

	* Descriptive stats for FUll SAMPLE 
	local sample_vars price bedrm bathrm hf_bathrm gba landarea age ayb fireplaces hardwood_floor metro_close Dac town* sf multi semi_detached condo Dheat* 
	* Descriptive Statistics
	estpost tabstat `sample_vars', by(hd_ever) statistics(count mean sd min max median) columns(statistics) listwise
	esttab using "${OUTPUT}/raw_descriptive_stat_fullsample.csv", replace cells("count mean sd min max p50")

******************************************
* 2: Repeat sales descriptive statistics *
******************************************

	use "${TEMP}/Repeat_sales_reg_ready.dta", clear

	* Get descriptive stats for repeat sales sample
	local repeat_sales price_chg saledate_chg post_desig_i hd_chg hd_chg_condo hd_chg_sf hd_chg_multi hd_chg_semi_detached hd_chg_town_end hd_chg_town_inside hd_buff_250feet_i hd_buff_250f_chg spring_chg fall_chg summer_chg saleyear_92_chg saleyear_93_chg saleyear_94_chg saleyear_95_chg saleyear_96_chg saleyear_97_chg saleyear_98_chg saleyear_99_chg saleyear_00_chg saleyear_01_chg saleyear_02_chg saleyear_03_chg saleyear_04_chg saleyear_05_chg saleyear_06_chg saleyear_07_chg saleyear_08_chg saleyear_09_chg saleyear_10_chg saleyear_11_chg saleyear_12_chg saleyear_13_chg saleyear_14_chg saleyear_15_chg saleyear_16_chg saleyear_17_chg saleyear_18_chg saleyear_19_chg
	* Descriptive Statistics
	estpost tabstat `repeat_sales', statistics(count mean sd min max median) columns(statistics) listwise
	esttab using "${OUTPUT}/raw_descriptive_stat_repeatsales.csv", replace cells("count mean sd min max p50")

*** EOF ***
