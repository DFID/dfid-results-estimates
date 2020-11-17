#' make NTD Intervention table
#' @param data indicator data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tableNTDa <- function(data) {

  data %>%
    filter(indicator=="ntd total")  %>%
    select(ntd_gender, results)  %>%
    pivot_wider(names_from = ntd_gender, values_from = results)

}


tableNTDb <- function(data) {

  data %>%
    filter(indicator=="ntd intervention")  %>%
    select(ntd_intervention_type, results)  %>%
    rename("Intervention Type"=ntd_intervention_type, "Total"=results)

}
