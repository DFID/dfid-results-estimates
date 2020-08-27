# SDPResults
***

This repository contains a pipeline for processing data for DFID's headline results estimates. It will generate plots, tables and a report ready for publication (almost).  

The pipeline is written in R using the [drake](https://github.com/ropensci/drake) package (which is awesome for such things). The report is written and compiled using [knitr](https://yihui.org/knitr/) and LaTeX (xelatex to be precise). 

## Usage
Technically it should be possible to clone this repo, jump into its root directory and from the console simply run `drake::r_make()`.

*If* you have the `drake` and `packrat` packages installed, and a LaTeX distirbution on your computer, this command will (using an isolated R process):
*build a private package library load those packages  
*source all the scripts in `R/` including the drake plan (`R/plan.R`)  
*configure the environment to to run the plan   
*execute/compile the plan   

This should then output a bunch of plots to `fig/`,  an excel file to `tables/`, and a pdf to `report/` amongst other log files and things.

In practice, **this will not go so smoothly**. Our next steps with the pipeline are to bundle it all in a container with the complete environment required for it to successfully run but for now there are some prerequisite dependencies.

### Prerequisites

1. Since the report is written in LaTeX you need you have a distribution installed on your computer - probably [MiKTeX](https://miktex.org/) for Windows systems.   

2. Also assumed is that the `GDS Transport` font is installed on your system. If not it will be necessary to install it or to specify another font option in `main.Rnw`. **`GDS Transport` is a proprietary font for use on GOV.UK and permission must be sought before use.** 

3. R version >= 4.0.0 with `drake` and `packrat` installed. Alternatively, you could install all the pakckages required (see the `packages.R`script) but **be warned** if they aren't the same version there may be breaking changes between those installed here and those installed on your machine. 

4. If you don't want to use `packrat` then you must install all the packages manually **AND** remove the `packrat-setup.R` script in `R/` or make sure the script isn't sourced in `_drake.R`. 

## The Plan

This workflow is fairly typical of data analysis/report automation but here we'll try to cover some of the unique aspects of the process. It might also be useful to `vis_r_drake(the_plan)` after sourcing `_drake.R` to see the dependency graph.   

SDP results are gatherered from across DFID. The main results this pipeline deals with are those aggregated from policy departments and country office figures. There are methodologies guiding which programmes qualify to be included against a given indicator. Departments input data onto spreadsheets, which is then brought into a tab on the spreadsheet using PowerQuery. 

1. Data  
* The pipeline begins by reading in data from this tab and concatenating it for all spreadshseets. The file `data/dept_raw.csv` is that data.    

But, this is where it gets messy and we need to bring in other data.  

* Some indicators (Jobs, PFM and Access to Finance) use their own tracking systems to quality assure their data so we read these in separately. Multilateral results are also calculated and submitted separately. As are climate spend figures, ODA figures and Energy figures.    

* Family Planning results are taken over a longer time frame than the current SDP period (2015-2020) and, therefore, include dome figures from the previous results framework. This data is read in separately.      

* Centrally Managed Programmes (CMPs) are programmes managed from the centre that typically cover a wide geography. In some cases projects may overlap with those managed by country offices. In these cases we conservatively subtract a percentage of results to ensure beneficiaries are not counted twice. These data are either the country breakdowns or the actual amount to be deducted. 

* Finally we read in some accessory data which help in the processing.

2. Tidying and Filtering
* First tidy up the department data, join the multilateral data, and add some columns.  

* Data are filtered to make separate data frames for each indicatos

3. Plots
* Data are further filtered to get regional and fragility breakdowns, including percentages.   

* The plots are then made from these data

4. Tables   
* The tables are filtered and formatted ready for publication, including rounding.   

* Tables are then brought into a list of tables, including 'placeholders' for tables where data is inputted manually at a later time. 

* Tables are placed in a workbook in separate tabs , title information is added, the whole table is formatted and then output to `tables/`. The `tables_titles.csv` data governs/ is needed to complete this process, Since there a number of different table types some manual correction needs to be applied to the formatting. 

5. Report   
* First, we specify which chapters of the report we want to knit to `.tex`. To specify which chapters are compiled (they will only been knit to .tex by this point, the `main.Rnw` needs to be edited before it is knit. 

* Secondly we knit them. Each chapter will load relevant data and plot targets made in the plan from `drake`'s cache using the `loadd()` function. Any inline figures are pulled from these data using filters in `\Sexpr{}`. As figures will be output to `figs/`.   

* Finally, `main.tex` is compiled and will output a pdf and log files to `report/`. 
