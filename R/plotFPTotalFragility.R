#' plot FP Total region
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'

plotFPTotalFragility <- function(data) {

  adj <- ifelse(data$perc<10,-0.3, 1.6)
  lab_col  <- ifelse(data$perc>10,"white", "black")

  fp_total_frag_plot  <-
    data %>%
    ggplot(., aes(x = fragility, y = perc)) +
    geom_bar(stat = "identity", fill=gov_cols[2], color=darken(gov_cols[2]), size=1) +
    geom_text(aes(label = paste0(round(perc,1), "%"), y=perc, fontface=2),
              vjust = adj, size =6,
              color = lab_col) +
    govstyle::theme_gov() +
    xlab("\nFragility (OECD States of Fragility)") +
    ylab("Results (%)\n") +
    labs(
      title="Family Planning",
      subtitle = "Percentage of Family Planning (Total Users) Results by Fragility Level\n\n",
      caption = "\n* 'Not Identified' are results which could not be disaggregated\n to country level becasue they come from CMPs or Multilaterals"
    ) +
    theme(
      axis.title.x = element_text(vjust=-1),
      axis.title.y = element_text(hjust=1),
      panel.grid.major.y = element_line(colour = "grey80"),
      panel.grid.major.x = element_blank(),
      plot.subtitle = element_text(hjust = 1, vjust=-2)
    ) +
    scale_y_continuous(breaks=seq(0, roundChoose(max(data$perc),10,TRUE), by = 10))


  ### FP plots not loaded from cache instead output directly to figs/ as its tricky to use subfloat in .Rnw with code chunks to have one fig caption.
   pdf(file="figs/fp_total_fragility_plot.pdf",
       width=8,
       height=6,
       pointsize=12)
   print(fp_total_frag_plot)
   dev.off()
}

