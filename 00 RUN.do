********************************************************************
* Replication materials for Preserving History or Property Values: *
* Historic Preservation and Housing Prices in Washington, DC 	   *
* Author: Lev Klarnet 											   *
* Date: May 8, 2019									               *
********************************************************************

*************************
* Set Stata environment *
*************************

	clear
	set type double
	set more off
	pause on


******************
* Define globals *
******************

	* Work directory
	global SCRIPTS      = c(pwd)
	global WKDIR        = subinstr("${SCRIPTS}", "\Scripts", "", .)
	global INPUT		= "${WKDIR}\Input"
	global TEMP         = "${WKDIR}\Temp"
	global OUTPUT       = "${WKDIR}\Output"

***************
* Run scripts *
***************

	do "${SCRIPTS}/01 Initial processing.do"
	do "${SCRIPTS}/02 Create control variables.do"
	do "${SCRIPTS}/03 Process repeat sales.do"
	do "${SCRIPTS}/04 Identify activist nominated hds.do"
	do "${SCRIPTS}/05 Descriptive stats.do"
	do "${SCRIPTS}/06 Regressions.do"
	do "${SCRIPTS}/07 Store results.do"

*** EOF ***
