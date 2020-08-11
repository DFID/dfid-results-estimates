#' plot FP Additional region
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'

plotFPAdditionalRegion <- function(data) {

  fp_plot_data <- data %>%
    filter(department!="Total") %>%
    group_by(region) %>%
    summarise(results=sum(total)) %>%
    mutate(perc=(results/sum(results))*100) %>%
    filter(results!=0)

  adj <- ifelse(fp_plot_data$perc<10,-0.3, 1.6)
  lab_col  <- ifelse(fp_plot_data$perc>10,"white", "black")

  fp_additional_region_plot  <-
    fp_plot_data %>%
    ggplot(., aes(x = region, y = perc)) +
    geom_bar(stat = "identity", fill=gov_cols[2], color=darken(gov_cols[2]), size=1) +
    geom_text(aes(label = paste0(round(perc,1), "%"), y=perc, fontface=2),
              vjust = adj, size =6,
              color = lab_col) +
    govstyle::theme_gov() +
    xlab("\nRegion") +
    ylab("Results (%)\n") +
    labs(
      title="Family Planning",
      subtitle = "Percentage of Family Planning (Additional Users) Results by Region\n\n",
      caption = "\n* 'Policy' are deparertments managing Centrally Managed Programmes, which might operate across regions"
    ) +
    theme(
      axis.title.x = element_text(vjust=-1),
      axis.title.y = element_text(hjust=1),
      panel.grid.major.y = element_line(colour = "grey80"),
      panel.grid.major.x = element_blank(),
      plot.subtitle = element_text(hjust = 1, vjust=-2)
    ) +
    scale_y_continuous(breaks=seq(0, roundChoose(max(fp_plot_data$perc),10,TRUE), by = 10))


  ### comment in if not using drake
  pdf(file="figs/fp_additional_region_plot.pdf",
      width=8,
      height=6,
      pointsize=12)
  print(fp_additional_region_plot)
  dev.off()
}

