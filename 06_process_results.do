* this scipt processes the results

use "$temp/reg_full_sample", clear
	
	gen count = _n
	keep if count > 29 & count < 80
	
	gen year = count + 1962 if count < 38
	replace year = count + 1963 if count > 37 & count < 56
	replace year = count + 1938 if count > 55 & count < 62
	replace year = count + 1939 if mi(year)
	* identify which variables are yearly or hd year
	gen hd_post_year = "_hd_year" if count > 55
	replace hd_post_year = "_year_only" if mi(hd_post_year)
	
	drop varnames stat_name stat_value count
	reshape wide coefficients std_errors t_stats p_value, i(year) j(hd_post_year) string
	
	
	preserve 
		import excel using "$input/year.xlsx", firstrow clear
		save "$temp/year.dta", replace
	restore 
	
	merge m:1 year using "$temp/year.dta"
	drop _m
	
	replace coefficients_hd_year = 0 if year == 2000
	replace coefficients_year_only = 0 if year == 2000
	sort year
	keep coefficients* year
	
	* calculate the added difference between the two
	gen hd_effect = coefficients_hd_year + coefficients_year_only
	
	* gen index
	gen i_year = 100*2.71828^coefficients_year_only
	gen i_hd_year = 100*2.71828^hd_effect


	* graph
	tw(scat i_year i_hd_year year),xtitle(Year) ytitle(Index) title("Washington DC: Regression Index Home Sale Prices" "(`i': Index Year 2000 = 100)") 
	graph export "$graph/index_reg_`i'.emf",replace

	* determine average return
	gen return = ((i/i[_n-1])-1)*100
	
	* graph return
	tw(scat return year),xtitle(Year) ytitle(Return) title("Fairfax County: Average Return" "`i'") 
	graph export "$graph/return_`i'.emf",replace

	
	sum return,de 
	return list
	putexcel set "$output/return.xlsx", sheet("r.`i'",replace) modify
	putexcel A1 = "`i'"
	putexcel B1 = "return"
	putexcel A2 = "mean"
	putexcel B2 = `r(mean)'
	putexcel A3 = "sd"
	putexcel B3 = `r(sd)'
	
}
*EOF
