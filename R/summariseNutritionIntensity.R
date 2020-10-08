#' summarise indicator data by fragility
#' @param data filtered indicator data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
summariseNutritionIntensity <- function(data) {

  data %>%
    filter(department!="Total") %>%
    ungroup() %>%
    select(low,medium,high,not_identified, total) %>%
    select(-total) %>%
    clean_names("title") %>%
    pivot_longer(cols=everything(),
                 names_to = "intensity") %>%
    group_by(intensity) %>%
    summarise(results=sum(value)) %>%
    mutate(perc=(results/sum(results))*100) %>%
    mutate_at(vars(intensity), as.factor) %>%
    mutate(intensity= fct_relevel(intensity, c("High", "Medium", "Low","Not Identified")))

}
