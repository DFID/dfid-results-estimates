#' make WASH additional table
#' @param data filtered data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableWASH <- function(data) {
  data %>%
  mutate_if(is.numeric, roundChoose, 1000) %>%
    adorn_totals("row") %>%
    mutate_if(is.numeric, ~(
      case_when(
        department=="Total" ~ roundChoose(.,100000),
        TRUE~.
      )
    )
    ) %>%
    clean_names("title")
}

