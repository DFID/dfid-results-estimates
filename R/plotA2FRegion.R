#' plot a2f region
#' @param data jobs data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
plotA2FRegion <- function(data, lookup){

  a2f_plot_data <-  data %>%
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

  adj <- ifelse(a2f_plot_data$perc<10,-0.3, 1.6)
  lab_col  <- ifelse(a2f_plot_data$perc>10,"white", "black")

  a2f_region_plot <-
    a2f_plot_data %>%
    ggplot(., aes(x = region, y = perc)) +
    geom_bar(stat = "identity", fill=gov_cols[7], color=darken(gov_cols[7]), size=1) +
    geom_text(aes(label = paste0(round(perc,1), "%"), y=perc, fontface=2),
              vjust = adj, size =6,
              color = lab_col) +
    govstyle::theme_gov() +
    xlab("\nRegion") +
    ylab("Results (%)\n") +
    labs(
      title="Access to Finance",
      subtitle = "Percentage of Access to Finance Results by Region\n\n",
      caption = "\n* 'Policy' are departments managing Centrally Managed Programmes, which might operate across regions"
    ) +
    theme(
      axis.title.x = element_text(vjust=-1),
      axis.title.y = element_text(hjust=1),
      panel.grid.major.y = element_line(colour = "grey80"),
      panel.grid.major.x = element_blank(),
      plot.subtitle = element_text(hjust = 1, vjust=-2)
    ) +
    scale_y_continuous(breaks=seq(0, roundChoose(max(a2f_plot_data$perc),10, up = TRUE), by = 10))


  ### comment in if not using drake
  pdf(file="figs/a2f_region_plot.pdf",
      width=8,
      height=6,
      pointsize=12)
  print(a2f_region_plot)
  dev.off()
}
