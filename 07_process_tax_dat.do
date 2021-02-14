* READ IN TAX ASSESSEMNT DATA

*import delimited using "$input/DC_tax_dept_real_estate_geocoded (1).csv", clear
*compress
*save "$temp/DC_tax_raw.dta", replace

* IMPORT MAIN DATASET TO CLEAR FOR MERGE
use "$temp/Housing_HD_metro_buf_clean.dta",clear

	* delete the 26 duplicates
	duplicates tag ssl, gen(dups)
	drop if dups == 1
	isid ssl 
	* remove all spaces from ssl
	replace ssl = subinstr(ssl," ","",.)
save "$temp/main_repeatsales.dta", replace
 
* import repeat sales data
use "$temp/DC_tax_raw.dta", clear
* clean dates
gen saledate_taxes = daily(recordationdate, "MDY")
format saledate %td

rename squaresuffixlot ssl
rename saleprice price_taxes
* remove all spaces from ssl
replace ssl = subinstr(ssl," ","",.)

* merge on main dataset
merge m:1 ssl using "$temp/main_repeatsales.dta"
drop if _m != 3
drop _m

* create repeat sales dummy variable
gen repeat_sale = 1 if saledate_clean != saledate_taxes & price_taxes != 0 & price != 0

drop if mi(repeat_sale)

save "$temp/repeat_sales.dta", replace

*EOF
