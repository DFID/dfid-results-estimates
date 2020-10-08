#' create jobs dataframe
#' @param data jobs data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterJobsGender  <-  function(data){

  data %>% select(department, gender, results) %>%
    pivot_wider(.,names_from = gender, values_from = results) %>%
    rowwise() %>%
    mutate(not_identified = total-sum(male,female)) %>%
    ungroup()  %>%
    mutate_at(vars(not_identified),function(x)ifelse(x<=1,0,x)) %>%
    adorn_totals("row") %>%
    select(department,  female, male, not_identified,  total)  %>%
    slice_tail(n()) %>%
    mutate_if(is.numeric, roundChoose, 1000) %>%
    mutate_at(vars(male, female, total), roundChoose, 100000) %>%
    select(-department) %>%
    clean_names("title")

}


#' create jobs dataframe
#' @param data jobs data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
# filterJobsType  <-  function(data){
#
#   jobs_raw %>% select(department, jobs, income, additional) %>% View()
#     group_by(department) %>%
#     slice(1) %>%
#   #  rowwise() %>%
#   #  mutate(total = sum(jobs, income, additional)) %>%
#
#     adorn_totals("row") %>%
#     select(department,  male,  female, not_identified,  total)  %>%
#     slice_tail(n()) %>%
#     mutate_if(is.numeric, roundChoose, 10000) %>%
#     mutate_at(vars(total), roundChoose, 100000) %>%
#     select(-department) %>%
#     clean_names("title")
#
# }


#' create jobs dataframe
#' @param data jobs data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterJobsRegion  <-  function(data){

  data %>% select(department, gender, results) %>%
    pivot_wider(.,names_from = gender, values_from = results) %>%
    mutate(region=recode_factor(department, !!!getVal(lookup,"region", "dept_publication_name"))) %>%
    rowwise() %>%
    mutate(not_identified = total-sum(male,female)) %>%
    mutate_at(vars(not_identified),function(x)ifelse(x<=2,0,x)) %>%
    ungroup()  %>%
    adorn_totals("row") %>%
    select(department,  region, male,  female, not_identified,  total)  %>%
    mutate_if(is.numeric, roundChoose, 1000) %>%
    mutate_at(vars(male:total), ~(
      case_when(
        department=="Total" ~ roundChoose(.,100000),
        TRUE~.
      )
    )
    ) %>%
    clean_names("title")

}
