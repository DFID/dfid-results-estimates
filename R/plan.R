the_plan <-
  drake_plan(

#### load data ----

## remote dept data from dept data tab in each template
#template_path = "C:/Users/c-baillie/DFID/Results Teamsite - Documents",
#dept_raw = readDeptData(template_path),
## local dept data already concatenated
dept_raw = read_csv("data/dept_raw.csv"),

## local data (other)
a2f_raw = read_csv("data/a2f.csv") %>%
          select(Department, `Project Title`, Female, Male, Total) %>%
          group_by(Department) %>%
          mutate(Department = recode(Department, PSD="Private Sector", ISD="Inclusive Societies")) %>%
          clean_names(.),

jobs_raw = read_csv("data/jobs.csv") %>%
          select(-Prog) %>%
          group_by(Office)  %>%
          summarise_all(sum) %>%
          pivot_longer(.,
               cols=c("male", "female", "results"),
               names_to=c("gender" ),
               values_to="results"
            ) %>%
          rename(department="Office") %>%
          mutate(gender=recode(gender, results="total")) %>%
          mutate(department = recode(department, PSD="Private Sector")),

energy = read_csv("data/energy.csv") %>%
  pivot_longer(.,
               cols=c(`2015/16`:`2019/20`),
               names_to = c("year"),
               values_to="energy"),

climate_spend = read_csv("data/climate_spend.csv"),

multilat = read_csv("data/multilat.csv"),

family_drf = read_csv("data/family_drf.csv"), # don't clean names to keep year col format

oda_gni = read_csv("data/sid_oda_annual.csv") %>% clean_names(.),

pfm = read_csv("data/pfm.csv") %>% select(dept,`2015/16`:`2019/20`) %>% replace(is.na(.), "-"),

# cmp discounts
family_total_cmp = read_csv("data/family_total_cmp_discount.csv"),

family_additional_cmp = read_csv("data/family_additional_cmp_discount.csv"),

education_cmp = read_csv("data/education_cmp_discount.csv") %>% clean_names(.),

nutrition_cmp = read_csv("data/nutrition_cmp_discount.csv") %>% clean_names(.),

# accessory stuff
tables_titles = read_csv("data/table_titles.csv"),
lookup = read_csv("data/dept_lookup.csv"),



#### format deptarment data ----
dept  = tidyDept(dept_raw, multilat, lookup),


#### indicator dataframes  -----

a2f = filterA2F(a2f_raw),

education = filterEducation(dept),

fp_total = filterFPTotal(dept),

fp_additional = filterFPAdditionalTotals(dept, family_drf),

fp_additional_plots = filterFPAdditionalBreakdown(dept, family_drf),

jobs = filterJobsGender(jobs_raw),

humanitarian = filterHumanitarian(dept),

nutri_gender  = filterNutritionGender(dept),

nutri_intensity = filterNutritionIntensity(dept),

wash = filterWASH(dept),


#### plots ----

### plot data frames

#a2f
a2f_region_data =  regionDataA2F(a2f_raw, lookup),

#education
edu_fragility_data  = education %>%
  filter(department!="Total" & department!="Double Counting") %>%
  group_by(fragility) %>%
  summarise(results=sum(total)) %>%
  mutate(perc=(results/sum(results))*100) %>%
  mutate(fragility= fct_relevel(fragility, c("Extremely Fragile", "Fragile", "Not Fragile","Not Identified"))),

edu_region_data  = education %>%
  filter(department!="Total") %>%
  group_by(region) %>%
  summarise(results=sum(total)) %>%
  mutate(perc=(results/sum(results))*100) %>%
  filter(results!=0),

#family
fp_total_fragility_data = fp_total %>%
  filter(Department!="Total") %>%
  group_by(Fragility) %>%
  summarise(results=sum(Average)) %>%
  mutate(perc=(results/sum(results))*100) %>%
  filter(results!=0)%>%
  mutate(Fragility= fct_relevel(Fragility, c("Extremely Fragile", "Fragile", "Not Fragile","Not Identified"))),

fp_total_region_data = fp_total %>%
  filter(Department!="Total") %>%
  group_by(Region) %>%
  summarise(results=sum(Average)) %>%
  mutate(perc=(results/sum(results))*100) %>%
  filter(results!=0),

fp_additional_fragility_data = fp_additional_plots %>%
  filter(department!="Total") %>%
  group_by(fragility) %>%
  summarise(results=sum(total)) %>%
  mutate(perc=(results/sum(results))*100) %>%
  filter(results!=0)%>%
  mutate(fragility= fct_relevel(fragility, c("Extremely Fragile", "Fragile", "Not Fragile","Not Identified"))),

fp_additional_region_data = fp_additional_plots %>%
  filter(department!="Total") %>%
  group_by(region) %>%
  summarise(results=sum(total)) %>%
  mutate(perc=(results/sum(results))*100) %>%
  filter(results!=0),

# humanitarian
human_fragility_data  = humanitarian %>%
  filter(department!="Total") %>%
  group_by(fragility) %>%
  summarise(results=sum(total)) %>%
  mutate(perc=(results/sum(results))*100)%>%
  mutate(fragility= fct_relevel(fragility, c("Extremely Fragile", "Fragile", "Not Fragile","Not Identified"))),

human_region_data  = humanitarian %>%
  filter(department!="Total") %>%
  group_by(region) %>%
  summarise(results=sum(total)) %>%
  mutate(perc=(results/sum(results))*100) %>%
  filter(results!=0),

#jobs
jobs_region_data = regionDataJobs(jobs_raw, lookup),

#nutrition
nutrition_fragility_data  = nutri_gender %>%
  group_by(fragility) %>%
  summarise(results=sum(total)) %>%
  mutate(perc=(results/sum(results))*100) %>%
  mutate(fragility= fct_relevel(fragility, c("Extremely Fragile", "Fragile", "Not Fragile","Not Identified"))),

nutrition_intensity_data  = nutri_intensity %>%
  filter(department!="Total") %>%
  ungroup() %>%
  select(low,medium,high,not_identified, total) %>%
  select(-total) %>%
  clean_names("title") %>%
  pivot_longer(cols=everything(),
               names_to = "intensity") %>%
  group_by(intensity) %>%
  summarise(results=sum(value)) %>%
  mutate(perc=(results/sum(results))*100) %>%
  mutate_at(vars(intensity), as.factor) %>%
  mutate(intensity= fct_relevel(intensity, c("High", "Medium", "Low","Not Identified"))),

nutrition_region_data  = nutri_gender %>%
  filter(department!="Total") %>%
  group_by(region) %>%
  summarise(results=sum(total)) %>%
  mutate(perc=(results/sum(results))*100) %>%
  filter(results!=0),

#wash
wash_fragility_data  = wash %>%
  filter(department!="Total") %>%
  group_by(fragility) %>%
  summarise(results=sum(total)) %>%
  mutate(perc=(results/sum(results))*100)%>%
  mutate(fragility= fct_relevel(fragility, c("Extremely Fragile", "Fragile", "Not Fragile","Not Identified"))),

wash_region_data  = wash %>%
  filter(department!="Total") %>%
  group_by(region) %>%
  summarise(results=sum(total)) %>%
  mutate(perc=(results/sum(results))*100) %>%
  filter(results!=0),


### plots
a2f_region_plot = plotA2FRegion(a2f_region_data),

climate_spend_plot = plotClimateSpend(climate_spend),

edu_frag_plot = plotEduFragility(edu_fragility_data),
edu_region_plot  =  plotEduRegion(edu_region_data),

energy_cumulative_plot = plotEnergyCumulative(energy),

fp_total_frag_plot = plotFPTotalFragility(fp_total_fragility_data),
fp_total_region_plot  = plotFPTotalRegion(fp_total_region_data),
fp_additional_frag_plot  = plotFPAdditionalFragility(fp_additional_fragility_data),
fp_additional_region_plot = plotFPAdditionalRegion(fp_additional_region_data),

human_frag_plot = plotHumanFragility(human_fragility_data),
human_region_plot = plotHumanRegion(human_region_data),

jobs_region_plot = plotJobsRegion(jobs_region_data),

nutrition_frag_plot = plotNutritionFragility(nutrition_fragility_data),
nutrition_region_plot = plotNutritionRegion(nutrition_region_data),
nutrition_intensity_plot = plotNutritionIntensity(nutrition_intensity_data),

oda_gni_plot = plotOdaGni(oda_gni),

pfm_plot =  plotPFM(pfm),

wash_frag_plot = plotWASHFragility(wash_fragility_data),
wash_region_plot = plotWASHRegion(wash_region_data),




#### Tables ----

a2f_table = a2f %>% clean_names("title"),


energy_table = energy %>%
               filter(type=="Annual") %>%
               pivot_wider(.,
                  names_from = c("year"),
                  values_from="energy"
                ) %>%
               select(-type),


education_table =  education %>%
                   add_row(department="Double Counting", # add in double counting
                            fragility="-",
                            region="-",
                            male=0,
                            female=0,
                            not_identified=0,
                            total= unlist(
                                        left_join(education, education_cmp, by="department") %>%
                                        mutate(min = pmin(total.x, total.y)) %>%
                                        ungroup() %>%
                                        summarise_at(vars(min),sum, na.rm=T))*-1) %>%
                   adorn_totals() %>%
                   mutate_if(is.numeric, roundChoose, 1000) %>%
                   mutate_if(is.numeric, ~(
                            case_when(
                                      department=="Total" ~ roundChoose(.,100000),
                                      TRUE~.
                                      )
                                          )
                            ) %>%
                  clean_names("title"),


fp_total_table = fp_total %>%
                 add_row(
                   Department="Double Counting",
                   Fragility="-",
                   Region="-",
                   `2015/16`=unlist(family_total_cmp[1]),
                   `2016/17`=unlist(family_total_cmp[2]),
                   `2017/18`=unlist(family_total_cmp[3]),
                   `2018/19`=unlist(family_total_cmp[4]),
                   `2019/20`=unlist(family_total_cmp[5]),
                   Average = mean(unlist(family_total_cmp))
                    ) %>%
                add_row(
                  Department="Total",
                  Fragility="-",
                  Region="-",
                  `2015/16`=sum(.$`2015/16`),
                  `2016/17`=sum(.$`2016/17`),
                  `2017/18`=sum(.$`2017/18`),
                  `2018/19`=sum(.$`2018/19`),
                  `2019/20`=sum(.$`2019/20`),
                  Average = NA #add totals manually then swap out total avg.
                  ) %>%
                mutate(Average = replace_na(Average, mean(unlist(.[nrow(.),4:8])))) %>%
                mutate_if(is.numeric, ~(
                  case_when(
                    Department!="Inclusive Societies" ~ roundChoose(.,1000),
                    TRUE~.
                  )
                )
                ) %>%
               mutate_if(is.numeric, ~(
                  case_when(
                    Department=="Inclusive Societies" ~ roundChoose(.,100),
                    TRUE~.
                  )
                )
                ) %>%
                mutate_if(is.numeric, ~(
                            case_when(
                                      Department=="Total" ~ roundChoose(.,100000),
                                      TRUE~.
                                      )
                                         )
                            ), #!!! don't clean_names or year col_names will mess up !!!


fp_additional_table = fp_additional %>%
                      mutate_if(is.numeric, ~(
                                  case_when(
                                    str_detect(Indicator, "-20") ~ .+unlist(family_additional_cmp),
                                    TRUE~.
                                            )
                                              )
                      ) %>%
                    add_row(Indicator="Total Additional Users",
                            Total = sum(.$Total)
                            ) %>%
                      mutate_if(is.numeric,  roundChoose, 100000) %>%
                      clean_names("title"),


humanitarian_table = humanitarian %>%
                     mutate_if(is.numeric, roundChoose, 1000) %>%
                     mutate_if(is.numeric, ~(
                     case_when(
                          department=="Total" ~ roundChoose(.,100000),
                          TRUE~.)
                                            )
                              ) %>%
                     clean_names("title"), #double counting already included in figures so nothing to add


jobs_table = jobs %>% clean_names("title"),


nutrition_table = nutri_gender %>%
                  ungroup() %>%
                  add_row(department="Double Counting", # add in double counting
                          fragility="-",
                          region="-",
                          male=NA,
                          female=NA,
                          not_identified=NA,
                          total=unlist(summarize_if(nutrition_cmp, is.numeric, sum, na.rm=TRUE))  *-1) %>%
                          replace(.,is.na(.),0) %>%
                  mutate_at(vars(not_identified), ~(
                        case_when(
                                  department=="Multilateral" ~ total,
                                  TRUE~.
                                  )
                                                    )
                            ) %>%
                  mutate_if(is.numeric, roundChoose, 1000) %>%
                  adorn_totals() %>%
                  mutate_if(is.numeric, ~(
                        case_when(
                                  department=="Total" ~ roundChoose(.,100000),
                                  TRUE~.
                                  )
                                                    )
                            ) %>%
                  clean_names("title"),


pfm_table = pfm  %>%
  mutate_at(vars(`2015/16`), ~( #these countries were not included in the Caribbean in 2015/16
    case_when(
      `2015/16` %in% c("Belize",
                  "Dominica",
                  "Grenada",
                  "Guyana",
                  "Jamaica",
                  "Suriname",
                  "Saint Lucia",
                  "St Vincent & the Grenadines",
                  "Haiti",
                  "Montserrat") ~ "-",
      TRUE~.
    )
  )
  ) %>%
  add_row(dept="Total",
          `2015/16`=as.character(length(unique(.$`2015/16`))-1),
          `2016/17`=as.character(length(unique(.$`2016/17`))-1),
          `2017/18`=as.character(length(unique(.$`2017/18`))-1),
          `2018/19`=as.character(length(unique(.$`2018/19`))-1),
          `2019/20`=as.character(length(unique(.$`2019/20`))-1)
          ) %>%
  mutate(dept = recode(dept, "-"="")) %>%
  rename(Department="dept"),


wash_table = wash %>%
  mutate_if(is.numeric, roundChoose, 1000) %>%
  adorn_totals("row") %>%
  mutate_if(is.numeric, ~(
    case_when(
      department=="Total" ~ roundChoose(.,100000),
      TRUE~.
    )
  )
  ) %>%
  clean_names("title"), # no double counting to added


# Make all the tables into a list. If there are 'missing' tables or ones being
# brought in from elsewhere you need to include them in the right order as the
# data in 'tables_titles.csv'. Here its just named tibbles.
tables_list = list(a2f_table,
                 tibble("CDC"), #named tibble of 'missing' or 'to be added manually' table
                 tibble("Climate Finance"), #named tibble of 'missing' or 'to be added manually' table
                 tibble("Dev Cap"), #named tibble of 'missing' or 'to be added manually' table
                 education_table,
                 energy_table,
                 fp_total_table,
                 fp_additional_table,
                 tibble("FCAS"),
                 humanitarian_table,
                 tibble("Immunisations"),
                 tibble("Improving Tax"),
                 tibble("Investment in the Multilateral System"),
                 jobs_table,
                 tibble("Malaria: Spend"),
                 tibble("Neglected Tropical Diseases: Spend"),
                 tibble("Neglected Tropical Diseases"),
                 nutrition_table,
                 tibble("Official Development Assistance (ODA)"),
                 tibble("Portfolio Quality Index"),
                 tibble("Private Sector Investment"),
                 tibble("Polio"),
                 pfm_table,
                 wash_table),


#### Output Tables ----

tables = makeTables(lst_data = tables_list, tables_titles = tables_titles), #NEED TO ADD warning/error message: will error if nrow tables titles != length tables list


#### Report ----

## knit .Rnw
sections = c(
               "doc/titlepage/titlepage",
               "doc/frontmatter/frontmatter",
               "doc/intro/intro",
               "doc/a2f/a2f",
               "doc/cdc/cdc",
               "doc/climate/climate",
               "doc/devcap/devcap",
               "doc/education/education",
               "doc/energy/energy",
               "doc/ntd/ntd",
               "doc/family/family",
               "doc/fcas/fcas",
               "doc/humanitarian/humanitarian",
               "doc/immunisation/immunisation",
               "doc/tax/tax",
               "doc/multi/multi",
               "doc/jobs/jobs",
               "doc/malaria_spend/malaria_spend",
               "doc/ntd_spend/ntd_spend",
               "doc/ntd/ntd",
               "doc/nutrition/nutrition",
               "doc/oda/oda",
               "doc/pqi/pqi",
               "doc/private/private",
               "doc/polio/polio",
               "doc/pfm/pfm",
               "doc/wash/wash",

               "main"
),


report = knitAll(files=sections),

compile = system("xelatex main.tex --output-directory=report --aux-directory=report")

)


