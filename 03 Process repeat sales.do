********************************************************************
* Replication materials for Preserving History or Property Values: *
* Historic Preservation and Housing Prices in Washington, DC 	   *
* Author: Lev Klarnet 						   *
* Date: May 8, 2019						   *
********************************************************************

* In this script, I save out the descriptive statistics for all houses in historic districts and all houses outside of
* historic districts.

************************************************************************************************************************
* Script table of contents:
*
* 1: Merge housing sales data
* 2: Create controls
* 3: Save out
************************************************************************************************************************
clear
set more off
set type double

*******************************
* 1: Merge housing sales data *
*******************************

	* Import the initially processed most recent housing data
	use "${TEMP}/All_sales_processed.dta",clear

		* To make the dataset unique at the square suffix lox (ssl) level, drop the 26 duplicates 
		duplicates tag ssl, gen(dups)
		count if dups == 1
		assert r(N) == 26
		drop if dups == 1
		
		* The data are now unique on ssl
		isid ssl 

		* remove all spaces from ssl
		replace ssl = subinstr(ssl," ","",.)
	
	* Save out for merge
	save "${TEMP}/All_sales_deduplicated.dta", replace
 
	* Import previous housing sales data available at Kaggle (https://www.kaggle.com/christophercorrea/dc-residential-
	* properties). Similarly I have pre-processed this data to include location and ssl information in ArcGIS
	import delimited using "${INPUT}/DC_tax_dept_real_estate_geocoded.csv", clear

	* Clean sale date
	assert !mi(recordationdate)
	assert regexm(recordationdate, "^[0-9]+/[0-9]+/[0-9][0-9][0-9][0-9]$")
	gen saledate_2018 = date(recordationdate, "MDY")
	format saledate_2018 %td

	* Rename variables
	rename squaresuffixlot ssl
	rename saleprice price_2018

	* Remove all spaces from ssl
	replace ssl = subinstr(ssl," ","",.)

	* Merge on 2019 dataset
	merge m:1 ssl using "${TEMP}/All_sales_deduplicated.dta"

	* Limit to instances where houses appear in both datasets
	drop if _m != 3
	drop _m

	* create repeat sales dummy variable
	gen repeat_sale = saledate_clean != saledate_2018 & price_2018 != 0 & price != 0

	* There are 3,888 repeat sales in the data: limit the data to only repeat sales
	count if repeat_sale == 1
	assert r(N) == 3888
	drop if repeat_sale == 0

*******************************
* 2: Create control variables *
*******************************

	* Create initial sale dates and prices
	gen saledate_i = saledate_clean if saledate_clean < saledate_2018
	replace saledate_i = saledate_2018 if saledate_clean > saledate_2018
	assert !mi(saledate_i)
	gen price_i = price if saledate_clean < saledate_2018
	replace price_i = price_2018 if saledate_clean > saledate_2018
	assert !mi(price_i)

	* Create final sale dates and prices
	gen saledate_f = saledate_2018 if saledate_clean == saledate_i
	replace saledate_f = saledate_clean if saledate_2018 == saledate_i
	assert !mi(saledate_f)
	gen price_f = price_2018 if saledate_clean == saledate_i
	replace price_f = price if saledate_2018 == saledate_i
	assert !mi(price_f)

	format saledate_* %td

	* Create variable for houses sold after designation for sales i
	gen daysbetween_i = saledate_i - desig_date if in_hd == 1
	gen post_desig_i = daysbetween_i > 0 & in_hd == 1

	* Create variable for post designation for sales f
	gen daysbetween_f = saledate_f - desig_date if in_hd == 1
	gen post_desig_f = daysbetween_f > 0 & in_hd == 1

	* Create HD_change variable that equals 1 if a house was initially sold before the neighborhood became a historic
	* district, but the neighborhood became a historic district before the final sale
	gen hd_chg = post_desig_f == 1 & post_desig_i == 0

	* Clean sale years and months
	gen saleyear_i = year(saledate_i)
	gen salemonth_i = month(saledate_i)
	gen saleyear_f = year(saledate_f)
	gen salemonth_f = month(saledate_f)

	* Create age variable
	gen age_i = max(0,saleyear_i - eyb)
	gen age_f = max(0,saleyear_f - eyb)

	* Create close to metro dummy if house is within 500f of metro 
	gen metro_close = dist_to_metro <= 500

	* Create dummy buffer variable if house is within 250f of hd
	* Create variable for buffer post designation for i sales
	gen daysbetween_buf_i = saledate_i - desig_date if in_hd == 0
	gen post_desig_buf_i = daysbetween_buf_i > 0 & in_hd == 0
	gen hd_buff_250feet_i = dist_to_hd <= 250 & post_desig_buf_i != 0 

	* Create dummy buffer variable if house is within 250f of hd
	* Create variable for buffer post designation for f sales
	gen daysbetween_buf_f = saledate_f - desig_date if in_hd == 0
	gen post_desig_buf_f = daysbetween_buf_f > 0 & in_hd == 0
	gen hd_buff_250feet_f = dist_to_hd <= 250 & post_desig_buf_f != 0 

	* Create buffer change variable
	gen hd_buff_250f_chg = hd_buff_250feet_f == 1 & hd_buff_250feet_i == 0

	* There are only 3 observations with an initial sale year before 1992. Drop saleyears before 1992
	count if saleyear_i < 1992
	assert r(N) == 3
	drop if saleyear_i < 1992

	* Create saleyear dummies
	tab saleyear_i, gen(Dsaley_i)

	* Rename years 
	rename Dsaley_i1 Dsaley92_i
	rename Dsaley_i2 Dsaley93_i
	rename Dsaley_i3 Dsaley94_i
	rename Dsaley_i4 Dsaley95_i
	rename Dsaley_i5 Dsaley96_i
	rename Dsaley_i6 Dsaley97_i
	rename Dsaley_i7 Dsaley98_i
	rename Dsaley_i8 Dsaley99_i
	rename Dsaley_i9 Dsaley00_i
	rename Dsaley_i10 Dsaley01_i
	rename Dsaley_i11 Dsaley02_i
	rename Dsaley_i12 Dsaley03_i
	rename Dsaley_i13 Dsaley04_i
	rename Dsaley_i14 Dsaley05_i
	rename Dsaley_i15 Dsaley06_i
	rename Dsaley_i16 Dsaley07_i
	rename Dsaley_i17 Dsaley08_i
	rename Dsaley_i18 Dsaley09_i
	rename Dsaley_i19 Dsaley10_i
	rename Dsaley_i20 Dsaley11_i
	rename Dsaley_i21 Dsaley12_i
	rename Dsaley_i22 Dsaley13_i
	rename Dsaley_i23 Dsaley14_i
	rename Dsaley_i24 Dsaley15_i
	rename Dsaley_i25 Dsaley16_i
	rename Dsaley_i26 Dsaley17_i
	rename Dsaley_i27 Dsaley18_i
	gen Dsaley19_i = 0

	* Create final sale yearly dummies
	tab saleyear_f, gen(Dsaley_f)

	* rename years so I don't go crazy 
	gen Dsaley92_f = 0 
	gen Dsaley93_f = 0 
	gen Dsaley94_f = 0 
	gen Dsaley95_f = 0 
	gen Dsaley96_f = 0 
	gen Dsaley97_f = 0
	gen Dsaley98_f = 0 
	rename Dsaley_f1 Dsaley99_f
	rename Dsaley_f2 Dsaley00_f
	rename Dsaley_f3 Dsaley01_f
	rename Dsaley_f4 Dsaley02_f
	rename Dsaley_f5 Dsaley03_f
	rename Dsaley_f6 Dsaley04_f
	rename Dsaley_f7 Dsaley05_f
	rename Dsaley_f8 Dsaley06_f
	rename Dsaley_f9 Dsaley07_f
	rename Dsaley_f10 Dsaley08_f
	rename Dsaley_f11 Dsaley09_f
	rename Dsaley_f12 Dsaley10_f
	gen Dsaley11_f = 0 
	rename Dsaley_f13 Dsaley12_f
	rename Dsaley_f14 Dsaley13_f
	rename Dsaley_f15 Dsaley14_f
	gen Dsaley15_f = 0 
	rename Dsaley_f16 Dsaley16_f
	rename Dsaley_f17 Dsaley17_f
	rename Dsaley_f18 Dsaley18_f
	rename Dsaley_f19 Dsaley19_f

	* Create seasonal dummies
	foreach n in i f {
		gen spring_`n' = month(saledate_`n') == 3 | month(saledate_`n') == 4 | month(saledate_`n') == 5
		gen summer_`n' = month(saledate_`n') == 6 |  month(saledate_`n') == 7 |  month(saledate_`n') == 8
		gen fall_`n' = month(saledate_`n') == 19 |  month(saledate_`n') == 10 |  month(saledate_`n') == 11
	}

	* Create condo dummy
	gen condo = source == "CONDOMINIUM"

	* Create change months
	foreach i in spring fall summer {
		gen `i'_chg = 1 if `i'_f == 1
		replace `i'_chg = -1 if `i'_i == 1
		replace `i'_chg = 0 if mi(`i'_chg)
		assert !mi(`i'_chg)
	}

	* Create change years
	local years 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19
	foreach i of local years {
		gen saleyear_`i'_chg = 1 if Dsaley`i'_f == 1
		replace saleyear_`i'_chg = -1 if Dsaley`i'_i == 1
		replace saleyear_`i'_chg = 0 if mi(saleyear_`i'_chg)
		assert !mi(saleyear_`i'_chg)
	}

	* Create change price
	gen price_chg = log(price_f)-log(price_i)

	* Create change in sale date
	gen saledate_chg = saledate_f - saledate_i 

	* Create time variable t 
	gen t = saledate_chg 

	* Create housing type dummy variables
	gen town_inside = struct == "TOWN INSIDE" | struct == "ROW INSIDE"
	gen town_end = struct == "TOWN END" | struct == "ROW END"
	gen sf = struct == "SINGLE"
	gen multi = struct == "MULTI"
	gen semi_detached = struct == "SEMI-DETACHED"

	* create post_desig housing type variables
	local hs_types condo sf multi semi_detached town_end town_inside
	foreach hs_type of local hs_types {
		gen hd_chg_`hs_type' = hd_chg * `hs_type'
		gen hd_buff_250f_chg_`hs_type' = hd_buff_250f_chg * `hs_type'
	}

**********************
* 3: Remove outliers *
**********************

	* There are 162 houses that were remodeled between the initial and final sale. Remove if remodeled to ensure houses
	* have not changed between sales.
	count if yr_rmdl > year(saledate_i) & yr_rmdl < year(saledate_f)
	assert r(N) == 162
	drop if yr_rmdl > year(saledate_i) & yr_rmdl < year(saledate_f)

	* Drop the top and bottom 1% of price changes to remove outliers for condos and residential properties separately
	summ price_chg if condo == 1,de
	drop if price_chg < r(p1) & condo == 1
	drop if price_chg > r(p99) & condo ==1

	summ price_chg if condo ==0,de
	drop if price_chg < r(p1) & condo == 0
	drop if price_chg > r(p99) & condo ==0

***************
* 4: Save out *
***************

	compress
	save "${TEMP}/Repeat_sales_reg_ready.dta", replace

*** EOF ***
