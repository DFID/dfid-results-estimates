#' plot ODA GNI
#'
#' Makes ODA:GNI plot
#' @param data sid_oda_annual.csv
#' @keywords names
#' @importFrom magrittr %>%
#' @export

plotOdaGni <- function(data){

  bar_plot <- ggplot(data, aes(x=year, y=oda)) +
    geom_bar(stat = "identity", fill=c(rep(gov_cols[10],nrow(data)-1),darken(gov_cols[10])), color=darken(gov_cols[10]), size=0.5) +
    govstyle::theme_gov() +
    xlab("") +
    ylab("Total ODA (GBP Million)") +
    labs(
      title="UK Official Development Assistance (ODA)",
      subtitle = "Total ODA (A) and ODA:GNI percentage (B) between 1970 and 2019 \n\n",
      caption = "\n* 2019 is shown in darker shade to indicate that it is a provisional figure"
    ) +
    theme(
      axis.title.x = element_text(vjust=-1),
      axis.title.y = element_text(hjust=1),
      panel.grid.major.y = element_line(colour = "grey80"),
      panel.grid.major.x = element_blank(),
      plot.subtitle = element_text(hjust = 1, vjust=-2)
    ) +
    scale_y_continuous(breaks=c(seq(0, 16000, by = 2000), 16000)) +
    expand_limits(y = c(0,16000)) +
    scale_x_continuous(breaks=c(seq(min(data$year), max(data$year),by=5),2019)) +
    annotate("segment", x = 2010, xend = 2018, y = 15000, yend = 14552, colour = "black") +
    annotate("text", x = 2005, y = 15000, label = "2018: Introduction of Grant \n Equivalent Measure", size=3) +
    annotate("text", x = 1970, y = 17000, label = "A", size=5, fontface="bold")


  line_plot <- ggplot(data, aes(x=year, y=oda_gni)) +
    geom_hline(yintercept=0.7, linetype="dashed",
               color = "grey70", size=1) +
    geom_vline(xintercept = 2013, linetype="dotted",
               color = gov_cols[10], size=1) +
    geom_line(color=gov_cols[8], size=1.5) +
    govstyle::theme_gov() +
    xlab("Year") +
    ylab("ODA:GNI (%)") +
    labs(
      #title="UK Official Development Assistance (ODA)",
      #subtitle = "ODA Level between 1970 and 2019 \n\n",
    ) +
    theme(
      axis.title.x = element_text(vjust=-1),
      axis.title.y = element_text(hjust=1),
      panel.grid.major.y = element_line(colour = "grey80"),
      panel.grid.major.x = element_blank(),
      plot.subtitle = element_text(hjust = 1, vjust=-2)
    ) +
    scale_y_continuous(breaks=c(seq(0, 1, by = 0.1))) +
    expand_limits(y = c(0,0.8)) +
    scale_x_continuous(breaks=c(seq(min(data$year), 2010,by=5),2013,2019)) +
    annotate("text", x = 1972, y = 0.66, label = "UN 0.7% target", color="grey70", fontface="bold")+
    annotate("text", x = 1970, y = 0.85, label = "B", size=5, fontface="bold")

  oda_plot <- bar_plot / line_plot

  oda_plot
  ### comment in if not using drake
   # pdf(file="figs/oda_gni_plot.pdf",
   #     width=8,
   #     height=9,
   #     pointsize=12)
   # print(oda_plot)
   # dev.off()

}
