********************************************************************
* Replication materials for Preserving History or Property Values: *
* Historic Preservation and Housing Prices in Washington, DC 	   *
* Author: Lev Klarnet 											   *
* Date: May 8, 2019									               *
********************************************************************

* In this script, I remove outliers and create the control variables for my regressions.

************************************************************************************************************************
* Script table of contents:
*
* 1: Remove outliers
* 2: Create controls
* 3: Save out
************************************************************************************************************************
clear
set more off
set type double

**********************
* 1: Remove outliers *
**********************

	* Load the processed data
	use "${TEMP}/All_sales_processed.dta",clear

	* There are only 15 sales before 1992, drop these
	count if saleyear < 1992
	assert r(N) == 15
	drop if saleyear < 1992

	* Drop the top 1% and bottom 1% of houses by price for each year and condo/residential
	foreach n in CONDOMINIUM RESIDENTIAL {
		forval i = 1992/2018 {
			sum price if saleyear==`i' & source == "`n'",de
			drop if price <r(p1) & saleyear == `i' & source == "`n'"
			drop if price >r(p99)& saleyear == `i' & source == "`n'"
		}
	}

	* Even after dropping the high priced houses, there are still 424 sales for over 10 million, drop these 
	count if price > 1e7 
	assert r(N) == 424
	drop if price > 1e7 

	sum price , de

	* Remove the top 1% and bottom 1% of houses by gba and lot size for each housing type condo/residential
	foreach n in CONDOMINIUM RESIDENTIAL {
		foreach i in gba landarea {
			drop if `i' == 0
			sum `i' if source == "`n'",de
			drop if `i' <r(p1) & source == "`n'"
			drop if `i' >r(p99) & source == "`n'"
		}
	}	

	* Drop missing bedrooms and bathrooms and larger than 10 bedrooms
	drop if bedrm > 10 | bedrm == 0 
	drop if bathrm > 10 | bathrm == 0 
	replace hf_bathrm = 0 if hf_bathrm == .

	* Drop stories larger than 5 or stories == 0
	drop if stories > 5 & source == "RESIDENTIAL"
	drop if stories == 0 & source == "RESIDENTIAL"

	* Drop if kitchens larger than 10
	drop if kitchens > 10 & source == "RESIDENTIAL"

	* Drop if fireplaces is larger than 7
	drop if fireplaces > 7 & source == "RESIDENTIAL"

*******************************
* 2: Create control variables *
*******************************

	* create variable for post designation
	gen daysbetween = saledate_clean - desig_date if in_hd == 1
	gen post_desig = 1 if daysbetween > 0 & in_hd == 1
	replace post_desig = 0 if mi(post_desig)

	*create interaction term between in_hd and post
	gen post_hd = post_desig * in_hd

	* Create and ac dummy variable
	gen Dac = 1 if ac == "Y"
	replace Dac = 0 if mi(Dac)
	drop ac

	* Create heat type dummy variables
	gen Dheat_forceair = heat == "FORCED AIR"
	gen Dheat_hotwaterrad = heat == "HOT WATER RAD"
	gen Dheat_htpump = heat == "HT PUMP"
	gen Dheat_warmcool = heat == "WARM COOL"

	* Create housing type dummy variables
	gen town_inside = struct == "TOWN INSIDE" | struct == "ROW INSIDE"
	gen town_end = struct == "TOWN END" | struct == "ROW END"
	gen sf = struct == "SINGLE"
	gen multi = struct == "MULTI"
	gen semi_detached = struct == "SEMI-DETACHED"

	* Create hardwood floors dummy
	gen hardwood_floor = intwall == "HARDWOOD" | intwall == "HARDWOOD/CARP" | intwall == "WOOD FLOOR"

	* Create condition dummy variables and drop cndtn7 (very good)
	tab cndtn, gen(Dcndtn)
	drop Dcndtn7

	* Create close to metro dummy if house is within 500f of metro 
	gen metro_close = dist_to_metro <= 500

	* Create dummy buffer variable if house is within 250f of hd
	* Create variable for buffer post designation
	gen post_desig_buf = saledate_clean > desig_date & in_hd == 0

	gen hd_buff_250f_ever = dist_to_hd <= 250 & in_hd == 0

	gen hd_buff_250f_post = dist_to_hd <= 250 & post_desig_buf == 1 

	* log home price and age 
	gen lprice = log(price)
	
	* Create age variable. Where age ==0 (new properties)
	gen age = max(0,saleyear - eyb)
	sum age,de

	* create age^2
	gen age2 = age*age

	* Create log sf variable
	gen lgba = log(gba)

	* Create log landarea variable
	gen log_landarea = log(landarea)

	* Create monthly dummies, dropping December
	tab salemonth, gen(Dsalemonth)
	drop Dsalemonth12

	* Create yearly dummies, dropping 2000
	tab saleyear, gen(Dsaley)
	* Rename years 
	rename Dsaley1 Dsaley92
	rename Dsaley2 Dsaley93
	rename Dsaley3 Dsaley94
	rename Dsaley4 Dsaley95
	rename Dsaley5 Dsaley96
	rename Dsaley6 Dsaley97
	rename Dsaley7 Dsaley98
	rename Dsaley8 Dsaley99
	rename Dsaley9 Dsaley00
	rename Dsaley10 Dsaley01
	rename Dsaley11 Dsaley02
	rename Dsaley12 Dsaley03
	rename Dsaley13 Dsaley04
	rename Dsaley14 Dsaley05
	rename Dsaley15 Dsaley06
	rename Dsaley16 Dsaley07
	rename Dsaley17 Dsaley08
	rename Dsaley18 Dsaley09
	rename Dsaley19 Dsaley10
	rename Dsaley20 Dsaley11
	rename Dsaley21 Dsaley12
	rename Dsaley22 Dsaley13
	rename Dsaley23 Dsaley14
	rename Dsaley24 Dsaley15
	rename Dsaley25 Dsaley16
	rename Dsaley26 Dsaley17
	rename Dsaley27 Dsaley18

	* omit year 2000
	drop Dsaley00

	* Create neighborhood dummy variables
	tab assessment_nbhd, gen(Dassessment_nbhd)
	* omit Woodridge
	drop Dassessment_nbhd56

	* Create condo dummy
	gen condo = source == "CONDOMINIUM"

	* Rename in_hd to hd_ever for clarity
	rename in_hd hd_ever

	* create seasonal variables where spring Mar-May, summer June-Aug, fall Sept-Nov
	gen spring = 1 if Dsalemonth3 == 1 | Dsalemonth4 == 1 | Dsalemonth5 == 1
	gen summer = 1 if Dsalemonth6 == 1 | Dsalemonth7 == 1 | Dsalemonth8 == 1
	gen fall = 1 if Dsalemonth9 == 1 | Dsalemonth10 == 1 | Dsalemonth11 == 1

	* create age decade dummies
	gen decade_pre1880s = 1 if ayb < 1880
	gen decade_1880s = 1 if ayb > 1879 & ayb < 1890
	gen decade_1890s = 1 if ayb > 1889 & ayb < 1900
	gen decade_1900s = 1 if ayb > 1899 & ayb < 1910
	gen decade_1910s = 1 if ayb > 1909 & ayb < 1920
	gen decade_1920s = 1 if ayb > 1919 & ayb < 1930
	gen decade_1930s = 1 if ayb > 1929 & ayb < 1940
	gen decade_1940s = 1 if ayb > 1939 & ayb < 1950
	gen decade_1950s = 1 if ayb > 1949 & ayb < 1960
	gen decade_1960s = 1 if ayb > 1959 & ayb < 1970
	gen decade_1970s = 1 if ayb > 1969 & ayb < 1980
	gen decade_1980s = 1 if ayb > 1979 & ayb < 1990
	gen decade_1990s = 1 if ayb > 1989 & ayb < 2000
	gen decade_2000s = 1 if ayb > 1999 & ayb < 2010

	* create time var
	gen t = saleyear - 1991

	* create post_desig housing type variables
	local hs_types condo sf multi semi_detached town_end town_inside
	foreach hs_type of local hs_types {
		gen post_desig_`hs_type' = post_desig * `hs_type'
		gen post_buff_post_`hs_type' = hd_buff_250f_post * `hs_type'
	}

***************
* 3: Save out *
***************

	compress 
	save "${TEMP}/All_sales_reg_ready.dta", replace

*** EOF ***
