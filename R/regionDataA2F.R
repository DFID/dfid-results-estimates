#' a2f region data
#' @param data jobs data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
regionDataA2F <- function(data, lookup){
    data %>%
      select(-male,-female) %>%
      ungroup() %>%
      mutate(region = recode_factor(department, !!!getRegion(lookup))) %>%
      add_row(
        department="Private Sector",
        project_title = "HiFi",
        total = unlist(.[1,"total"])*0.43,
        region = "Africa"
      ) %>%
      add_row(
        department="Private Sector",
        project_title = "HiFi",
        total = unlist(.[1,"total"])*0.55,
        region = "Asia"
      ) %>%
      add_row(
        department="Private Sector",
        project_title = "HiFi",
        total = unlist(.[1,"total"])*0.02,
        region = "Middle East"
      ) %>%
      mutate_at(vars(region), ~(
        case_when(
          project_title=="FSDA" ~ "Africa",
          TRUE ~ as.character(.)
        ))) %>%
      filter(total<45000000) %>%
      select(-project_title) %>%
      group_by(region) %>%
      summarise(results = sum(total)) %>%
      mutate(perc=(results/sum(results))*100) %>%
      filter(results!=0)
}

