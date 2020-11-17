#' plot nutrition region
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
plotNutritionRegion <- function(data) {

  adj <- ifelse(data$perc<10,-0.3, 1.6)
  lab_col  <- ifelse(data$perc>10,"white", "black")

  nutrition_region_plot <-
    data %>%
    ggplot(., aes(x = region, y = perc)) +
    geom_bar(stat = "identity", fill=gov_cols[4], color=darken(gov_cols[4]), size=1) +
    geom_text(aes(label = paste0(round(perc,1), "%"), y=perc, fontface=2),
              vjust = adj, size =6,
              color = lab_col) +
    govstyle::theme_gov() +
    xlab("\nRegion") +
    ylab("Results (%)\n") +
    labs(
      title="Nutrition",
      subtitle = "Percentage of Nutrition Results by Region\n\n",
      caption = "\n* 'Policy' are departments managing Centrally Managed Programmes, which might operate across regions"
    ) +
    theme(
      axis.title.x = element_text(vjust=-1),
      axis.title.y = element_text(hjust=1),
      panel.grid.major.y = element_line(colour = "grey80"),
      panel.grid.major.x = element_blank(),
      plot.subtitle = element_text(hjust = 1, vjust=-2)
    ) +
    scale_y_continuous(breaks=seq(0, roundChoose(max(data$perc),10,TRUE), by = 10))


  ### comment in if not using drake
  # pdf(file="figs/nutrition_region_plot.pdf",
  #     width=8,
  #     height=6,
  #     pointsize=12)
  # print(nutrition_region_plot)
  # dev.off()
}

