#' create Humanitarian dataframe
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterHumanitarian  <-  function(data){

  data %>% filter(indicator==levels(data$indicator)[6] &
                    year=="2015/21" &
                    forecast_achieved=="Achieved" &
                    disabled=="No") %>%
    mutate(region=fct_relevel(region,"Africa","Asia","Europe","Middle East","Other", "Policy")) %>%
    mutate(fragility = fct_recode(fragility, `Not Identified`="Not Applicable")) %>%
    group_by(department, gender, fragility, region) %>%
    summarise(results = sum(results)) %>%
    pivot_wider(.,names_from = gender, values_from = results) %>%
    mutate_if(is.numeric,function(x)ifelse(x<=1,0,x)) %>%
    arrange(region, by_group=TRUE) %>%
    adorn_totals() %>% # double countin handled internally by chase so don't need to add a discount total
    rename(`Not Identified`="Unknown") %>%
    select(department, fragility, region, Female, Male, `Not Identified`, Total) %>%
    replace_na(list(Male = 0)) %>%
    filter(Total!=0) %>%
    clean_names("snake")
}


