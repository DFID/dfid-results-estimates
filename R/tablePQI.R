#' make PQI table
#' @param data input data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tablePQI <- function(data) {

  data %>%
    filter(indicator=="pqi")  %>%
    select(year,results)  %>%
    pivot_wider(names_from=year, values_from=results)

}

