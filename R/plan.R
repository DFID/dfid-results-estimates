the_plan <-
  drake_plan(

#### Load data ----

## remote dept data from dept data tab in each template
#template_path = "",
#dept_raw = readDeptData(template_path),

## local dept data already concatenated
dept_raw = read_csv(file_in("data/dept_raw_achieved.csv")),


## local data (other)
a2f_raw = read_csv(file_in("data/a2f.csv")) %>%
          select(Department, `Project Title`, Female, Male, Total) %>%
          group_by(Department) %>%
          mutate(Department = recode(Department, PSD="Private Sector", ISD="Inclusive Societies")) %>%
          clean_names(.),

climate_spend = read_csv(file_in("data/climate_spend.csv")),

energy = read_csv(file_in("data/energy.csv")) %>%
               pivot_longer(.,
               cols=c(`2015/16`:`2019/20`),
               names_to = c("year"),
               values_to="energy"),

family_drf = read_csv(file_in("data/family_drf.csv")), # don't clean names to keep year col format

inputs = read_csv(file_in("data/inputs.csv")),

jobs_raw = read_csv(file_in("data/jobs.csv")) %>%
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

multilat = read_csv(file_in("data/multilat.csv")),

oda_gni = read_csv(file_in("data/sid_oda_annual.csv")) %>% clean_names(.),

pfm = read_csv(file_in("data/pfm.csv")) %>% select(dept,`2015/16`:`2019/20`) %>% replace(is.na(.), "-"),

# cmp discounts
family_total_cmp = read_csv(file_in("data/family_total_cmp_discount.csv")),

family_additional_cmp = read_csv(file_in("data/family_additional_cmp_discount.csv")),

education_cmp = read_csv(file_in("data/education_cmp_discount.csv")) %>% clean_names(.),

nutrition_cmp = read_csv(file_in("data/nutrition_cmp_discount.csv")) %>% clean_names(.),

# accessory stuff
tables_titles = read_csv(file_in("data/table_titles.csv")),
lookup = read_csv(file_in("data/dept_lookup.csv")),



#### Format Department Data ----
dept  = tidyDept(bilateral_data = dept_raw, multilateral_data = multilat, lookup = lookup),

#### Indicator Dataframes  -----

a2f = filterA2F(a2f_raw),

education = filterEducation(dept),

fp_total = filterFPTotal(dept),

fp_additional = filterFPAdditionalTotals(dept, family_drf),

fp_additional_plots = filterFPAdditionalBreakdown(dept, family_drf),

immunisations = filterImmunisations(dept),

jobs = filterJobsGender(jobs_raw),

humanitarian = filterHumanitarian(dept),

nutri_gender  = filterNutritionGender(dept),

nutri_intensity = filterNutritionIntensity(dept),

wash = filterWASH(dept), #2020 Ukraine WASH results could not be QA'd so removed here



#### Disaggregation Summaries ----

#a2f
a2f_region_data =  summariseA2FRegion(a2f_raw, lookup),

#education
edu_fragility_data  = summariseFragility(education),
edu_region_data  = summariseRegion(education),

#family
fp_total_fragility_data = summariseFragility(fp_total),
fp_total_region_data = summariseRegion(fp_total),
fp_additional_fragility_data = summariseFragility(fp_additional_plots),
fp_additional_region_data = summariseRegion(fp_additional_plots),

# humanitarian
human_fragility_data  = summariseFragility(humanitarian),
human_region_data  = summariseRegion(humanitarian),

#jobs
jobs_region_data = summariseJobsRegion(jobs_raw, lookup),

#nutrition
nutrition_fragility_data  = summariseFragility(nutri_gender),
nutrition_intensity_data  = summariseNutritionIntensity(nutri_intensity),
nutrition_region_data  = summariseRegion(nutri_gender),

#wash
wash_fragility_data  = summariseFragility(wash),
wash_region_data  = summariseRegion(wash),





#### Plots ----

a2f_region_plot = plotA2FRegion(a2f_region_data),

climate_spend_plot = plotClimateSpend(climate_spend),

edu_frag_plot = plotEduFragility(edu_fragility_data),
edu_region_plot  =  plotEduRegion(edu_region_data),

energy_cumulative_plot = plotEnergyCumulative(energy),

### FP plots not loaded from cache instead output directly to figs/ as its tricky to use subfloat in .Rnw with code chunks to have one fig caption.
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

cdc_table = tableCDC(inputs),

climate_table = tableClimate(inputs),

devcap_table = tableDevCap(inputs),

energy_table = tableEnergy(energy),

education_table =  tableEducation(education, education_cmp),

fp_total_table = tableFPTotal(fp_total, family_total_cmp),
fp_additional_table = tableFPAdditional(fp_additional, family_additional_cmp),

fcas_table = tableFCAS(inputs),

humanitarian_table = tableHumanitarian(humanitarian), #double counting already included in figures so nothing to add

immunisations_table = tableImmunisations(immunisations),

improve_tax_table = tableTax(inputs),

invest_multilat_table = tableMultilat(inputs),

jobs_table = jobs %>% clean_names("title"),

malaria_table = tableMalaria(inputs),

ntd_spend_table = tableNTDSpend(inputs),

ntd_table_a = tableNTDa(inputs),
ntd_table_b = tableNTDb(inputs),

nutrition_table = tableNutrition(nutri_gender, nutrition_cmp),

oda_table = tableODA(inputs),

pqi_table = tablePQI(inputs),

psi_table = tablePSI(inputs),

polio_table = tablePolio(inputs),

pfm_table = tablePFM(pfm), # no double counting to be added

wash_table = tableWASH(wash),


# output tables - these needs to be provided in a list
tables = target(
  command= {formatTables(lst_data = list(a2f_table,
                                         cdc_table,
                                         climate_table,
                                         devcap_table,
                                         education_table,
                                         energy_table,
                                         fp_total_table,
                                         fp_additional_table,
                                         fcas_table,
                                         humanitarian_table,
                                         immunisations_table,
                                         improve_tax_table,
                                         invest_multilat_table,
                                         jobs_table,
                                         malaria_table,
                                         ntd_spend_table,
                                         ntd_table_a, #ntd_table_b is added as a separate argument below
                                         nutrition_table,
                                         oda_table,
                                         pqi_table,
                                         psi_table,
                                         polio_table,
                                         pfm_table,
                                         wash_table),
                         tables_titles = tables_titles,
                         ntd_table_b)
    file_out="tables/tables.xlsx"
    }
  ),





#### Report ----

## knit .Rnw to .tex
report = target(
  command = {knitAll(files=file_in(
    c(
    "doc/titlepage/titlepage.Rnw",
    "doc/frontmatter/frontmatter.Rnw",
    "doc/intro/intro.Rnw",
    "doc/a2f/a2f.Rnw",
    "doc/cdc/cdc.Rnw",
    "doc/climate/climate.Rnw",
    "doc/devcap/devcap.Rnw",
    "doc/education/education.Rnw",
    "doc/energy/energy.Rnw",
    "doc/ntd/ntd.Rnw",
    "doc/family/family.Rnw",
    "doc/fcas/fcas.Rnw",
    "doc/humanitarian/humanitarian.Rnw",
    "doc/immunisation/immunisation.Rnw",
    "doc/tax/tax.Rnw",
    "doc/multi/multi.Rnw",
    "doc/jobs/jobs.Rnw",
    "doc/malaria_spend/malaria_spend.Rnw",
    "doc/ntd_spend/ntd_spend.Rnw",
    "doc/ntd/ntd.Rnw",
    "doc/nutrition/nutrition.Rnw",
    "doc/oda/oda.Rnw",
    "doc/pqi/pqi.Rnw",
    "doc/private/private.Rnw",
    "doc/polio/polio.Rnw",
    "doc/pfm/pfm.Rnw",
    "doc/wash/wash.Rnw",
    "main.Rnw"
  )
  )
  )
  file_out=c(
    "doc/titlepage/titlepage.tex",
    "doc/frontmatter/frontmatter.tex",
    "doc/intro/intro.tex",
    "doc/a2f/a2f.tex",
    "doc/cdc/cdc.tex",
    "doc/climate/climate.tex",
    "doc/devcap/devcap.tex",
    "doc/education/education.tex",
    "doc/energy/energy.tex",
    "doc/ntd/ntd.tex",
    "doc/family/family.tex",
    "doc/fcas/fcas.tex",
    "doc/humanitarian/humanitarian.tex",
    "doc/immunisation/immunisation.tex",
    "doc/tax/tax.tex",
    "doc/multi/multi.tex",
    "doc/jobs/jobs.tex",
    "doc/malaria_spend/malaria_spend.tex",
    "doc/ntd_spend/ntd_spend.tex",
    "doc/ntd/ntd.tex",
    "doc/nutrition/nutrition.tex",
    "doc/oda/oda.tex",
    "doc/pqi/pqi.tex",
    "doc/private/private.tex",
    "doc/polio/polio.tex",
    "doc/pfm/pfm.tex",
    "doc/wash/wash.tex",
    "main.tex"
  )
  }
),


# compile .tex
compile = target(
  command = {
    system(paste0("xelatex ", report[[length(report)]], " --output-directory=report  --aux-directory=report"))
    file_out("report/main.pdf")
  }
)


)

