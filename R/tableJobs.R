#' make jobs table
#' @param data indicator data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableJobs<- function(data) {

  data %>%
    filter(region=="Total") %>%
    select(-region) %>%
    mutate_if(is.numeric, roundChoose, 1000) %>%
    mutate_at(vars(results), roundChoose, 100000) %>%
    select(female,male,not_identified, results) %>%
    rename("total"=results) %>%
    clean_names("title")

}


