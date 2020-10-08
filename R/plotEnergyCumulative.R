#' plot energy region
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
plotEnergyCumulative <- function(data) {

  energy_data <- data %>%
    filter(type=="Cumulative")

  energy_cumulative_plot <-
    energy_data %>%
    ggplot(., aes(x = year, y = energy, group=type)) +
    geom_line(color=lighten(gov_cols[9],1.6), size=2) +
    geom_point(color=gov_cols[9], size=5) +
    govstyle::theme_gov() +
    xlab("\nYear") +
    ylab("Clean Energy Capacity (MW)\n") +
    labs(
      title="Energy",
      subtitle = "Cumulative Clean Energy Capacity Installed as a Result of ICF support\n\n"
    ) +
    theme(
      axis.title.x = element_text(vjust=-1),
      axis.title.y = element_text(hjust=1),
      panel.grid.major.y = element_line(colour = "grey80"),
      panel.grid.major.x = element_blank(),
      plot.subtitle = element_text(hjust = 1, vjust=-2)
    )

  ### comment in if not using drake
  # pdf(file="figs/energy_cumulative_plot.pdf",
  #     width=8,
  #     height=6,
  #     pointsize=12)
  # print(energy_cumulative_plot)
  # dev.off()
}


