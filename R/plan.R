the_plan <-
  drake_plan(

## load template data
# remote
education_raw <- readEducation("Z:"),
family_raw <- readFamily("Z:"),
humanitarian_raw <- readHumanitarian("Z:"),
nutrition_raw <- readNutrition("Z:"),
pfm_raw <- readPFM("Z:"),
a2f_raw <- readA2F("Z:"),
#dept_raw <- readDeptData("Z:")
# local
jobs <- read_csv("jobs.csv"),
multilat <- read_csv("data/multilat.csv"),
lookup <- read_csv("data/dept_lookup.csv"),

## format data
education_tidy <- tidyEducation("Z:"),
family_tidy <- tidyFamily("Z:"),
humanitarian_tidy <- tidyHumanitarian("Z:"),
nutrition_tidy <- tidyNutrition("Z:"),
pfm_tidy <- tidyPFM("Z:"),
a2f_tidy <- tidyA2F("Z:"),

## cat data
master <- bind_rows(education_tidy, family_tidy, humanitarian_tidy, nutrition_tidy, pfm_tidy, a2f_tidy, jobs, multilat),

## filter data

## plots

## tables
# write(line,file="myfile",append=TRUE) # will have to append xtable to files somehow with captions etc in the right places. maybe a func to grep out the correct lines.

## knit .Rnw
knit2tex(""),

## compile .tex
system("xelatex.exe doc/main.tex")

)


