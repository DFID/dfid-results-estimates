the_plan <-
  drake_plan(

## load data
education_raw <- readEducation("Z:"),
family_raw <- readFamily("Z:"),
humanitarian_raw <- readHumanitarian("Z:"),
nutrition_raw <- readNutrition("Z:"),
pfm_raw <- readPFM("Z:"),
a2f_raw <- readA2F("Z:"),

## format data

## cat data

## filter data

## plots

## tables
# write(line,file="myfile",append=TRUE) # will have to append xtable to files somehow with captions etc in the right places. maybe a func to grep out the correct lines.

## knit .Rnw
knit2tex(""),

## compile .tex
system("xelatex.exe doc/main.tex")

)


