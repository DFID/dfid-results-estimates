#' create Family dataframe
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterFPAdditionalTotals  <-  function(data, family_drf){

  data %>% filter(indicator==levels(data$indicator)[1] &
                    !(year %in% c("2013/14", "2014/15", "2015/21")) &
                    forecast_achieved=="Achieved" &
                    disabled=="No") %>%
    select(department,results, year) %>%
    group_by(department) %>%
    summarise(results=sum(results))  %>%
    full_join(.,family_drf,by="department") %>%
    rowwise() %>%
    mutate(drf=sum(`2013/14`,`2014/15`)) %>%
    select(-c(department,`2013/14`,`2014/15`)) %>%
    ungroup() %>%
    summarise_all(sum, na.rm=T) %>%
    tidyr::gather() %>%
    arrange(key) %>%
    rename(Indicator="key", Total="value") %>%
    mutate(Indicator=recode(Indicator, drf="Number of additional women and girls using modern methods of family planning 2012-15",
                            results="Number of additional women and girls using modern methods of family planning 2015-20"))
}

#' create Family dataframe
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterFPAdditionalBreakdown  <-  function(data, family_drf){
  data %>% filter(indicator==levels(data$indicator)[1] &
                    !(year %in% c("2013/14", "2014/15", "2015/21")) &
                    forecast_achieved=="Achieved" &
                    disabled=="No") %>%
    mutate(region_fp = fct_recode(region_fp, `Policy`="CMP")) %>%
    select(department, fragility, region_fp, results, year) %>%
    mutate(region_fp=fct_relevel(region_fp,"Africa","Asia","Europe","Middle East","Other", "Policy")) %>%
    mutate(fragility=fct_recode(fragility, `Not Identified`="Not Applicable")) %>%
    group_by(department,fragility, region_fp) %>%
    summarise(results=sum(results))  %>%
    full_join(.,family_drf,by="department") %>%
    rowwise() %>%
    mutate(Total=results + sum(`2013/14`,`2014/15`)) %>%
    select(-c(results:`2014/15`)) %>%
    adorn_totals("row") %>%
    mutate_at(vars(region_fp), ~(
      case_when(
        department=="Global Funds" ~ "Multilateral",
        TRUE~.
      )
    )
    ) %>%
    arrange(region_fp) %>%
    rename(Region=region_fp) %>%
    filter(Total!=0) %>%
    drop_na()  %>%
    clean_names("snake")
}

#' create  Education dataframe
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterFPTotal  <-  function(data){

  data %>% filter(indicator==levels(data$indicator)[7] &
                  forecast_achieved=="Achieved" &
                  disabled=="No") %>%
    mutate(region_fp = fct_recode(region_fp, Policy="CMP")) %>%
    select(department,year,fragility, region_fp, results) %>%
    pivot_wider(., values_from=results,names_from = year) %>%
    mutate(region_fp=fct_relevel(region_fp,"Africa","Asia","Europe","Middle East","Other", "Policy")) %>%
    mutate(fragility=fct_recode(fragility, `Not Identified`="Not Applicable")) %>%
    select(-c(`2013/14`, `2014/15`, `2020/21`)) %>% # get rid of DRF years for totals
    mutate_if(is.numeric,function(x)ifelse(x<=1,0,x)) %>%
    mutate(Average= rowMeans(select(., contains("/")), na.rm=T)) %>%
    mutate_at(vars(region_fp), ~(
      case_when(
        department=="Global Funds" ~ "Multilateral",
        TRUE~as.character(.)
      )
    )
    ) %>%
    arrange(region_fp, by_group=TRUE) %>%
    mutate_at(vars(region_fp), as.factor) %>%
    rename(Department=department, Fragility=fragility, Region=region_fp) %>%
    filter(Average!=0) %>%
    drop_na()
}


