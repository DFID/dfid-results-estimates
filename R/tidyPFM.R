#' Format FAMILY PLANNING  tab
#'
#' This function takes output from jailbreakr for the FAMILYPLANNING tab on the SDP templates and returns a long format table.
#' @param dat List of tiny little matrices extracted from sector templates with jailbreakr
#' @keywords names
#' @importFrom magrittr %>%
#' @examples formatFamilyDept(family.raw)
#' @export
formatFamilyDept <- function(df){

  forecast <- edu2 %>% janitor::remove_empty(which = "rows") %>% dplyr::slice(4:6) %>% janitor::remove_empty(which = "cols") %>% as.data.frame()
  achieved <- edu2 %>% janitor::remove_empty(which = "rows") %>% dplyr::slice(7:9) %>% janitor::remove_empty(which = "cols") %>% as.data.frame()

  # metadata
  metadata <- edu2 %>% janitor::remove_empty(which = "rows") %>% dplyr::slice(3) %>% janitor::remove_empty(which = "cols")
  dept_name <- unname(unlist(metadata[1]))
  dept_code <- unname(unlist(metadata[2]))
  ind_ref <- unname(unlist( round(as.numeric(metadata[4]),2)))
  ind_name <- unname(unlist(metadata[6]))
  ind_type <- "ADDITIVE"


  # format forecast
  colnames(forecast) <- c("split", unlist(forecast[1,2:(ncol(forecast)-1)]), "2015/21")
  forecast %<>%
    dplyr::slice(-c(1:2)) %>%
    dplyr::mutate_at(vars(dplyr::contains("/")), as.numeric) %>%
    tidyr::pivot_longer(
      cols = c(-split),
      names_to = c("year"),
      values_to = "result",
      values_ptypes = list(val = 'double')) %>%
    unnest() %>%
    dplyr::mutate(achieved_forecast="forecast") %>%
    dplyr::select(-split) %>%
    dplyr::mutate(indicator= ind_name)


  # format achieved
  colnames(achieved) <- c("split", unlist(achieved[1,2:(ncol(achieved)-1)]), "2015/21")
  achieved %<>%
    dplyr::slice(-c(1:2)) %>%
    dplyr::mutate_at(vars(dplyr::contains("/")), as.numeric) %>%
    tidyr::pivot_longer(
      cols = c(-split),
      names_to = c("year"),
      values_to = "result",
      values_ptypes = list(val = 'double')) %>%
    unnest() %>%
    dplyr::mutate(achieved_forecast="achieved") %>%
    dplyr::select(-split) %>%
    dplyr::mutate(indicator= ind_name)



  z <- rbind(achieved,forecast) %>%
    dplyr::mutate(disability=NA) %>%
    dplyr::mutate(dept=dept_name) %>%
    dplyr::mutate(dept_code=dept_code) %>%
    dplyr::mutate(indicator_ref=ind_ref) %>%
    dplyr::mutate(indicator_type= ind_type) %>%
    dplyr::select(order(colnames(.)))

  return(z)

}


