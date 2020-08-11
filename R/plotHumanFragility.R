#' plot education fragility
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
plotHumanFragility <- function(data) {

  human_plot_data  <- data %>%
    filter(department!="Total") %>%
    group_by(fragility) %>%
    summarise(results=sum(total)) %>%
    mutate(perc=(results/sum(results))*100)

  adj <- ifelse(human_plot_data$perc<10,-0.3, 1.6)
  lab_col  <- ifelse(human_plot_data$perc>10,"white", "black")

  human_frag_plot  <-
    human_plot_data   %>%
    ggplot(., aes(x = fragility, y = perc)) +
    geom_bar(stat = "identity", fill=gov_cols[3], color=darken(gov_cols[3]), size=1) +
    geom_text(aes(label = paste0(round(perc,1), "%"), y=perc, fontface=2),
              vjust = adj, size =6,
              color = lab_col) +
    govstyle::theme_gov() +
    xlab("\nFragility (OECD States of Fragility)") +
    ylab("Results (%)\n") +
    labs(
      title="Humanitarian",
      subtitle = "Percentage of Humanitarian Results by Fragility Level\n\n",
      caption = "\n* 'Not Identified' are results which could not be disaggregated to country level"
    ) +
    theme(
      axis.title.x = element_text(vjust=-1),
      axis.title.y = element_text(hjust=1),
      panel.grid.major.y = element_line(colour = "grey80"),
      panel.grid.major.x = element_blank(),
      plot.subtitle = element_text(hjust = 1, vjust=-2)
    ) +
    scale_y_continuous(breaks=seq(0, roundChoose(max(human_plot_data$perc),10,TRUE), by = 10))


  ### comment in if not using drake
  pdf(file="figs/human_fragility_plot.pdf",
      width=8,
      height=6,
      pointsize=12)
  print(human_frag_plot)
  dev.off()
}

