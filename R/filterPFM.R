#' create PFM dataframe
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterPFM  <-  function(data){
  dept %>% filter(indicator==levels(dept$indicator)[4] &
                    year=="2015/21" &
                    forecast_achieved=="Achieved" &
                    results==1
                  ) %>%
    mutate(fragility = fct_recode(fragility, `Not Identified`="Not Applicable")) %>%
    mutate(region=fct_relevel(region,"Africa","Asia","Europe","Middle East","Other", "Policy")) %>%
    select(department, fragility, region,  results)
}
