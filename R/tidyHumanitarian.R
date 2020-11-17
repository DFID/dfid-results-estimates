#' Format HUMANITARIAN  tab
#'
#' This function parses data from the HUMANITARIAN tab on the SDP templates and returns a long format table.
#' @param template SDP template for relevant indicator
#' @keywords names
#' @importFrom magrittr %>%
#' @examples formatHumanitarianDept(humanitarian.raw)
#' @export
formatHumanitarianDept <- function(template){
# read in bits of sheet for forecast and achieved

  forecast <- edu2 %>% janitor::remove_empty(which = "rows") %>% dplyr::slice(5:8) %>% janitor::remove_empty(which = "cols") %>% as.data.frame()
  achieved <- edu2 %>% janitor::remove_empty(which = "rows") %>% dplyr::slice(9:12) %>% janitor::remove_empty(which = "cols")%>% as.data.frame()

  metadata <- edu2 %>% janitor::remove_empty(which = "rows") %>% dplyr::slice(3) %>% janitor::remove_empty(which = "cols")
  dept_name <- unname(unlist(metadata[1]))
  dept_code <- unname(unlist(metadata[2]))
  ind_ref <- unname(unlist(metadata[4]))
  ind_name <- unname(unlist(metadata[6]))
  ind_type <- unname(unlist(metadata[7]))



  #format forecast
  forecast[1,2:ncol(forecast)] <- zoo::na.locf(unlist(forecast[1,]))
  colnames(forecast) <- c("split", paste(unlist(forecast[1,2:ncol(forecast)]), unlist(forecast[2,2:ncol(forecast)]), sep="_"))
  forecast %<>%
    dplyr::slice(-c(1:2)) %>%
    dplyr::mutate_at(vars(dplyr::contains("_")), as.numeric) %>%
    dplyr::mutate(`2015/16_Unknown`= unlist(`2015/16_Total`)-(unlist(`2015/16_Male`)+ unlist(`2015/16_Female`))) %>% # these add in unknown. must be easier way using seq_along
    dplyr::mutate(`2016/17_Unknown`= unlist(`2016/17_Total`)-(unlist(`2016/17_Male`)+ unlist(`2016/17_Female`))) %>%
    dplyr::mutate(`2017/18_Unknown`= unlist(`2017/18_Total`)-(unlist(`2017/18_Male`)+ unlist(`2017/18_Female`))) %>%
    dplyr::mutate(`2018/19_Unknown`= unlist(`2018/19_Total`)-(unlist(`2018/19_Male`)+ unlist(`2018/19_Female`))) %>%
    dplyr::mutate(`2019/20_Unknown`= unlist(`2019/20_Total`)-(unlist(`2019/20_Male`)+ unlist(`2019/20_Female`))) %>%
    dplyr::mutate(`2020/21_Unknown`= unlist(`2020/21_Total`)-(unlist(`2020/21_Male`)+ unlist(`2020/21_Female`))) %>%
    dplyr::rename_at(vars(starts_with("Total")), # rename these cols
                     funs(stringr::str_replace(., "Total", "2015/21"))) %>%
    tidyr::pivot_longer(
      cols = c(-split),
      names_to = c("year", "gender"),
      names_pattern = "([^_]+)_([^_]+)",
      values_to = "result",
      values_ptypes = list(val = 'double')) %>%
    unnest() %>%
    dplyr::mutate(year=dplyr::recode(year, Total="2015/21")) %>%  # reporting period
    dplyr::mutate(achieved_forecast="forecast") %>%
    dplyr::mutate(split=dplyr::recode(split, `Forecast Results - Total`="total", `of which disabled`="disabled")) %>%
    dplyr::mutate(split=tolower(split)) %>% dplyr::mutate(gender=tolower(gender)) %>%
    dplyr::mutate(disability = ifelse(split=="disabled","disabled",NA)) %>% # add diabled col
    dplyr::mutate(result=ifelse(result<0,0,result)) %>% # clean negative numbers
    dplyr::select(-split)

  #format achieved
  achieved[1,2:ncol(achieved)] <- zoo::na.locf(unlist(achieved[1,]))
  colnames(achieved) <- c("split", paste(unlist(achieved[1,2:ncol(achieved)]), unlist(achieved[2,2:ncol(achieved)]), sep="_"))
  achieved %<>%
    dplyr::slice(-c(1:2)) %>%
    dplyr::mutate_at(vars(dplyr::contains("_")), as.numeric) %>%
    dplyr::mutate(`2015/16_Unknown`= unlist(`2015/16_Total`)-(unlist(`2015/16_Male`)+ unlist(`2015/16_Female`))) %>% # these add in unknown. must be easier way using seq_along
    dplyr::mutate(`2016/17_Unknown`= unlist(`2016/17_Total`)-(unlist(`2016/17_Male`)+ unlist(`2016/17_Female`))) %>%
    dplyr::mutate(`2017/18_Unknown`= unlist(`2017/18_Total`)-(unlist(`2017/18_Male`)+ unlist(`2017/18_Female`))) %>%
    dplyr::mutate(`2018/19_Unknown`= unlist(`2018/19_Total`)-(unlist(`2018/19_Male`)+ unlist(`2018/19_Female`))) %>%
    dplyr::mutate(`2019/20_Unknown`= unlist(`2019/20_Total`)-(unlist(`2019/20_Male`)+ unlist(`2019/20_Female`))) %>%
    dplyr::mutate(`2020/21_Unknown`= unlist(`2020/21_Total`)-(unlist(`2020/21_Male`)+ unlist(`2020/21_Female`))) %>%
    dplyr::rename_at(vars(starts_with("Total")), # rename these cols
                     funs(stringr::str_replace(., "Total", "2015/21"))) %>%
    tidyr::pivot_longer(
      cols = c(-split),
      names_to = c("year", "gender"),
      names_pattern = "([^_]+)_([^_]+)",
      values_to = "result",
      values_ptypes = list(val = 'double')) %>%
    unnest() %>%
    dplyr::mutate(year=dplyr::recode(year, Total="2015/21")) %>%  # reporting period
    dplyr::mutate(achieved_forecast="achieved") %>%
    dplyr::mutate(split=dplyr::recode(split, `Achieved  Results - Total`="total", `of which disabled`="disabled")) %>%
    dplyr::mutate(split=tolower(split)) %>% dplyr::mutate(gender=tolower(gender)) %>%
    dplyr::mutate(disability = ifelse(split=="disabled","disabled",NA)) %>% # add diabled col
    dplyr::mutate(result=ifelse(result<0,0,result)) %>% # clean negative numbers
    dplyr::select(-split)

  z <- rbind(forecast,achieved) %>%
    dplyr::mutate(dept=dept_name) %>%
    dplyr::mutate(dept_code=dept_code) %>%
    dplyr::mutate(indicator_ref=ind_ref) %>%
    dplyr::mutate(indicator=ind_name) %>%
    dplyr::mutate(indicator_type=ind_type) %>%
    select(order(colnames(.)))

  return(z)

}
