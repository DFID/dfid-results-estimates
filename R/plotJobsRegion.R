#' plot jobs region
#' @param data jobs data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
plotJobsRegion <- function(data, lookup){

  jobs_plot_data <- data %>%
    select(department,gender, results) %>%
    mutate(region = recode_factor(department, !!!getRegion(lookup))) %>%
    mutate(region = recode(region, PSD="Policy")) %>%
    filter(gender=="total") %>%
    group_by(region) %>%
    summarise(results = sum(results)) %>%
    mutate(perc=(results/sum(results))*100) %>%
    filter(results!=0)

    adj <- ifelse(jobs_plot_data$perc<10,-0.3, 1.6)
    lab_col  <- ifelse(jobs_plot_data$perc>10,"white", "black")

  jobs_region_plot <-
    jobs_plot_data %>%
    ggplot(., aes(x = region, y = perc)) +
    geom_bar(stat = "identity", fill=gov_cols[6], color=darken(gov_cols[6]), size=1) +
    geom_text(aes(label = paste0(round(perc,1), "%"), y=perc, fontface=2),
            vjust = adj, size =6,
            color = lab_col) +
    govstyle::theme_gov() +
    xlab("\nRegion") +
    ylab("Results (%)\n") +
    labs(
      title="Jobs & Income",
      subtitle = "Percentage of Jobs & Income Results by Region\n\n",
      caption = "\n* 'Policy' are departments managing Centrally Managed Programmes, which might operate across regions"
    ) +
    theme(
      axis.title.x = element_text(vjust=-1),
      axis.title.y = element_text(hjust=1),
      panel.grid.major.y = element_line(colour = "grey80"),
      panel.grid.major.x = element_blank(),
      plot.subtitle = element_text(hjust = 1, vjust=-2)
    ) +
    scale_y_continuous(breaks=seq(0, roundChoose(max(jobs_plot_data$perc),10, up = TRUE), by = 10))


### comment in if not using drake
pdf(file="figs/jobs_region_plot.pdf",
    width=8,
    height=6,
    pointsize=12)
print(jobs_region_plot)
dev.off()
}
