#' plot climate spend
#' @param data Master data
#' @keywords internal
#' @importFrom magrittr %>%
#' @export
#'
plotClimateSpend <- function(data) {

climate_spend_plot  <-
    ggplot(data[1,], aes(x=type, y=vals)) +
    geom_bar(stat="identity", size=1, fill=gov_cols[10],  color=darken(gov_cols[10])) +
    geom_hline(aes(yintercept=unlist(data[2,1])), color="red",  size=0.8, linetype="dashed") +
    scale_y_continuous(expand = c(0,0),  limits=c(0,4000),  breaks=c(seq(0, 3000,by=1000),3641)) +
    scale_x_discrete(expand=c(0,1), labels=c("2016/17-2019/20")) +
    govstyle::theme_gov() +
    theme(panel.grid.major.y = element_line(colour = "grey80"),
          aspect.ratio = 1.2) +
    labs(title="DFID Progress Against Climate Finance Target",
         subtitle="",
         x="DFID Spend",
         y="Millions (GBP)")+
    annotate("text", x = 1.2, y = 3500, label = "Cumulative Spend Target: 2016/17-2020/21", color="red", fontface="bold")


  ### comment in if not using drake
 # pdf(file="figs/climate_spend_plot.pdf",
#      width=8,
#      height=6,
#      pointsize=12)
#  print(climate_spend_plot)
#  dev.off()
}

