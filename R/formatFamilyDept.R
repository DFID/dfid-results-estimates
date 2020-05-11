#' Format FAMILY PLANNING  tab
#'
#' This function takes output from jailbreakr for the FAMILYPLANNING tab on the SDP templates and returns a long format table.
#' @param dat List of tiny little matrices extracted from sector templates with jailbreakr
#' @keywords names
#' @importFrom magrittr %>%
#' @examples formatFamilyDept(family.raw)
#' @export
formatFamilyDept <- function(df){

  forecast <- edu2 %>% janitor::remove_empty(which = "rows") %>% dplyr::slice(5:9) %>% slice(-3) %>% janitor::remove_empty(which = "cols") %>% as.data.frame()
  achieved <- edu2 %>% janitor::remove_empty(which = "rows") %>% dplyr::slice(10:14) %>% slice(-3) %>% janitor::remove_empty(which = "cols") %>% as.data.frame()

  # metadata
  metadata <- edu2 %>% janitor::remove_empty(which = "rows") %>% dplyr::slice(3) %>% janitor::remove_empty(which = "cols")
  dept_name <- unname(unlist(metadata[1]))
  dept_code <- unname(unlist(metadata[2]))
  ind_ref <- unname(unlist(metadata[4]))
  ind_name_tot <- "Number of women and girls using modern methods of family planning through DFID support (Total Users)"
  ind_name_add <- "Number of women and girls using modern methods of family planning through DFID support (Additional Users)"
  ind_type_add <- unname(unlist(metadata[7]))
  ind_type_tot <- "AVERAGE"

  sdp_to_date_acheived = c("2015/16", "2016/17", "2017/18", "2018/19") # need to add in latest reporting period here
  sdp_to_date_forecast = c("2015/16", "2016/17", "2017/18", "2018/19", "2019/20", "2020/21")

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
    dplyr::mutate(split=dplyr::recode(split, `Forecast Autumn 2018 - Additional Users`="additional", `Forecast Autumn 2018 - Total Users`="total")) %>%
    dplyr::mutate(split=tolower(split)) %>%
    dplyr::mutate(result=ifelse(result<0,0,result)) %>% # clean negative numbers
    dplyr::rename(indicator="split") %>%
    dplyr::mutate(indicator=dplyr::recode(indicator,additional=ind_name_add, total=ind_name_tot)) %>%
    group_by(indicator) %>%
    dplyr::mutate(result = replace_na(result,
                                      mean(result[year %in% sdp_to_date_forecast], na.rm = TRUE)
                                      )
                 )


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
    dplyr::mutate(split=dplyr::recode(split, `Achieved Autumn 2018 - Additional Users`="additional", `Achieved Autumn 2018 - Total Users`="total")) %>%
    dplyr::mutate(split=tolower(split)) %>%
    dplyr::mutate(result=ifelse(result<0,0,result)) %>% # clean negative numbers
    dplyr::rename(indicator="split") %>%
    dplyr::mutate(indicator=dplyr::recode(indicator,additional=ind_name_add, total=ind_name_tot)) %>%
    group_by(indicator) %>%
    dplyr::mutate(result = replace_na(result,
                                      mean(result[year %in% sdp_to_date], na.rm = TRUE)
                                      )
                  )


  fp <- rbind(achieved,forecast) %>%
    dplyr::mutate(disability=NA) %>%
    dplyr::mutate(dept=dept_name) %>%
    dplyr::mutate(dept_code=dept_code) %>%
    dplyr::mutate(indicator_ref=ind_ref) %>%
    dplyr::mutate(indicator_type=
                    case_when(
      stringr::str_detect(indicator, "Additional") ~ ind_type_add,
      stringr::str_detect(indicator, "Total") ~ ind_type_tot,
      TRUE ~ NA_character_
      )
    ) %>%
    dplyr::select(order(colnames(.)))


  return(fp)

}


