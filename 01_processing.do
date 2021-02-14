*** 01 script for initial cleaning ***

* import and save out csv CODED OUT FOR TIME
*import delimited using "$input/Prop_HD_near_metro.csv", clear
*compress
*save "$temp/Housing_HD_metro_buf.dta",replace
 
use "$temp/Housing_HD_metro_buf.dta", clear

* drop useless variables
drop objectid_* field1 shape* gis* hit* designat_* edit* statu* name* national* latitude longitude

* clean sale dates
gen sale_month = substr(saledate,1,2)
gen sale_data_long = substr(saledate,1,10) if sale_month == "10" | sale_month == "11" | sale_month == "12"
gen sale_data_short = substr(saledate,1,9) if sale_month != "10" & sale_month != "11" & sale_month != "12"
replace sale_data_long = trim(sale_data_long)
replace sale_data_short = trim(sale_data_short)
gen saledate_clean = date(sale_data_long,"MDY")
replace saledate_clean = date(sale_data_short,"MDY") if !mi(sale_data_short)
format saledate_clean %td
assert !mi(saledate_clean) if !mi(saledate)
assert mi(saledate_clean) if mi(saledate)
drop sale_data_* saledate sale_month

* drop if missing sale price or sale date
drop if mi(price) | mi(saledate_clean) | dist_to_hd == -1

* make sure no buffers include observations inside of HDs
gen hd = 1 if !mi(trim(label))
* assert that distance to nearest HD worked
assert dist_to_hd > 0 if mi(hd) 
assert dist_to_hd == 0 if hd == 1
assert dist_to_hd != 0 if mi(hd)

* rename key variables
rename near_fid metro_id
rename near_dist dist_to_metro

* match near hd to uniqueid for merge 
bysort hd_id(uniqueid): gen near_hd_id_clean = uniqueid[_N]

* fix special cases with no home sales 
replace near_hd_id_clean = "D_030" if hd_id == 4
replace near_hd_id_clean = "D_071" if hd_id == 15

* Read in and save out HD years
preserve
	import delimited using "$input/hd_year.csv", clear
	* clean HD years
	drop if mi(month)
	gen desig_year = mdy(month,day,year)
	format desig_year %td
	drop year month day
	rename uniqueid near_hd_id_clean
	save "$temp/hd_year.dta",replace
restore

* merge HD years onto data
merge m:1 near_hd_id_clean using "$temp/hd_year.dta"
drop if _m == 2 | (_m == 1 & !mi(label))
drop _m

* assert for all homes sold in HDs their closest HD is the same
assert near_hd_id_clean == uniqueid if !mi( uniqueid)
* remove the near unique id's from near 
replace near_hd_id_clean = "" if !mi(uniqueid) 

* compress and save out
compress
save "$temp/Housing_HD_metro_buf_clean.dta",replace

*EOF
