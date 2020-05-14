#install.packages("packrat", repos = "https://cran.rstudio.com/")
#packrat::init(
#  infer.dependencies = FALSE,
#  enter = TRUE,
#  restart = FALSE)

### Setup repositories ###

# Install packages that install packages.
install.packages("remotes", repos = "https://cran.rstudio.com/")

# Set repos.
my_repos <- vector()
my_repos["CRAN"] <- "https://cran.rstudio.com/"
options(repos = my_repos)

### Install CRAN packages ###
cran_packages <- c(
  "lubridate",
  "janitor",
  "conflicted",
  "knitr",
  "rmarkdown",
  "here",
  "dotenv",
  "drake",
  "tidyverse",
  "magrittr",
  "dplyr",
  "zoo",
  "stringr",
  "ggplot2"
)

install.packages(cran_packages)

### Install github packages ###
github_packages <- c(
  "ukgovdatascience/govstyle"
)

remotes::install_github(github_packages)

# gt needs to be installed at a specific commit to deal with a bug
# https://github.com/rstudio/gt/issues/280
remotes::install_github("rstudio/gt", ref = "51a812ba6a10769bd24e01c82a3e1b7de44a5a40")

### Take snapshot ###

packrat::snapshot(
  snapshot.sources = FALSE,
  ignore.stale = TRUE,
  infer.dependencies = FALSE)
