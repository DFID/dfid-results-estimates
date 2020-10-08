#' make Dev Cap table
#' @param data input data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableDevCap <- function(data) {

  data %>%
    filter(indicator=="dev cap")  %>%
    select(year,results)  %>%
    pivot_wider(names_from=year, values_from=results) %>%
    mutate(Total=roundChoose(sum(.), up = TRUE, 1000000))

}


