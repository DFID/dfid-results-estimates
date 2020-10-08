#' make Malaria table
#' @param data indicator data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableMalaria <- function(data) {

  data %>%
    filter(indicator=="malaria spend")  %>%
    select(year,results)  %>%
    pivot_wider(names_from=year, values_from=results) %>%
    mutate_if(is.numeric, ~(.*1000000))

}
