#' make fp additional table
#' @param data filtered data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableFPAdditional<- function(data, cmp) {
  data %>%
  mutate_if(is.numeric, ~(
    case_when(
      str_detect(Indicator, "-20") ~ .+unlist(cmp),
      TRUE~.
    )
  )
  ) %>%
    add_row(Indicator="Total Additional Users",
            Total = sum(.$Total)
    ) %>%
    mutate_if(is.numeric,  roundChoose, 100000) %>%
    clean_names("title")
}

