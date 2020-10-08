#' make Polio table
#' @param data input data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tablePolio <- function(data) {

  data %>%
    filter(indicator=="polio") %>%
    select(year,results)  %>%
    pivot_wider(names_from=year, values_from=results)

}

