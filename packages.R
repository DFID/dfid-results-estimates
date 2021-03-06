## library() calls go here
library(conflicted)
library(dplyr)
library(dotenv)
library(drake)
library(ggplot2)
library(govstyle)
library(patchwork)
library(purrr)
library(here)
library(janitor)
library(knitr)
library(lubridate)
library(magrittr)
library(openxlsx)
library(scales)
library(stringr)
library(tidyr)
library(readr)
library(rgeos)
library(forcats)
library(zoo)
library(rnaturalearth)
library(rnaturalearthdata)
library(ggrepel)
library(sf)
library(systemfonts)
library(xtable)
conflict_prefer("filter","dplyr")
conflict_prefer("data_frame", "dplyr")
