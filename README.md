# DFID Results Estimates
***

## Background
This repository contains the pipeline used for producing DFID's headline results estimates publication. It will generate the plots, tables and report as they appear on the [results estimates webpages](https://www.gov.uk/guidance/dfid-results-estimates).   

The pipeline is written in R using the [drake](https://github.com/ropensci/drake) package. The report is written and compiled using [knitr](https://yihui.org/knitr/) and XeLaTeX (for native OTF and TTF support). 

The approach is based heavily on the suggestions of Miles McBain, set out in [this](https://milesmcbain.xyz/posts/the-drake-post/) blog post.

## Aims

## Usage
If you have `drake` and `packrat` installed it should be possible to:

1. clone this repository  
2. cd to the project `root/` directory
3. run `packrat::restore()`   
4. run `packrat::init(infer.dependencies = FALSE, options = list(vcs.ignore.lib = TRUE, vcs.ignore.src = TRUE))` (additional options are not required but ensure `packrat/lib/` and `packrat/source/` are added to `.gitignore`)  
5. run `drake::r_make()`    

These commands will:
* build a private package library using the `packrat/packrat.lock` file
* initiate the packrat repository for use in the project
* load the required packages
* source scripts in `R/` including the drake plan (`R/plan.R`)  
* configure the environment to run the plan   
* execute/compile the plan using an isolated R process

This should output:
* plots in pdf format to `figs/`   
* an excel file to `tables/`   
* a pdf to `report/` 

In practice, **this may not go so smoothly**. Please raise an issue or contact [statistics@fcdo.gov.uk]() if you have any suggestions, comments, or issues.


### Prerequisites

1. Since the report is written in XeLaTeX you need to have a distribution installed on your computer - probably [MiKTeX](https://miktex.org/) for Windows systems. You don't need to worry about configuring R/RStudio to compile using XeLaTeX since we use a system call.   

2. Also assumed is that the `GDS Transport` font is installed on your system. If it isn't, it will be necessary to install it or to specify another font option in `main.Rnw`.  
> **WARNING:** `GDS Transport` is a proprietary font and is for sole use on GOV.UK: permission must be sought before use. 

3. R version >= 4.0.0. 

4. If you don't use `packrat` then you must install all the packages manually (see the `packages.R`script for a list of packages used).  
> **WARNING:** if packages are not the same version as those used to run the pipeline there may be breaking changes between versions we installed and those installed on your machine. We recommend using packrat.    



## The Plan

The plan (`R/plan.R`) is the heart of a drake pipeline and it defines each of the pipeline targets and sets out the general workflow.  

To better understand the workflow, here we briefly describe aspects of the pipeline peculiar to our project and our data. It might also be useful to `vis_r_drake(the_plan)` after sourcing `_drake.R` to view a dependency graph of the pipeline targets and how they interconnect.   

The bulk of the pipeline handles headline results estimates that are aggregated from policy department and country office programmes for a particular indicator. DFID departments and country offices input data onto template spreadsheets, which are then subject to several rounds of Quality Assurance (QA). Results that pass the QA process are brought into a 'department level' results tab on the department spreadsheet. For further information about results and how they are calculated see our [webpages](https://www.gov.uk/guidance/dfid-results-estimates).


### 1. Data  
* The pipeline begins by reading in data from the 'department level' tab and concatenating it for all department spreadsheets. In production we use the live spreadsheets as input and if you have access to these files there is an option in `R/plan.R` to use them. The file `data/dept_raw_achieved.csv` is a cold copy of that data saved at the end of the QA phase of results data collection, on Friday 7th of August 2020. However, there are differences between the cold copy and the live copy:   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1. Only achieved data is provided in the cold copy;  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2. Only the aggregated results are provided. Countries report results yearly but we do not publish annual breakdowns due to the aggregation methodologies used and time lags for some data - for more information about this please see the [results estimates webpages](https://www.gov.uk/guidance/dfid-results-estimates).

However, not all indicators use these templates and various other datasets need to be used in the pipeline.  

* Jobs, Public Financial Management and Access to Finance indicators use their own collation and QA systems so we read these in separately. Multilateral results are also calculated and submitted separately. As are Climate spend figures, ODA figures and Energy figures.    

* Family Planning results are calculated over a longer time frame than the current SDP period (2015-2020) and, therefore, include some figures from the previous results framework. This data is read in separately.      

* 'Inputs' are a set of data drawn directly from financial and programme management systems, and mainly cover spend-type indicators. 

* Centrally Managed Programmes (CMPs) are programmes managed by central DFID departments that typically cover a wide geography. In some cases programmes may overlap with bilateral programmes managed by Country Offices. In these cases we conservatively subtract a percentage of results based on potential geographic overlap to ensure beneficiaries are not counted twice. These data are either the country breakdowns yet to be deducted or the actual amount to be deducted already calculated, depending on the department submitting the data. Each of these data files has a `*_cmp.csv` suffix.

* Finally, we read in some accessory data: a lookup table for fragility level and department names, and a file containing table subtitles and names used for producing the final data tables.  

* In terms of data, this project is not large and all of the datasets required to run this pipeline, are provided in `data/`. A metadata file is also included that explains each of the variables in each dataset.    

### 2. Tidying and Filtering
* Department data are tidied, the multilateral data are joined, and some columns are added from the lookup.  

* Data are filtered to make separate data frames for each indicator.

### 3. Plots
* Indicator data are summarised into regional and fragility breakdowns, including percentages.   

* Plots are then made from these data.

### 4. Tables   
* Indicator data are formatted into tables ready for publication, including application of rounding rules (see [Technical Notes](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/911809/dfid_results-estimates_technical-notes_2015-2020.pdf)) and addition of CMP double counting deductions, if applicable.   

* Tables are inserted in a workbook in separate tabs, indicator title information is added, the whole table is formatted and then output to `tables/`. The `tables_titles.csv` data is needed to complete this process. Here we attempt to format all the tables at once but since there are a number of different table types, each with their own structure, some manual correction may need to be applied to the formatting after the spreadsheet is output. We may also manually add footnotes with important additional information.

### 5. Report   
* First, we specify which chapters of the report we want to knit to `.tex`. To specify which chapters are then *compiled* in the last step, `main.Rnw` needs to be edited **before** it is knit (though if missed this can be corrected afterwards by editing `main.tex` to `\include{}` any missed chapters)! 

* Secondly, we knit each chapter in `doc/` and `main.Rnw`. Each chapter will load relevant data and plot targets in the plan from `drake`'s cache using the `loadd()` function. Any in-line values are pulled from these data using filters in `\Sexpr{}`. Figures are also output to `figs/` so they can be used separately in other documents if required.   

* Finally, `main.tex` is compiled and will output a `.pdf` and log files to `report/`. In some cases, to ensure the table of contents, and other referenced elements are correctly compiled, it may be  necessary to `clean(c(report,compile))` and re-run  `r_make()`.  This will clean the report and compile targets from the cache and re-compile the `.pdf`. 
