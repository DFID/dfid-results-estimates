#' summarise indicator data by region
#' @param data filtered indicator data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export

summariseRegion<- function(data) {

  if(colnames(data[,ncol(data)])!="Average"){
  data %>%
      filter(department!="Total") %>%
      group_by(region) %>%
      summarise(results=sum(total)) %>%
      mutate(perc=(results/sum(results))*100) %>%
      filter(results!=0)
  } else {
    data %>%
      clean_names(.) %>%
      filter(department!="Total") %>%
      group_by(region) %>%
      summarise(results=sum(average)) %>%
      mutate(perc=(results/sum(results))*100) %>%
      filter(results!=0)
  }
}

