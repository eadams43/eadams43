********************************************************************************
* Author: Emily Adams

* Date: 02/04/2026

* HBS302: PS1

* Data Set #1: ACSST1Y2023.S2201-Data from the U.S. Census Bureau 

* Data Set #2: Birth to Death Ratio, by State from the CDC

* Abstract: The first dataset from the U.S. Census Bureau provides information about the households that received SNAP benefits in 2023. The second dataset from the CDC provides the ratio of births to deaths in each state. These datasets could be useful when investigating if there is a causal or correlational relationship between the number of households that receive food stamps and between the ratio of births to deaths in each state.
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
cd "/Users/emilyadams/Downloads/HBS302"
capture log close
log using "ps1_log.smcl", replace 


********************************************************************************
* 2. Dataset #1
********************************************************************************

* Importing Dataset #1
import delimited "https://drive.google.com/uc?export=download&id=13yCoC17B2uCpGu0QgOIe8Y99bdEvBqPo" ,varnames(1) rowrange(3) clear 

* Cleaning Dataset #1 
describe
list in 1/10
ds s2201_*

* Cutting unnecessary variables
keep geo_id name s2201_c01_001* s2201_c03_001*
drop *m

*Naming and labeling variables
rename s2201_c01_001e total_households
label variable total_households "Total number of households"

rename s2201_c03_001e snap_households
label variable snap_households "Households that receieve SNAP benefits"

*Destringing Variables
destring total_households, replace ignore(",") force
destring snap_households, replace ignore (",") force

*Generating new variable- ratio of snap households to regular
gen snap_ratio = snap_households / total_households

*Further cleaning up dataset
drop total_households
drop snap_households

*Saving clean dataset 
save "ps1_dataset_1clean.dta" , replace

********************************************************************************
* 3. Dataset #2
********************************************************************************

*Import Dataset #2
import delimited "https://drive.google.com/uc?export=download&id=17zs9Io_o4CMy5LNqqWPXmrI-cD7M7sdr" ,varnames(1) rowrange(3) clear

* Cleaning Dataset #2
keep if year == 2023
drop colorcode
describe
list in 1/10

* Creating a new variable of states and changing abbreviations to the full state name in order to match Dataset #1 and make it easier to merge
gen name = ""
replace name = "Alabama" if location == "AL"
replace name = "Alaska" if location == "AK"
replace name = "Arizona" if location == "AZ"
replace name = "Arkansas" if location == "AR"
replace name = "California" if location == "CA"
replace name = "Colorado" if location == "CO"
replace name = "Connecticut" if location == "CT"
replace name = "Delaware" if location == "DE"
replace name = "District of Columbia" if location == "DC"
replace name = "Florida" if location == "FL"
replace name = "Georgia" if location == "GA"
replace name = "Hawaii" if location == "HI"
replace name = "Idaho" if location == "ID"
replace name = "Illinois" if location == "IL"
replace name = "Indiana" if location == "IN"
replace name = "Iowa" if location == "IA"
replace name = "Kansas" if location == "KS"
replace name = "Kentucky" if location == "KY"
replace name = "Louisiana" if location == "LA"
replace name = "Maine" if location == "ME"
replace name = "Maryland" if location == "MD"
replace name = "Massachusetts" if location == "MA"
replace name = "Michigan" if location == "MI"
replace name = "Minnesota" if location == "MN"
replace name = "Mississippi" if location == "MS"
replace name = "Missouri" if location == "MO"
replace name = "Montana" if location == "MT"
replace name = "Nebraska" if location == "NE"
replace name = "Nevada" if location == "NV"
replace name = "New Hampshire" if location == "NH"
replace name = "New Jersey" if location == "NJ"
replace name = "New Mexico" if location == "NM"
replace name = "New York" if location == "NY"
replace name = "North Carolina" if location == "NC"
replace name = "North Dakota" if location == "ND"
replace name = "Ohio" if location == "OH"
replace name = "Oklahoma" if location == "OK"
replace name = "Oregon" if location == "OR"
replace name = "Pennsylvania" if location == "PA"
replace name = "Rhode Island" if location == "RI"
replace name = "South Carolina" if location == "SC"
replace name = "South Dakota" if location == "SD"
replace name = "Tennessee" if location == "TN"
replace name = "Texas" if location == "TX"
replace name = "Utah" if location == "UT"
replace name = "Vermont" if location == "VT"
replace name = "Virginia" if location == "VA"
replace name = "Washington" if location == "WA"
replace name = "West Virginia" if location == "WV"
replace name = "Wisconsin" if location == "WI"
replace name = "Wyoming" if location == "WY"

* Cleaning dataset
drop location 

save "ps1_dataset_2clean.dta" , replace

********************************************************************************
* 4. Merging the Datasets
********************************************************************************

* Merge
use "ps1_dataset_1clean.dta" , clear
merge 1:1 name using "ps1_dataset_2clean.dta"
tab _merge

* Cleaning after merge
keep if _merge ==3
drop _merge

* Cleaning other variables
rename name state
rename birthtodeathratio birthtodeath_ratio
label variable snap_ratio "Ratio of snap households to total"

save "ps1_merge_dataset.dta" , replace

********************************************************************************
* 5. Exploring the Merged Dataset
********************************************************************************

* Table of general information about the dataset
describe 

* Summary of statistics of dataset
* Mean of snap_ratio is .114, SD is .034
* Mean of birthtodeath_ratio is 1.137, SD is .256
summarize


********************************************************************************
* 6. Exporting the Merged Dataset
********************************************************************************

* Exporting as a .dta
use "ps1_merge_dataset.dta" , clear
save "ps1_final_dataset.dta" , replace

* Exporting as a .csv
export delimited using "ps1_final_dataset.csv", replace

* Exporting as an .xslx
export excel using "ps1_final_dataset.xlsx", ///
    firstrow(variables) replace

log close
