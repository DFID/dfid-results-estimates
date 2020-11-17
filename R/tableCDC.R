#' make CDC table
#' @param data indicator data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableCDC <- function(data) {

  data %>%
    filter(indicator=="cdc")  %>%
    select(year,results)  %>%
    pivot_wider(names_from=year, values_from=results)

}


