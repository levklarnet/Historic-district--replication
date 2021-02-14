* Descriptive stas

use "$temp/reg_ready.dta", clear

* INSTALL ESTOUT TO EXPORT DISCRIPTIVE STATS
ssc install estout, replace

* Get descriptive stats for full sample, only in HD*post, and not HD*post
* Descriptive stats for RESIDENTIAL ONLY
local residential_vars stories kitchens Dcndt*
* Descriptive Statistics
estpost tabstat `residential_vars', by(hd_ever) statistics(count mean sd min max median) columns(statistics) listwise
esttab using "$output/raw_descriptive_stat_residential.csv", replace cells("count mean sd min max p50")

* Descriptive stats for FUll SAMPLE 
local sample_vars price bedrm bathrm hf_bathrm gba landarea age ayb fireplaces hardwood_floor metro_close Dac town* sf multi semi_detached condo Dheat* 
* Descriptive Statistics
estpost tabstat `sample_vars', by(hd_ever) statistics(count mean sd min max median) columns(statistics) listwise
esttab using "$output/raw_descriptive_stat_fullsample.csv", replace cells("count mean sd min max p50")

* EOF
