# DFID Results Estimates: Pipeline
***

<img src="https://github.com/DFID/dfid-results-estimates/blob/master/images/ukaid.png" width="250" height="250"/>


  - [Background](#background)
  - [Usage](#usage)
    * [Prerequisites](#prerequisites)
  - [Overview](#overview)
    * [1. Data](#1-data)
    * [2. Tidying and Filtering](#2-tidying-and-filtering)
    * [3. Plots](#3-plots)
    * [4. Tables](#4-tables)
    * [5. Report](#5-report)


## Background
This repository contains the pipeline used for producing DFID's headline results estimates publication. It will generate the plots, tables and report as they appear on the [results estimates webpages](https://www.gov.uk/guidance/dfid-results-estimates).   

The pipeline is written in R using the [drake](https://github.com/ropensci/drake) package. The report is written and compiled using [knitr](https://yihui.org/knitr/) and XeLaTeX. 

The approach is based heavily on the suggestions of Miles McBain, set out in [this](https://milesmcbain.xyz/posts/the-drake-post/) blog post.  

Please contact [statistics@fcdo.gov.uk](mailto:statistics@fcdo.gov.uk) if you have any suggestions, questions or comments. If you find any bugs or errors please raise an [issue](https://github.com/DFID/dfid-results-estimates/issues).

## Releases

Each new pipeline [release](https://github.com/DFID/dfid-results-estimates/releases) corresponds to a specific release of the results estimates publication on GOV.UK.   
Each pipeline release is also given a unique Document Object Identifier (DOI):

Publication Date | Publication Release | Pipeline DOI | 
----- | ----- | ----- | -----
27 August 2020 | [Results estimates: 2015 to 2020](https://www.gov.uk/government/publications/dfid-results-estimates-2015-to-2020) | [![DOI](https://zenodo.org/badge/254392963.svg)](https://zenodo.org/badge/latestdoi/254392963)  


## Usage
If you have `drake` and `packrat` installed it should be possible to:

1. clone this repository  
2. `cd` to the project `root/` directory
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
* plots in pdf format to [figs/](figs/)   
* an excel file to [tables/](tables/)  
* a pdf to [report/](report) 

In practice, **this may not go so smoothly**. Please ensure all [prerequisites](#prerequisites) are satisfied before raising an [issue](https://github.com/DFID/dfid-results-estimates/issues). 


### Prerequisites

1. Since the report is written in XeLaTeX you need to have a LaTeX distribution installed on your computer - probably [MiKTeX](https://miktex.org/download) for Windows systems but it should work with any distribution on any operating system. You don't need to worry about configuring R/RStudio to compile using XeLaTeX since we use a system call.   

2. The published [Sector Report](https://www.gov.uk/government/publications/dfid-results-estimates-2015-to-2020) (`report/main.pdf`) is compiled using **GDS Transport website** font.  We assume you do not have this font installed on your system since it is for proprietary use on GOV.UK. Therefore, `main.Rnw` is set to compile the document using the **TeX Gyre Heros** font. If you have **GDS Transport Website** installed on your system, and you would prefer to use this font, please see options in `main.Rnw`.    

3. R version >= 4.0.0. 

4. If you don't use `packrat` then you must install all packages, and their dependencies, manually (see the `packages.R`script for a list of packages used).  
> **WARNING:** if packages are not the same version as those used to run the pipeline there may be breaking changes between versions we installed and those installed on your machine. We recommend using packrat.    


## Overview

The plan (`R/plan.R`) is the heart of a drake pipeline and it defines each of the pipeline targets and sets out the general workflow.  

To better understand the pipeline, here, we briefly describe aspects of the workflow peculiar to our project and our data. It might also be useful to `vis_r_drake(the_plan)` after sourcing `_drake.R` to view a dependency graph of the pipeline targets and how they interconnect.   

The bulk of the pipeline handles results that are aggregated from policy department and country office programmes to produce headline results estimates for different indicators. DFID departments and country offices input data onto template spreadsheets, which are then subject to several rounds of Quality Assurance (QA). Results that pass the QA process are brought into a 'department level' results tab on the department spreadsheet. For further information about results and how they are calculated see our [webpages](https://www.gov.uk/guidance/dfid-results-estimates).


### 1. Data  
&nbsp;&nbsp;**a.** The pipeline begins by reading in data from the 'department level' tab and concatenating it for all department spreadsheets. In *production* we use the live spreadsheets as input but `data/dept_raw_achieved.csv` is a cold copy of that data saved at the end of the QA phase of results data collection, on Friday 7th of August 2020. There are important differences between the cold copy and the live copy:   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **i.** Only achieved data are provided in the cold copy   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **ii.** Only cumulative results are provided. Countries report results yearly but we do not publish annual breakdowns due to the aggregation methodologies used and time lags for some data - for more information about this please see the [results estimates webpages](https://www.gov.uk/guidance/dfid-results-estimates).

&nbsp;&nbsp;**b.** However, not all indicators use these templates and various other datasets need to be used in the pipeline:   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **i.** Jobs, Public Financial Management and Access to Finance indicators use their own collation and QA systems so we read these in separately.     
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **ii.** Multilateral results are also calculated and submitted separately.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **iii.** As are Climate spend figures, ODA figures and Energy figures.      

&nbsp;&nbsp;**c.** Family Planning results are calculated over a longer time frame than the current SDP period (2015-2020) and, therefore, include some figures from the previous results framework. This data is read in separately.      

&nbsp;&nbsp;**d.** *Inputs* are a set of data drawn directly from financial and programme management systems, and mainly cover spend-type indicators. 

&nbsp;&nbsp;**e.** Centrally Managed Programmes (CMPs) are programmes managed by central DFID departments that typically cover a wide geography. In some cases programmes may overlap with bilateral programmes managed by country offices. In these cases we conservatively subtract a percentage of results based on potential geographic overlap to ensure beneficiaries are not counted twice. These data are either the CMP country breakdowns yet to be deducted or the actual amount to be deducted already calculated, depending on the department submitting the data. Each of these data files has a `*_cmp_discount.csv` suffix.

&nbsp;&nbsp;**f.** Finally, we read in some accessory data:    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **i.** lookup table for fragility level and department names.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **ii.** table subtitles and names used for producing the final data tables.    

&nbsp;&nbsp;**g.** In terms of data, this project is not large and all of the datasets required to run this pipeline are provided in `data/`. A metadata file is also included that explains each of the variables in each dataset.    

### 2. Tidying and Filtering
&nbsp;&nbsp;**a.** Department data are tidied, the multilateral data are joined, and some columns are added from the lookup.  

&nbsp;&nbsp;**b.** Data are filtered to make separate data frames for each indicator.

### 3. Plots   
&nbsp;&nbsp;**a.** Indicator data are summarised into regional and fragility breakdowns.   

&nbsp;&nbsp;**b.** Plots are then made from these data. Plots are all stored as targets in `drake`'s cache and output separately when chapters are knit, except  for Family Planning plots which are written to `figs` at this stage. This is so its easier to group *Total* and *Additional* plots together with a single caption in the final report.

### 4. Tables   
&nbsp;&nbsp;**a.** Indicator data are formatted into tables ready for publication, including application of rounding rules (see [Technical Notes](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/911809/dfid_results-estimates_technical-notes_2015-2020.pdf)) and addition of CMP double counting deductions, if applicable.   

&nbsp;&nbsp;**b.** Tables are inserted in a workbook in separate tabs, indicator title information is added (from `tables_titles.csv`), the whole table is formatted and then output to `tables/`. Here we attempt to format all the tables at once but since there are a number of different table types, each with their own structure, some manual correction may need to be applied to the formatting after the spreadsheet is output. 
> **NOTE:** We may also manually add footnotes with important additional information. The [official publication](https://www.gov.uk/guidance/dfid-results-estimates) should be consulted for this important context.

&nbsp;&nbsp;**c.** The published data tables use **GDS Transport Website** font, which we assume is not installed on most systems. The function `R/formatTables()` takes a boolean to specify whether tables should be output using **GDS Transport website** and by default is set to `FALSE`. Tables should be output in **Arial** on Windows,  **Helvetica** on Mac, and the default sans-serif font on Linux (**DejaVu Sans** on Ubuntu).

### 5. Report   
&nbsp;&nbsp;**a.** All sweave files (`*.Rnw`) in `doc/` and `main.Rnw` are knit to `.tex`.     
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **i.** Each chapter will load relevant data and plot targets in the plan from `drake`'s cache using the `loadd()` function in a code chunk.    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **ii.** In-line values are filtered from these data using `\Sexpr{}`.   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **iii.** Figures are output to `figs/` so they can be used separately in other documents if required.   

&nbsp;&nbsp;**b.** Finally, `main.tex` is compiled, which will output `main.pdf` and log files to `report/`. These  are useful for debugging LaTeX compilation errors. In some cases, to ensure the table of contents and other reference elements are correctly compiled, it may be  necessary to `clean(compile)` and re-run  `r_make()`.  This will clean the compile target from the cache and re-compile `main.pdf`
