#' jobs region data
#' @param data jobs raw data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
summariseJobsRegion <- function(data){
  data %>%
    filter(region!="Total") %>%
    select(region,results) %>%
    mutate(perc=(results/sum(results))*100) %>%
    filter(results!=0) %>%
    mutate(region = fct_relevel(region, c("Africa", "Asia", "Policy")))
}
