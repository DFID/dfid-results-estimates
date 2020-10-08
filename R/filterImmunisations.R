#' create immunisations dataframe
#' @param data immnisations data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterImmunisations <-  function(data){

  data %>%
    filter(indicator==levels(data$indicator)[4]) %>%
    select(indicator,year,immunisation, results) %>%
    pivot_wider(names_from = "year", values_from = "results") %>%
    mutate(indicator=c("Number of children immunised against preventable diseases",
                       "Number of lives saved by immunising against preventable diseases"
                                )) %>%
    rename(total=`2015/21`) %>%
    rename_at(vars(contains("/")),
      ~(stringr::str_replace_all(., '\\/.*', '')
      )
    ) %>%
    arrange(desc(indicator)) %>%
    select(-immunisation) %>%
    mutate_if(is.numeric, roundChoose, 1000) %>%
    mutate_at(vars(total), roundChoose, 10000)

}
