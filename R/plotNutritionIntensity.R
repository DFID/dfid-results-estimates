#' plot nutrition intensity
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
plotNutritionIntensity <- function(data) {

  adj <- ifelse(data$perc<10,-0.3, 1.6)
  lab_col  <- ifelse(data$perc>10,"white", "black")

  nutrition_intensity_plot <-
    data %>%
    ggplot(., aes(x = intensity, y = perc)) +
    geom_bar(stat = "identity", fill=gov_cols[4], color=darken(gov_cols[4]), size=1) +
    geom_text(aes(label = paste0(round(perc,1), "%"), y=perc, fontface=2),
              vjust = adj, size =6,
              color = lab_col) +
    govstyle::theme_gov() +
    xlab("\nIntensity") +
    ylab("Results (%)\n") +
    labs(
      title="Nutrition",
      subtitle = "Percentage of Nutrition Results by Intervention Intensity\n\n"
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
  # pdf(file="figs/nutrition_intensity_plot.pdf",
  #     width=8,
  #     height=6,
  #     pointsize=12)
  # print(nutrition_intensity_plot)
  # dev.off()
}


