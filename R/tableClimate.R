#' make Climate table
#' @param data input data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableClimate <- function(data) {

  data %>%
    filter(indicator=="climate finance")  %>%
    select(year,results)  %>%
    pivot_wider(names_from=year, values_from=results) %>%
    mutate(Total=sum(.[,-1]))

}


