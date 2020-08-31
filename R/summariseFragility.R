#' summarise indicator data by fragility
#' @param data filtered indicator data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

summariseFragility <- function(data) {

  if(colnames(data[,ncol(data)])!="Average"){
  data %>%
    filter(department!="Total") %>%
    group_by(fragility) %>%
    summarise(results=sum(total)) %>%
    mutate(perc=(results/sum(results))*100) %>%
    filter(results!=0) %>%
    mutate(fragility= fct_relevel(fragility, c("Extremely Fragile", "Fragile", "Not Fragile","Not Identified")))
  } else {
    data %>%
      clean_names(.) %>%
      filter(department!="Total") %>%
      group_by(fragility) %>%
      summarise(results=sum(average)) %>%
      mutate(perc=(results/sum(results))*100) %>%
      filter(results!=0) %>%
      mutate(fragility= fct_relevel(fragility, c("Extremely Fragile", "Fragile", "Not Fragile","Not Identified")))
  }
}

