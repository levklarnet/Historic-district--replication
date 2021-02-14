*** 02 script for variable cleaning ***

use "$temp/Housing_HD_metro_buf_clean.dta",clear

isid objectid

* create variable for post designation
gen daysbetween = saledate_clean - desig_year if hd == 1
gen post_desig = 1 if daysbetween > 0 & hd == 1
replace post_desig = 0 if mi(post_desig)

*create interaction term between hd and post
gen post_hd = post_desig * hd
replace post_hd = 0 if mi(post_hd)
replace hd = 0 if mi(hd)

*clean sale years
gen saleyear = year(saledate_clean)
gen salemonth = month(saledate_clean)
drop if saleyear < 1992

* DROP ABOVE THE 99 TH PERCENTILE OR BELOW THE 1ST IN EACH YEAR
foreach n in Condominium Residential {
	forval i = 1992/2018 {
		sum price if saleyear==`i' & source == "`n'",de
		drop if price <r(p1) & saleyear == `i' & source == "`n'"
		drop if price >r(p99)& saleyear == `i' & source == "`n'"
	}
}

* drop crazy high outliers
drop if price > 10000000 

sum price , de

* create age variable
gen age = max(0,saleyear - eyb)
sum age,de

* clean gba and living gba
assert !mi(living_gba) if source == "Condominium"
assert !mi(gba) if source == "Residential"
assert mi(gba) if source == "Condominium"
assert mi(living_gba) if source == "Residential"
replace gba = living_gba if mi(gba)
drop living_gba
assert !mi(gba)

* clean gba and lot size
local list gba landarea
foreach n in Condominium Residential {
	foreach i of local list {
		drop if `i' == 0
		sum `i' if source == "`n'",de
		drop if `i' <r(p1) & source == "`n'"
		drop if `i' >r(p99) & source == "`n'"
	}
}	
* drop missing bedrooms and larger than 10 bedrooms
drop if bedrm > 10 | bedrm == 0 
drop if bathrm > 10 | bathrm == 0 
replace hf_bathrm = 0 if hf_bathrm == .

* clean other control variables
gen Dac = 1 if ac == "Y"
replace Dac = 0 if mi(Dac)
drop ac

* create head type dummy variables
gen Dheat_forceair = 1 if heat == "Forced Air"
gen Dheat_hotwaterrad = 1 if heat == "Hot Water Rad"
gen Dheat_htpump = 1 if heat == "Ht Pump"
gen Dheat_warmcool = 1 if heat == "Warm Cool"
foreach i of varlist Dheat* {
	replace `i' = 0 if mi(`i')
}


* clean stories variable
drop if stories > 5 & source == "Residential"
drop if stories == 0 & source == "Residential"

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

* create condition dummy variables
tab cndtn, gen(Dcndtn)
drop Dcndtn7

* create dummy hardwood
gen hardwood_floor = 1 if intwall == "Hardwood" | intwall == "Hardwood/Carp" | intwall == "Wood Floor"
replace hardwood_floor = 0 if mi(hardwood_floor)

* clean kitchens
drop if kitchens > 10 & source == "Residential"

* clean fireplaces
drop if fireplaces > 7 & source == "Residential"

*convert meters to feet
replace dist_to_metro = dist_to_metro * 3.28084
replace dist_to_hd = dist_to_hd * 3.28084

* create close to metro dummy if house is within 500f of metro 
gen metro_close = 1 if dist_to_metro <= 500
replace metro_close = 0 if mi(metro_close)

* create dummy buffer variable if house is within 250f of hd
* create variable for buffer post designation
gen post_desig_buf = 1 if saledate_clean > desig_year & hd == 0
replace post_desig_buf = 0 if mi(post_desig_buf)

gen hd_buff_250f_ever = 1 if dist_to_hd <= 250 & hd == 0
replace hd_buff_250f_ever = 0 if mi(hd_buff_250f_ever)

gen hd_buff_250f_post = 1 if dist_to_hd <= 250 & post_desig_buf != 0 
replace hd_buff_250f_post = 0 if mi(hd_buff_250f_post)

* log home price and age 
gen lprice = log(price)
* WHERE AGE ==0 ( NEW PROPERTIES )

* create age^2
gen age2 = age*age

* CREATE LOG SF VARIABLE
gen lgba = log(gba)

* CREATE LOG LANDAREA VARIABLE
gen log_landarea = log(landarea)

* CREATE MONTHLY DUMMY VARIABLES
tab salemonth, gen(Dsalemonth)
drop Dsalemonth12
* You need to do similar analysis with every other covariate .
* CREATING DUMMY VARIABLES FOR EACH YEAR CATEGORY :
tab saleyear, gen(Dsaley)
* rename years so I don't go crazy 
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

* create neighborhood dummy variables
tab assessment_nbhd, gen(Dassessment_nbhd)
* omit Woodridge
drop Dassessment_nbhd56

* create condo dummy
gen condo = 1 if source == "Condominium"
replace condo = 0 if mi(condo)

* create neighborhood time trends 
*foreach i of varlist Dassessment* {
*	foreach n of varlist Dsaleyear* {
*		gen `i'_`n' = 1 if `i' == 1 & `n' == 1
*		replace `i'_`n' = 0 if mi(`i'_`n')
*	}
*}
* ALTERNATIVELY CREATE ID TERM THAT MULTIPLIES YEAR BY NEIGHBORHOOD
*tostring saleyear, gen(str_year)
*gen heighborhood_year_fe = str_year + assessment_nbhd

* create yearly dummies interacted with hd and hd_post 
*foreach i of varlist Dsaley* {
*	gen post_hd_`i' = 1 if `i' == 1 & post_desig == 1
*	replace post_hd_`i' = 0 if mi(post_hd_`i')
*}
*foreach i of varlist Dsaley* {
	* dummies for hd ever per year
*	gen hd_ever_`i' = 1 if `i' == 1 & hd == 1
*	replace hd_ever_`i' = 0 if mi(hd_ever_`i')
*}

* rename hd to hd_ever for clarity
rename hd hd_ever

* create seasonal variables where spring Mar-May, summer June-Aug, fall Sept-Nov
gen spring = 1 if Dsalemonth3 == 1 | Dsalemonth4 == 1 | Dsalemonth5 == 1
gen summer = 1 if Dsalemonth6 == 1 | Dsalemonth7 == 1 | Dsalemonth8 == 1
gen fall = 1 if Dsalemonth9 == 1 | Dsalemonth10 == 1 | Dsalemonth11 == 1

* create decade dummies
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


compress 
save "$temp/reg_ready.dta", replace

* EOF	
