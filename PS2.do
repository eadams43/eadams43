********************************************************************************
* Author: Emily Adams

* Date: 02/18/2026

* HBS302: PS2

* Data Set: ps1_final_dataset.dta (turned into an accessible link)

* Abstract: I am using my previously merged data set from PS1. However, as shown in the Do File, I reduced this dataset down to its last 6 rows in order for the charts to be less cluttered.
********************************************************************************

********************************************************************************
* 1. Preliminaries 
********************************************************************************
clear
set matsize 800
version 19.5
set more off
set varabbrev off

**Setting working directory and opening log 
cd "/Users/emilyadams/Downloads/HBS302/PS2"
capture log close
log using "ps2_log.smcl", replace 

********************************************************************************
* 2. Dataset
********************************************************************************

* Importing Dataset
import delimited "https://drive.google.com/uc?export=download&id=1zwhHJ83jqB3Qj9IZGvtSeZAlDXvlthe0" , varnames(1)rowrange(47)

* Changing the labels to make the future charts cleaner
replace state = "VT" if state == "Vermont"
replace state = "VA" if state == "Virginia"
replace state = "WA" if state == "Washington"
replace state = "WV" if state == "West Virginia"
replace state = "WI" if state == "Wisconsin"
replace state = "WY" if state == "Wyoming"

save ps2_final_dataset.dta, replace
********************************************************************************
* 3. Exploring Data
********************************************************************************

* Summary of statistics of dataset
summarize snap_households
* Mean of snap_household=95284.5; SD=157577.2
summarize snap_ratio
* Mean of snap_ratio=.1115681; SD=.0421505
summarize birthtodeath_ratio
* Mean of birthtodeath_ratio=.9916667; SD=.2308607

********************************************************************************
* 4. Generate Tables
********************************************************************************

**Frequency Table
tabulate snap_ratio 
* Shows how frequent each value appears in the dataset. In this set, each value only appears once, which is why the total percent is 100, with each value having 1 for its frequency and 16.67 for its percent.

**Cross Tabulation
tab snap_ratio birthtodeath_ratio
* Analyzes the relationship between two categorical variables to show any trend or association between the two. The totals for each variable are 1, which means there is not a relationship between the two.

********************************************************************************
* 5. Data Visualization 
********************************************************************************

**Bar Chart: used to compare the mean birthtodeath_ratio and snap_ratio in each of these 6 states
graph bar birthtodeath_ratio snap_ratio, over(state) /// 
title("Comparing Snap Ratio to Birth to Death Ratio Across States") ///
ytitle("Ratio") ///
bar(1, color(navy)) ///
bar(2, color(pink))

graph export PS2_bar.png, replace

**Pie Chart: used to divide up the percentage of households that use SNAP benefits between the 6 states.
use ps2_final_dataset.dta, replace
set scheme white_tableau

graph pie snap_ratio, over(state) ///
title("Snap Ratio in States (by Household)") ///
plabel(_all percent, format(%4.1f))

graph export PS2_pie.png, replace 

**Summary
* The bar chart helped me to visually compare how the means of birthtodeath_ratios compare to the means of snap_ratio in the six states from the dataset.
* The pie chart helped me to visualize what percent of households use SNAP benefits.








