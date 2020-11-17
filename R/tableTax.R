#' make Tax table
#' @param data input data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableTax <- function(data) {

  data %>%
    filter(indicator=="tax")  %>%
    select(year,results)  %>%
    pivot_wider(names_from=year, values_from=results)

}


