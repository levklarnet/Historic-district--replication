********************************************************************
* Replication materials for Preserving History or Property Values: *
* Historic Preservation and Housing Prices in Washington, DC 	   *
* Author: Lev Klarnet 						   *
* Date: May 8, 2019					           *
********************************************************************

* In this script, I store the results of my regressions in an Excel file.

local reg full_sample_nt residential_nt repeat_sales_nt act_residential_nt act_full_sample_nt act_repeat_sales_nt act_repeat_sales_ols repeat_sales_ols
	foreach i of local reg {
		estimates use "${TEMP}/`i'.ster"
		global stored_results ""

		* R2
		local n_obs = `e(N)'
		local n_obs_tsln "Number of observations"
		local R2 = `e(r2)'
		local R2_tsln "R-squared"
		local R2a = `e(r2_a)'	
		local R2a_tsln "R-squared (adjusted)"
		global stored_results "${stored_results} n_obs R2 R2a"

		* AIC/BIC
		estat ic
		matrix IC = r(S)
		local aic = IC[1,5]
		local aic_tsln "AIC"
		local bic = IC[1,6]
		local bic_tsln "BIC"
		global stored_results "${stored_results} aic bic"				


		clear
		set obs 1
		gen stat_name = ""
		label var stat_name "Statistic"
		gen stat_value = .
		label var stat_value "Value"
		foreach v of global stored_results {
			replace stat_name = "``v'_tsln'" if _n == _N
			replace stat_value = ``v'' if _n == _N
			local Nobs_plus1 = _N + 1
			set obs `Nobs_plus1'
		}
		drop if _n == _N

		gen id = _n
		save "${TEMP}/stats_`i'.dta", replace

		****************************************************************
		* COEFFICIENTS
		****************************************************************

		clear
		estimates use "${TEMP}/`i'.ster"

		mat coefficients = e(b)'
		svmat coefficients
		rename coefficients* coefficients

		local varnames: rownames coefficients
		gen varnames = ""
		gen std_errors = .
			
		forvalues jj=1/`: word count `varnames'' {
	  		replace varnames =`"`: word `jj' of `varnames''"' in `jj'
			local varname = varnames[`jj']
			replace std_errors = _se[`varname'] in `jj'	  
		}		
		order varnames
		gen t_stats = coefficients/std_errors
		gen p_value = 2*ttail(e(df_r),abs(t_stat))
		label var coefficients "Coefficients"
		label var varnames "Variable names"
		label var t_stats "t-statistics"
		label var p_value "p-value"

		gen fl_omitvar = missing(t_stats)
		gen obs_n = _n
		sort fl_omitvar obs_n
		drop fl_omitvar obs_n

		gen id = _n
		merge 1:1 id using "${TEMP}/stats_`i'.dta", nogen
		drop id
		gen exp_id = "${exp_id}"

		label var exp_id "Sensitivity ID"
		order exp_id
		drop exp_id
		save "${TEMP}/reg_`i'", replace
		export excel using "${OUTPUT}/Regression.xlsx", sheet("raw.`i'") sheetreplace firstrow(var) 
	}

*** EOF ***

