#' Format EDUCATION tab
#'
#' This function takes output from jailbreakr for the EDUCATION tab on the SDP templates and returns a long format table.
#' @param dat List of tiny little matrices extracted from sector templates with jailbreakr
#' @keywords names
#' @importFrom magrittr %>%
#' @examples formatEducationDept(education.raw)
#' @export
formatEducationDept <- function(dat){
  # read in bits of sheet for forecast and achieved
  x <- as.data.frame(dat[2])
  y <-  cbind(result_split=c(NA,NA,unlist(dat[3])), as.data.frame(dat[30])) %>% dplyr::mutate_at("result_split", as.character) # pull the bits out of the table soup

  dept_name <- unlist(x[2,1])
  dept_code <- unlist(x[2,2])
  ind_ref <- unlist(x[2,7])
  ind_name <- unlist(x[2,11])
  ind_type <- unlist(x[2,16])

  #format forecast
  x = x[-c(1:3),-c(2)]
  x[1:2,1] <- c("result", "split")
  x[1,] <- zoo::na.locf(unlist(x[1,]))
  colnames(x) <- paste(unlist(x[1,]), unlist(x[2,]), sep="_")
  x %<>%
    dplyr::slice(-c(1:2)) %>%
    dplyr::mutate(`2015/16_Unknown`= unlist(`2015/16_Total`)-(unlist(`2015/16_Male`)+ unlist(`2015/16_Female`))) %>% # these add in unknow. must be easier way using seq_along
    dplyr::mutate(`2016/17_Unknown`= unlist(`2016/17_Total`)-(unlist(`2016/17_Male`)+ unlist(`2016/17_Female`))) %>%
    dplyr::mutate(`2017/18_Unknown`= unlist(`2017/18_Total`)-(unlist(`2017/18_Male`)+ unlist(`2017/18_Female`))) %>%
    dplyr::mutate(`2018/19_Unknown`= unlist(`2018/19_Total`)-(unlist(`2018/19_Male`)+ unlist(`2018/19_Female`))) %>%
    dplyr::mutate(`2019/20_Unknown`= unlist(`2019/20_Total`)-(unlist(`2019/20_Male`)+ unlist(`2019/20_Female`))) %>%
    dplyr::mutate(`2020/21_Unknown`= unlist(`2020/21_Total`)-(unlist(`2020/21_Male`)+ unlist(`2020/21_Female`))) %>%
    dplyr::rename_at(vars(starts_with("Total")), # rename these cols
              funs(stringr::str_replace(., "Total", "2015/21"))) %>%
    dplyr::mutate_at(vars(dplyr::contains("/")),as.numeric) %>% #use / to change those cols to numeric
    tidyr::pivot_longer(
      cols = c(-result_split),
      names_to = c("year", "gender"),
      names_pattern = "([^_]+)_([^_]+)",
      values_to = "result",
      values_ptypes = list(val = 'double')) %>%
    unnest() %>%
    dplyr::mutate(year=dplyr::recode(year, Total="2015/21")) %>%  # reporting period
    dplyr::mutate(achieved_forecast="forecast") %>%
    dplyr::mutate(result_split=dplyr::recode(result_split, `Forecast Results - Total`="total", `of which disabled`="disabled")) %>%
    dplyr::mutate(result_split=tolower(result_split)) %>% dplyr::mutate(gender=tolower(gender)) %>%
    dplyr::mutate(education_level= ifelse(result_split=="total","all", ifelse(result_split=="disabled",NA, result_split))) %>% #add
    dplyr::mutate(disability = ifelse(result_split=="disabled","disabled",NA)) %>% # add diabled col
    dplyr::mutate(result=ifelse(result<0,0,result)) %>% # clean negative numbers
    dplyr::select(-result_split)

  #format achieved
  y[1:2,1] <- c("result", "split") # temp values to become col name
  y[1,] <- zoo::na.locf(unlist(y[1,])) # fill in missing years
  colnames(y) <- paste(unlist(y[1,]), unlist(y[2,]), sep="_") # new colnames
  y %<>%
    dplyr::slice(-c(1:2)) %>% #and remove rows
    dplyr::mutate(`2015/16_Unknown`= unlist(`2015/16_Total`)-(unlist(`2015/16_Male`)+ unlist(`2015/16_Female`))) %>% # these add in unknow. must be easier way using seq_along
    dplyr::mutate(`2016/17_Unknown`= unlist(`2016/17_Total`)-(unlist(`2016/17_Male`)+ unlist(`2016/17_Female`))) %>%
    dplyr::mutate(`2017/18_Unknown`= unlist(`2017/18_Total`)-(unlist(`2017/18_Male`)+ unlist(`2017/18_Female`))) %>%
    dplyr::mutate(`2018/19_Unknown`= unlist(`2018/19_Total`)-(unlist(`2018/19_Male`)+ unlist(`2018/19_Female`))) %>%
    dplyr::mutate(`2019/20_Unknown`= unlist(`2019/20_Total`)-(unlist(`2019/20_Male`)+ unlist(`2019/20_Female`))) %>%
    dplyr::mutate(`2020/21_Unknown`= unlist(`2020/21_Total`)-(unlist(`2020/21_Male`)+ unlist(`2020/21_Female`))) %>%
    dplyr::rename_at(vars(dplyr::starts_with("Total")), # rename these cols
              funs(stringr::str_replace(., "Total", "2015/21"))) %>%
    dplyr::mutate_at(vars(dplyr::contains("/")),as.numeric) %>% #use / to change those cols to numeric
    tidyr::pivot_longer(
      cols = c(-result_split),
      names_to = c("year", "gender"),
      names_pattern = "([^_]+)_([^_]+)",
      values_to = "result",
      values_ptypes = list(val = 'double')) %>% #long format
    unnest() %>%
    dplyr::mutate(year=dplyr::recode(year, Total="2015/21")) %>%  # reporting period
    dplyr::mutate(achieved_forecast="achieved") %>%
    dplyr::mutate(result_split=dplyr::recode(result_split, `Achieved  Results - Total`="total", `of which disabled`="disabled")) %>%
    dplyr::mutate(result_split=tolower(result_split)) %>% mutate(gender=tolower(gender)) %>%
    dplyr::mutate(education_level= ifelse(result_split=="total","all", ifelse(result_split=="disabled",NA, result_split))) %>% #add
    dplyr::mutate(disability = ifelse(result_split=="disabled","disabled",NA)) %>% # add diabled col
    dplyr::mutate(result=ifelse(result<0,0,result)) %>% # clean negative numbers
    select(-result_split)

  z <- rbind(x,y) %>% dplyr::mutate(dept=dept_name) %>%
    dplyr::mutate(dept_code=dept_code) %>%
    mutate(indicator_ref=ind_ref) %>%
    dplyr::mutate(indicator=ind_name) %>%
    dplyr::mutate(indicator_type=ind_type) %>%
    select(order(colnames(.)))

  return(z)
}
