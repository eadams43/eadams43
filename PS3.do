********************************************************************************
* Author: Emily Adams

* Date: 03/04/2026

* HBS302: PS3

* Data Set: ps1_final_dataset.dta (turned into an accessible link)

* Project Title: Predicting State Birth to Death Ratio Using SNAP Household Ratio 

* Abstract: I am using my previously merged data set from PS1. I am using a linear regression model to determine if there if a state's birth to death ratio has an effect on the ratio of SNAP households. 
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
cd "/Users/emilyadams/Desktop/HBS302"
capture log close
log using "ps3_log.smcl", replace 

********************************************************************************
* 2. Dataset
********************************************************************************

* Importing Dataset
import delimited "https://drive.google.com/uc?export=download&id=1zwhHJ83jqB3Qj9IZGvtSeZAlDXvlthe0" ,

********************************************************************************
* 3. Regression Model and Visualizing Relationships
********************************************************************************

* IV (x): birthtodeath_ratio
* DV (y): snap_ratio
regress snap_ratio birthtodeath_ratio

*Hypothesis: I hypothesize that if a state has a higher rate of births to deaths, then they will have a correlating high ratio of households that receive SNAP benefits. 
*Interpreting model: with a T value of -2.13, this is stastically significant. However, the negative coefficient of the birthtodeath_ratio indicates that as this variable increases, the snap_households variable decreases.

*Scatterplot with fitted regression line
twoway (scatter snap_ratio birthtodeath_ratio) (lfit snap_ratio birthtodeath_ratio) , ///
ytitle("snap_ratio")  ///
title("Linear Regression of Birth to Death Ratio and SNAP Household Ratio")

*Comparing plot with regression: This plot aligns with my regression table. the fitted line slope is negative and downward sloping, which aligns with the negative coeffient. The R squared value isalso small, which is reflected in how scattered the points are on the graph and how they do not tightly align with the fitted line.
 

********************************************************************************
* 3. Visualize Predicted Values
********************************************************************************
reg snap_ratio c.birthtodeath_ratio

*Simple OLS Regression
margins, at(birthtodeath_ratio=(.05(.05).20))

marginsplot, ///
    title("Predicted SNAP Ratio by Birth to Death Ratio") ///
    ytitle("Predicted SNAP Ratio") ///
    xtitle("Birth to Death Ratio") ///
    graphregion(color(white)) plotregion(color(white))

*The margins plot indicates that as the birth-to-death ratio increases, predicted ratio of households with SNAP  decreases. This may suggest that areas experiencing population growth are more economically stable and do not have as many households with receive SNAP, while areas with population decline may have greater reliance on food assistance with SNAP.

reg snap_ratio birthtodeath_ratio
eststo m1

esttab m1
esttab m1 using results.rtf, ///
se ///
star(* 0.10 ** 0.05 *** 0.01) ///
replace

*Model 1 and the regression estimates the relationship between the birth-to-death ratio and SNAP household participation. The coefficient on the birth-to-death ratio is negative and statistically significant. This indicates that areas with higher birth-to-death ratios tend to have lower SNAP participation rates. This suggests that high birth-to-death rations are indicators of demographic growth, is associated with reduced reliance on SNAP benefits. The visualization helped with my understanding because I originally hypothesized that high birth-to-death ratios would correlate with high ratios of households with SNAP benefits. The next step could be adding a control, like unemployment rate or median income.











