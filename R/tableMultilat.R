#' make Multilat table
#' @param data indicator data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableMultilat <- function(data) {

data %>%
    filter(indicator=="multilat")  %>%
    select(year,results, multilat_rank)  %>%
    tidyr::gather(key = key, value = value, 2:ncol(.)) %>%
    spread(key = names(.)[1], value = "value") %>%
    arrange(desc(key)) %>%
    select(-key) %>%
    mutate_at(vars(everything()), ~(
        ifelse(.<2, paste0("Rank ",  .),paste0("\U00A3",format(., big.mark = ","),"m"))
            )
         ) %>%
    replace(.,is.na(.), "Rank not yet available*")
}

