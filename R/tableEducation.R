#' make education table
#' @param data indicator data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableEducation<- function(data, cmp) {

  data %>%
    add_row(department="Double Counting", # add in double counting
            fragility="-",
            region="-",
            male=0,
            female=0,
            not_identified=0,
            total= unlist(
              left_join(., cmp, by="department") %>%
                mutate(min = pmin(total.x, total.y)) %>%
                ungroup() %>%
                summarise_at(vars(min),sum, na.rm=T))*-1) %>%
    adorn_totals() %>%
    mutate_if(is.numeric, roundChoose, 1000) %>%
    mutate_if(is.numeric, ~(
      case_when(
        department=="Total" ~ roundChoose(.,100000),
        TRUE~.
      )
    )
    ) %>%
    clean_names("title")
}


