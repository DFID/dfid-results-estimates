#' jobs region data
#' @param data jobs data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
summariseJobsRegion <- function(data, lookup){
  data %>%
    select(department,gender, results) %>%
    mutate(region = recode_factor(department, !!!getRegion(lookup))) %>%
    mutate(region = recode(region, PSD="Policy")) %>%
    filter(gender=="total") %>%
    group_by(region) %>%
    summarise(results = sum(results)) %>%
    mutate(perc=(results/sum(results))*100) %>%
    filter(results!=0)
}
