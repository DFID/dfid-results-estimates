#' create Nutrition Gender dataframe
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterNutritionGender  <-  function(data){

  data %>% filter(indicator==levels(data$indicator)[3] &
                    year=="2015/21" &
                    forecast_achieved=="Achieved" &
                    disabled=="No" &
                    nutrition_intensity=="All"
                    ) %>%
    mutate(fragility = fct_recode(fragility, `Not Identified`="Not Applicable")) %>%
    mutate(region=fct_relevel(region,"Africa","Asia","Europe","Middle East","Other", "Policy", "Multilateral")) %>%
    group_by(department, gender, fragility, region) %>%
    summarise(results = sum(results)) %>%
    pivot_wider(.,names_from = gender, values_from = results) %>%
    mutate_if(is.numeric,function(x)ifelse(x<=1,0,x)) %>%
    arrange(region, by_group=TRUE) %>%
    rename(`Not Identified`="Unknown") %>%
    select(department, fragility, region, Female, Male, `Not Identified`, Total) %>%
    replace_na(list(Male = 0, Female=0, `Not Identified`=0)) %>%
    filter(Total!=0) %>%
    clean_names("snake")
}


#' create Nutrition Intensity dataframe
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterNutritionIntensity  <-  function(data){

  data %>% filter(indicator==levels(data$indicator)[3] &
                    year=="2015/21" &
                    forecast_achieved=="Achieved" &
                    disabled=="No" &
                    gender=="Total"
    ) %>%
    mutate(fragility = fct_recode(fragility, `Not Identified`="Not Applicable")) %>%
    mutate(region=fct_relevel(region,"Africa","Asia","Europe","Middle East","Other", "Policy", "Multilateral")) %>%
    group_by(department, fragility, region,  nutrition_intensity) %>%
    summarise(results = sum(results)) %>%
    pivot_wider(.,names_from = nutrition_intensity, values_from = results) %>%
    arrange(region, by_group=TRUE) %>%
    replace(.,is.na(.),0) %>%
    rowwise() %>%
    mutate(not_identified = All - (sum(Low,Medium,High))) %>%
    mutate_if(is.numeric,function(x)ifelse(x<=1,0,x)) %>%
    adorn_totals("row") %>%
    mutate_if(is.numeric, roundChoose, 1000) %>%
    mutate_if(is.numeric, ~(
      case_when(
        department=="Total" ~ roundChoose(.,100000),
        TRUE~.
      )
    )
    ) %>%
    rename(`Total`="All") %>%
    select(department, fragility, region, Low, Medium,  High, not_identified, Total) %>%
    filter(Total!=0) %>%
    clean_names("snake")
}

