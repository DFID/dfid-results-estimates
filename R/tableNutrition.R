#' make nutrition additional table
#' @param data filtered data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableNutrition <- function(data, cmp) {
  data %>%
    ungroup() %>%
    add_row(department="Double Counting", # add in double counting
            fragility="-",
            region="-",
            male=NA,
            female=NA,
            not_identified=NA,
            total=unlist(summarise_if(cmp, is.numeric, sum, na.rm=TRUE))  *-1) %>%
    replace(.,is.na(.),0) %>%
    mutate_at(vars(not_identified), ~(
      case_when(
        department=="Multilateral" ~ total,
        TRUE~.
      )
    )
    ) %>%
    mutate_if(is.numeric, roundChoose, 1000) %>%
    adorn_totals() %>%
    mutate_if(is.numeric, ~(
      case_when(
        department=="Total" ~ roundChoose(.,100000),
        TRUE~.
      )
    )
    ) %>%
    clean_names("title")

}

