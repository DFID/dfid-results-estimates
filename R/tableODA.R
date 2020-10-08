#' make ODA table
#' @param data input data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableODA <- function(data) {

  data %>%
    filter(indicator=="oda")  %>%
    select(year,results)  %>%
    pivot_wider(names_from=year, values_from=results) %>%
    mutate_at(vars(everything()), ~(paste0(.,"%"))) %>%
    mutate_at(vars(names(.[,ncol(.)])), ~(paste0(.,"*")))

}


