# SDPResults
***

This repository contains a pipeline for processing data for DFID's headline results estimates. It will generate plots, tables and a report ready for publication (almost).   

The pipeline is written in R using the [drake](https://github.com/ropensci/drake) package. The report is written and compiled using [knitr](https://yihui.org/knitr/) and LaTeX (xelatex to be precise). 

The general workflow is based heavily on the suggestions of Miles McBain, set out in [this](https://milesmcbain.xyz/posts/the-drake-post/) blog post.


## Usage
Technically it should be possible to:

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
* execute/compile the plan (using an isolated R process)

This should output:
* a bunch of plots to `fig/`   
* an excel file to `tables/`   
* a pdf to `report/` 

In practice, **this will not go so smoothly**. Our next steps with the pipeline are to bundle it all in a container with the complete environment required for it to successfully run but for now there are some prerequisite dependencies.

### Prerequisites

1. Since the report is written in LaTeX you need you have a distribution installed on your computer - probably [MiKTeX](https://miktex.org/) for Windows systems.   

2. Also assumed is that the `GDS Transport` font is installed on your system. If not it will be necessary to install it or to specify another font option in `main.Rnw`. **This font is proprietary for sole use on GOV.UK: permission must be sought before use.** 

3. R version >= 4.0.0. Alternatively, you could manually install all the packages required 

4. If you don't want to use `packrat` then you must install all the packages manually (see the `packages.R`script). **If** you do this you must remove the `packrat-setup.R` script in `R/` or make sure the script isn't sourced in `_drake.R`. Also, **be warned** that if packages are not the same version as we used to run the pipeline there may be breaking changes between those we installed and those installed on your machine. 



## The Plan

The whole workflow is fairly typical of a data analysis/report automation project but here we'll try to cover some of the unique aspects of the process. It might also be useful to `vis_r_drake(the_plan)` after sourcing `_drake.R` to see the dependency graph.   

Headline results data are gathered from across DFID. The main results this pipeline deals with are those aggregated from policy departments and country office programmes. Departments input data onto individial spreadsheets containing separate tabs for each indicator. These tabs are then concatenated into another tab on the spreadsheet using PowerQuery. 

### 1. Data  
* The pipeline begins by reading in data from this tab and concatenating it for all department spreadsheets. The file `data/dept_raw.csv` is a cold copy of that data saved on Friday 7th of August 2020.    

But, this is where it gets messy and we need to bring in other data.  

* Jobs, Public Financial Management and Access to Finance indicators use their own tracking systems to quality assure their data so we read these in separately. Multilateral results are also calculated and submitted separately. As are climate spend figures, ODA figures and Energy figures.    

* Family Planning results are calculated over a longer time frame than the current SDP period (2015-2020) and, therefore, include some figures from the previous results framework. This data is read in separately.      

* Centrally Managed Programmes (CMPs) are programmes managed from the centre that typically cover a wide geography. In some cases projects may overlap with those managed by country offices. In these cases we conservatively subtract a percentage of results to ensure beneficiaries are not counted twice. These data are either the country breakdowns yet to be deducted or the actual amount to be deducted already calculated. 

* Finally we read in some accessory data which help in the processing.   

* A metadata file is included in `data/` that explains each of the variables in each dataset. 

### 2. Tidying and Filtering
* First tidy up the department data, join the multilateral data, and add some columns.  

* Data are filtered to make separate data frames for each indicators

### 3. Plots
* Data are further filtered to get regional and fragility breakdowns, including percentages.   

* The plots are then made from these data

### 4. Tables   
* The tables are filtered and formatted ready for publication, including application of rounding rules.   

* Tables are then brought into a list of tables, including 'place-holders' for tables where data is inputted manually at a later time (these are mainly spend or other "input" indicators which are mostly single values).

* Tables are placed in a workbook in separate tabs, title information is added, the whole table is formatted and then output to `tables/`. The `tables_titles.csv` data governs/ is needed to complete this process, Since there a number of different table types eahc with their own structure some manual correction needs to be applied to the formatting after output. 

### 5. Report   
* First, we specify which chapters of the report we want to knit to `.tex`. To specify which chapters are *compiled* in the last step, `main.Rnw` needs to be edited **before** it is knit (though if missed this can be corrected after by editing `main.tex` to `\include` chapters)! 

* Secondly, we knit each chapter and `main.Rnw`. Each chapter will load relevant data and plot targets in the plan from `drake`'s cache using the `loadd()` function. Any in-line figures are pulled from these data using filters in `\Sexpr{}`. Figures will be output to `figs/`.   

* Finally, `main.tex` is compiled and will output a pdf and log files to `report/`. 
