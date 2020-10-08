#' make energy table
#' @param data indicator data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableEnergy<- function(data) {

  data %>%
    filter(type=="Annual") %>%
    pivot_wider(.,
                names_from = c("year"),
                values_from="energy"
    ) %>%
    select(-type)
}

