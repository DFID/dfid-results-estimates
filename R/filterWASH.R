#' create WASH dataframe
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterWASH  <-  function(data){

data %>% filter(indicator==levels(data$indicator)[6] &
                    year=="2015/21" &
                    forecast_achieved=="Achieved" &
                    wash_intervention=="All",
                    disabled=="No") %>%
    mutate(fragility = fct_recode(fragility, `Not Identified`="Not Applicable")) %>%
    mutate(region_wash = fct_recode(region_wash, `Policy`="CMP")) %>%
    mutate(region_wash=fct_relevel(region_wash,"Africa","Asia","Europe","Middle East", "Other", "Policy")) %>%
    group_by(department, gender, fragility, region_wash) %>%
    summarise(results = sum(results)) %>%
    pivot_wider(.,names_from = gender, values_from = results) %>%
    mutate_if(is.numeric,function(x)ifelse(x<=1,0,x)) %>%
    arrange(region_wash, by_group=TRUE) %>%
    filter(department!="Ukraine") %>%  # 2020 Ukraine results could not be QA'd so removed
    mutate_at(vars(Unknown), ~(
      case_when(
        department=="Multilateral" ~ Total-Female,
        TRUE~.
      )
    )
    ) %>%
    rename(`Not Identified`="Unknown") %>%
    rename(region=region_wash) %>%
    select(department, fragility, region, Female, Male, `Not Identified`, Total) %>%
    replace_na(list(Male = 0)) %>%
    filter(Total!=0) %>%
    clean_names("snake")
}





