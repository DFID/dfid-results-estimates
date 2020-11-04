if(!require("packrat")){
  install.packages("packrat", repos = "https://cran.rstudio.com/")
   library(remotes)
 }

packrat::init(
   infer.dependencies = FALSE,
   enter = TRUE,
   restart = FALSE)

#### Setup repositories ----

# Install packages that install packages.
install.packages("remotes", repos = "https://cran.rstudio.com/")

# Set repos.
my_repos <- vector()
my_repos["CRAN"] <- "https://cran.rstudio.com/"
options(repos = my_repos)

#### Install CRAN packages ----
 cran_packages <- c(
   "conflicted",
   "dplyr",
   "dotenv",
   "drake",
   "ggplot2",
   "govstyle",
   "patchwork",
   "purrr",
   "here",
   "janitor",
   "knitr",
   "lubridate",
   "magrittr",
   "openxlsx",
   "scales",
   "stringr",
   "tidyr",
   "readr",
   "rgeos",
   "forcats",
   "zoo",
   "rnaturalearth",
   "rnaturalearthdata",
   "ggrepel",
   "sf",
   "systemfonts",
   "xtable"
)

install.packages(cran_packages)

#### Install github packages ----
 github_packages <- c(
   "ukgovdatascience/govstyle"
 )

remotes::install_github(github_packages)


#### Take snapshot ----

packrat::snapshot(
   snapshot.sources = FALSE,
   ignore.stale = TRUE,
   infer.dependencies = FALSE)
