#' Format FAMILY PLANNING  tab
#'
#' This function takes output from jailbreakr for the FAMILYPLANNING tab on the SDP templates and returns a long format table.
#' @param dat List of tiny little matrices extracted from sector templates with jailbreakr
#' @keywords names
#' @importFrom magrittr %>%
#' @examples formatFamilyDept(family.raw)
#' @export
formatFamilyDept <- function(df){
  # read in bits of sheet for forecast and achieved
  x <- as.data.frame(df[2])
  dept_name <- unlist(x[2,1])
  dept_code <- unlist(x[2,2])
  ind_ref <- unlist(x[2,7])
  ind_name_add <- "Number of women and girls using modern methods of family planning through DFID support (Total Users)"
  ind_name_tot <- "Number of women and girls using modern methods of family planning through DFID support (Additional Users)"
  ind_type_add <- unlist(x[2,16])
  ind_type_tot <- "AVERAGE"

  forecast <- list(
    c(NA,df[[3]]),
    c(family.raw[[30]][c(1,4,5),2]),
    c(family.raw[[48]][c(1,3,4),2]),
    c(family.raw[[66]][1,],family.raw[[67]]),
    c(family.raw[[86]][1,],family.raw[[87]]),
    c(family.raw[[106]][1,],family.raw[[107]]),
    c(family.raw[[126]][1,],family.raw[[127]]),
    c(family.raw[[146]][1,],family.raw[[147]])
  )

  achieved <- list(
    c(NA,df[[4]]),
    c(family.raw[[31]][c(1,4,5),2]),
    c(family.raw[[49]][c(1,3,4),2]),
    c(family.raw[[66]][1,],family.raw[[69]]),
    c(family.raw[[86]][1,],family.raw[[89]]),
    c(family.raw[[106]][1,],family.raw[[109]]),
    c(family.raw[[126]][1,],family.raw[[129]]),
    c(family.raw[[146]][1,],family.raw[[149]])
  )

  forecast <- purrr::map(forecast, function(x)Reduce(rbind,x))
  forecast <- do.call(cbind,(purrr::map(forecast, unlist, unlist))) %>% tibble::as_tibble() %>%
    dplyr::mutate(V1=replace(V1, 1, "achieved_forecast")) %>%
    setNames(.[1,]) %>%
    dplyr::slice(-1) %>%
    dplyr::mutate_at(vars(dplyr::contains("/")),as.numeric) %>%
    dplyr::mutate(indicator=c("additional", "total")) %>%
    dplyr::mutate(achieved_forecast=replace(achieved_forecast, 1:2, "forecast")) %>%
    dplyr::mutate(`2015/21`=c(sum(.[1,2:8]), mean(as.numeric(.[2,2:8]))))

  achieved <- purrr::map(achieved, function(x)Reduce(rbind,x))
  achieved <- do.call(cbind,(purrr::map(achieved, unlist, unlist))) %>% tibble::as_tibble() %>%
    dplyr::mutate(V1=replace(V1, 1, "achieved_forecast")) %>%
    setNames(.[1,]) %>%
    dplyr::slice(-1) %>%
    dplyr::mutate_at(vars(contains("/")),as.numeric) %>%
    dplyr::mutate(indicator=c("additional", "total")) %>%
    dplyr::mutate(achieved_forecast=replace(achieved_forecast, 1:2, "achieved")) %>%
    dplyr::mutate(`2015/21`=c(sum(.[1,2:8]), mean(as.numeric(.[2,2:8]))))

  fp <- rbind(achieved,forecast) %>% tidyr::pivot_longer(-c(achieved_forecast,indicator), names_to = "year", values_to = "results") %>%
    dplyr::mutate(indicator=dplyr::recode(indicator,additional=ind_name_add, total=ind_name_tot)) %>%
    dplyr::mutate(disability=NA) %>%
    dplyr::mutate(dept=dept_name) %>%
    dplyr::mutate(dept_code=dept_code) %>%
    dplyr::mutate(indicator_ref=ind_ref) %>%
    dplyr::mutate(indicator_type= case_when(
    stringr::str_detect(indicator, "Additional") ~ ind_type_add,
    stringr::str_detect(indicator, "Total") ~ ind_type_tot,
      TRUE                      ~ NA_character_
    )) %>%
    dplyr::select(order(colnames(.)))

  return(fp)

}



