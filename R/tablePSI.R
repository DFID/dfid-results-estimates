#' make PSI table
#' @param data input data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

tablePSI <- function(data) {

  data %>%
    filter(indicator=="psi")  %>%
    select(year,results, pf_body)  %>%
    pivot_wider(names_from=year, values_from=results) %>%
    rowwise() %>%
    mutate(Total=sum(c_across(`2015`:`2019`))) %>%
    mutate_at(vars("2015":"Total"), ~(.*1000000000)) %>%
    mutate(pf_body=recode(pf_body, pidg="Private Infrastructure Development Group", cdc="CDC*")) %>%
    rename("Organisation"=pf_body)

}

