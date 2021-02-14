** Descriptive Statistics for repeat sales data

use "$temp/repeatsales_reg_ready.dta", clear

* INSTALL ESTOUT TO EXPORT DISCRIPTIVE STATS
ssc install estout, replace

* Get descriptive stats for repeat sales sample
local repeat_sales price_chg saledate_chg post_desig_i hd_chg hd_chg_condo hd_chg_sf hd_chg_multi hd_chg_semi_detached hd_chg_town_end hd_chg_town_inside hd_buff_250feet_i hd_buff_250f_chg spring_chg fall_chg summer_chg saleyear_92_chg saleyear_93_chg saleyear_94_chg saleyear_95_chg saleyear_96_chg saleyear_97_chg saleyear_98_chg saleyear_99_chg saleyear_00_chg saleyear_01_chg saleyear_02_chg saleyear_03_chg saleyear_04_chg saleyear_05_chg saleyear_06_chg saleyear_07_chg saleyear_08_chg saleyear_09_chg saleyear_10_chg saleyear_11_chg saleyear_12_chg saleyear_13_chg saleyear_14_chg saleyear_15_chg saleyear_16_chg saleyear_17_chg saleyear_18_chg saleyear_19_chg
* Descriptive Statistics
estpost tabstat `repeat_sales', statistics(count mean sd min max median) columns(statistics) listwise
esttab using "$output/raw_descriptive_stat_repeatsales.csv", replace cells("count mean sd min max p50")


*EOF
