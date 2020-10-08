#' plot a2f region
#' @param data jobs data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
plotA2FRegion <- function(data){

  adj <- ifelse(data$perc<10,-0.3, 1.6)
  lab_col  <- ifelse(data$perc>10,"white", "black")

  a2f_region_plot <-
    data %>%
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
    scale_y_continuous(breaks=seq(0, roundChoose(max(data$perc),10, up = TRUE), by = 10))


  ### comment in if not using drake
  # pdf(file="figs/a2f_region_plot.pdf",
  #     width=8,
  #     height=6,
  #     pointsize=12)
  # print(a2f_region_plot)
  # dev.off()
}
