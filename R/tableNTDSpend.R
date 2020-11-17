#' make NTD Spend table
#' @param data indicator data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableNTDSpend <- function(data) {

  data %>%
    filter(indicator=="ntd spend")  %>%
    select(year,results, ntd_spend_type)  %>%
    pivot_wider(names_from=year, values_from=results) %>%
    mutate_if(is.numeric, ~(. * 1000000)) %>%
    rename("Programme Type"=ntd_spend_type)
}
