#' make FCAS table
#' @param data indicator data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableFCAS <- function(data) {

 data %>%
    filter(indicator=="fcas")  %>%
    select(year,results)  %>%
    mutate(results=round(results*100)) %>%
    pivot_wider(names_from=year, values_from=results) %>%
    mutate_at(vars(`2015`:`2018`), ~(paste0(.,"%"))) %>%
    mutate_if(is.numeric, as.character) %>%
    replace(., is.na(.), "Data not yet available**")

}


