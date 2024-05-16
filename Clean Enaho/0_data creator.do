**********************************************************************************************
*ENAHO (1997-2018)
*Authors: Josting Kitmang, Sebastian Sardon	(based on code by Fernando Aragon and Juan Pablo Rud)
*Last updated: June 16, 2019
*Cleans ENAHO raw data
*Inputs: ENAHO raw data - modules 1, 2, 3, 5, 85, and 'sumaria'
*Output:
	*A single .dta file
*Running Time: Around 2 minutes
**********************************************************************************************

clear all
set more off
*Set path to the root of working directory
    global	ccc_cloud   "E:\Box\Research\Synthetic Panel\Peru\ENAHO\Data\ENAHO_1997-2018"
	global	ccc_git		"E:\GitHub\ENAHO"
*Set path to folder containing do-files
    global ccc_dofiles "${ccc_git}/Clean Raw ENAHO"
*Set path to raw data folder
    global ccc_in      "${ccc_cloud}"
*Set path to output folder
    global ccc_out     "${ccc_git}/Out"

*Runtime: around 1.2 minutes
cd "${ccc_git}"

timer on 1
foreach i in 1 2 3 5{
    if `i' == 5 qui do "$ccc_dofiles/4_prepare_`i'00.do"
	else        qui do "$ccc_dofiles/`i'_prepare_`i'00.do"
	di "prepare module `i'00 DONE"
	}
	
qui do "$ccc_dofiles/5_prepare_ethnicity.do"
di     "prepare ethnicity DONE"

qui do "$ccc_dofiles/6_prepare_sumaria.do"
di     "prepare modulo sumaria DONE"

qui do "$ccc_dofiles/7_merge_hhs.do"
qui do "$ccc_dofiles/8_merge_individuals.do"
di "merge DONE"

save "$ccc_out/1997-2018.dta", replace

*To clear temproary files, uncomment line in loop
local trash_files: dir "Trash" files "*.dta"
foreach file of local trash_files{
*	erase "Trash/`file'"
	}
timer off 1
timer list

