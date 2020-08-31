# SDPResults
***

This repository contains the pipeline used for creating DFID's headline results estimates publication. It will generate plots, tables and a report ready for publication (almost).   

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

3. R version >= 4.0.0. 

4. If you don't want to use `packrat` then you must install all the packages manually (see the `packages.R`script). **If** you do this you must remove the `packrat_setup.R` script `root/` or make sure the script isn't sourced in `_drake.R`. **WARNING:** if packages are not the same version as we used to run the pipeline there may be breaking changes between those we installed and those installed on your machine. We recommend using packrat.    



## The Plan

Here we cover some of aspects of the processing, peculiar to our setup. It might also be useful to `vis_r_drake(the_plan)` after sourcing `_drake.R` to view a dependency graph of the pipeline targets and how they connect with each other.   

Headline results data are gathered from across DFID. The main results this pipeline deals with are those aggregated from policy departments and country office programmes, rather than single value figures such as spend. Departments input data onto individial spreadsheets containing separate tabs for each indicator. Data from these tabs, which pass internal Quality Assurance (QA), are then concatenated into another tab on the spreadsheet using PowerQuery. 

All data are located in `data/`.

### 1. Data  
* The pipeline begins by reading in data from this tab and concatenating it for all department spreadsheets. During the commissioning of results data collection we use the live spreadsheets as input. If you have access to these files there is an option in `R/plan.R` to use them. The file `data/dept_raw.csv` is a cold copy of that data saved at the end of the QA phase of results data collection, on Friday 7th of August 2020.    

But, this is where it gets messy and we need to bring in other data.  

* Jobs, Public Financial Management and Access to Finance indicators use their own tracking systems to QA their data so we read these in separately. Multilateral results are also calculated and submitted separately. As are Climate spend figures, ODA figures and Energy figures.    

* Family Planning results are calculated over a longer time frame than the current SDP period (2015-2020) and, therefore, include some figures from the previous results framework. This data is read in separately.      

* Centrally Managed Programmes (CMPs) are programmes managed from the centre that typically cover a wide geography. In some cases programmes may overlap with bilateral programmes managed by country offices. In these cases we conservatively subtract a percentage of results based on potential geographic overlap to ensure beneficiaries are not counted twice. These data are either the country breakdowns yet to be deducted or the actual amount to be deducted already calculated. Each of these data files has a `_cmp.csv` suffix.

* Finally we read in some accessory data which help in the processing.   

* A metadata file is also included in `data/` that explains each of the variables in each dataset. 

### 2. Tidying and Filtering
* First, department data are tidied, the multilateral data are joined, and some columns are added from the lookup.  

* Data are filtered to make separate data frames for each indicator.

### 3. Plots
* Indicator data are further summarised into regional and fragility breakdowns, including percentages.   

* Plots are then made from these data.

### 4. Tables   
* Indicator data are formatted into tables ready for publication, including application of rounding rules and addition of double counting deductions if applicable.   

* Tables are then brought into a list of tables, including 'place-holders' for tables where data is inputted manually at a later time (these are mainly spend or other "input" indicators which are mostly single values). The `tables_titles.csv` data is needed to complete this process.  

* Tables are placed in a workbook in separate tabs, title information is added, the whole table is formatted and then output to `tables/`. Here we attempt to format all the tables at once, but since there a number of different table types, each with their own structure, some manual correction needs to be applied to the formatting after the spreadsheet is output.

### 5. Report   
* First, we specify which chapters of the report we want to knit to `.tex`. To specify which chapters are *compiled* in the last step, `main.Rnw` needs to be edited **before** it is knit (though if missed this can be corrected afterwards by editing `main.tex` to `\include{}` any missed chapters)! 

* Secondly, we knit each chapter in `doc/` and `main.Rnw`. Each chapter will load relevant data and plot targets in the plan from `drake`'s cache using the `loadd()` function. Any in-line values are pulled from these data using filters in `\Sexpr{}`. Figures will be output to `figs/`.   

* Finally, `main.tex` is compiled and will output a pdf and log files to `report/`. 
