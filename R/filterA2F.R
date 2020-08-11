#' create jobs dataframe
#' @param data jobs data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
filterA2F  <-  function(data){

  data %>%
    rowwise() %>%
    mutate(not_identified = total-sum(male,female, na.rm=T)) %>%
    ungroup()  %>%
    mutate_at(vars(not_identified),function(x)ifelse(x<=1,0,x)) %>%
    adorn_totals("row") %>%
    select(department,  female, male,  not_identified,  total)  %>%
    slice_tail(n()) %>%
    select(-department) %>%
    mutate_if(is.numeric, roundChoose, 100000) %>%
    clean_names("title")

}
