* this scripts cleans the repeat sales dataset

use "$temp/repeat_sales.dta", clear

* create initial sale dates and prices
gen saledate_i = saledate_clean if saledate_clean < saledate_taxes
replace saledate_i = saledate_taxes if saledate_clean > saledate_taxes
assert !mi(saledate_i)
gen price_i = price if saledate_clean < saledate_taxes
replace price_i = price_taxes if saledate_clean > saledate_taxes
assert !mi(price_i)

* create initial and final sale dates and prices
gen saledate_f = saledate_taxes if saledate_clean == saledate_i
replace saledate_f = saledate_clean if saledate_taxes == saledate_i
assert !mi(saledate_f)
gen price_f = price_taxes if saledate_clean == saledate_i
replace price_f = price if saledate_taxes == saledate_i
assert !mi(price_f)

format saledate_* %td

* create variable for post designation for sales i and f
gen daysbetween_i = saledate_i - desig_year if hd == 1
gen post_desig_i = 1 if daysbetween_i > 0 & hd == 1
replace post_desig_i = 0 if mi(post_desig_i)
* create variable for post designation for sales f
gen daysbetween_f = saledate_f - desig_year if hd == 1
gen post_desig_f = 1 if daysbetween_f > 0 & hd == 1
replace post_desig_f = 0 if mi(post_desig_f)

* create HD_change variable 
gen hd_chg = 1 if post_desig_f == 1 & post_desig_i == 0
replace hd_chg = 0 if mi(hd_chg)

* remove if remodeled 
drop if yr_rmdl > year(saledate_i) & yr_rmdl < year(saledate_f)

*clean sale years
gen saleyear_i = year(saledate_i)
gen salemonth_i = month(saledate_i)
gen saleyear_f = year(saledate_f)
gen salemonth_f = month(saledate_f)

* create age variable
gen age_i = max(0,saleyear_i - eyb)
gen age_f = max(0,saleyear_f - eyb)

* clean gba and living gba
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

* create close to metro dummy if house is within 500f of metro 
gen metro_close = 1 if dist_to_metro <= 500
replace metro_close = 0 if mi(metro_close)

* create dummy buffer variable if house is within 250f of hd
* create variable for buffer post designation for i sales
replace hd = 0 if mi(hd)
gen daysbetween_buf_i = saledate_i - desig_year if hd == 0
gen post_desig_buf_i = 1 if daysbetween_buf_i > 0 & hd == 0
replace post_desig_buf_i = 0 if mi(post_desig_buf_i)

gen hd_buff_250feet_i = 1 if dist_to_hd <= 250 & post_desig_buf_i != 0 
replace hd_buff_250feet_i = 0 if mi(hd_buff_250feet_i)

* create dummy buffer variable if house is within 250f of hd
* create variable for buffer post designation for f sales
gen daysbetween_buf_f = saledate_f - desig_year if hd == 0
gen post_desig_buf_f = 1 if daysbetween_buf_f > 0 & hd == 0
replace post_desig_buf_f = 0 if mi(post_desig_buf_f)

gen hd_buff_250feet_f = 1 if dist_to_hd <= 250 & post_desig_buf_f != 0 
replace hd_buff_250feet_f = 0 if mi(hd_buff_250feet_f)

* create buffer change variable
gen hd_buff_250f_chg = 1 if hd_buff_250feet_f == 1 & hd_buff_250feet_i == 0
replace hd_buff_250f_chg = 0 if mi(hd_buff_250f_chg)

* drop saleyears before 1992
drop if saleyear_i < 1992

* create saleyear dummies
tab saleyear_i, gen(Dsaley_i)

* rename years so I don't go crazy 
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

* create final sale yearly dummies
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

* create seasonal dummies
local type i f
foreach n of local type {
	gen spring_`n' = 1 if month(saledate_`n') == 3 | month(saledate_`n') == 4 | month(saledate_`n') == 5
	gen summer_`n' = 1 if month(saledate_`n') == 6 |  month(saledate_`n') == 7 |  month(saledate_`n') == 8
	gen fall_`n' = 1 if  month(saledate_`n') == 19 |  month(saledate_`n') == 10 |  month(saledate_`n') == 11
}

* create condo dummy
gen condo = 1 if source == "Condominium"
replace condo = 0 if mi(condo)

* create change months
local seasons spring fall summer
foreach i of local seasons {
	gen `i'_chg = 1 if `i'_f == 1
	replace `i'_chg = -1 if `i'_i == 1
	replace `i'_chg = 0 if mi(`i'_chg)
}
* create change years
local years 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19
foreach i of local years {
	gen saleyear_`i'_chg = 1 if Dsaley`i'_f == 1
	replace saleyear_`i'_chg = -1 if Dsaley`i'_i == 1
	replace saleyear_`i'_chg = 0 if mi(saleyear_`i'_chg)
}

* create change price
gen price_chg = log(price_f)-log(price_i)

* create change in sale data
gen saledate_chg = saledate_f - saledate_i 

* create time variable t 
gen t = saledate_chg 

* clean housing type
gen town_inside = 1 if struct == "Town Inside" | struct == "Row Inside"
gen town_end = 1 if struct == "Town End" | struct == "Row End"
gen sf = 1 if struct == "Single"
gen multi = 1 if struct == "Multi"
gen semi_detached = 1 if struct == "Semi-Detached"
* replace housing type to 0 if not
foreach i of varlist town_inside town_end sf multi semi_detached {
	replace `i' = 0 if mi(`i')
}

* create post_desig housing type variables
local hs_types condo sf multi semi_detached town_end town_inside
foreach hs_type of local hs_types {
	gen hd_chg_`hs_type' = hd_chg * `hs_type'
	gen hd_buff_250f_chg_`hs_type' = hd_buff_250f_chg * `hs_type'
}

* get rid of outliers
summ price_chg if condo == 1,de
drop if price_chg < r(p1) & condo == 1
drop if price_chg > r(p99) & condo ==1

summ price_chg if condo ==0,de
drop if price_chg < r(p1) & condo == 0
drop if price_chg > r(p99) & condo ==0


save "$temp/repeatsales_reg_ready.dta", replace

* EOF


