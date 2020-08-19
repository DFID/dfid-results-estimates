# SDPResults
***

This repository contains a pipeline for gathering and calculating figures for DFID headline results and to generate plots, tables and report (almost) ready for publication.  

The pipeline is written in R using the [drake]{https://github.com/ropensci/drake} package (which is awesome for such things). The report is written and compiled using Sweave/LaTeX (xelatex to be precise). 

## Usage
Technically it should be possible to clone this repo, jump into its root directory and from the console simply run `drake::r_make()`.

If you have the `drake` and `packrat` packages installed, and a LaTeX distirbution on your computer, this command will (using an isolated R process):
*build a private package library including all necessary packages 
*read the drake plan
*execute the plan

This should then output a bunch of plots to  `fig/`,  an excel file to `tables/`, and a pdf to `report/` amongst other log  files and things.

In practice, this will not go so smoothly. The next step bundle this all in a container with the complete environment required, but for now there are some prerequisite dependencies.

## Prerequisites

1. Since the report is written in Sweave/Latex you need you have a Latex distribution installed on your computer - probably MikTex for Windows systems.   

2. Also assumed is that the `GDS Transport` foont is installed on your system. If not it will be necessary to install it, or to specify another `font` option in `main.Rnw`. `GDS Transport` is proprietary for use on GOV.UK and permission must be sought before use. 

3. R version >= 4.0.0 with `drake` and `packrat` installed. Alternatively, you could install all the pakckages required but be warned if they aren't the same version there may be breaking changes between those installed here and those installed on your machine. 

## The Plan

Here we'll try to describe the plan. It might also be useful to `vis_r_drake(the_plan)` after sourcing `_drake.R` to see the dependency graph.   

SDP results are gatherered from across DFID. The main results this pipeline deals with are those aggregated from policy department and country office figures. There are methodologies guiding which programmes qualify to be included against a given indicator. Departments input data onto spreadsheets, which is then brought into a tab on the spreadsheet using individual cell references in a long format. The pipeline begins by reading in data from this tab and concatenating it for all spreadshseets. The file `data/dept__raw.csv` is that data.    

But, this is where it gets messy and we need to bring in other data. Some indicators (Jobs, PFM and Access to Finance) use their own trackers to QA the data so we reead these in separately. Multilateral results are also calculated and submitted separately, as are climate spend  figures, ODA annual figures and Energy figures.  