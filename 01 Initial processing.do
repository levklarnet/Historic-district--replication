********************************************************************
* Replication materials for Preserving History or Property Values: *
* Historic Preservation and Housing Prices in Washington, DC 	   *
* Author: Lev Klarnet 											   *
* Date: May 8, 2019									               *
********************************************************************

* In this script, I standardize certain variables from the input file. I then merge on the historic district designation
* dates.

************************************************************************************************************************
* Script table of contents:
*
* 1: Load data
* 2: Standardize variables
* 3: Merge HD desig dates
* 4: Save out
************************************************************************************************************************
clear
set more off
set type double

****************
* 1: Load data *
****************

	* The data have been pre-processed to combine the Computer Assisted Mass Appraisal - Residential, Computer Assisted
	* Mass Appraisal - Condominium, and the address rediential units files available at https://opendata.dc.gov/. The
	* input file has been further processed in ArcGIS to merge on the historic district shapefile to identify which
	* properties are located within historic districts.

	* Import csv
	import delimited using "${INPUT}/Prop_HD_near_metro.csv", clear

	* Confirm unique on objectid (property)
	isid objectid

	* Drop unnecessary variables
	drop objectid_* field1 shape* gis* hit* designat_* edit* statu* name* national* latitude longitude

	* Initial string cleaning
	ds, has(type string)
	foreach var in `r(varlist)' {
		replace `var' = trim(itrim(upper(`var')))
	}

	* rename key variables
	rename near_fid metro_id
	rename near_dist dist_to_metro
	rename label hd_label

****************************
* 2: Standardize variables *
****************************

	* Clean sale dates
	assert regexm(saledate, "^[0-9]+/[0-9]+/[0-9][0-9][0-9][0-9] 0:00$") if !mi(saledate)
	gen saledate_clean = date(saledate, "MDY##")
	assert !mi(saledate_clean) if !mi(saledate)
	drop saledate
	format saledate_clean %td

	* Create saleyear and salemonth variables
	gen saleyear = year(saledate_clean)
	gen salemonth = month(saledate_clean)


	* Limit the dataset properties that have sold: drop if missing sale price or sale date
	drop if mi(price) | mi(saledate_clean) | dist_to_hd == -1

	* Confirm no buffers include observations inside of HDs
	gen in_hd = !mi(trim(hd_label))

	* Confirm distance to hd is greater than 0 if not in hd and dist to hd is equal to 0 if in hd
	assert dist_to_hd > 0 if in_hd == 0 
	assert dist_to_hd == 0 if in_hd == 1

	* Match near hd to uniqueid (where uniqueid refers to the unique hd id) for merge 
	bysort hd_id (uniqueid): gen near_hd_id_clean = uniqueid[_N]

	* Manual changes for special cases with no home sales 
	replace near_hd_id_clean = "D_030" if hd_id == 4
	replace near_hd_id_clean = "D_071" if hd_id == 15

	* Clean gba and living gba (square footage)
	assert !mi(living_gba) if source == "Condominium"
	assert !mi(gba) if source == "Residential"
	assert mi(gba) if source == "Condominium"
	assert mi(living_gba) if source == "Residential"
	replace gba = living_gba if mi(gba)
	drop living_gba
	assert !mi(gba)

	*convert meters to feet
	replace dist_to_metro = dist_to_metro * 3.28084
	replace dist_to_hd = dist_to_hd * 3.28084

***************************
* 3: Merge HD desig dates *
***************************

	* Read in and save out HD_desig_date, referring to the manually created dataset on the dates that each historic
	* district was designated
	preserve
		import delimited using "${INPUT}/HD_desig_date.csv", clear
		* clean HD designation dates
		drop if mi(month)
		gen desig_date = mdy(month,day,year)
		format desig_date %td
		drop year month day
		rename uniqueid near_hd_id_clean
		save "${TEMP}/HD_desig_date.dta",replace
	restore

	* merge HD years onto data
	merge m:1 near_hd_id_clean using "${TEMP}/HD_desig_date.dta"
	
	* There are 7 merge 2s, indicating there are 7 historic districts without home sales
	count if _m == 2
	assert r(N) == 7

	* Further, there are 127 rows that are associated with ST. ELIZABETH'S HOSPITAL HD, which isn't a historic district,
	* but rather a historic property
	count if _m == 1 & !mi(hd_label)

	* Drop these rows
	drop if _m == 2 | (_m == 1 & !mi(hd_label))
	drop _m

	* assert for all homes sold in HDs their closest HD is the same
	assert near_hd_id_clean == uniqueid if !mi(uniqueid)

	* remove the near unique id's from properties within historic districts 
	replace near_hd_id_clean = "" if !mi(uniqueid) 

***************
* 4: Save out *
***************

	* compress and save out
	compress
	save "${TEMP}/All_sales_processed.dta",replace

*** EOF ***
