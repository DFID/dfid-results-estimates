#' create  Education dataframe
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterEducation  <-  function(data){

data  %>% filter(indicator==levels(data$indicator)[2] &
                 education_level=="All" &
                 year=="2015/21" &
                 forecast_achieved=="Achieved" &
                  disabled=="No") %>%
mutate(fragility = fct_recode(fragility, `Not Identified`="Not Applicable")) %>%
mutate(region=fct_relevel(region,"Africa","Asia","Europe","Middle East","Other", "Policy", "Multilateral")) %>%
group_by(department, gender, fragility, region) %>%
summarise(results = sum(results)) %>%
pivot_wider(.,names_from = gender, values_from = results) %>%
mutate_at(vars(-c(department, fragility, region)),function(x)ifelse(x<=1,0,x)) %>%
arrange(region, by_group=TRUE) %>%
mutate_at(vars(Unknown), ~(
  case_when(
    department=="Multilateral" ~ Total-Female,
    TRUE~.
  )
)
) %>%
ungroup() %>%
rename(`Not Identified`="Unknown") %>%
select(department, fragility, region, Female, Male, `Not Identified`, Total) %>%
replace_na(list(Male = 0)) %>%
clean_names("snake") %>%
filter(total!=0)
}








