#' make Immunisations table
#' @param data filtered data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableImmunisations<- function(data) {

  data %>%
    clean_names("title") %>%
    rename_at(vars(contains("X")), ~(stringr::str_replace_all(., 'X', '')))
}

